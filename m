Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4NFoFdX011581 for <xfs@oss.sgi.com>; Sat, 23 May 2009 10:50:15 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BFEF19DAAE6
	for <xfs@oss.sgi.com>; Sat, 23 May 2009 08:50:26 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id lSXNc6pagxzD7lEA for
	<xfs@oss.sgi.com>; Sat, 23 May 2009 08:50:26 -0700 (PDT)
Message-ID: <4A181B40.9080608@sandeen.net>
Date: Sat, 23 May 2009 10:50:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
References: <4A180FCD.9080905@cape-horn-eng.com>
In-Reply-To: <4A180FCD.9080905@cape-horn-eng.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Richard Ems <Richard.Ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

Richard Ems wrote:
> Hi list,
> 
> I'm getting the error "xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
> Invalid argument" while trying to grow an XFS partition.
> 
> This is on openSUSE 11.1 64 bit, with xfsprogs-2.10.2-3.1 from
> http://download.opensuse.org/repositories/filesystems/openSUSE_11.1/x86_64/xfsprogs-2.10.2-3.1.x86_64.rpm

The compat handlers should only matter if you're using 32 bit userspace
with a 64 bit kernel...

Are you certain that your xfsprogs userspace is 64-bit?

> 
> This error is the same or looks similar to the one reported some months
> ago at http://oss.sgi.com/archives/xfs/2009-02/msg00028.html .
> 
> There is apparently a fix for it, see
> http://oss.sgi.com/archives/xfs/2008-12/msg01794.html :
> 
> *********************************************************
> commit 471d59103167c84f17b9bcfee22ed10b44ff206e
> Author: sandeen@xxxxxxxxxxx <sandeen@xxxxxxxxxxx>
> Date:   Tue Nov 25 21:20:10 2008 -0600
> 
>     [XFS] Add compat handlers for data & rt growfs ioctls
> 
>     The args for XFS_IOC_FSGROWFSDATA and XFS_IOC_FSGROWFSRTA
>     have padding on the end on intel, so add arg copyin functions,
>     and then just call the growfs ioctl helpers.
> 
>     Signed-off-by: Eric Sandeen <sandeen@xxxxxxxxxxx>
>     Reviewed-by: Christoph Hellwig <hch@xxxxxx>
>     Signed-off-by: Lachlan McIlroy <lachlan@xxxxxxx>
> *********************************************************
> 
> I tried different 2.6.27 versions, one 2.6.29 and one 2.6.30-rc6
> version, all gave the same error, check
> https://bugzilla.novell.com/show_bug.cgi?id=506361 for the different
> kernel versions and errors.

I don't see in that bug where you tested .29 or .30, or what the results
were...


> Is this fix still not included in Linus / openSUSE trees?

As for Linus' tree, AFAIK everything works; I can't speak to what SuSE has.

-Eric

> Or am I hitting another error?
> 
> Thanks, Richard
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
