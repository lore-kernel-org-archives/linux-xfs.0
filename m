Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C7CBA7F4E
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 06:15:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5E69304048
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 04:15:12 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id MMU6uvoPlVUZLzQG (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Mar 2013 04:15:08 -0700 (PDT)
Subject: Bug#695640: xfs_quota: cannot find mount point for path: Success
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.695640.B695640.13637778069436@bugs.debian.org>
Date: Wed, 20 Mar 2013 22:09:35 +1100
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20130320110935.GE17758@dastard>
References: <CAA0ZO6APzwQCX=yf=qq8NkmjwDHVsgRBNCgN3KNW3RLgAWB=8A@mail.gmail.com>
	<20121211223700.GA27055@sgi.com>
	<CAA0ZO6BOUXTMpdrR-r=__-ZaAM6X39h2SisYXLfTTraTcttr+g@mail.gmail.com>
	<20121211231533.GG16353@dastard>
	<CAA0ZO6BvLQGt_9G-FSi+ZMCzJh_kmb1z2bdoPPwaVMVVK1UXJw@mail.gmail.com>
	<CAA0ZO6BGqvBdXRr9U4BagQYGa=_kC2VUgtOj+qPB5HEX2U8O7w@mail.gmail.com>
	<20130318224814.GP6369@dastard>
	<CAA0ZO6BVwPP9McKA=vn1+21gHpRCQP9P963nsSjY_zXHWeszrg@mail.gmail.com>
	<20130319063104.GA6369@dastard>
	<CAA0ZO6AxFzinTv_COhK6GqnRpSiYW95otznKvYKiWZB5+=CyBg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA0ZO6AxFzinTv_COhK6GqnRpSiYW95otznKvYKiWZB5+=CyBg@mail.gmail.com>
Reply-To: Dave Chinner <david@fromorbit.com>, 695640@bugs.debian.org
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
To: Brian May <brian@microcomaustralia.com.au>
Cc: 695640@bugs.debian.org, Ben Myers <bpm@sgi.com>

On Wed, Mar 20, 2013 at 04:19:16PM +1100, Brian May wrote:
> On 19 March 2013 17:31, Dave Chinner <david@fromorbit.com> wrote:
> 
> > Which tells me exactly what is happening.
> >
> > The project quotas are not on the filesystem you directed the the
> > quota command at, and xfs_quota is telling you that it can't find
> > the mount point for the configured project quotas on /home. Either:
> >
> 
> Hello,
> 
> Thanks for your response.
> 
> I am kind of confused still. I asked for user quotas, with the -u flag. Why
> should it be trying to lookup project quotas?

Because the quota command does mount point and project quota
initialisation (i.e. global state) before it parses any specific
command.

> I only want to get the report of user quotas. I only want to get the report
> for one filesystem. A filesystem that
> doesn't support project quotas, which should be fine because I am not
> asking for project quotas.

The issues project quota configuration is global information, and
the initialisation code is not aware of the fact that:

	a) you are not asking for project quota information; and
	b) you are not asking for information about a mount point
	   that doesn't have any project quotas on it.

> > # xfs_quota  -x -c "quota -N -u brian"
> 
> This prints the quota information 20 times. Huh?

How many mount points do you have? 20?

> > or
> >
> > # xfs_quota  -x -c "quota -N -u brian" /home /share
> >
> 
> This prints the quota information 2 times. Huh?

The command has once for each of the mount points, and the command
itself iterates mount points because you haven't given it a mount
point to look at. So, double iteration.  This same problem was fixed
for the report command by setting it to be a global command i.e. the
fix I mentioned previously that you tested should prevent this
second case, and maybe even the first.

There are several layers of interactions here, and that's why I need
to have a think about it to understand it fully and fix it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
