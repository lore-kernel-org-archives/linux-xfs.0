Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28GEKPR047251 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 10:14:20 -0600
Received: from josefsipek.net (josefsipek.net [64.9.206.49]) by cuda.sgi.com
	with ESMTP id 8xtVpJQscn0hEn2r for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 08:14:19 -0800 (PST)
Date: Thu, 8 Mar 2012 11:14:18 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] default to 64 bit inodes & add feature flag
Message-ID: <20120308161418.GA17800@josefsipek.net>
References: <4F5798F9.2050809@redhat.com> <20120308013413.GL3592@dastard>
	<4F5813D8.8070305@sandeen.net> <20120308153721.GS7762@sgi.com>
	<4F58D35D.7080504@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F58D35D.7080504@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ben Myers <bpm@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 08, 2012 at 09:42:21AM -0600, Eric Sandeen wrote:
> So, after thinking about this (and talking on irc) some more, I'm
> not convinced that a feature flag is the way to go.
> 
> If we set a feature flag, suddenly old filesystems with 64-bit
> inodes will grow a new feature, and this will force a userspace
> upgrade - but there is no real new feature.  This seems like a bad
> idea.  My original patch (which Dave responded to with this one)
> simply made inode64 default, with no feature flags.
> 
> Unless someone has a really compelling argument for the flag,
> I'm thinking this is the wrong approach after all.
> 
> Perhaps I should resend the just-make-it-default patch.
> 
> Comments?

I was thinking about this sort of scenario.  You are right, there's no
on-disk format change.  My initial thought about how to handle this was to
just make inode64 the default on 64-bit builds.  I think the feature flag
idea is good because it essentially acts as a taint flag - much like the
attr2 feature flag.  The difference is, in the inode64 case...

1) it's the same on-disk format
2) there are years of ambiguous-inode filesystems out there

Out of curiosity...is there a reason we can't do both?  Default to 64-bit,
and slowly introduce the 64-bit inodes feature flag?

Jeff.

-- 
What is the difference between Mechanical Engineers and Civil Engineers?
Mechanical Engineers build weapons, Civil Engineers build targets.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
