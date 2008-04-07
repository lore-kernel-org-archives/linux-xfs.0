Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 15:00:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m37M0aMC002775
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 15:00:38 -0700
Date: Tue, 8 Apr 2008 08:01:06 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: performance problems with XFS and Linux kernel 2.6.24.4
Message-ID: <20080407220106.GF108924158@sgi.com>
References: <007001c898f5$cae2f4a0$60a8dde0$@masuda@jlbond.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007001c898f5$cae2f4a0$60a8dde0$@masuda@jlbond.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bond Masuda <bond.masuda@jlbond.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 07, 2008 at 02:24:41PM -0700, Bond Masuda wrote:
> Hi,
> 
> I am aware of the change regarding barrier/nobarrier in 2.6.17 and above.
> However, the performance hit I'm seeing is very severe and much worse than
> what I was seeing in 2.6.17 (bundled with latest updates in Fedora Core 4).
> 
> I'm currently running Fedora 8 with 2.6.24.4-64.fc8. If I remove nobarrier
> mount option, it takes seconds just to write few megabytes and the system
> becomes very very sluggish. On 2.6.17 (Fedora 4) without the nobarrier
> option it was still usable.

Doesn't sound like a barrier problem.

> The XFS file system is about 900GB, if that matters.
> 
> Is this a known problem?

<shrug>

> How can I gather more information to figure out
> exactly what is going on?

Start with what your hardware is, what your storage config is, output
of 'xfs_info <mtpt>', the log of your test (complete output) on working
and non-working kernels, etc.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
