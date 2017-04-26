Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58914 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1434861AbdDZD6T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 23:58:19 -0400
Subject: Re: [PATCH 1/2 v2] mkfs: unify numeric types of main variables in
 main()
References: <20170419153025.10368-1-jtulak@redhat.com>
 <20170420083323.12524-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <62f04d88-9475-b1a4-dd91-871fd091b0e1@sandeen.net>
Date: Tue, 25 Apr 2017 22:58:17 -0500
MIME-Version: 1.0
In-Reply-To: <20170420083323.12524-1-jtulak@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/20/17 3:33 AM, Jan Tulak wrote:
> In the past, when mkfs was first written, it used atoi and
> similar calls, so the variables were ints. However, the situation moved
> since then and in course of the time, mkfs began to use other types too.
> 
> Clean and unify it. We don't need negative values anywhere in the code and
> some numbers has to be 64bit. Thus, uint64_t is the best candidate as the target
> type for numeric values. The existing uses of __uint64_t in mkfs change to the
> standard uint64_t type. For flag values let's use boolean.
> 
> This patch changes variables declared at the beginning of main() +
> block/sectorsize, making only minimal changes. The following patch
> cleans some now-unnecessary type casts.
> 
> It would be nice to change types in some of the structures too, but
> this might lead to changes outside of mkfs, so I'm skipping them for
> this moment to keep it simple.

This introduces quite a few new warnings on i386, first of all.
(they persist with patch 2/2), so please sort that out.

Also, almost all of the existing use of PRIu64 in the codebase
puts spaces around it, i.e.
	("The value is %" PRIu64 "\n")
not
	("The value is %"PRIu64"\n")

so I'd prefer that you follow that convention whenever you
need to use it.

On a respin, it would be nice to separate the boolean changes
into a separate patch from the 64-bit changes, to produce
shorter individual patches to aid review.  In fact, splitting out
another patch to first convert existing __uint64_t to uint64_t would
make it even nicer.  Small, self-contained, functional patches.
Change one thing at a time, especially for long patches.

(Splitting out the bools would make it more obvious that "discard" and
"lalign" really should be converted to bools below, not uint64_t
as they are now; there might be others.)

However, as Dave said earlier:

> we need to work
> towards removing all the variables, not try to make them pretty....

and indeed, your later patches do remove a lot of the variables that
you're converting here, i.e.:

[PATCH 08/12] mkfs: replace variables with opts table: -b,d,s options

does:

-uint64_t		blocksize;
-uint64_t		sectorsize;
...
-	uint64_t		agcount;
-	uint64_t		agsize;
-	uint64_t		blocklog;
...
-	uint64_t		dbytes;
-	uint64_t		dsu;
-	uint64_t		dsw;
-	uint64_t		dsunit;
-	uint64_t		dswidth;
...
-	uint64_t		sectorlog;

and [PATCH 09/12] mkfs: replace variables with opts table: -i options
does:

-	uint64_t		imaxpct;
-	uint64_t		inodelog;
-	uint64_t		inopblock;
-	uint64_t		isize;

etc ...

so is there any real advantage to converting all of these, only to remove
most of them a few patches later?  (If there is, just help me understand
why...)

Thanks,
-Eric

> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
