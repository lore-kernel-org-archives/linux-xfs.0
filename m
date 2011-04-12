Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3CAm1lX145607 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 05:48:02 -0500
Received: from nm24-vm0.bullet.mail.sp2.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 850AABBA130
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 03:51:21 -0700 (PDT)
Received: from nm24-vm0.bullet.mail.sp2.yahoo.com
	(nm24-vm0.bullet.mail.sp2.yahoo.com [98.139.91.226]) by
	cuda.sgi.com with SMTP id 9UCFlzhIGyY1ZeMB for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2011 03:51:21 -0700 (PDT)
Message-ID: <38287.10078.qm@web112901.mail.gq1.yahoo.com>
References: <31377534.post@talk.nabble.com> <20110412094917.GY31057@dastard>
Date: Tue, 12 Apr 2011 03:51:20 -0700 (PDT)
From: Leo Davis <leo1783@yahoo.com>
Subject: Re: fs corruption
In-Reply-To: <20110412094917.GY31057@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5007183295558255908=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============5007183295558255908==
Content-Type: multipart/alternative; boundary="0-1099530454-1302605480=:10078"

--0-1099530454-1302605480=:10078
Content-Type: text/plain; charset=us-ascii

You have a corrupted free space btree.

Err... apologies for my ignorance, but what is a free space btree?

I had serial trace from raid controller which i just checked and it logged some 
'Loose cabling', but this was months back.....
not sure whether that can be the cause of this.. strange if that is the case 
since it's been a long time




________________________________
From: Dave Chinner <david@fromorbit.com>
To: stress_buster <leo1783@yahoo.com>
Cc: xfs@oss.sgi.com
Sent: Tue, April 12, 2011 3:19:17 PM
Subject: Re: fs corruption

On Tue, Apr 12, 2011 at 02:33:07AM -0700, stress_buster wrote:
> 
> My dmesg output shows the below trace. It repeats over and over again.
> 
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1545 of file
> fs/xfs/xfs_alloc.c.  Caller 0xffffffff881a8961
> 
> Call Trace:
>  [<ffffffff881a6e27>] :xfs:xfs_free_ag_extent+0x19e/0x67e
>  [<ffffffff881a8961>] :xfs:xfs_free_extent+0xa9/0xc9
>  [<ffffffff881d96cf>] :xfs:xlog_recover_process_efi+0x112/0x16c
>  [<ffffffff881f31b4>] :xfs:xfs_fs_fill_super+0x0/0x3e4
>  [<ffffffff881da8c2>] :xfs:xlog_recover_process_efis+0x4f/0x8d
>  [<ffffffff881da914>] :xfs:xlog_recover_finish+0x14/0xad
>  [<ffffffff881f31b4>] :xfs:xfs_fs_fill_super+0x0/0x3e4
>  [<ffffffff881df420>] :xfs:xfs_mountfs+0x498/0x5e2
>  [<ffffffff881dfb42>] :xfs:xfs_mru_cache_create+0x113/0x143
>  [<ffffffff881f33b7>] :xfs:xfs_fs_fill_super+0x203/0x3e4
>  [<ffffffff800e544f>] get_sb_bdev+0x10a/0x16c
>  [<ffffffff800e4dec>] vfs_kern_mount+0x93/0x11a
>  [<ffffffff800e4eb5>] do_kern_mount+0x36/0x4d
>  [<ffffffff800ef2ed>] do_mount+0x6a9/0x719
>  [<ffffffff80008d84>] __handle_mm_fault+0x5f2/0xfaa
>  [<ffffffff80022127>] __up_read+0x19/0x7f
>  [<ffffffff80067b88>] do_page_fault+0x4fe/0x874
>  [<ffffffff8012c580>] inode_doinit_with_dentry+0x86/0x47c
>  [<ffffffff800cd378>] zone_statistics+0x3e/0x6d
>  [<ffffffff8000f2ff>] __alloc_pages+0x78/0x308
>  [<ffffffff8004c9fd>] sys_mount+0x8a/0xcd
>  [<ffffffff8005e116>] system_call+0x7e/0x83
> 
> Failed to recover EFIs on filesystem: cciss/c0d0
> XFS: log mount finish failed
> 
> Can someone shed some light on what is happening here?

You have a corrupted free space btree. How it occurred, I have no
idea.

> Also what the next steps I need to take to repair the fs? (assuming my xfs
> fs is corrupted)
> Will running xfs_repair be good enough in this case?

