Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB21KFGM003055 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 19:20:16 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay3.corp.sgi.com (Postfix) with SMTP id A8552AC09B
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2008 17:20:11 -0800 (PST)
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com
	[134.14.54.237]) by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA23639 for
	<xfs@oss.sgi.com>; Tue, 2 Dec 2008 12:20:10 +1100
Subject: TAKE - xfsprogs: pad ustat struct for mount check to avoid corruption
Message-Id: <20081202012010.217DA58ADBF6@chook.melbourne.sgi.com>
Date: Tue,  2 Dec 2008 12:20:09 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Linux kernels (at least up until 2.6.27) are lacking compat sys_ustat
handlers on some platforms (notably PPC) so that if called from 32 bits
on a 64-bit kernel, the kernel will copy out too much (32 bytes onto a
20-byte structure):
 
[root@xero xfstests]# xfs_logprint /dev/loop0
xfs_logprint:
*** stack smashing detected ***: xfs_logprint terminated
Aborted
 
This will be fixed upstream, but for the benefit of older kernels we
may want to guard against this by padding the structure we pass into
the syscall.   We don't care about the values anyway, just the return
value.
 
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Tue Dec  2 12:17:58 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xcmds-clean
Inspected by:  Eric Sandeen <sandeen@sandeen.net>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32618a
xfsprogs/libxfs/linux.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/linux.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- Pad ustat struct to avoid stack corruption


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
