Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 22:48:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A5mb6U008706
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 22:48:39 -0700
Date: Thu, 10 Apr 2008 15:49:13 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] remove unnecessary periodic superblock logging.
Message-ID: <20080410054913.GL108924158@sgi.com>
References: <20080410042001.GF108924158@sgi.com> <op.t9do1hkj3jf8g2@pc-bnaujok.melbourne.sgi.com> <47FDA5BA.3080401@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FDA5BA.3080401@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Barry Naujok <bnaujok@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 10, 2008 at 03:29:30PM +1000, Timothy Shimmin wrote:
> Barry Naujok wrote:
> >On Thu, 10 Apr 2008 14:20:01 +1000, David Chinner <dgc@sgi.com> wrote:
> >
> >>Remove periodic logging of in-core superblock counters.
> >>
> >>xfssyncd triggers the logging of superblock counters every
> >>30s if the filesystem is made with lazy-count=1. This will
> >>prevent disks from idling and spinning down as there will
> >>be a log write every 30s. With the way counter recovery
> >>works for lazy-count=1, this code is unnecessary and provides
> >>no real benefit, so just remove it.
> >
> >I'm happy with this (xfs_initialize_perag_data() does the
> >global counter recovery during mount).
> >
> 
> So we only do the sb count logging at unmount type times...
> xfs_attr_quiesce() and xfs_unmountfs(),
> when no log recovery will happen.
> Hmmm...so why do we have to log it out at these times?
> I'm forgetting how this works.

xfs_log_sbcount() sync's the incore counters to the superblock
buffer transactionally. Not strictly necessary, but for consistency
with other superblock updates.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
