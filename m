Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34116 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753146AbeDQPd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 11:33:58 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3HFQ5rH106387
        for <linux-xfs@vger.kernel.org>; Tue, 17 Apr 2018 15:33:57 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2hbamf2p1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 17 Apr 2018 15:33:57 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3HFXu5g015130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 17 Apr 2018 15:33:56 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3HFXuFc023189
        for <linux-xfs@vger.kernel.org>; Tue, 17 Apr 2018 15:33:56 GMT
Date: Tue, 17 Apr 2018 08:33:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Assertion fails on xfs_db when setting erroneous type
Message-ID: <20180417153355.GA24738@magnolia>
References: <20180417122351.l4uxq6cx2wczjlsh@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417122351.l4uxq6cx2wczjlsh@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Tue, Apr 17, 2018 at 02:23:51PM +0200, Carlos Maiolino wrote:
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

"Unrecognized metadata\n" ?

The block space pointer that got us here wasn't necessarily invalid,
it's just that we don't recognize the block as matching whatever type is
selected in the io cursor.

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

Funny, I've had a debug patch squirreled away in my xfsprogs tree for
ages to teach those ASSERTs not to abort the binary (which then sprays
core files everywhere).  This one has been particularly annoying, so...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Comments?
> 
> Cheers
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
