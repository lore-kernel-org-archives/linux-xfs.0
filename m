Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 Mar 2007 05:21:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2RCKw6p012906
	for <xfs@oss.sgi.com>; Tue, 27 Mar 2007 05:21:00 -0700
Date: Tue, 27 Mar 2007 23:20:47 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: changing xfs file system tunnings(sunit,swidth) after mkfs.xfs
Message-ID: <20070327122047.GA32597093@melbourne.sgi.com>
References: <5d96567b0703261325m8f17b2eg55e04264fee4832a@mail.gmail.com> <1174947030.5051.586.camel@edge> <5d96567b0703270004j72d89618xe27bbf3d5e44eea1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0703270004j72d89618xe27bbf3d5e44eea1@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: nscott@aconex.com, xfs@oss.sgi.com

On Tue, Mar 27, 2007 at 09:04:33AM +0200, Raz Ben-Jehuda(caro) wrote:
> ahha...
> but did you ever tried to set an sunit value bigger than the one
> set during the mkfs.xfs ?

Sure - but you've got to satisfy a whole heap of alignment
and size considerations when changing sunit e.g. AGs must be
stripe unit aligned and their size must be a whole multiple
of the stripe unit.

Hence any new value generally needs to be a multiple so
that filesystem alignment remains valid.

You might want to get a recent kernel, too, as it will
tell more about the reason why the mount with the new
sunit is failing (in dmesg).

Cheers,

dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
