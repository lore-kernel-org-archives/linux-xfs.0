Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A5EAB7F63
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 01:33:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7446B304059
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 23:33:10 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id J2FCbcGDrpsABb5q (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 23:33:05 -0700 (PDT)
Subject: Bug#695640: xfs_quota: cannot find mount point for path: Success
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.695640.B695640.136367467128102@bugs.debian.org>
Date: Tue, 19 Mar 2013 17:31:04 +1100
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20130319063104.GA6369@dastard>
References: <CAA0ZO6CtLRkgrpXqapg3B5oMwGdLq8tS3y4dYG47aYX5BZkA=g@mail.gmail.com>
	<20121211221419.GZ27055@sgi.com>
	<CAA0ZO6APzwQCX=yf=qq8NkmjwDHVsgRBNCgN3KNW3RLgAWB=8A@mail.gmail.com>
	<20121211223700.GA27055@sgi.com>
	<CAA0ZO6BOUXTMpdrR-r=__-ZaAM6X39h2SisYXLfTTraTcttr+g@mail.gmail.com>
	<20121211231533.GG16353@dastard>
	<CAA0ZO6BvLQGt_9G-FSi+ZMCzJh_kmb1z2bdoPPwaVMVVK1UXJw@mail.gmail.com>
	<CAA0ZO6BGqvBdXRr9U4BagQYGa=_kC2VUgtOj+qPB5HEX2U8O7w@mail.gmail.com>
	<20130318224814.GP6369@dastard>
	<CAA0ZO6BVwPP9McKA=vn1+21gHpRCQP9P963nsSjY_zXHWeszrg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA0ZO6BVwPP9McKA=vn1+21gHpRCQP9P963nsSjY_zXHWeszrg@mail.gmail.com>
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

On Tue, Mar 19, 2013 at 03:51:30PM +1100, Brian May wrote:
> On 19 March 2013 09:48, Dave Chinner <david@fromorbit.com> wrote:
> 
> > > Did my strace output help diagnose this bug?
> >
> > No, but it's most likely the same problem as fixed in commit
> > 19473a2ac. Can you add this to quota/quot.c:quot_init():
> >
> > +       quot_cmd.flags = CMD_FLAG_GLOBAL;
> >
> > And see if the problem goes away?
> >
> 
> I made this change to the version in Debian squeeze.
> 
> I didn't see any change in behaviour :-(
> 
> hq ~ # xfs_quota  -x -c "quota -N -u brian" /home
> xfs_quota: cannot find mount point for path `/share/systems': Success
> xfs_quota: cannot find mount point for path `/share/cs': Success
> xfs_quota: cannot find mount point for path `/share/cas': Success
> xfs_quota: cannot find mount point for path `/share/cfcp': Success
> xfs_quota: cannot find mount point for path `/share/lgs': Success
> xfs_quota: cannot find mount point for path `/share/common': Success
> xfs_quota: cannot find mount point for path `/share/summer': Success
> /dev/mapper/hq-home    3800752          0          0   00 [--------] /home

Which tells me exactly what is happening.

The project quotas are not on the filesystem you directed the the
quota command at, and xfs_quota is telling you that it can't find
the mount point for the configured project quotas on /home. Either:

# xfs_quota  -x -c "quota -N -u brian"

or

# xfs_quota  -x -c "quota -N -u brian" /home /share

will not output the error message because xfs_quota knows about the
locations of the project quotas.

Yes, it's not obvious what is happening here but technically it
isn't a bug, either, because you told xfs_quota not to load
information about any other mountpoint.

I'll have a think about how to make this output less .... obtuse.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
