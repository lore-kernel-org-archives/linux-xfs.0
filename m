Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41008 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753219AbeDQQxr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Apr 2018 12:53:47 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7ACC3450A9B
        for <linux-xfs@vger.kernel.org>; Tue, 17 Apr 2018 11:52:53 -0500 (CDT)
Subject: Re: Assertion fails on xfs_db when setting erroneous type
References: <20180417122351.l4uxq6cx2wczjlsh@odin.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <efd47bd4-1835-ae8b-f539-9b9cd8bed46d@sandeen.net>
Date: Tue, 17 Apr 2018 11:53:44 -0500
MIME-Version: 1.0
In-Reply-To: <20180417122351.l4uxq6cx2wczjlsh@odin.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org



On 4/17/18 7:23 AM, Carlos Maiolino wrote:
> Hi,
> 
> recently while playing with a FS image, I've hit an assertion in xfs_db:
> 
> xfs_db: print.c:164: print_flist_1: Assertion `fa->arg & 64' failed.
> Aborted (core dumped)
> 
> The reason for this assert was that I tried to print a remote attr3 block, after
> having set the block pointer to a random, no attr3 location.
> 
> I wonder if crashing xfs_db here is the right thing to do?
> 
> 
> I've written a small workaround for it as below:
> 
> 
> @@ -160,9 +160,10 @@ print_flist_1(
>                                         (f->flags & FLD_ARRAY) != 0);
>                                 if (neednl)
>                                         dbprintf("\n");
> -                       } else {
> -                               ASSERT(fa->arg & FTARG_OKEMPTY);
> +                       } else if (fa->arg & FTARG_OKEMPTY) {
>                                 dbprintf(_("(empty)\n"));
> +                       } else {
> +                               dbprintf(_("Invalid arg\n"));
>                         }
>                 }
>                 free_strvec(pfx);
> 
> 
> I wonder if something like this makes sense or not? I'm still familiarizing
> myself with xfs_db code, so I'm not sure if something as the small patch above
> is a valid fix for it or not, but I believe exiting xfs_db just because somebody
> tried to print a metadata block using a different type from the on-disk block
> being read doesn't look like the right thing to do.
> 
> Comments?

Ok, so what's going on here is that the attr3 (same as dir3, or attr, or ...) types
don't fully specify what's to be printed.  Instead, it can print the "header" one
of 3 different ways, depending on the magic that's found.  Each of the
attr3_*_hdr_count() functions below returns 0 or 1 based on the magic it finds,
so it'll print the correct type of block:

const field_t   attr3_flds[] = {
        { "hdr", FLDT_ATTR3_LEAF_HDR, OI(L3OFF(hdr)), attr3_leaf_hdr_count,
          FLD_COUNT, TYP_NONE },
        { "hdr", FLDT_ATTR3_NODE_HDR, OI(N3OFF(hdr)), attr3_node_hdr_count,
          FLD_COUNT, TYP_NONE },
        { "hdr", FLDT_ATTR3_REMOTE_HDR, OI(0), attr3_remote_hdr_count,
          FLD_COUNT, TYP_NONE },

... and after the headers, it has other similar tests to print details of the block
type that's found.

The problem is that if it's none of the above, they all return 0, and as a result
there is no ->child field to print.

That's how we drop through print_flist_1; there is no child, and no prfunc.

                if (fl->child) {
...
                } else {
                        if (fa->prfunc) {
...
                        } else {
                                ASSERT(fa->arg & FTARG_OKEMPTY);
                                dbprintf(_("(empty)\n"));
                        }

Rather than segfaulting, we should probably print something useful, I agree.  :)

(I'm not sure if just adding a generic ->prfunc would work or if we'd get that
even for valid attr3 blocks...)

What I'd suggest is adding another "hdr" entry above but with a new count function,
attr3_unknown_hdr_count() which returns 1 only if none of the other 3 header
counters/checkers pass:

       if (!attr3_leaf_hdr_count(obj, startoff) &&
           !attr3_node_hdr_count(obj, startoff) &&
           !attr3_remote_hdr_count(obj, startoff))

and then print something useful to the user about what's going on so they can either say
"oh, I guess I got the wrong block" or maybe "oh, the magic has a bitflip, let me rewrite
it and try again."  I think that'd be more informative than just printing "(empty)" as
I think your patch will do.

attr3_unknown_hdr_count() could simply print something like "unrecognized as attr3 block,
try printing as data" and return 0 (so nothing get printed) along with OKEMTPY "(empty)",
and that'd be more informative.

Or, you could get fancier, and add a couple of new lines that print out the block both as
an "unknown blkinfo header" and an "unknown remote header" and let the user try to see what
seems most likely.

However you approach it, attr and dir3 (and dir?) need the same treatment - i.e. anything
like attr3_flds where it's possible that /none/ of the child fields match and we end up
with no ->prfunc and no ->child in the print function.

-Eric

