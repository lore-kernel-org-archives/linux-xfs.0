Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92LTdkO088143 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 16:29:39 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id gwLkSKO8FwBhHzdj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 14:31:02 -0700 (PDT)
Message-ID: <506B5D11.4030107@tlinx.org>
Date: Tue, 02 Oct 2012 14:30:57 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
References: <506B1A03.7030600@tlinx.org> <20121002201748.GQ23520@dastard>
In-Reply-To: <20121002201748.GQ23520@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>


> 
> xfsprogs has had this support via readline since, well, before I
> started working on XFS....
---
ok... I know this isn't in my version...
> which xfs_db
/usr/sbin/xfs_db
Ishtar:law> ldd /usr/sbin/xfs_db
         linux-vdso.so.1 (0x00007fffbcb07000)
         libuuid.so.1 => /lib64/libuuid.so.1 (0x0000003007200000)
         libpthread.so.0 => /lib64/libpthread.so.0 (0x0000003001000000)
         libc.so.6 => /lib64/libc.so.6 (0x0000003000400000)
         /lib64/ld-linux-x86-64.so.2 (0x0000003000000000)
--- there is no libreadline

Hmmm....maybe it's a distro bug...but can't figure out why they'd turn it off...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
