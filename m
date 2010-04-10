Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3A2Zt8s161474 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 21:35:56 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 532512B2807
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 19:37:47 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 7uD10BhRC9HxDxXb
	for <xfs@oss.sgi.com>; Fri, 09 Apr 2010 19:37:47 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 2717A6C3DC
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 21:37:45 -0500 (CDT)
Message-ID: <4BBFE478.3090901@hardwarefreak.com>
Date: Fri, 09 Apr 2010 21:37:44 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: [PATCH] enable inode64 by default when possible
References: <4B7309D7.5090800@sandeen.net> <1270850499.7840.25.camel@doink>
In-Reply-To: <1270850499.7840.25.camel@doink>
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
To: xfs@oss.sgi.com

Alex Elder put forth on 4/9/2010 5:01 PM:

> OK, it's been about two months since Eric proposed this, and
> I'm finally getting around to writing up a response.
> 
> I discussed this with a few people within SGI, and there were
> two main concerns that were mentioned:
> - This may be a problem for some NFS clients
> - This may be a problem for some backup software
> We don't believe there are any direct issues with DMF or CXFS
> in making this change.
> 
> I understand that the change is only in the default behavior,
> and that forcing 32-bit inodes will still be an available
> option.

Hi Alex,

How will this change affect those people running 32bit CPUs and kernels, if
at all?  Or is this change related not to the word width of the hardware/OS
but to the size of the filesystem and/or number of files/inodes contained
within?  You mentioned possible issues with NFS.  Are there any issues with
Samba?

Intel Atom (32bit x86) CPUs and XFS on multi terabyte disks are popular with
many folks running Linux based media PCs, streaming their ripped DVDs and
other large media files from their XFS filesystems.  I don't personally do
this, but I also have 32bit only systems that won't be replaced with 64bit
CPUs for some time to come.

Thanks.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
