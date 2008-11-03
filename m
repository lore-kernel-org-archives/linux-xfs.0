Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 16:28:00 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA30RkMk012533
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 16:27:47 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E54D1318DAD
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 16:27:47 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id B6KVquvVg7A0zMBO for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 16:27:47 -0800 (PST)
Date: Mon, 3 Nov 2008 11:27:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: create tape group
Message-ID: <20081103002743.GK19509@disturbed>
References: <490C7CAC.2070902@sandeen.net> <20081102220551.GG19509@disturbed> <490E33D1.8030306@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490E33D1.8030306@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Nov 02, 2008 at 05:12:17PM -0600, Eric Sandeen wrote:
> Dave Chinner wrote:
> 
> > On Sat, Nov 01, 2008 at 10:58:36AM -0500, Eric Sandeen wrote:
> >   
> >> Create a tape group for anything which expects
> >> to dump to tape (I guess this is a superset
> >> of "remote" and a few others).
> >>     
> >
> > Given that most ppl don't have tape drives, should these be left in
> > the auto group now that they can easily be run by 'check -g tape'? I
> > know I've never had a config to run them the *entire* time I've 
> > personally run XFSQA...
> >
> > Cheers,
> >
> > Dave.
> >   
> Sounds like a plan.  We probably don't even know (?) if they run
> well enough to be in the auto group?  Revised patch below:

Looks OK to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
