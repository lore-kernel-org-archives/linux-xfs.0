Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Sep 2007 05:55:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8LCtlgf001727
	for <xfs@oss.sgi.com>; Fri, 21 Sep 2007 05:55:50 -0700
Date: Fri, 21 Sep 2007 22:55:31 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Concurrent Multi-File Data Streams
Message-ID: <20070921125531.GM995458@sgi.com>
References: <12789210.post@talk.nabble.com> <20070921091441.3ABB88E0B@mail.edu.haifa.ac.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921091441.3ABB88E0B@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>
Cc: 'Hxsrmeng' <hxsrmeng@gmail.com>, xfs@oss.sgi.com

On Fri, Sep 21, 2007 at 11:13:33AM +0200, Leon Kolchinsky wrote:
> I'm running DSS (Darwin Streaming Server) on one of my servers and that
> "Concurrent Multi-File Data Streams" thing seems very interesting :)

Filestreams is needed to optimise concurrent *ingest* of data,
not playout.

i.e. if you are ingesting multiple real-time streams of data at the
same time as you are playing out real-time streams and you area
missing playout deadlines (i.e. dropping frames) due to sub-optimal
data layout, then it might help you.....

> I have a separate partition there I store all movies.
> Is 2.6.22 kernel already has this patch incorporated already(actually
> gentoo-sources-2.6.22-r5)?

It went into .22 so you should have it.

> Are there any special mkfs.xfs or mount options I should make to make this
> thing work or make the FS to be optimized for streaming?

The allocator behaviour is changed by the mount option "-o filestreams".

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
