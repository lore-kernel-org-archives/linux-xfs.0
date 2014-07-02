Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C6BD7F54
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 08:07:59 -0500 (CDT)
Message-ID: <53B40427.6060302@sgi.com>
Date: Wed, 02 Jul 2014 08:07:51 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
In-Reply-To: <20140702120441.GA51757@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: "Carlos E. R." <carlos.e.r@opensuse.org>, XFS mail list <xfs@oss.sgi.com>

On 07/02/14 07:04, Brian Foster wrote:
> On Wed, Jul 02, 2014 at 11:57:25AM +0200, Carlos E. R. wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>>
>>
>> Hi,
>>
>> I got this error:
>>
>>
>> <0.6>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.186436] r8169 0000:06:00.0 eth0: link up
>> <0.6>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.615073] PM: restore of devices complete after 2735.034 msecs
>> <0.1>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626346] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c39fe9
>> <0.1>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626346]<0.4>
>> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626348] CPU: 0 PID: 28875
>> Comm: kworker/0:2 Tainted: P           O 3.11.10-11-desktop #1
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626348] Hardware name: MICRO-STAR INTERNATIONAL CO.,LTD MS-7516/MS-7516, BIOS V1.5 10/10/2008
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626388] Workqueue: xfs-eofblocks/sde5 xfs_eofblocks_worker [xfs]
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626390]  0000000000000002 ffffffff815a0252 00000000002a61c2 ffffffffa0c38996
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626391]  ffff8800b7025680 ffff88022eb74180 ffff880121c3fe50 0000000000000002
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626393]  0000000000000000 0000000100000000 0000000000000000 0000000000000001
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626393] Call Trace:
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626403]  [<ffffffff81004a28>] dump_trace+0x88/0x310
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626406]  [<ffffffff81004d80>] show_stack_log_lvl+0xd0/0x1d0
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626408]  [<ffffffff810061bc>] show_stack+0x1c/0x50
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626411]  [<ffffffff815a0252>] dump_stack+0x50/0x89
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626425]  [<ffffffffa0c38996>] xfs_free_ag_extent+0x226/0x860 [xfs]
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626468]  [<ffffffffa0c39fe9>] xfs_free_extent+0xb9/0xf0 [xfs]
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626510]  [<ffffffffa0c4c39e>] xfs_bmap_finish+0x11e/0x170 [xfs]
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626560]  [<ffffffffa0c6b4c0>] xfs_itruncate_extents+0x190/0x340 [xfs]
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626623]  [<ffffffffa0c33633>] xfs_free_eofblocks+0x1e3/0x260 [xfs]
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626659]  [<ffffffffa0c291ef>] xfs_inode_free_eofblocks+0x6f/0x150 [xfs]
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626688]  [<ffffffffa0c27f82>] xfs_inode_ag_walk.isra.10+0x1c2/0x310 [xfs]
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626716]  [<ffffffffa0c28a8e>] xfs_inode_ag_iterator_tag+0x6e/0xb0 [xfs]
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626744]  [<ffffffffa0c28d82>] xfs_eofblocks_worker+0x12/0x20 [xfs]
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626763]  [<ffffffff8106ac78>] process_one_work+0x168/0x490
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626765]  [<ffffffff8106b914>] worker_thread+0x114/0x3a0
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626768]  [<ffffffff81071c3f>] kthread+0xaf/0xc0
>> <0.4>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626771]  [<ffffffff815addfc>] ret_from_fork+0x7c/0xb0
>> <0.5>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.626776] XFS (sde5): xfs_do_force_shutdown(0x8) called from line 916 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_bmap.c.  Return address = 0xffffffffa0c4c3d8
>> <0.1>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.706440] XFS (sde5): Corruption of in-memory data detected.  Shutting down filesystem
>> <0.1>  2014-06-29 12:32:18 Telcontar kernel - - - [212890.706440] XFS (sde5): Please umount the filesystem and rectify the problem(s)
>>
>
> This is the background eofblocks scanner attempting to free preallocated
> space on a file. The scanner looks for files that have been recently
> grown and since been flushed to disk (i.e., no longer concurrently being
> written to) and trims the post-eof preallocation that comes along with
> growing files.
>
> The corruption errors at xfs_alloc.c:1602,1629 on v3.11 fire if the
> extent we are attempting to free is already accounted for in the
> by-block allocation btree. IOW, this is attempting to free an extent
> that the allocation metadata thinks is already free.
>
>>
>> Brief description:
>>
>>
>>   * It happens only on restore from hibernation.
>
> Interesting, could you elaborate a bit more on the behavior this system
> is typically subjected to? i.e., is this a server that sees a constant
> workload that is also frequently hibernated/awakened?
>
>>   * It happens randomly, spaced a month or two.
>>   * It happens always on the same partition, the one that holds /home
>>     (I have 10 XFS partitions spread on 4 internal hard disks, and a few
>>     more external). It is a new disk, 2 TB, traditional MBR partitions.
>>   * Disk has no defects, or at least so says smartctl long test.
>>   * When it happens, recovery is impossible: xfs_repair does not seem to
>>     find anything, or maybe it does, silently; but on system reuse,
>>     it crashes again, fast.
>>   * Thus recovery procedure is to use "xfsdump" to get a backup copy,
>>     reformat the partition, and recover the files with xfsrestore.
>>
>>
>> The worst issue for me is that "xfs_repair" fails to repair it.

what version of xfs_repair? Did you try to mount to replay the log 
before repair?

Besides Brian's good advice, is kdump configured to dump vmcore?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
