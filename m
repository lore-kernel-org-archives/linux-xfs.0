Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n74GP5rZ178263 for <xfs@oss.sgi.com>; Tue, 4 Aug 2009 11:25:05 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B47FB144A0CA
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2009 09:25:54 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id qOvXBTtIxXNrELUv for
	<xfs@oss.sgi.com>; Tue, 04 Aug 2009 09:25:54 -0700 (PDT)
Message-ID: <4A786110.8090404@sandeen.net>
Date: Tue, 04 Aug 2009 11:25:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] XFS: __xfs_get_blocks check pointer to the target
	device
References: <1249329808.7686.26.camel@logos>	<20090803214929.GB3167@infradead.org>
	<1249351241.7513.18.camel@logos>
In-Reply-To: <1249351241.7513.18.camel@logos>
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
To: Ramon de Carvalho Valle <ramon@risesecurity.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, mszeredi@novell.com, hch@lst.de, xfs@oss.sgi.com

Ramon de Carvalho Valle wrote:
> On Mon, 2009-08-03 at 17:49 -0400, Christoph Hellwig wrote:
>> On Mon, Aug 03, 2009 at 05:03:28PM -0300, Ramon de Carvalho Valle wrote:
>>> The __xfs_get_blocks function does not check if the pointer to the target
>>> device is valid before dereferencing it.
>> It should never be zero.  It's set by xfs_imap_to_bmap to either
>> mp->m_ddev_targp which is always allocated, or to mp->m_rtdev_targp
>> which is always allocated if we have a realtime device, and
>> XFS_IS_REALTIME_INODE should only be true in that case.
>>
> 
> While testing XFS code with a modified version of fsfuzzer on SLES 10
> SP3 (Kernel 2.6.16.60-0.49.3.ramon-ppc64), I came across the following
> Oops:

...

ahah, useful information that would have been great in the original
patch submission.  :)

> I added a printk() line just before the:
> 
> 	bh_result->b_bdev = iomap.iomap_target->bt_bdev;
> 
> and as we can see iomap.iomap_target is NULL.
> 
> My guess is that the XFS_DIFLAG_REALTIME flag is being set incorrectly
> on the xfs inode structure, setting iomapp->iomap_target to the wrong
> device pointer (probably NULL).
> 
> I don't know if this is the best place to add a check, neither if
> returning -XFS_ERROR(EIO) is correct at this point. Maybe doing:
> 
> 	if (iomap.iomap_target && omap.iomap_flags & IOMAP_REALTIME)
> 		bh_result->b_bdev = iomap.iomap_target->bt_bdev;
> 
> would be a better solution.

Can you test hch's patch w/ your fuzzed image?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
