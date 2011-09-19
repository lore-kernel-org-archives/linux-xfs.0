Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JERW7W254284 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 09:27:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B35755042B
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 07:27:30 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	w9W4ms5fMzPSdvOQ for <xfs@oss.sgi.com>;
	Mon, 19 Sep 2011 07:27:30 -0700 (PDT)
Date: Mon, 19 Sep 2011 10:27:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: silent corruption after kernel panic?
Message-ID: <20110919142729.GA20750@infradead.org>
References: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA722B40@seldmbx01.corpusers.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA722B40@seldmbx01.corpusers.net>
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
To: "Assarsson, Emil" <Emil.Assarsson@sonyericsson.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Sep 19, 2011 at 02:28:23PM +0200, Assarsson, Emil wrote:
> Hi,
> 
> We are running a 20TB XFS filesystem on top of LVM2 and SAN storage (HP
> Open-V) with multipathd. Ubuntu Lucid. The disk write cache is enabled
> and we use mount options rw.


> Sep 16 06:40:34 seldlnx034 kernel: [54607.977261] XFS internal error
> XFS_WANT_CORRUPTED_RETURN at line 381 of
> file /build/buildd/linux-2.6.32/fs/xfs/xfs_alloc.c.  Caller
> 0xffffffffa01eed36
> Sep 16 06:40:34 seldlnx034 kernel: [54607.996676]  [<ffffffffa0215383>]
> xfs_error_report+0x43/0x50 [xfs]
> Sep 16 06:40:34 seldlnx034 kernel: [54607.996689]

This (corrupted allocation btrees) is a typical indication of missing
cache flushes.

Given that before ~2.6.35 LVM/device mapper was not able to pass through
cache flush requests that is your most likely culprit.  A repair will
rebuild the freespace btrees, and make sure to keep the write caches
down the whole stack disabled.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
