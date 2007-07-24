Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 21:33:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6O4XFbm011507
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 21:33:18 -0700
Message-ID: <46A57B49.9030106@sgi.com>
Date: Tue, 24 Jul 2007 14:08:41 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: fix null files exposure growing via truncate V2
References: <20070619063714.GP86004887@sgi.com>
In-Reply-To: <20070619063714.GP86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Looks good to me.  Thanks for fixing it Dave.

David Chinner wrote:
> Test 140 fails due to the ftruncate() logging the new file size
> before any data that had previously been written had hit the
> disk. IOWs, it violates the data write/inode size update rule
> that fixes the null files problem.
> 
> The fix here checks when growing the file as to whether it the disk
> inode size is different to the in memory size. If they are
> different, we have data that needs to be written to disk beyond the
> existing on disk EOF. Hence to maintain ordering we need to flush
> this data out before we log the changed file size.
> 
> Version 2:
> 
> o Only flush the range between the old on disk size and the current
>   in memory size.
> 
> Cheers,
> 
> Dave.
