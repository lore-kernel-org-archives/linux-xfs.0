Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p52CANtC197044 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 07:10:24 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 708BC167E5AE
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 05:10:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hIFU3Jp2kR3kwKgT for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2011 05:10:22 -0700 (PDT)
Date: Thu, 2 Jun 2011 14:10:11 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
In-Reply-To: <BANLkTinJcvvv2pfXBt7EZ9TXONb9jRe0uQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1106021352330.3931@dhcp-27-109.brq.redhat.com>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<20110602030802.GR561@dastard>
	<BANLkTi=sPM_AYB4w=N5pWHfws9R3WnfJVw@mail.gmail.com>
	<20110602064040.GS561@dastard>
	<BANLkTinJcvvv2pfXBt7EZ9TXONb9jRe0uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-854799617-1307016615=:3931"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Amir G." <amir73il@users.sourceforge.net>
Cc: sandeen@redhat.com, Amir Goldstein <amir73il@users.sf.net>, xfs@oss.sgi.com, sergey57@gmail.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-854799617-1307016615=:3931
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 2 Jun 2011, Amir G. wrote:

> On Thu, Jun 2, 2011 at 9:40 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jun 02, 2011 at 06:49:20AM +0300, Amir G. wrote:
> >> On Thu, Jun 2, 2011 at 6:08 AM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Thu, Jun 02, 2011 at 05:33:34AM +0300, Amir G. wrote:
> >> >> On Thu, Jun 2, 2011 at 5:16 AM, Amir G. <amir73il@users.sourceforge.net> wrote:
> >> >> > On Thu, Jun 2, 2011 at 2:28 AM, Dave Chinner <david@fromorbit.com> wrote:
> >> > Personally I think that ext4dev shouldn't be supported at all. A
> >> > special fstyp iwhile ext4 was being developed was, IMO, a stupid
> >> > thing to do in the first place, and I was happy when it died. It
> >> > should not be resurrected and propagated.
> >> >
> >> > xfstests assumes that you are using a userspace that is current with
> >> > the version of the filesystem the kernel supports. If you are
> >> > running a development/special branch of ext4, then you need to be
> >> > running a userspace that understands it completely. If all you are
> >> > doing with the ext4dev fstyp is trying to vector to a different fsck
> >> > program that supports a new set of feature bits, then IMO you are
> >> > doing it all wrong.
> >> >
> >> > Fundamentally, the filesystem is either ext4 or it isn't. If the
> >> > features are never going to make it into mainline ext4, then you
> >> > need a completely different fstype and full userspace support for
> >> > that fstype. Once you have that, you can add the fstype support to
> >> > xfstests. However, just using a different fstyp just to set a
> >> > certain set of feature flags is, again IMO, a pretty stupid way of
> >> > going about this.
> >> >
> >>
> >> The features are going into mainline, but are not there yet.
> >
> > So using feature bits as they were intended is the right thing to
> > do, isn't it?
> 
> I am not sure what you mean by that.
> The fact that to this day fsck.ext2/3/4 have always been the same
> file (hence support the same feature set) does not mean that they have
> to be that way by design.
> 
> on my test system fsck.ext4dev must be used to test ext4dev, which has
> newer features than ext4.

And that's perfectly fine, you can use whatever you want on you system.

> I fail to see the problem with that.
> 
> >
> >> I did not invent the ext4dev standard, which is pretty well supported
> >> by all relevant tools, but I find it very convenient for the testing.
> >
> > As I understand it, ext4dev is deprecated and should not be used for
> > any new filesystems. When did that status change?
> >
> > Or did you just start using it because it's convenient for your
> > purposes?  What happens when someone else decides to use ext4dev for
> > testing incompatible development features because it is convenient
> > for them?
> >
> 
> The way I see it, ext4dev is a tool for ext4 developers (and testers).
> Anyone can use it for their own needs and it would be convenient for everyone.
> I never suggested that Fedora push my ext4dev utils as a standard package.
> But me and my group can use it to test the snapshots feature and Ted
> and his group can use it to test the allocation clusters feature.

ext4dev is not a tool for ext4 developers. It has been deprecated and
does not exist anymore, looking at kernel config there is nothing like
that. If you do not want to have different filesystem for your system
to be able to test ext4 without breaking your system ,than it is perfectly
fine to write yourself such helpers. But I do not see any reason for
pushing this stuff to other tools. In fact it should have been removed
from everywhere, since it does not exist anymore ... or has something
changed ? Are we resurrecting ext4dev ? Then we should start somewhere
else do not you think ?

> 
> 
> >> Especially, when I expect my testers to be running a stable
> >> distro release (i.e. F15 or Ubuntu 11.4) and be able to install
> >> my experimental ext4dev module and utils, without it affecting
> >> their (most likely) root ext4/ext3 fs.
> >
> > So get them to use an ext3, XFS, reiser or JFS root filesystem if
> > that's your major concern. That's long been a best practice for
> > configuring a filesystem test box - don't use the same filesystem
> > for your root/stable filesystems as the filesytsem you are testing.
> >
> > e.g. If you pick ext3 for the root filesystem, then you can test
> > ext4, btrfs, xfs, etc changes without having to worry about whether
> > the development module being tested is going to affect your root
> > filesystem....
> 
> You make it sound as if I have a flock of testers out there waiting for
> me to feed them with use cases to test and who abide to my setup
> instructions.
> 
> Wake up call! this is not the case for me and for most developers.
> If I'm lucky, I can get a e few testers who will say:
> OK, if all I have to do is download this package and run 'make test'
> I can spare an hour to play with it.
> 
> So, yes, it's true. There are other ways to accomplish what I am doing,
> but I am going out of my way to try to make the life of developers and testers
> easier and you are doing the exact opposite by raising objections to a rather
> trivial and harmless patch.

What is easier for testers and developers ? I fail to see the reason for
including non-existing FSTYP into xfstests while it should be forgotten
by now. Just provide sources with whatever fs name you choose (or just
patches for ext4 preferably), provide patches to e2fsprogs and patches to
xfstests if you want people to test with it. And it should be easy for every
tester, or developer to use it, shouldn't it ? Is that a problem ?

-Lukas

> 
> Let me ask you this: which FSTYP will be useful to more developers
> ext4dev or reiserfs?
> 
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-854799617-1307016615=:3931
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-854799617-1307016615=:3931--
