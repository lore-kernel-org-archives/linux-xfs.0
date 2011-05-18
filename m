Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4I6WSx6223920 for <xfs@oss.sgi.com>; Wed, 18 May 2011 01:32:28 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F173B1341C2A
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 23:32:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SNRoejwunhN9I7Ag for <xfs@oss.sgi.com>;
	Tue, 17 May 2011 23:32:26 -0700 (PDT)
Date: Wed, 18 May 2011 16:31:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests: device busy when umount
Message-ID: <20110518063153.GZ19446@dastard>
References: <BANLkTimQW+kyqjmzpAHH_W5x2v1EWW2AZA@mail.gmail.com>
	<4DD286E5.8090105@redhat.com>
	<BANLkTi=pZS6sTjS61UmpbOsj+vF+ithVvw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTi=pZS6sTjS61UmpbOsj+vF+ithVvw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Yongqiang Yang <xiaoqiangnk@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 17, 2011 at 06:01:14PM +0300, Amir Goldstein wrote:
> On Tue, May 17, 2011 at 5:32 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > On 5/17/11 4:03 AM, Yongqiang Yang wrote:
> >> Hi,
> >>
> >> I noticed that all tests which contain 'device busy' errors have
> >> falloc operations. =A0Does the error have something to do with falloc?

<shrug>

Perhaps a bit more detail about what you are testing, how you've set
up xfstests, etc, and some analysis of the problem is in order first?

> > cc'ing xfs list since xfs devs maintain xfstests.
> >
> > What tests have "device busy" errors? =A0What do the usual investigative
> > steps such as "lsof" and "fuser" tell you when this happens?
> =

> I tried running lsof | grep $TEST_DIR before umount
> and I tried sleep 1 before umount and it didn't yield anything.

Which usually indicates that you've got some kind of reference
counting problem preventing the filesystem from being unmounted.

> > Are there loop devices that didn't get cleaned up, or processes that
> > have not terminated?
> >
> > What tests have these problems?
> =

> for me 124 always fails to umount, and 198 and 213 sometimes fails to umo=
unt.

What, exactly, are you testing on? test 124 uses XFS_IOC_RESVSP
directly, not fallocate(), so all it is doing on a non-XFS
filesystem is iterating a loop that writes a 1MB file, reads it back
then unlinks it....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
