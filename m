Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2EE9TX022176 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 08:14:09 -0600
Received: from mx2.isti.cnr.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 505351E94300
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 06:15:51 -0800 (PST)
Received: from mx2.isti.cnr.it (mx2.isti.cnr.it [194.119.192.4]) by
	cuda.sgi.com with ESMTP id qxG8AlpsczvgWYoB for
	<xfs@oss.sgi.com>; Thu, 02 Dec 2010 06:15:51 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUY70BGTDSLVVTNA@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Thu, 02 Dec 2010 15:14:39 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUY706M72OLS71Q6@mx.isti.cnr.it> for xfs@oss.sgi.com; Thu,
	02 Dec 2010 15:14:32 +0100 (MET)
Date: Thu, 02 Dec 2010 15:14:28 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
In-reply-to: <20101202141134.GA22012@infradead.org>
Message-id: <4CF7A9C4.2040607@shiftmail.org>
MIME-version: 1.0
References: <4CF7A539.1050206@shiftmail.org>
	<20101202141134.GA22012@infradead.org>
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
Cc: linux-lvm@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 12/02/2010 03:11 PM, Christoph Hellwig wrote:
> I'm pretty sure you have CONFIG_DEBUG_BLOCK_EXT_DEVT enabled.  This
> option must never be enabled, as it causes block devices to be
> randomly renumered.  Together with the ramdisk driver overloading
> the BLKFLSBUF ioctl to discard all data it guarantees you to get
> data loss like yours.
>    

Nope...

# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
