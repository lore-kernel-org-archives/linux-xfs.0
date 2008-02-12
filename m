Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Feb 2008 04:24:52 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1CCOXTF017824
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2008 04:24:40 -0800
Date: Tue, 12 Feb 2008 23:24:46 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Restoring damaged incremental XFS dump?
Message-ID: <20080212122446.GE155407@sgi.com>
References: <1202769551.16458.1236311973@webmail.messagingengine.com> <47B0E26D.7070807@sgi.com> <1202815035.5821.1236404891@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202815035.5821.1236404891@webmail.messagingengine.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Felix E. Klee" <felix.klee@inka.de>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Tue, Feb 12, 2008 at 12:17:15PM +0100, Felix E. Klee wrote:
> On Tue, 12 Feb 2008 11:03:57 +1100, "Timothy Shimmin"
> <tes@sgi.com> said:
> > I'm not sure what you mean by "true snapshots". I wouldn't really
> > call it snapshots as in what you could get if you froze the
> > filesystem etc..
> 
> Oh, it does not freeze the filesystem - what a pity.  I recall someone
> telling me that it does.  Seems like that was bad information or my
> memory is failing on me.

Use dm-snap to create a snapshot and do the backup from that.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
