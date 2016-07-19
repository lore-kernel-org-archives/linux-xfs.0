Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9FFCE7CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 05:10:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 64796304032
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 03:10:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7GksDM4czQE4uprA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Jul 2016 03:10:47 -0700 (PDT)
Date: Tue, 19 Jul 2016 12:10:41 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfs_do_force_shutdown
Message-ID: <20160719101041.GA2430@redhat.com>
References: <CA++_uht+DQCXQ=oF0RWkje1dPxFTA9RNKH3rpGkL5gJBgFkDiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Kuo Hugo <tonytkdk@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 19, 2016 at 05:17:25PM +0800, Kuo Hugo wrote:
>    Hi Folks,
>    I got a question regarding to xfs_do_force_shutdown. The smartctl
>    doesn't show any clue about disk bad. The device works properly again
>    after remount. The xfs_repair complete to repair the device very quick
>    and these's not too much suspecious.
>    * Is this a xfs level issue about dirty logs ?
>    * Is this HBA problem ?
>    ```

It's certainly an I/O error, but why it happened needs further investigation. I
can't say what happened without looking on the remaining logs to see if is there
something else there. There are probably more errors from the block layer than
the one you pasted here, please, attach the complete log of the system where it
happened, dmesg and /var/log/messages files.

Also, the device might be working properly again, because you haven't tried to
read/write sector 3909224960, which is the sector that looks to have triggered
the errors you specified.

Also, what's the kernel version you are using? the amount of
"xfs_log_force: error -5 returned" messages, says it's a quite old kernel.


Cheers.

>    Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330404]
>    blk_update_request: I/O error, dev sdy, sector 3909224960
>    Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330650] XFS (sdy):
>    metadata I/O error: block 0xe9020a00 ("xlog_iodone") error 5 numblks 64
>    Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330939] XFS (sdy):
>    xfs_do_force_shutdown(0x2) called from line 1179 of file
>    /build/linux-lts-vivid-whAhIw/linux-lts-vivid-3.19.0/fs/xfs/xfs_log.c.
>    Return address = 0xffffffffc06a1d96
>    Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330973] XFS (sdy):
>    xfs_log_force: error -5 returned.
>    Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.330999] XFS (sdy): Log
>    I/O Error Detected.  Shutting down filesystem
>    Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.331206] XFS (sdy): Please
>    umount the filesystem and rectify the problem(s)
>    Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.331443] Buffer I/O error
>    on dev sdy, logical block 18, lost async page write
>    Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.337098] Buffer I/O error
>    on dev sdy, logical block 30523594, lost async page write
>    Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.348492] Buffer I/O error
>    on dev sdy, logical block 19, lost async page write
>    Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.359941] Buffer I/O error
>    on dev sdy, logical block 30523599, lost async page write
>    Jul 17 22:52:31 HBGTCOBSON02 kernel: [9291040.380649] XFS (sdy):
>    xfs_log_force: error -5 returned.
>    Jul 17 22:52:59 HBGTCOBSON02 kernel: [9291069.111432] XFS (sdy):
>    xfs_log_force: error -5 returned.
>    Jul 17 22:53:29 HBGTCOBSON02 kernel: [9291099.215252] XFS (sdy):
>    xfs_log_force: error -5 returned.
>    Jul 17 22:53:33 HBGTCOBSON02 kernel: [9291102.517951] XFS (sdy):
>    xfs_log_force: error -5 returned.
>    Jul 17 22:53:33 HBGTCOBSON02 kernel: [9291102.517981] XFS (sdy):
>    xfs_log_force: error -5 returned.
>    Jul 17 22:53:33 HBGTCOBSON02 kernel: [9291102.518006] XFS (sdy):
>    xfs_log_force: error -5 returned.
>    Jul 18 08:35:55 HBGTCOBSON02 kernel: [9326072.158898] XFS (sdy):
>    Mounting V4 Filesystem
>    Jul 18 08:35:55 HBGTCOBSON02 kernel: [9326072.279516] XFS (sdy):
>    Starting recovery (logdev: internal)
>    Jul 18 08:35:55 HBGTCOBSON02 kernel: [9326072.725549] XFS (sdy): Ending
>    recovery (logdev: internal)
>    ```
>    thanks // Hugo

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
