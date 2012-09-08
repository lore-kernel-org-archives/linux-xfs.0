Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8808v7S248929 for <xfs@oss.sgi.com>; Fri, 7 Sep 2012 19:08:57 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yIlh1xqa2SOTvGh4 for <xfs@oss.sgi.com>;
	Fri, 07 Sep 2012 17:09:56 -0700 (PDT)
Date: Sat, 8 Sep 2012 10:09:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V3] xfstests: make 275 pass
Message-ID: <20120908000954.GW15292@dastard>
References: <4F04A6E6.1090304@redhat.com> <4F04BC81.1000207@redhat.com>
	<20120104231725.GB24466@dastard> <4F207079.6050401@sandeen.net>
	<504A5176.5020302@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <504A5176.5020302@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, Zach Brown <zab@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Sep 07, 2012 at 02:56:38PM -0500, Eric Sandeen wrote:
> On 1/25/12 3:13 PM, Eric Sandeen wrote:
> > Ok, this is a significant rework of 275, which made too many
> > assumptions about details of space usage and failed on several
> > filesystems (it passed on xfs, but only by accident).
> > 
> > This new version tries to leave about 256k free, then tries
> > a single 1M IO, and fails only if 0 bytes are written.
> > 
> > It also sends a lot more to $seq.full for debugging on failure
> > and fixes a few other stylistic things.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> 
> Poor Zach ran into this one again.  Can I get a review of this
> version, and I'll merge it if it looks good?

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
