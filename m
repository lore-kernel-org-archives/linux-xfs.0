Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAGJulZ5216008 for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 13:56:47 -0600
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 776251D12198
	for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 11:56:46 -0800 (PST)
Received: from peace.netnation.com (peace.netnation.com [204.174.223.2]) by
	cuda.sgi.com with ESMTP id FLIjWLB7fo6kr0Ry for
	<xfs@oss.sgi.com>; Wed, 16 Nov 2011 11:56:46 -0800 (PST)
Date: Wed, 16 Nov 2011 11:56:43 -0800
From: Simon Kirby <sim@hostway.ca>
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111116195643.GF24411@hostway.ca>
References: <20111020224214.GC22772@hostway.ca>
	<20111021132240.GA24136@infradead.org>
	<20111021202857.GB30100@hostway.ca>
	<20111024082219.GA19941@infradead.org>
	<20111025200748.GA25043@hostway.ca>
	<20111026112521.GA10432@infradead.org>
	<20111104210324.GB14983@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111104210324.GB14983@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Nov 04, 2011 at 05:03:24PM -0400, Christoph Hellwig wrote:

> Sorry Simon,
> 
> I haven't really been able to get back to this as fast as I wanted to
> do.  Can you do another run and check if the patch still helps your
> issue even if you remove the xfs_log_force line?

Hello!

Sorry for the delay in testing.

Yes, everything looks fine even with the xfs_log_force line from your
patch commented out. So, the changes in xfs_reclaim_inode() are just the
set_bit(XBT_FORCE_FLUSH) and wake_up_process(), relative to 3.1.

Simon-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
