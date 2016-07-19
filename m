Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E70387CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 15:21:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F4198F8037
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 13:21:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Vwy2DeQUZrYwnrWt for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2016 13:21:19 -0700 (PDT)
Received: from Liberator.local (204-195-32-108.wavecable.com [204.195.32.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 027D34A4
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 15:21:18 -0500 (CDT)
Subject: Re: xfs_do_force_shutdown
References: <CA++_uht+DQCXQ=oF0RWkje1dPxFTA9RNKH3rpGkL5gJBgFkDiQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d74812e6-6b34-d548-944e-547f89413093@sandeen.net>
Date: Tue, 19 Jul 2016 13:21:17 -0700
MIME-Version: 1.0
In-Reply-To: <CA++_uht+DQCXQ=oF0RWkje1dPxFTA9RNKH3rpGkL5gJBgFkDiQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 7/19/16 2:17 AM, Kuo Hugo wrote:
> Hi Folks, 
> 
> I got a question regarding to xfs_do_force_shutdown. The smartctl
> doesn't show any clue about disk bad. The device works properly again
> after remount. The xfs_repair complete to repair the device very
> quick and these's not too much suspecious.
> 
> 
> * Is this a xfs level issue about dirty logs ? 
> * Is this HBA problem ?
> 
> 
> ```
> Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330404] blk_update_request: I/O error, dev sdy, sector 3909224960

The root cause here is that IO error from the block device.
Everything else is XFS reacting to that error; it does not
indicate an xfs bug.

-Eric

> Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330650] XFS (sdy): metadata I/O error: block 0xe9020a00 ("xlog_iodone") error 5 numblks 64
> Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330939] XFS (sdy): xfs_do_force_shutdown(0x2) called from line 1179 of file /build/linux-lts-vivid-whAhIw/linux-lts-vivid-3.19.0/fs/xfs/xfs_log.c.  Return address = 0xffffffffc06a1d96
> Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330973] XFS (sdy): xfs_log_force: error -5 returned.
> Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330999] XFS (sdy): Log I/O Error Detected.  Shutting down filesystem
> Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.331206] XFS (sdy): Please umount the filesystem and rectify the problem(s)
> Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.331443] Buffer I/O error on dev sdy, logical block 18, lost async page write
> Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.337098] Buffer I/O error on dev sdy, logical block 30523594, lost async page write
> Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.348492] Buffer I/O error on dev sdy, logical block 19, lost async page write
> Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.359941] Buffer I/O error on dev sdy, logical block 30523599, lost async page write
> Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.380649] XFS (sdy): xfs_log_force: error -5 returned.
> Jul 17 22:52:59 HBGTCOBSON02 kernel: [9291069.111432] XFS (sdy): xfs_log_force: error -5 returned.
> Jul 17 22:53:29 HBGTCOBSON02 kernel: [9291099.215252] XFS (sdy): xfs_log_force: error -5 returned.
> Jul 17 22:53:33 HBGTCOBSON02 kernel: [9291102.517951] XFS (sdy): xfs_log_force: error -5 returned.
> Jul 17 22:53:33 HBGTCOBSON02 kernel: [9291102.517981] XFS (sdy): xfs_log_force: error -5 returned.
> Jul 17 22:53:33 HBGTCOBSON02 kernel: [9291102.518006] XFS (sdy): xfs_log_force: error -5 returned.
> Jul 18 08:35:55 HBGTCOBSON02 kernel: [9326072.158898] XFS (sdy): Mounting V4 Filesystem
> Jul 18 08:35:55 HBGTCOBSON02 kernel: [9326072.279516] XFS (sdy): Starting recovery (logdev: internal)
> Jul 18 08:35:55 HBGTCOBSON02 kernel: [9326072.725549] XFS (sdy): Ending recovery (logdev: internal)
> ```
> 
> thanks // Hugo
> 
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
