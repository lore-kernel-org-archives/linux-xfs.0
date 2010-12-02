Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2EFsZ9022289 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 08:15:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA7AD1E94327
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 06:17:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id OjZJoT8GMQJtNhkQ for
	<xfs@oss.sgi.com>; Thu, 02 Dec 2010 06:17:38 -0800 (PST)
Date: Thu, 2 Dec 2010 09:17:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
Message-ID: <20101202141737.GA29799@infradead.org>
References: <4CF7A539.1050206@shiftmail.org>
	<20101202141134.GA22012@infradead.org>
	<4CF7A9C4.2040607@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CF7A9C4.2040607@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-lvm@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Dec 02, 2010 at 03:14:28PM +0100, Spelic wrote:
> On 12/02/2010 03:11 PM, Christoph Hellwig wrote:
> >I'm pretty sure you have CONFIG_DEBUG_BLOCK_EXT_DEVT enabled.  This
> >option must never be enabled, as it causes block devices to be
> >randomly renumered.  Together with the ramdisk driver overloading
> >the BLKFLSBUF ioctl to discard all data it guarantees you to get
> >data loss like yours.
> 
> Nope...
> 
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set

Hmm, I suspect dm-linear's dumb forwarding of ioctls has the same
effect.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
