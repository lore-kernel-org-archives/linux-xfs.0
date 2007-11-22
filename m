Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 19:41:27 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAM3fGdI006551
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 19:41:21 -0800
Date: Thu, 22 Nov 2007 14:41:06 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122034106.GV114266761@sgi.com>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <20071122025726.GG17536@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122025726.GG17536@waste.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matt Mackall <mpm@selenic.com>
Cc: David Chinner <dgc@sgi.com>, Andi Kleen <andi@firstfloor.org>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Wed, Nov 21, 2007 at 08:57:27PM -0600, Matt Mackall wrote:
> On Thu, Nov 22, 2007 at 12:12:14PM +1100, David Chinner wrote:
> > In all the cases that I know of where ppl are using what could
> > be considered real-time I/O (e.g. media environments where they
> > do real-time ingest and playout from the same filesystem) the
> > real-time ingest processes create the files and do pre-allocation
> > before doing their I/O. This I/O can get held up behind another
> > process that is not real time that has issued log I/O. 
> > 
> > Given there is no I/O priority inheritence and having log I/O stall
> > will stall the entire filesystem, we cannot allow log I/O to
> > stall in real-time environments. Hence it must have the highest
> > possible priority to prevent this.
> 
> I've seen PVRs that would be upset by this. They put media on one
> filesystem and database/apps/swap/etc. on another, but have everything
> on a single spindle. Stalling a media filesystem read for a write
> anywhere else = fail.

Sounds like the PVR is badly designed to me. If a write can cause a
read to miss a playback deadline, then you haven't built enough
buffering into your playback application.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
