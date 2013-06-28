Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B228C7F52
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 11:49:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E744304081
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 09:49:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 9mGKidaHQ6Znq44E for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 09:49:21 -0700 (PDT)
Message-ID: <51CDBE90.5090309@sandeen.net>
Date: Fri, 28 Jun 2013 12:49:20 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 01/15] xfs: update mount options documentation
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-2-git-send-email-david@fromorbit.com>
	<20130627144814.GM20932@sgi.com> <20130627190831.GN20932@sgi.com>
	<20130628020912.GI32195@dastard> <20130628023204.GJ32195@dastard>
	<20130628153950.GA9164@sgi.com>
In-Reply-To: <20130628153950.GA9164@sgi.com>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 6/28/13 11:39 AM, Geoffrey Wehrman wrote:
> On Fri, Jun 28, 2013 at 12:32:04PM +1000, Dave Chinner wrote:
> | On Fri, Jun 28, 2013 at 12:09:12PM +1000, Dave Chinner wrote:
> | > Mount options are perfectly fine to be removed - they've been given
> | > deprecated warnings for quite some time now (the most recent is the
> | > delaylog which has been doing that since 3.1 IIRC). So they are all
> | > fine to actually remove - 12 months warning is usually considered
> | > sufficient.
> 
> I hardly consider 12 years to be sufficient.  I have no problem with

12 years, really?  Maybe you meant months.  I hope you meant months!

> deprecating and disabling mount options so that they are ineffective,
> but removing them so that an administrator gets an error when upgrading
> his system is irresponsible product management, especially when it
> requires almost no effort to keep the deprecated, disabled interface.
> 
> You move to newer kernels much faster than most people.  Doesn't Red Hat
> still support Red Hat 5?  How old is that kernel?  

Yes, of course we do - it's based on 2.6.18, which was released in 2006.
But I'm not sure how that's relevant?

> One of the reasons I
> and others dread upgrading systems is because there are always
> interfaces that change, always data conversions that have to be run,
> always new processes to learn.  I realize that XFS is still an evolving
> filesystem, by historically one of its greatest achievements has been
> that of backward compatibility.  When XFS was ported from IRIX to Linux,
> the same filesystem could be used without any conversion.  Why force a
> user to modify his fstab just because he has upgraded his kernel?

That's quite a leap; year-long, orderly deprecation of mount options is
hardly comparable breaking on-disk formats during a port.

But of course we (RHEL) take migration seriously too, which is why we have
migration guides to help admins make the transition, documenting the many
necessary changes when doing a large upgrade.

For the big jumps that come from distro upgrades, they can document these
changes along with myriad others.

For people rolling their own kernels & updating every now and then, they'll
have a 12 month window of warnings to give them time to adapt and/or
request that the option be kept.

If you're upgrading a kernel which is older than 12 months, quite frankly
you'll have a fair bit more to do than worry about than "irixsgid" mount
options when you make that big a jump.  Updating fstab will be the least
of your worries.

There is no need to accumulate dead, no-op code in xfs.  It's one
of the reasons closed-source proprietary code ends up being so crufty
and hard to maintain - years and years of accumulated gunk nobody dares
touch.  We can do better than that.

Deprecating old code in an orderly & documented fashion is a longstanding
best practice in the linux kernel.  And we've already removed other XFS
mount options, and the world didn't end:

f538d4da8d521746ca5ebf8c1a8105eb49bfb45e (removed nologflush mount option)
288699fecaffa1ef8f75f92020cbb593a772e487 xfs: drop dmapi hooks (removed dmapi mount options)
a64afb057b607c04383ab5fb53c51421ba18c434 xfs: remove obsolete osyncisosync mount option
a19d9f887d81106d52cacbc9930207b487e07e0e xfs: kill ino64 mount option

We've removed sysctls too:

e0b8e8b65d578f5d5538465dff8392cf02e1cc5d [XFS] remove restricted chown parameter from xfs linux

Seriously - this is how we maintain code.

> | > As to the sysctls - they haven't had any effect since 3.5 when the
> | > xfsbufd was removed, so it's time to mark them deprecated so we can
> | > remove them in a year's time. That gives anyone using them
> | > (including distros) plenty of time to fix whatever is using them
> | > before they get removed.
> | > 
> | > > I'm thinking of the 3.3 glusterfs and 3.8 pulseaudio reakeage.  And I would
> | > > really like to have a nice holiday weekend. ;)
> | > 
> | > I think you're being overly paranoid here - I'm simply following the
> | > normal deprecation protocol here....
> | 
> | Documenation/ABI/README:
> | 
> | We have four different levels of ABI stability, as shown by the four
> | different subdirectories in this location.  Interfaces may change levels
> | of stability according to the rules described below.
> | ....
> |  obsolete/
> |          This directory documents interfaces that are still remaining in
> | 	 the kernel, but are marked to be removed at some later point in
> | 	 time.  The description of the interface will document the reason
> | 	 why it is obsolete and when it can be expected to be removed.
> 
> 
> | I think you'll find that what I done follows this policy. If you
> | really want, I'll move them to Documenation/ABI/obsolete.  And, of
> | course, if removing them proves to be a problem, as Eric said we can
> | always reinstate them or remove the deprecation notices.
> 
> It is great that Linux has a documented life cycle for kernel to userspace	
> interfaces.  These are guidelines for the minimum requirements.  Move the
> mount options to obsolete.  I have no problems with making mount options
> obsolete.  Remove them and people will make a big fuss.

Well, AFAIK nobody fussed over nodelaylog, ino64, osyncisosync, or the
dmapi options.  Nobody fussed over the restrict_chown sysctl.

And as I mentioned earlier, the whole point of the deprecation period is to let
people speak up if they need it.  Ext4 put options back when people fussed; we
can do that too as needed.  (Unless you consider this a pre-emptive fuss.  ;)
The spirit of the fuss-rule, though, is that people actually *using* it can
fuss; meta-fussing hasn't traditionally counted.)

I understand that you don't want to surprise or inconvenience users; that
should be balanced with keeping the code current, orderly & un-crufty.
A 12-month notification & RFC period strikes that balance well, I think.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