That's all you can do. If it's really important, and you don't have
a backup, I'd suggest mounting with "-o ro,norecovery" and taking a
backup first....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--0-1099530454-1302605480=:10078
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman,new york,times,serif;font-size:12pt">You have a corrupted free space btree.<br><br>Err... apologies for my ignorance, but what is a free space btree?<div><br></div><div style="font-family: times new roman,new york,times,serif; font-size: 12pt;">I had serial trace from raid controller which i just checked and it logged some 'Loose cabling', but this was months back.....<br>not sure whether that can be the cause of this.. strange if that is the case since it's been a long time<br><br><br><div style="font-family: arial,helvetica,sans-serif; font-size: 13px;"><font face="Tahoma" size="2"><hr size="1"><b><span style="font-weight: bold;">From:</span></b> Dave Chinner &lt;david@fromorbit.com&gt;<br><b><span style="font-weight: bold;">To:</span></b> stress_buster &lt;leo1783@yahoo.com&gt;<br><b><span style="font-weight: bold;">Cc:</span></b>
 xfs@oss.sgi.com<br><b><span style="font-weight: bold;">Sent:</span></b> Tue, April 12, 2011 3:19:17 PM<br><b><span style="font-weight: bold;">Subject:</span></b> Re: fs corruption<br></font><br>
On Tue, Apr 12, 2011 at 02:33:07AM -0700, stress_buster wrote:<br>&gt; <br>&gt; My dmesg output shows the below trace. It repeats over and over again.<br>&gt; <br>&gt; XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1545 of file<br>&gt; fs/xfs/xfs_alloc.c.&nbsp; Caller 0xffffffff881a8961<br>&gt; <br>&gt; Call Trace:<br>&gt;&nbsp; [&lt;ffffffff881a6e27&gt;] :xfs:xfs_free_ag_extent+0x19e/0x67e<br>&gt;&nbsp; [&lt;ffffffff881a8961&gt;] :xfs:xfs_free_extent+0xa9/0xc9<br>&gt;&nbsp; [&lt;ffffffff881d96cf&gt;] :xfs:xlog_recover_process_efi+0x112/0x16c<br>&gt;&nbsp; [&lt;ffffffff881f31b4&gt;] :xfs:xfs_fs_fill_super+0x0/0x3e4<br>&gt;&nbsp; [&lt;ffffffff881da8c2&gt;] :xfs:xlog_recover_process_efis+0x4f/0x8d<br>&gt;&nbsp; [&lt;ffffffff881da914&gt;] :xfs:xlog_recover_finish+0x14/0xad<br>&gt;&nbsp; [&lt;ffffffff881f31b4&gt;] :xfs:xfs_fs_fill_super+0x0/0x3e4<br>&gt;&nbsp; [&lt;ffffffff881df420&gt;] :xfs:xfs_mountfs+0x498/0x5e2<br>&gt;&nbsp;
 [&lt;ffffffff881dfb42&gt;] :xfs:xfs_mru_cache_create+0x113/0x143<br>&gt;&nbsp; [&lt;ffffffff881f33b7&gt;] :xfs:xfs_fs_fill_super+0x203/0x3e4<br>&gt;&nbsp; [&lt;ffffffff800e544f&gt;] get_sb_bdev+0x10a/0x16c<br>&gt;&nbsp; [&lt;ffffffff800e4dec&gt;] vfs_kern_mount+0x93/0x11a<br>&gt;&nbsp; [&lt;ffffffff800e4eb5&gt;] do_kern_mount+0x36/0x4d<br>&gt;&nbsp; [&lt;ffffffff800ef2ed&gt;] do_mount+0x6a9/0x719<br>&gt;&nbsp; [&lt;ffffffff80008d84&gt;] __handle_mm_fault+0x5f2/0xfaa<br>&gt;&nbsp; [&lt;ffffffff80022127&gt;] __up_read+0x19/0x7f<br>&gt;&nbsp; [&lt;ffffffff80067b88&gt;] do_page_fault+0x4fe/0x874<br>&gt;&nbsp; [&lt;ffffffff8012c580&gt;] inode_doinit_with_dentry+0x86/0x47c<br>&gt;&nbsp; [&lt;ffffffff800cd378&gt;] zone_statistics+0x3e/0x6d<br>&gt;&nbsp; [&lt;ffffffff8000f2ff&gt;] __alloc_pages+0x78/0x308<br>&gt;&nbsp; [&lt;ffffffff8004c9fd&gt;] sys_mount+0x8a/0xcd<br>&gt;&nbsp; [&lt;ffffffff8005e116&gt;] system_call+0x7e/0x83<br>&gt; <br>&gt; Failed to recover
 EFIs on filesystem: cciss/c0d0<br>&gt; XFS: log mount finish failed<br>&gt; <br>&gt; Can someone shed some light on what is happening here?<br><br>You have a corrupted free space btree. How it occurred, I have no<br>idea.<br><br>&gt; Also what the next steps I need to take to repair the fs? (assuming my xfs<br>&gt; fs is corrupted)<br>&gt; Will running xfs_repair be good enough in this case?<br><br>That's all you can do. If it's really important, and you don't have<br>a backup, I'd suggest mounting with "-o ro,norecovery" and taking a<br>backup first....<br><br>Cheers,<br><br>Dave.<br>-- <br>Dave Chinner<br><a ymailto="mailto:david@fromorbit.com" href="mailto:david@fromorbit.com">david@fromorbit.com</a><br></div></div>
</div></body></html>
--0-1099530454-1302605480=:10078--


--===============5007183295558255908==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5007183295558255908==--
