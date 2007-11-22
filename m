Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Nov 2007 15:09:39 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAMN9W2j032441
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2007 15:09:34 -0800
Date: Fri, 23 Nov 2007 10:09:22 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122230922.GZ114266761@sgi.com>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <20071122025726.GG17536@waste.org> <20071122034106.GV114266761@sgi.com> <20071122072549.GQ19691@waste.org> <20071122103159.GW114266761@sgi.com> <20071122181029.GR19691@waste.org> <20071122222909.GY114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122222909.GY114266761@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, Andi Kleen <andi@firstfloor.org>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Fri, Nov 23, 2007 at 09:29:09AM +1100, David Chinner wrote:
> On Thu, Nov 22, 2007 at 12:10:29PM -0600, Matt Mackall wrote:
> > If I've got XFS on filesystems A and B on the same spindle (or volume
> > group?) and my real RT I/O takes place only on B, then I want log
> > flushing to happen in RT on B. But -never on A-. If I can do this with
> > a tunable, I'm perfectly happy.
> 
> No, not another mount option. I'm just going to drop this one for
> now...

Actually, I might change it to use the highest non-rt priority, which
would solve the latency issues in the normal cases and still leave
the RT rope dangling for those that want to use it.

Is that an acceptible compromise, Matt?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
