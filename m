Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FC157F3F
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 10:39:51 -0500 (CDT)
Date: Fri, 28 Jun 2013 10:39:50 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH 01/15] xfs: update mount options documentation
Message-ID: <20130628153950.GA9164@sgi.com>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-2-git-send-email-david@fromorbit.com>
	<20130627144814.GM20932@sgi.com> <20130627190831.GN20932@sgi.com>
	<20130628020912.GI32195@dastard> <20130628023204.GJ32195@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130628023204.GJ32195@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Fri, Jun 28, 2013 at 12:32:04PM +1000, Dave Chinner wrote:
| On Fri, Jun 28, 2013 at 12:09:12PM +1000, Dave Chinner wrote:
| > Mount options are perfectly fine to be removed - they've been given
| > deprecated warnings for quite some time now (the most recent is the
| > delaylog which has been doing that since 3.1 IIRC). So they are all
| > fine to actually remove - 12 months warning is usually considered
| > sufficient.

I hardly consider 12 years to be sufficient.  I have no problem with
deprecating and disabling mount options so that they are ineffective,
but removing them so that an administrator gets an error when upgrading
his system is irresponsible product management, especially when it
requires almost no effort to keep the deprecated, disabled interface.

You move to newer kernels much faster than most people.  Doesn't Red Hat
still support Red Hat 5?  How old is that kernel?  One of the reasons I
and others dread upgrading systems is because there are always
interfaces that change, always data conversions that have to be run,
always new processes to learn.  I realize that XFS is still an evolving
filesystem, by historically one of its greatest achievements has been
that of backward compatibility.  When XFS was ported from IRIX to Linux,
the same filesystem could be used without any conversion.  Why force a
user to modify his fstab just because he has upgraded his kernel?

| > As to the sysctls - they haven't had any effect since 3.5 when the
| > xfsbufd was removed, so it's time to mark them deprecated so we can
| > remove them in a year's time. That gives anyone using them
| > (including distros) plenty of time to fix whatever is using them
| > before they get removed.
| > 
| > > I'm thinking of the 3.3 glusterfs and 3.8 pulseaudio reakeage.  And I would
| > > really like to have a nice holiday weekend. ;)
| > 
| > I think you're being overly paranoid here - I'm simply following the
| > normal deprecation protocol here....
| 
| Documenation/ABI/README:
| 
| We have four different levels of ABI stability, as shown by the four
| different subdirectories in this location.  Interfaces may change levels
| of stability according to the rules described below.
| ....
|  obsolete/
|          This directory documents interfaces that are still remaining in
| 	 the kernel, but are marked to be removed at some later point in
| 	 time.  The description of the interface will document the reason
| 	 why it is obsolete and when it can be expected to be removed.


| I think you'll find that what I done follows this policy. If you
| really want, I'll move them to Documenation/ABI/obsolete.  And, of
| course, if removing them proves to be a problem, as Eric said we can
| always reinstate them or remove the deprecation notices.

It is great that Linux has a documented life cycle for kernel to userspace
interfaces.  These are guidelines for the minimum requirements.  Move the
mount options to obsolete.  I have no problems with making mount options
obsolete.  Remove them and people will make a big fuss.


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
