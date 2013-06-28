Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 934087F3F
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 11:16:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0DAD0AC007
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 09:16:26 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ySAdgHf5WBMJVVEk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 09:16:25 -0700 (PDT)
Date: Fri, 28 Jun 2013 12:16:21 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where
	appropriate
Message-ID: <20130628121621.6a6b6046@oracle.com>
In-Reply-To: <20130628152552.GB26841@sergelap>
References: <20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
	<20130626173017.5100327a@oracle.com>
	<20130626224410.GB28426@dastard> <20130627130205.GA4003@sergelap>
	<20130628015401.GG32195@dastard> <20130628152552.GB26841@sergelap>
Mime-Version: 1.0
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
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Brian Foster <bfoster@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, xfs@oss.sgi.com

On Fri, 28 Jun 2013 10:25:52 -0500
Serge Hallyn <serge.hallyn@ubuntu.com> wrote:

> Quoting Dave Chinner (david@fromorbit.com):
> > On Thu, Jun 27, 2013 at 08:02:05AM -0500, Serge Hallyn wrote:
> > > Quoting Dave Chinner (david@fromorbit.com):
> > > > On Wed, Jun 26, 2013 at 05:30:17PM -0400, Dwight Engen wrote:
> > > > > On Wed, 26 Jun 2013 12:09:24 +1000
> > > > > Dave Chinner <david@fromorbit.com> wrote:
> > > > > > > We do need to decide on the di_uid that comes back from
> > > > > > > bulkstat. Right now it is returning on disk (==
> > > > > > > init_user_ns) uids. It looks to me like xfsrestore is
> > > > > > > using the normal vfs routines (chown,
> > > 
> > > I might not be helpful here, (as despite having used xfs for years
> > > I've not used these features) but feel like I should try based on
> > > what I see in the manpages.  Here is my understanding:
> > > 
> > > Assume you're a task in a child userns, where you have host uids
> > > 100000-110000 mapped to container uids 0-10000,
> > > 
> > > 1. bulkstat is an xfs_ioctl command, right?  It should return the
> > > mapped uids (0-10000).
> > > 
> > > 2. xfsdump should store the uids as seen in the caller's
> > > namespace.  If xfsdump is done from the container, the dump
> > > should show uids 0-10000.
> > 
> > So when run from within a namespace, it should filter and return
> > only inodes that match the uids/gids mapped into the namespace?
> 
> I would think they should all be returned, with uid/gid being -1.

I agree, so I think bulkstat should return the uids with
from_kuid_munged(current_user_ns(), VFS_I(ip)), so it returns the
same values that stat(2) would. This would mean callers in
init_user_ns see the same values they do today. Callers inside
a userns will see mapped values, but note that they have to be
CAP_SYS_ADMIN in init_user_ns, which I wouldn't expect to normally be
the case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
