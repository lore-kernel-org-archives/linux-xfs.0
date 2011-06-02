Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p526elGN176921 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 01:40:47 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53EFC15DAC27
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 23:40:45 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1SIewnZTWFEhtcCA for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2011 23:40:45 -0700 (PDT)
Date: Thu, 2 Jun 2011 16:40:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Message-ID: <20110602064040.GS561@dastard>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<20110602030802.GR561@dastard>
	<BANLkTi=sPM_AYB4w=N5pWHfws9R3WnfJVw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTi=sPM_AYB4w=N5pWHfws9R3WnfJVw@mail.gmail.com>
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
To: "Amir G." <amir73il@users.sourceforge.net>
Cc: sandeen@redhat.com, Amir Goldstein <amir73il@users.sf.net>, xfs@oss.sgi.com, sergey57@gmail.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Jun 02, 2011 at 06:49:20AM +0300, Amir G. wrote:
> On Thu, Jun 2, 2011 at 6:08 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jun 02, 2011 at 05:33:34AM +0300, Amir G. wrote:
> >> On Thu, Jun 2, 2011 at 5:16 AM, Amir G. <amir73il@users.sourceforge.net> wrote:
> >> > On Thu, Jun 2, 2011 at 2:28 AM, Dave Chinner <david@fromorbit.com> wrote:
> > Personally I think that ext4dev shouldn't be supported at all. A
> > special fstyp iwhile ext4 was being developed was, IMO, a stupid
> > thing to do in the first place, and I was happy when it died. It
> > should not be resurrected and propagated.
> >
> > xfstests assumes that you are using a userspace that is current with
> > the version of the filesystem the kernel supports. If you are
> > running a development/special branch of ext4, then you need to be
> > running a userspace that understands it completely. If all you are
> > doing with the ext4dev fstyp is trying to vector to a different fsck
> > program that supports a new set of feature bits, then IMO you are
> > doing it all wrong.
> >
> > Fundamentally, the filesystem is either ext4 or it isn't. If the
> > features are never going to make it into mainline ext4, then you
> > need a completely different fstype and full userspace support for
> > that fstype. Once you have that, you can add the fstype support to
> > xfstests. However, just using a different fstyp just to set a
> > certain set of feature flags is, again IMO, a pretty stupid way of
> > going about this.
> >
> 
> The features are going into mainline, but are not there yet.

So using feature bits as they were intended is the right thing to
do, isn't it?

> I did not invent the ext4dev standard, which is pretty well supported
> by all relevant tools, but I find it very convenient for the testing.

As I understand it, ext4dev is deprecated and should not be used for
any new filesystems. When did that status change?

Or did you just start using it because it's convenient for your
purposes?  What happens when someone else decides to use ext4dev for
testing incompatible development features because it is convenient
for them?

> Especially, when I expect my testers to be running a stable
> distro release (i.e. F15 or Ubuntu 11.4) and be able to install
> my experimental ext4dev module and utils, without it affecting
> their (most likely) root ext4/ext3 fs.

So get them to use an ext3, XFS, reiser or JFS root filesystem if
that's your major concern. That's long been a best practice for
configuring a filesystem test box - don't use the same filesystem
for your root/stable filesystems as the filesytsem you are testing.

e.g. If you pick ext3 for the root filesystem, then you can test
ext4, btrfs, xfs, etc changes without having to worry about whether
the development module being tested is going to affect your root
filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
