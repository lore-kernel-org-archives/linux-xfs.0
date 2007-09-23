Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Sep 2007 09:14:38 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.231])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8NGEWQ3007146
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 09:14:35 -0700
Received: by wx-out-0506.google.com with SMTP id s9so1165823wxc
        for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 09:14:35 -0700 (PDT)
Subject: Re: Review: Concurrent Multi-File Data Streams
From: Ming Zhang <blackmagic02881@gmail.com>
Reply-To: blackmagic02881@gmail.com
In-Reply-To: <20070923074500.GO995458@sgi.com>
References: <12789210.post@talk.nabble.com>
	 <20070921091441.3ABB88E0B@mail.edu.haifa.ac.il>
	 <20070921125531.GM995458@sgi.com>
	 <1190399077.3795.86.camel@localhost.localdomain>
	 <20070923074500.GO995458@sgi.com>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 11:47:05 -0400
Message-Id: <1190562425.3795.97.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Leon Kolchinsky <leonk@construct.haifa.ac.il>, 'Hxsrmeng' <hxsrmeng@gmail.com>, xfs@oss.sgi.com

On Sun, 2007-09-23 at 17:45 +1000, David Chinner wrote:
> On Fri, Sep 21, 2007 at 02:24:37PM -0400, Ming Zhang wrote:
> > On Fri, 2007-09-21 at 22:55 +1000, David Chinner wrote:
> > > On Fri, Sep 21, 2007 at 11:13:33AM +0200, Leon Kolchinsky wrote:
> > > > I'm running DSS (Darwin Streaming Server) on one of my servers and that
> > > > "Concurrent Multi-File Data Streams" thing seems very interesting :)
> > > 
> > > Filestreams is needed to optimise concurrent *ingest* of data,
> > > not playout.
> > > 
> > > i.e. if you are ingesting multiple real-time streams of data at the
> > > same time as you are playing out real-time streams and you area
> > > missing playout deadlines (i.e. dropping frames) due to sub-optimal
> > > data layout, then it might help you.....
> > > 
> > > > I have a separate partition there I store all movies.
> > > > Is 2.6.22 kernel already has this patch incorporated already(actually
> > > > gentoo-sources-2.6.22-r5)?
> > > 
> > > It went into .22 so you should have it.
> > 
> > i did not see xfs_filestream.c in 2.6.22.6 yet. did i miss something
> > here?
> 
> No, my mistake - it seems so long since I checked it in. it went
> into 2.6.23-rc1....

thanks.


> 
> Cheers,
> 
> Dave.
-- 
Ming Zhang


@#$%^ purging memory... (*!%
http://blackmagic02881.wordpress.com/
http://www.linkedin.com/in/blackmagic02881
--------------------------------------------
