Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Apr 2008 23:23:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3O6N6dj020816
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 23:23:07 -0700
Received: from rv-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2E42DF8E5
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 23:23:46 -0700 (PDT)
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.230]) by cuda.sgi.com with ESMTP id qBnhPzulBcwJLDbX for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 23:23:46 -0700 (PDT)
Received: by rv-out-0506.google.com with SMTP id g37so1450188rvb.32
        for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 23:23:46 -0700 (PDT)
Message-ID: <c33e4330804232323p1b6d5121oc56b0c43663a4e84@mail.gmail.com>
Date: Thu, 24 Apr 2008 02:23:45 -0400
From: "Michael Darling" <darlingm@gmail.com>
Subject: Re: XFS drops create/delete files to 6.6% of EXT3 (software raid) and to 0.6% of EXT3 (3ware hardware raid)
In-Reply-To: <20080424053358.GW103491721@sgi.com>
MIME-Version: 1.0
References: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com>
	 <4810062F.50100@sandeen.net> <20080424053358.GW103491721@sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Eric, for the numbers you provided, are you using a single drive, software
raid, or hardware raid?  If a hardware raid, is it a 3ware card?

I hadn't seen the nobarrier mount option before.  Using that changes
sequential creates from about 190/second to about 2500/second, and changes
sequential deletes from about 170/second to about 3700/second.

I don't yet have a BBU for the 3ware card, but would certainly get one if we
go with the 3ware card before we start putting real data on the raid.  Am I
right that with a BBU unit and a battery backup for the server as a whole,
that nobarrier would be safe to use?

Not using nobarrier, but using logbsize 256k changes sequential creates from
about 190/second to about 270/second.  So, it's an improvement, but no where
near where a software raid performs (1600/second) or where the hardware raid
performs with nobarrier.


On Thu, Apr 24, 2008 at 1:33 AM, David Chinner <dgc@sgi.com> wrote:

> On Wed, Apr 23, 2008 at 11:01:51PM -0500, Eric Sandeen wrote:
> > Michael Darling wrote:
> > > I am preparing a new server, and benchmarking EXT3 against XFS, both
> using
> > > software RAID and hardware RAID using a 3ware 9650SE-4LPML.
> > >
> > > Using bonnie++ as a benchmark, I am seeing significant performance
> boosts in
> > > my block sequential reads and writes moving from EXT3 to XFS.  I am
> aware
> > > that XFS won't create and delete files as quickly as EXT3, however I
> am
> > > seeing drops from 29455/second to 1957/second using software RAID, and
> from
> > > 32524/second to 189/second using hardware RAID.  I'm not sure if when
> using
> > > software raid, if creating and deleting files should drop to 6.6% of
> EXT3.
> > > But, what I'm pretty sure of, is when using hardware raid, that
> creating and
> > > deleting files shouldn't drop to 0.6% of EXT3.
> >
> > So I played with this a little on 2.6.25, on plain partitions.
> >
> > I saw similar numbers; for example, sequential creates:
> >
> > ext3:         23698/s
> > xfs:            319/s
> > xfs,nobarrier:         4478/s
>
> And with logbsize=256k?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>


[[HTML alternate version deleted]]
