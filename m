Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C7B97F67
	for <linux-xfs@oss.sgi.com>; Tue, 19 Mar 2013 03:20:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 274DE8F804B
	for <linux-xfs@oss.sgi.com>; Tue, 19 Mar 2013 01:20:16 -0700 (PDT)
Received: from smtp5.epfl.ch (smtp5.epfl.ch [128.178.224.8]) by cuda.sgi.com
	with SMTP id bZXMCWX2bcRAfnit for <linux-xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 01:20:12 -0700 (PDT)
Message-ID: <51481FF4.9060500@epfl.ch>
Date: Tue, 19 Mar 2013 09:21:08 +0100
From: Guillaume Anciaux <guillaume.anciaux@epfl.ch>
MIME-Version: 1.0
Subject: Re: mount XFS partition fail after repair when uquota and gquota
	are used
References: <1363600796196-34996.post@n7.nabble.com>
	<20130318233353.GT6369@dastard>
In-Reply-To: <20130318233353.GT6369@dastard>
Content-Type: multipart/mixed; boundary="------------070202080702080601030508"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------070202080702080601030508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/19/2013 12:33 AM, Dave Chinner wrote:
> On Mon, Mar 18, 2013 at 02:59:56AM -0700, anciaux wrote:
>> I have been struggling to repair a partition after a RAID disk set failure.
>>
>> Apparently the data is accessible with no problem since I can mount the
>> partition.
>>
>> The problem is ONLY when I use the uquota and gquota mount option (which I
>> was using freely before the disk failure).
>>
>> The syslog shows:
>>
>> Mar 18 09:35:50 storage kernel: [  417.885430] XFS (sdb1): Internal error
>> xfs_iformat(1) at line 319 of file
> And the line before this in your log should tell you what inode was
> corrupt. Can you paste it?
>
> Cheers,
>
> Dave.
Some lines were missing. Here is the complete log:

Mar 18 09:35:50 storage kernel: [  417.883817] XFS (sdb1): corrupt 
dinode 3224608213, extent total = 1, nblocks = 0.
Mar 18 09:35:50 storage kernel: [  417.883822] ffff880216304500: 49 4e 
81 a4 01 02 00 01 00 00 03 f4 00 00 03 f5  IN..............
Mar 18 09:35:50 storage kernel: [  417.883926] XFS (sdb1): Internal 
error xfs_iformat(1) at line 319 of file 
/build/buildd/linux-3.2.0/fs/xfs/xfs_inode.c.  Caller 0xffffffffa0308502
Mar 18 09:35:50 storage kernel: [  417.883928]
Mar 18 09:35:50 storage kernel: [  417.884103] Pid: 2947, comm: mount 
Tainted: P           O 3.2.0-38-generic #61-Ubuntu
Mar 18 09:35:50 storage kernel: [  417.884105] Call Trace:
Mar 18 09:35:50 storage kernel: [  417.884137] [<ffffffffa02c26cf>] 
xfs_error_report+0x3f/0x50 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884155] [<ffffffffa0308502>] ? 
xfs_iread+0x172/0x1c0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884166] [<ffffffffa02c273e>] 
xfs_corruption_error+0x5e/0x90 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884183] [<ffffffffa030826c>] 
xfs_iformat+0x42c/0x550 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884200] [<ffffffffa0308502>] ? 
xfs_iread+0x172/0x1c0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884217] [<ffffffffa0308502>] 
xfs_iread+0x172/0x1c0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884223] [<ffffffff81193612>] ? 
inode_init_always+0x102/0x1c0
Mar 18 09:35:50 storage kernel: [  417.884235] [<ffffffffa02c71e4>] 
xfs_iget_cache_miss+0x64/0x230 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884247] [<ffffffffa02c74d9>] 
xfs_iget+0x129/0x1b0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884250] [<ffffffff81193e9a>] ? 
evict+0x12a/0x1c0
Mar 18 09:35:50 storage kernel: [  417.884269] [<ffffffffa0323c46>] 
xfs_qm_dqusage_adjust+0x86/0x2a0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884300] [<ffffffffa02bfda1>] ? 
xfs_buf_rele+0x51/0x130 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884314] [<ffffffffa02ccf83>] 
xfs_bulkstat+0x413/0x800 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884338] [<ffffffffa0323bc0>] ? 
xfs_qm_quotacheck_dqadjust+0x190/0x190 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884358] [<ffffffffa02d66d5>] ? 
kmem_free+0x35/0x40 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884382] [<ffffffffa03246b5>] 
xfs_qm_quotacheck+0xe5/0x1c0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884406] [<ffffffffa031de3c>] ? 
xfs_qm_dqdestroy+0x1c/0x30 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884430] [<ffffffffa0324a94>] 
xfs_qm_mount_quotas+0x124/0x1b0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884452] [<ffffffffa0310990>] 
xfs_mountfs+0x5f0/0x690 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884470] [<ffffffffa02ce322>] ? 
xfs_mru_cache_create+0x162/0x190 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884490] [<ffffffffa02d053e>] 
xfs_fs_fill_super+0x1de/0x290 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884499] [<ffffffff8117c366>] 
mount_bdev+0x1c6/0x210
Mar 18 09:35:50 storage kernel: [  417.884518] [<ffffffffa02d0360>] ? 
xfs_parseargs+0xbc0/0xbc0 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884537] [<ffffffffa02ce665>] 
xfs_fs_mount+0x15/0x20 [xfs]
Mar 18 09:35:50 storage kernel: [  417.884547] [<ffffffff8117cef3>] 
mount_fs+0x43/0x1b0
Mar 18 09:35:50 storage kernel: [  417.884555] [<ffffffff8119783a>] 
vfs_kern_mount+0x6a/0xc0
Mar 18 09:35:50 storage kernel: [  417.884564] [<ffffffff81198d44>] 
do_kern_mount+0x54/0x110
Mar 18 09:35:50 storage kernel: [  417.884573] [<ffffffff8119a8a4>] 
do_mount+0x1a4/0x260
Mar 18 09:35:50 storage kernel: [  417.884581] [<ffffffff8119ad80>] 
sys_mount+0x90/0xe0
Mar 18 09:35:50 storage kernel: [  417.884591] [<ffffffff81665982>] 
system_call_fastpath+0x16/0x1b
Mar 18 09:35:50 storage kernel: [  417.884596] XFS (sdb1): Corruption 
detected. Unmount and run xfs_repair

--------------070202080702080601030508
Content-Type: text/x-vcard; charset=utf-8;
 name="guillaume_anciaux.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="guillaume_anciaux.vcf"

begin:vcard
fn:Guillaume Anciaux
n:Anciaux;Guillaume
org:EPFL/ENAC/IS/LSMS
adr:;;Station 18, GC A2 494;Lausanne;Vaud;1015;Switzerland
email;internet:guillaume.anciaux@epfl.ch
title:Ph.D
url:http://lsms.epfl.ch
version:2.1
end:vcard


--------------070202080702080601030508
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------070202080702080601030508--
