Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 491717FB4
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 16:24:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B0499AC002
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 14:24:03 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xxtWzCxDQhoYZru5 for <xfs@oss.sgi.com>;
	Wed, 24 Feb 2016 14:24:00 -0800 (PST)
Received: from Liberator.example.com
	(74-95-67-117-Minnesota.hfc.comcastbusiness.net [74.95.67.117])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6B51463CE6BA
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 16:23:59 -0600 (CST)
Subject: Re: XFS Corruption
References: <CACepTxgki0HxCv4MwBRbtP0k2hv8Qguq-UO_BA3U0eeAsN_8Fw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56CE2D7D.20800@sandeen.net>
Date: Wed, 24 Feb 2016 16:23:57 -0600
MIME-Version: 1.0
In-Reply-To: <CACepTxgki0HxCv4MwBRbtP0k2hv8Qguq-UO_BA3U0eeAsN_8Fw@mail.gmail.com>
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

On 2/24/16 12:12 AM, fangchen sun wrote:
> Dear all:
> 
> I have a ceph object storage cluster, and choose XFS as the underlying file system.
> I recently ran into a problem that sometimes the function "setxattr()"  failed, 
> I can only umount the disk and repair it with "xfs_repair".
> 
> os: centos 6.5
> kernel version: 2.6.32

Problems with distribution kernels generally need to be reported and handled through
your distribution.  And when you do, providing the full unedited dmesg - which
should include an actual description of the error from xfs, rather than just
the backtrace below - and the results of the xfs_repair, will be necessary.

Thanks,
-Eric
 
> the log for dmesg command:
> [41796028.532225] Pid: 1438740, comm: ceph-osd Not tainted 2.6.32-925.431.23.3.letv.el6.x86_64 #1
> [41796028.532227] Call Trace:
> [41796028.532255]  [<ffffffffa01e1e5f>] ? xfs_error_report+0x3f/0x50 [xfs]
> [41796028.532276]  [<ffffffffa01d506a>] ? xfs_da_read_buf+0x2a/0x30 [xfs]
> [41796028.532296]  [<ffffffffa01e1ece>] ? xfs_corruption_error+0x5e/0x90 [xfs]
> [41796028.532316]  [<ffffffffa01d4f4c>] ? xfs_da_do_buf+0x6cc/0x770 [xfs]
> [41796028.532335]  [<ffffffffa01d506a>] ? xfs_da_read_buf+0x2a/0x30 [xfs]
> [41796028.532359]  [<ffffffffa0206fc7>] ? kmem_zone_alloc+0x77/0xf0 [xfs]
> [41796028.532380]  [<ffffffffa01d506a>] ? xfs_da_read_buf+0x2a/0x30 [xfs]
> [41796028.532399]  [<ffffffffa01bc481>] ? xfs_attr_leaf_addname+0x61/0x3d0 [xfs]
> [41796028.532426]  [<ffffffffa01bc481>] ? xfs_attr_leaf_addname+0x61/0x3d0 [xfs]
> [41796028.532455]  [<ffffffffa01ff187>] ? xfs_trans_add_item+0x57/0x70 [xfs]
> [41796028.532476]  [<ffffffffa01cc208>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
> [41796028.532495]  [<ffffffffa01bcbb4>] ? xfs_attr_set_int+0x3c4/0x510 [xfs]
> [41796028.532517]  [<ffffffffa01d4f5b>] ? xfs_da_do_buf+0x6db/0x770 [xfs]
> [41796028.532536]  [<ffffffffa01bcd81>] ? xfs_attr_set+0x81/0x90 [xfs]
> [41796028.532560]  [<ffffffffa0216cc3>] ? __xfs_xattr_set+0x43/0x60 [xfs]
> [41796028.532584]  [<ffffffffa0216d31>] ? xfs_xattr_user_set+0x11/0x20 [xfs]
> [41796028.532592]  [<ffffffff811aee92>] ? generic_setxattr+0xa2/0xb0
> [41796028.532596]  [<ffffffff811b134e>] ? __vfs_setxattr_noperm+0x4e/0x160
> [41796028.532600]  [<ffffffff81196b77>] ? inode_permission+0xa7/0x100
> [41796028.532604]  [<ffffffff811b151c>] ? vfs_setxattr+0xbc/0xc0
> [41796028.532607]  [<ffffffff811b15f0>] ? setxattr+0xd0/0x150
> [41796028.532612]  [<ffffffff8105af80>] ? __dequeue_entity+0x30/0x50
> [41796028.532617]  [<ffffffff8100988e>] ? __switch_to+0x26e/0x320
> [41796028.532621]  [<ffffffff8118aec0>] ? __sb_start_write+0x80/0x120
> [41796028.532626]  [<ffffffff8152912e>] ? thread_return+0x4e/0x760
> [41796028.532630]  [<ffffffff811b171d>] ? sys_fsetxattr+0xad/0xd0
> [41796028.532633]  [<ffffffff8100b072>] ? system_call_fastpath+0x16/0x1b
> [41796028.532636] XFS (sdi1): Corruption detected. Unmount and run xfs_repair
> 
> Any comments will be much appreciated!
> 
> Best Regards!
> sunspot
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
