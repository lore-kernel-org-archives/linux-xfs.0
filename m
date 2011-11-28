Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASJt90x252548 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 13:55:09 -0600
Date: Mon, 28 Nov 2011 14:55:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111128195505.GA3759@infradead.org>
References: <20111020224214.GC22772@hostway.ca>
	<20111021132240.GA24136@infradead.org>
	<20111021202857.GB30100@hostway.ca>
	<20111024082219.GA19941@infradead.org>
	<20111025200748.GA25043@hostway.ca>
	<20111026112521.GA10432@infradead.org>
	<20111104210324.GB14983@infradead.org>
	<20111116195643.GF24411@hostway.ca>
	<20111120153241.GA23511@infradead.org>
	<20111128190554.GA31168@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128190554.GA31168@hostway.ca>
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
To: Simon Kirby <sim@hostway.ca>
Cc: bpm@sgi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 28, 2011 at 11:05:54AM -0800, Simon Kirby wrote:
> On Sun, Nov 20, 2011 at 10:32:41AM -0500, Christoph Hellwig wrote:
> 
> > On Wed, Nov 16, 2011 at 11:56:43AM -0800, Simon Kirby wrote:
> > > Sorry for the delay in testing.
> > > 
> > > Yes, everything looks fine even with the xfs_log_force line from your
> > > patch commented out. So, the changes in xfs_reclaim_inode() are just the
> > > set_bit(XBT_FORCE_FLUSH) and wake_up_process(), relative to 3.1.
> > 
> > Dave pointed out that we can do better than the big hammer, and the
> > patch below should fix your issue, too.  Can you test it?
> 
> Yes, seems to be fine. No hung task warnings, tested for ~5 days.

Thanks a lot for the testing Simon.

Ben, can you add a:

Tested-by: Simon Kirby <sim@hostway.ca>

to the patch when applying it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
