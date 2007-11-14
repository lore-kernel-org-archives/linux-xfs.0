Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Nov 2007 14:54:47 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAEMsdCX010799
	for <linux-xfs@oss.sgi.com>; Wed, 14 Nov 2007 14:54:41 -0800
Date: Wed, 14 Nov 2007 23:31:12 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.24-rc2 XFS nfsd hang
In-Reply-To: <20071114125907.GB4010@fieldses.org>
Message-ID: <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de>
References: <20071114070400.GA25708@puku.stupidest.org> <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Benny Halevy <bhalevy@panasas.com>, Chris Wedgwood <cw@f00f.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

On Wed, 14 Nov 2007, J. Bruce Fields wrote:
> On Wed, Nov 14, 2007 at 09:43:40AM +0200, Benny Halevy wrote:
>> I wonder if this is a similar hang to what Christian was seeing here:
>> http://lkml.org/lkml/2007/11/13/319
>
> Ah, thanks for noticing that.  Christian Kujau, is /data an xfs
> partition?

Sorry for the late reply :\

Yes, the nfsd process only got stuck when I did ls(1) (with or without -l) 
on a NFS share which contained a XFS partition. I did not care for the 
underlying fs first so I just ls'ed my shares and noticed that it got 
stuck. Now that you mention it I tried again, with a (git-wise) current 
2.6 kernel and the same .config: http://nerdbynature.de/bits/2.6.24-rc2/nfsd/

Running ls on a ext3 or jfs backed nfs share did succeed, running ls on an 
xfs backed nfs share did not. The sysrq-t (see dmesg.2.gz please) looks 
like yours (to my untrained eye):

nfsd          D c04131c0     0  8535      2
       e7ea97b8 00000046 e7ea9000 c04131c0 e7ea97b8 e697e7e0 00000282 e697e7e8
       e7ea97e4 c0409ebc f71f3500 00000001 f71f3500 c0115540 e697e804 e697e804
       e697e7e0 8f082000 00000001 e7ea97f4 c0409cc2 00000004 00000062 e7ea9800
Nov 14 23:07:14 sheep kernel: [ 1870.124185] Call Trace:
[<c0409ebc>] __down+0x7c/0xd0
[<c0409cc2>] __down_failed+0xa/0x10
[<c0296d46>] xfs_buf_lock+0x46/0x50
[<c02985a2>] _xfs_buf_find+0xf2/0x190
[<c0298694>] xfs_buf_get_flags+0x54/0x120
[<c029877d>] xfs_buf_read_flags+0x1d/0x80
[<c0289afa>] xfs_trans_read_buf+0x4a/0x350
[<c025e049>] xfs_da_do_buf+0x409/0x760
[<c025e42f>] xfs_da_read_buf+0x2f/0x40
[<c02634f2>] xfs_dir2_leaf_lookup_int+0x172/0x270
[<c02637ce>] xfs_dir2_leaf_lookup+0x1e/0x90
[<c02608e4>] xfs_dir_lookup+0xe4/0x100
[<c028abde>] xfs_dir_lookup_int+0x2e/0x100
[<c028eee2>] xfs_lookup+0x62/0x90
[<c029b644>] xfs_vn_lookup+0x34/0x70
[<c016de06>] __lookup_hash+0xb6/0x100
[<c016ee6e>] lookup_one_len+0x4e/0x50
[<f9037769>] compose_entry_fh+0x59/0x120 [nfsd]
[<f9037c29>] encode_entry+0x329/0x3c0 [nfsd]
[<f9037cfb>] nfs3svc_encode_entry_plus+0x3b/0x50 [nfsd]
[<c02639b4>] xfs_dir2_leaf_getdents+0x174/0x900
[<c026070a>] xfs_readdir+0xba/0xd0
[<c0298d74>] xfs_file_readdir+0x44/0x70
[<c01726ae>] vfs_readdir+0x7e/0xa0
[<f902e6b3>] nfsd_readdir+0x73/0xe0 [nfsd]
[<f9036eea>] nfsd3_proc_readdirplus+0xda/0x200 [nfsd]
[<f902a2db>] nfsd_dispatch+0x11b/0x210 [nfsd]
[<f920f2ac>] svc_process+0x41c/0x760 [sunrpc]
[<f902a8c4>] nfsd+0x164/0x2a0 [nfsd]
[<c0103507>] kernel_thread_helper+0x7/0x10


>> Any suggestions other than to bisect this?  (Bisection might be
>> painful as it crosses the x86-merge.)

Make that "impossible" for me, as I could not boot the bisected kernel and 
marking versions as "bad" for unrelated things seems to invalidate the 
results. However, from ~2500 revisions (2.6.24-rc2 to 2.6.23.1) down to 
~20 or so in just 10 builds, that's pretty awesome.

Christian.
-- 
BOFH excuse #321:

Scheduled global CPU outage
