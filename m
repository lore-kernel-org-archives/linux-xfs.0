Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA6DcCCd220541 for <xfs@oss.sgi.com>; Fri, 6 Nov 2009 07:38:12 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B0EA675A1
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2009 05:38:26 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id JdCwbDoGw70dtsZd for
	<xfs@oss.sgi.com>; Fri, 06 Nov 2009 05:38:26 -0800 (PST)
References: <200911061017.12200@zmi.at>
Message-Id: <88ED0857-A754-4E3C-BA26-FC5EE85D7394@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <200911061017.12200@zmi.at>
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: kernel crash with damaged XFS
Date: Fri, 6 Nov 2009 07:38:23 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Nov 6, 2009, at 3:17 AM, Michael Monnerie <michael.monnerie@is.it-management.at 
 > wrote:

> I had that during the last days on my system. It kept on running  
> despite
> this error. I xfs_repair'ed the fs again and now it's working.
> This is the same server I talked about with Eric last time, where he
> improved xfs_repair and that repaired my fs. I had to run
> xfs_repair several times again until all errors were solved,
> and now nothing is reported anymore.
> The server had no crash or whatever since the last repair, so I wonder
> where these corruptions come from.
>
> Nov  2 00:01:12 orion.i.zmi.at kernel: Filesystem "dm-0": corrupt  
> inode 3858839593 ((a)extents = 7).  Unmount and run xfs_repair.

Just FWIW this is not a crash, it is XFS properly handling corrruption  
it encountered.  The corruption could be due to a bug in XFS or other  
code, or a hardware problem.  Does repair fix it this time?

- Eric

> Nov  2 00:01:12 orion.i.zmi.at kernel: Pid: 18910, comm: find  
> Tainted: G          2.6.27.29-0.1-xen #1
> Nov  2 00:01:12 orion.i.zmi.at kernel:
> Nov  2 00:01:12 orion.i.zmi.at kernel: Call Trace:
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffff8020c597>]  
> show_trace_log_lvl+0x41/0x58
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffff80464a12>]  
> dump_stack+0x69/0x6f
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffffa033cbdb>]  
> xfs_iformat_extents+0xc9/0x1c4 [xfs]
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffffa033d136>]  
> xfs_iformat+0x2b0/0x3f7 [xfs]
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffffa033d364>]  
> xfs_iread+0xe7/0x1eb [xfs]
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffffa0338910>]  
> xfs_iget_core+0x3a5/0x63a [xfs]
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffffa0338c87>] xfs_iget 
> +0xe2/0x187 [xfs]
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffffa0352912>]  
> xfs_lookup+0x79/0xa5 [xfs]
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffffa035b53f>]  
> xfs_vn_lookup+0x3c/0x78 [xfs]
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffff802a603b>]  
> real_lookup+0x7e/0x10f
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffff802a612f>]  
> do_lookup+0x63/0xb6
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffff802a87aa>]  
> __link_path_walk+0x9f4/0xe58
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffff802a8dd9>]  
> path_walk+0x5e/0xba
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffff802a8f97>]  
> do_path_lookup+0x162/0x1b9
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffff802a9930>]  
> user_path_at+0x48/0x79
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffff802a1e85>]  
> vfs_lstat_fd+0x15/0x41
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffff802a1f88>]  
> sys_newfstatat+0x22/0x43
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<ffffffff8020b3b8>]  
> system_call_fastpath+0x16/0x1b
> Nov  2 00:01:12 orion.i.zmi.at kernel:  [<00007f265cb0f4de>]  
> 0x7f265cb0f4de
>
>
> mfg zmi
> -- 
> // Michael Monnerie, Ing.BSc    -----      http://it-management.at
> // Tel: 0660 / 415 65 31                      .network.your.ideas.
> // PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
> // Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
> // Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4
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
