Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBAA58Lf221316 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 04:05:08 -0600
Subject: Re: [PATCH] xfstests: fix 108 golden output
From: Boris Ranto <branto@redhat.com>
In-Reply-To: <1291929579.13355.30.camel@doink>
References: <20101110125855.GA18357@infradead.org>
	<1291929579.13355.30.camel@doink>
Date: Fri, 10 Dec 2010 11:06:49 +0100
Message-ID: <1291975609.3282.7.camel@dhcp-31-190.brq.redhat.com>
Mime-Version: 1.0
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
To: aelder@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, 2010-12-09 at 15:19 -0600, Alex Elder wrote:
> On Wed, 2010-11-10 at 07:58 -0500, Christoph Hellwig wrote:
> > The new common scratch mount filter produces slightly different
> > whitespaces than the old home grown filter, so adjust the golden
> > output.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I found out why this is happening.  I get no
> such error, and Dave Chinner said he wasn't seeing
> it either.
> 
> xfs_quota is formatting its output such that the
> second and later columns always align at a certain
> offset from the beginning of the line.  As a result,
> path names assigned as SCRATCH_DEV of different
> lengths will produce different (filtered) output,
> with more or fewer blanks between SCRATCH_DEV and
> the usage number.
> 
> Boris Ranto has proposed a change that would
> add the "-b" flag to diff when checking output
> against golden output.  That should fix it, but
> it's possible we *want* differences in white
> space to matter in some cases.  Have to look
> into this.
> 
> 					-Alex
> 

The change was designed to add the "-b" flag only for this test case.
Any other test case could also modify its diff options through
DIFF_OPTIONS variable in its config file ($seq.config).

-Boris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
