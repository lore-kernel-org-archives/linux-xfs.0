Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2RKNcx7006134 for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 15:23:48 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF4ED1CE30E
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 13:23:11 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id igsZg37crIjshEAJ for <xfs@oss.sgi.com>;
	Fri, 27 Mar 2009 13:23:11 -0700 (PDT)
Message-ID: <49CD359E.905@sandeen.net>
Date: Fri, 27 Mar 2009 15:22:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Corruption of in-memory data
References: <49CD2EF0.9060009@blackopscode.com>
In-Reply-To: <49CD2EF0.9060009@blackopscode.com>
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
To: Florian Hines <fhines@blackopscode.com>
Cc: xfs@oss.sgi.com

Florian Hines wrote:
> Hey everybody,
> 
> Over the last few day's I've been getting a rash (8 so far) of disk's
> throwing the error "Filesystem "sdxX": Corruption of in-memory data
> detected.  Shutting down filesystem: sdxX".  xfs_check never seem's to
> find anything and just unmounting and remounting solves the issue at
> least for awhile.   

try xfs_repair, with -n if you want a dry run.

It's canceling a dirty transaction, I'm not sure why.  The message is a
little misleading.  Want to try 2.6.29? :)

-Eric

> Is this usually caused by bad ram ?  It's happened
> on 6 systems so far (all using Debian Etch AMD64 with the stock 2.6.18
> kernel, each system as a 5 sata drives, not raided).
> 
> Can anyone shed some light on what this error actually indicates for me  ?
> 
> --Full error from dmesg below--
>  Filesystem "sda3": XFS internal error xfs_trans_cancel at line 1138 of
> file fs/xfs/xfs_trans.c.  Caller 0xffffffff8818ead5
> 
> Call Trace:
>  [<ffffffff8818fdd0>] :xfs:xfs_trans_cancel+0x5b/0xfe
>  [<ffffffff8818ead5>] :xfs:xfs_rename+0xa13/0xa9a
>  [<ffffffff881a0aac>] :xfs:xfs_vn_rename+0x2c/0x6f
>  [<ffffffff80220104>] __up_read+0x13/0x8a
>  [<ffffffff8817c732>] :xfs:xfs_iunlock+0x57/0x79
>  [<ffffffff80220104>] __up_read+0x13/0x8a
>  [<ffffffff8817c732>] :xfs:xfs_iunlock+0x57/0x79
>  [<ffffffff88195286>] :xfs:xfs_access+0x3d/0x46
>  [<ffffffff80228cc4>] vfs_rename+0x2d5/0x426
>  [<ffffffff802344fb>] sys_renameat+0x180/0x1f9
>  [<ffffffff80221605>] sys_newstat+0x28/0x31
>  [<ffffffff80257c16>] system_call+0x7e/0x83
> 
> xfs_force_shutdown(sda3,0x8) called from line 1139 of file
> fs/xfs/xfs_trans.c.  Return address = 0xffffffff8818fdee
> Filesystem "sda3": Corruption of in-memory data detected.  Shutting down
> filesystem: sda3
> Please umount the filesystem, and rectify the problem(s)
> 
> 
> --
> flo
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
