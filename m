Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 12:52:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LJqTCb030777
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 12:52:31 -0700
Received: from p02c11o146.mxlogic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 181FA6D0D9F
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 12:53:00 -0700 (PDT)
Received: from p02c11o146.mxlogic.net (p02c11o146.mxlogic.net [208.65.144.79]) by cuda.sgi.com with ESMTP id vGIDPYy9iQNMHoJF for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 12:53:00 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Duplicate directory entries
Date: Fri, 21 Mar 2008 14:29:14 -0400
Message-ID: <D9A1816327F7BF4F931ADE74C248DFC90E0A6873@it-004.Isys.com>
In-Reply-To: <20080320043557.GX95344431@sgi.com>
References: <20080320000254.GC103321673@sgi.com> <D9A1816327F7BF4F931ADE74C248DFC90A42D366@it-004.Isys.com> <20080320043557.GX95344431@sgi.com>
From: "Jim Paradis" <jparadis@exagrid.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

> > >> We recently ran across a situation where we saw two directory
entries
> > >> that were exactly the same.
> > >
> > >What kernel version?
> >
> > 2.6.18.
.
.
.
> I don't think this is your problem unless you've only recently
upgraded
> from an old kernel and your applications do direct I/O.....
> 
> Can you reproduce the problem or provide any information on events
> that may have occurred around the time of the duplicates being
created?
> I suspect that a reproducable test case will be the only way we can
track
> this down....

No, we have not recently upgraded the kernel.

Unfortunately, we are not yet able to reproduce the problem at will.
It's something we observed on a production system, but there's a lot
that goes on on that system.  I'll keep trying to narrow it down,
though...

--jim
