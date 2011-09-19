Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JAsef6245620 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 05:54:40 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 935274EE982
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 03:54:38 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id fRkxfl1MLoF08BvI
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 03:54:38 -0700 (PDT)
Message-ID: <4E771F6D.5090005@profihost.ag>
Date: Mon, 19 Sep 2011 12:54:37 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: xfs deadlock in stable kernel 3.0.4
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org>
	<4E70571A.80108@profihost.ag> <4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag>
	<20110918200438.GC14899@infradead.org>
In-Reply-To: <20110918200438.GC14899@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, aelder@sgi.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 18.09.2011 22:04, schrieb Christoph Hellwig:
> On Sun, Sep 18, 2011 at 11:14:08AM +0200, Stefan Priebe - Profihost AG wrote:
>> Hi,
>>
>> at least i'm now able to reproduce the issue. I hope this will help
>> to investigate the issue and hopefully you can reproduce it as well.
>>
>> I'm using vanilla 3.0.4 kernel + xfs as root filesystem and had
>> detect hanging taks with 120s set. You'll then see that the bonnie++
>> command get's stuck in xlog_grant_log_space while creating or
>> deleting files. I was using a SSD or a fast Raid 10 (24x SAS Disks)
>> - i was not able to reproduce it on normal SATA disks even a 20x
>> SATA Raid 10 didn't work.
>
> Thanks a lot for the reproducer!
>
> I've tried it on my laptop SSD and that didn't reproduce it yet.  I'll
> try it on monday on a real high end setup.

Sadly my SSD briked tonight while doing heavy testing ;-( I was not able 
to reproduce it on every partition. Only on some. Sadly i was not able 
to find the common point which causes this.

I've now to setup a new machine and try to reproduce it again.

What i got so far is that bonnie++ is always hanging here:

[] ? radix_tree_gang_lookup_slot+0x6a/0x8d
[] ? xfs_bmap_search_extents+0x56/0xb9
[] ? find_get_pages+0x39/0xd8
[] xlog_wait+0x58/0x70
[] ? try_to_wake_up+0x1c6/0x1c6
[] ? xlog_grant_push_ail+0xb7/0xbf
[] xlog_grant_log_space+0x162/0x2b1
[] xfs_log_reserve+0xbb/0xc4
[] xfs_trans_reserve+0xd6/0x1b1
[] xfs_free_eofblocks+0x16b/0x1fb
[] xfs_release+0x1c7/0x202
[] xfs_file_release+0x10/0x14
[] fput+0xfd/0x1eb
[] filp_close+0x6d/0x78
[] sys_close+0x9a/0xd4
[] system_call_fastpath+0x16/0x1b

The traces we had in the past were difficult to check which process was 
causing the lookup. So it doesn't seem to be the xlog_grant_log_space 
itself it seems that it is more xfs_bmap_search_extents or 
radix_tree_gang_lookup_slot?

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
