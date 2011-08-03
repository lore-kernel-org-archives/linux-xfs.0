Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p735W0LK136308 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 00:32:00 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7A63B6C15
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2011 22:31:59 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	9hGPiGgfRQLaGMfn for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2011 22:31:59 -0700 (PDT)
Received: by iym5 with SMTP id 5so330135iym.26
	for <xfs@oss.sgi.com>; Tue, 02 Aug 2011 22:31:59 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 3 Aug 2011 13:31:58 +0800
Message-ID: <CAOJJ1Zp9YTKxCr2H-betxrTWSdQ0joWCBQXJFyOQm364RLFHJg@mail.gmail.com>
Subject: Help: XFS failure in AoE environment
From: Lee Eric <openlinuxsource@gmail.com>
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
To: xfs@oss.sgi.com, aoetools-discuss@lists.sourceforge.net

Hi,

I encounter following error when I do rw operate(touch afile) in a
mounted AoE device.

[246817.267117] end_request: I/O error, dev etherd/e0.0, sector 2112
[246817.269673] I/O error in filesystem ("etherd/e0.0p1") meta-data
dev etherd/e0.0p1 block 0x40       ("xfs_trans_read_buf") error 5 buf
count 8192
[246817.271625] xfs_imap_to_bp: xfs_trans_read_buf()returned an error
5 on etherd/e0.0p1.  Returning error.
[246817.273679] aoe: device 0.0 is not up
[246817.274609] end_request: I/O error, dev etherd/e0.0, sector 2072
[246817.275753] I/O error in filesystem ("etherd/e0.0p1") meta-data
dev etherd/e0.0p1 block 0x18       ("xfs_trans_read_buf") error 5 buf
count 4096
[246825.921150] aoe: device 0.0 is not up
[246825.922041] end_request: I/O error, dev etherd/e0.0, sector 2112
[246825.925328] I/O error in filesystem ("etherd/e0.0p1") meta-data
dev etherd/e0.0p1 block 0x40       ("xfs_trans_read_buf") error 5 buf
count 8192
[246825.929950] xfs_imap_to_bp: xfs_trans_read_buf()returned an error
5 on etherd/e0.0p1.  Returning error.
[246826.059006] aoe: device 0.0 is not up
[246826.059916] end_request: I/O error, dev etherd/e0.0, sector 513058
[246826.061380] I/O error in filesystem ("etherd/e0.0p1") meta-data
dev etherd/e0.0p1 block 0x7cc22       ("xlog_iodone") error 5 buf
count 1024
[246826.063761] xfs_force_shutdown(etherd/e0.0p1,0x2) called from line
944 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0400f85
[246826.066437] Filesystem "etherd/e0.0p1": Log I/O Error Detected.
Shutting down filesystem: etherd/e0.0p1
[246826.068615] Please umount the filesystem, and rectify the problem(s)
[246826.069801] xfs_force_shutdown(etherd/e0.0p1,0x1) called from line
1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address =
0xffffffffa0417c2a
[246830.158555] xfs_force_shutdown(etherd/e0.0p1,0x1) called from line
1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address =
0xffffffffa0417c2a
[246837.513785] xfs_force_shutdown(etherd/e0.0p1,0x1) called from line
1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address =
0xffffffffa0417c2a
[246848.280546] xfs_force_shutdown(etherd/e0.0p1,0x1) called from line
1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address =
0xffffffffa0417c2a
[246854.464107] Filesystem "etherd/e0.0p1": xfs_log_force: error 5 returned.
[246860.477020] xfs_force_shutdown(etherd/e0.0p1,0x1) called from line
1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address =
0xffffffffa0417c2a
[246871.807801] xfs_force_shutdown(etherd/e0.0p1,0x1) called from line
1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address =
0xffffffffa0417c2a
[246883.345140] xfs_force_shutdown(etherd/e0.0p1,0x1) called from line
1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address =
0xffffffffa0417c2a
[246884.465156] Filesystem "etherd/e0.0p1": xfs_log_force: error 5 returned.
[246894.424083] xfs_force_shutdown(etherd/e0.0p1,0x1) called from line
1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address =
0xffffffffa0417c2a

The touch process seems hang and process status is D+. My OS is Fedora
14 x86_64 arch. AoE version is 77.

It happens several times, is there any way to fix that?

Thanks.

Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
