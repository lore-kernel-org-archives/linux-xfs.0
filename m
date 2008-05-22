Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 11:10:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4MIAAWu031962
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 11:10:13 -0700
Received: from pomaz-ex.szeredi.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BE63171D499
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 11:10:58 -0700 (PDT)
Received: from pomaz-ex.szeredi.hu (fxip-0047f.externet.hu [88.209.222.127]) by cuda.sgi.com with ESMTP id ChQnIHlBvWcUcrr2 for <xfs@oss.sgi.com>; Thu, 22 May 2008 11:10:58 -0700 (PDT)
In-reply-to: <20080520083351.GA14826@lst.de> (message from Christoph Hellwig
	on Tue, 20 May 2008 10:33:51 +0200)
Subject: Re: [PATCH] always set a/c/mtime through ->setattr
References: <20080520060838.GA6436@lst.de> <E1JyMSu-0001au-96@pomaz-ex.szeredi.hu> <20080520083351.GA14826@lst.de>
Message-Id: <E1JzFFa-0008VR-9B@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 May 2008 20:10:50 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: hch@lst.de
Cc: miklos@szeredi.hu, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Artem.Bityutskiy@nokia.com

> All major disk or in-memory filesystems except for XFS just pass down
> ATTR_*TIME requests to inode_setattr which is not more than just
> dirtying the inode.  NFS and CIFS set S_NOCMTIME so they're not affected
> by this at all.

I've checked, and relatively few filesystems set S_NOCMTIME:

 cifs, fuse, nfs

But there are quite a few others which don't call inode_setattr (which
means that the unchanged time optimization is lost), or which do
something possibly slow in their ->setattr():

 adfs, 9p, afs, coda, gfs2 ...

just to name a few at the start of the alphabet.

So it looks to me as this could cause some unintended performance
regressions in these filesystems.

Miklos
