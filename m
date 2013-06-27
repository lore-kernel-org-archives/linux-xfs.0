Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C9817F3F
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 08:02:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 275BA8F804B
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 06:02:15 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id iK7WMFh8w3SwTPQl
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 06:02:14 -0700 (PDT)
Date: Thu, 27 Jun 2013 08:02:05 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where
	appropriate
Message-ID: <20130627130205.GA4003@sergelap>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
	<20130626173017.5100327a@oracle.com>
	<20130626224410.GB28426@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130626224410.GB28426@dastard>
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
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Brian Foster <bfoster@redhat.com>, Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

Quoting Dave Chinner (david@fromorbit.com):
> On Wed, Jun 26, 2013 at 05:30:17PM -0400, Dwight Engen wrote:
> > On Wed, 26 Jun 2013 12:09:24 +1000
> > Dave Chinner <david@fromorbit.com> wrote:
> > > > We do need to decide on the di_uid that comes back from bulkstat.
> > > > Right now it is returning on disk (== init_user_ns) uids. It looks
> > > > to me like xfsrestore is using the normal vfs routines (chown,

I might not be helpful here, (as despite having used xfs for years
I've not used these features) but feel like I should try based on
what I see in the manpages.  Here is my understanding:

Assume you're a task in a child userns, where you have host uids
100000-110000 mapped to container uids 0-10000,

1. bulkstat is an xfs_ioctl command, right?  It should return the mapped
uids (0-10000).

2. xfsdump should store the uids as seen in the caller's namespace.  If
xfsdump is done from the container, the dump should show uids 0-10000.

3. xfsrestore should use be run from the desired namespace.  If you did
xfsdump from the host ns, you should then xfsrestore from the host ns.
Then inside the container those uids (100000-110000) will be mapped
to your uids (0-10000).

4. If you xfsdump in this container, then xfsrestore in another
container where you have 200000-210000 mapped to 0-10000, the dump
image will have uids 0-10000.  The restored image will have container
uids 0-10000, while on the underlying host media it will be uids
200000-210000.

5. If you xfsdump in this container then xfsrestore on the host, then
the host uids 0-10000 will be used on the underlying media.  The
container would be unable to read this files as the uids do not map
into the container.

-serge

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
