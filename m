Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97EAOlG193129 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 09:10:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A4894AB05F
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 07:11:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ljaXWz8u1AVmgNht for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 07:11:51 -0700 (PDT)
Date: Wed, 7 Oct 2009 10:11:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs: add discard support
Message-ID: <20091007141149.GA16020@infradead.org>
References: <20091006184758.GA4780@infradead.org>
	<20091007044215.GK9464@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091007044215.GK9464@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Oct 07, 2009 at 03:42:16PM +1100, Dave Chinner wrote:
> On Tue, Oct 06, 2009 at 02:47:58PM -0400, Christoph Hellwig wrote:
> > Call the BLKDISCARD ioctl to mark the whole disk as unused before creating
> > a new filesystem.  This will allow SSDs, Arrays with thin provisioning support
> > and virtual machines to make smarter allocation decisions.
> 
> Good idea, but perhaps the discard should be optional rather than
> unconditional.  My immediate thought was the SOP for setting up
> encrypted devices - fill the empty disk with random data before
> setting up the encrypted device. If you then send it a discard....

Yeah.  I'm fine with making it the default but adding a option to
disable it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
