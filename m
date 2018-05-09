Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51326 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965012AbeEIQ1a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 12:27:30 -0400
Date: Wed, 9 May 2018 09:27:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs_db and ASSERT fails dur type mismatch
Message-ID: <20180509162710.GU11261@magnolia>
References: <20180509114554.2slvfi3hqt4na6vy@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509114554.2slvfi3hqt4na6vy@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, sandeen@redhat.com

On Wed, May 09, 2018 at 01:45:54PM +0200, Carlos Maiolino wrote:
> Hey folks,
> 
> I've been thinking about different ways to fix those crashes on xfs_db due type
> mismatch, based on the previous discussion and a chat I had with Eric on irc.
> 
> After thinking a bit more about it, I do think using unknown header types adds
> unneeded extra complexity to the code, to achieve the same result as an extra
> check on print_flist_1().
> 
> Adding an unknown type, will require a change to all types affected by this
> issue. I am not sure if a single unknown type can be used for all metadata types
> which is affected by this, but I think it requires an unknown type for each of
> these metadata. Or at least an entry for an unknown header type (in case of of
> the known ones are not found).
> 
> While, the crash caused by unrecognized metadata when using these types, can be
> fixed by something like my original change.
> 
> I wrote a slightly different patch like this:
> 
> diff --git a/db/print.c b/db/print.c
> index 0da36c27..f8a48281 100644
> --- a/db/print.c
> +++ b/db/print.c
> @@ -160,9 +160,10 @@ print_flist_1(
>                                         (f->flags & FLD_ARRAY) != 0);
>                                 if (neednl)
>                                         dbprintf("\n");
> -                       } else {
> -                               ASSERT(fa->arg & FTARG_OKEMPTY);
> +                       } else if (fa->arg & FTARG_OKEMPTY) {
>                                 dbprintf(_("(empty)\n"));
> +                       } else {
> +                               dbprintf(_("Unrecognized metadata or type mismatch\n"));
>                         }
>                 }
>                 free_strvec(pfx);
> 
> 
> This will still keep printing "(empty)" where it should be printed, or print out
> a hint that something went wrong.
> 
> I honestly think this the best solution for these crashes, what you guys think?

Looks fine to me, I dislike ASSERTs on crap metadata, especially in the
debugging tool.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Cheers
> 
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
