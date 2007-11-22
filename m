Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 19:11:34 -0800 (PST)
Received: from waste.org (waste.org [66.93.16.53])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAM3BRHh002066
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 19:11:29 -0800
Date: Wed, 21 Nov 2007 20:57:27 -0600
From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122025726.GG17536@waste.org>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122011214.GR114266761@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Thu, Nov 22, 2007 at 12:12:14PM +1100, David Chinner wrote:
> On Thu, Nov 22, 2007 at 01:49:25AM +0100, Andi Kleen wrote:
> > David Chinner <dgc@sgi.com> writes:
> > 
> > > To ensure that log I/O is issued as the highest priority I/O, set
> > > the I/O priority of the log I/O to the highest possible. This will
> > > ensure that log I/O is not held up behind bulk data or other
> > > metadata I/O as delaying log I/O can pause the entire transaction
> > > subsystem. Introduce a new buffer flag to allow us to tag the log
> > > buffers so we can discrimiate when issuing the I/O.
> > 
> > Won't that possible disturb other RT priority users that do not need 
> > log IO (e.g. working on preallocated files)? Seems a little
> > dangerous.
> 
> In all the cases that I know of where ppl are using what could
> be considered real-time I/O (e.g. media environments where they
> do real-time ingest and playout from the same filesystem) the
> real-time ingest processes create the files and do pre-allocation
> before doing their I/O. This I/O can get held up behind another
> process that is not real time that has issued log I/O. 
> 
> Given there is no I/O priority inheritence and having log I/O stall
> will stall the entire filesystem, we cannot allow log I/O to
> stall in real-time environments. Hence it must have the highest
> possible priority to prevent this.

I've seen PVRs that would be upset by this. They put media on one
filesystem and database/apps/swap/etc. on another, but have everything
on a single spindle. Stalling a media filesystem read for a write
anywhere else = fail.

-- 
Mathematics is the supreme nostalgia of our time.
