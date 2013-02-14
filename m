Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A93927FFE
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 06:28:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3EF72AC001
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 04:28:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pI2PwSSXA9cnpfuG for
	<xfs@oss.sgi.com>; Thu, 14 Feb 2013 04:28:37 -0800 (PST)
Date: Thu, 14 Feb 2013 13:28:24 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
In-Reply-To: <20130214110423.GN26694@dastard>
Message-ID: <alpine.LFD.2.00.1302141307050.2315@(none)>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
	<20130212202753.GC26694@dastard>
	<20130213080154.GC18597@x2.net.home>
	<alpine.LFD.2.00.1302131127070.2315@(none)>
	<20130213121655.GA7799@x2.net.home>
	<20130213221720.GH26694@dastard>
	<982B8DBB-3FBA-4213-BC92-848A64C60110@colorremedies.com>
	<alpine.LFD.2.00.1302140929570.2315@(none)>
	<20130214110423.GN26694@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1066676158-1360844910=:2315"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com, Karel Zak <kzak@redhat.com>, Zach Brown <zabrown@redhat.com>, =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>, Chris Murphy <lists@colorremedies.com>, linux-btrfs@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1066676158-1360844910=:2315
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 14 Feb 2013, Dave Chinner wrote:

> Date: Thu, 14 Feb 2013 22:04:23 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Chris Murphy <lists@colorremedies.com>, Karel Zak <kzak@redhat.com>,
>     xfs@oss.sgi.com, sandeen@redhat.com, Zach Brown <zabrown@redhat.com>,
>     linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
> 
> On Thu, Feb 14, 2013 at 09:36:38AM +0100, Lukáš Czerner wrote:
> > On Thu, 14 Feb 2013, Chris Murphy wrote:
> > 
> > > Date: Thu, 14 Feb 2013 00:29:59 -0700
> > > From: Chris Murphy <lists@colorremedies.com>
> > > To: Dave Chinner <david@fromorbit.com>
> > > Cc: Karel Zak <kzak@redhat.com>, Lukáš Czerner <lczerner@redhat.com>,
> > >     xfs@oss.sgi.com, sandeen@redhat.com, Zach Brown <zabrown@redhat.com>,
> > >     linux-btrfs@vger.kernel.org
> > > Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
> > > 
> > > 
> > > On Feb 13, 2013, at 3:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > > it is the responsibility of filesystem
> > > > tools to behave sanely, not for the rest of the world to have to
> > > > work around the dangerous behaviour of a specific filesystems'
> > > > toolset.
> > > 
> > > I appreciate this, and in particular that mkfs.xfs doesn't nerf a file system without the use of -f; even an existing XFS file system. Considering most data loss is user induced, I'd appreciate it if other file systems's tools weren't so easily made belligerent by (hopefully temporarily) confused apes wearing pants.
> > > 
> > > Chris Murphy
> > 
> > I would not be so optimistic about it. The reason being that there
> > are almost _always_ old file system signatures on the device.
> 
> That assumption is way off the mark.  What you do as a filesystem
> developer (remake filesystems on the same block device hundreds of
> times a day) is not at all typical, so you cannot extrapolate from
> your usage habits to what typically happens in production
> environments.
> 
> Admins don't tend to use "force" options by default (especially for
> destructive comands like mkfs) as 1) they are rarely necessary in the
> real world and 2) the consequences of errors are severe.  The most
> common filesystem creation pattern in production systems (be it
> desktop, workstation or server) is that storage, devices and
> filesystems are set up once and then used for the entire lifetime
> ofthe system without ever having mkfs run on them again. i.e on
> pristine, empty hardware. Hence users rarely, if ever, need to use
> the force option for mkfs.xfs.
> 
> > So I
> > think that it got to the point where users will usually use mkfs.xfs
> > -f all the time. And even if they did not and they would use a wrong
> > device they would probably get the same warning even for the device
> > they wanted to use in the first place.
> 
> I get a couple of queries a year from people saying they
> accidentally ran mkfs.ext4 on the wrong device and want to know if
> they can recover their XFS filesystem. The next question is usually
> "why didn't mkfs.ext4 warn me there was an existing filesystem on
> the device like mkfs.xfs does?".
> 
> That is why the "don't overwrite an existing filesystem by default"
> behaviour is important. Users like to be protected from mistakes
> they weren't aware they made, and far too few of our filesystem
> utilities provide that safety net.
> 
> A couple of users a year losing data like this is a couple of users
> too many. Especially when it would only take a couple of hours of
> your time to implement....
> 
> > So even thoug it might help in some cases I do not think that we
> > should go and change all file systems to do that as well, it would
> > not be very useful anyway.
> 
> Tell that to the next user that trashes their data because a
> filesystem tool simply assumed in correctly that it owned the block
> device.

I am not sure whether using a single file system for the
lifetime of the hardware is really the case, it seems unlikely to
me, but you have more experience than I do... But I am not talking
about remaking the file system hundreds of times a day, because once
is just enough to hit this.

mkfs.ext4 actually does have 'undo' functionality which can store
the changes made to the device on the file system itself. It is not
enabled by default, but exactly for this reason I've been thinking
of ways to make this default and possible delete the data when it's
not likely to be needed anymore (first mount ? write ?).

I was also thinking about checking /etc/fstab prior the file system
creation, this might rule out most of the false positives that
mkfs.xfs can generate I guess.

-Lukas


> 
> Cheers,
> 
> Dave.
> 
--8323328-1066676158-1360844910=:2315
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-1066676158-1360844910=:2315--
