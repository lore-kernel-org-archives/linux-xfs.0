Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F117B7CBF
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:29:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C128F30407F
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 03:29:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	aU5qXt0AXRi4HSiF for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 03:29:08 -0700 (PDT)
Date: Fri, 7 Jun 2013 20:29:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests btrfs/314: test send / receive
Message-ID: <20130607102904.GC13113@dastard>
References: <1370532033-20561-1-git-send-email-list.xfs@jan-o-sch.net>
	<51B0CCC6.2010500@redhat.com> <51B18962.3090504@jan-o-sch.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51B18962.3090504@jan-o-sch.net>
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
To: Jan Schmidt <list.xfs@jan-o-sch.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org, sbehrens@giantdisaster.de, xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 09:18:58AM +0200, Jan Schmidt wrote:
> (cc Arne for far-progs discussion)
> 
> On Thu, June 06, 2013 at 19:54 (+0200), Eric Sandeen wrote:
> > On 6/6/13 10:20 AM, Jan Schmidt wrote:
> >> Basic send / receive functionality test for btrfs. Requires current
> >> version of fsstress built (-x support). Relies on fssum tool, which is
> >> not part of the test suite but can skip the test if it is missing.
> >>
> >> Signed-off-by: Jan Schmidt <list.xfs@jan-o-sch.net>
> > 
> > w/o commenting on the test itself, I'm a little uneasy about requiring
> > some external, not-widely-installed tool for this to run.  The fear is
> > that it won't be run as often as it could/should be.
> 
> The main purpose is to have it run by developers changing something around btrfs
> send / receive and probably the backref walker (while there exists a separate
> test not requiring fssum for backrefs). I think we can get them to install fssum.

There's no point in having tests that require you to go find
something else before the tests can be run. That's been tried
before, and it doesn't work - the test just won't get run by
the majority of people who run xfstests.

> > Could the same test be done w/o fssum, or should we maybe put a copy
> > of fssum into xfstests/src/fssum.c ?
> 
> I don't know any adequate replacement for fssum in this case. The purpose is to
> build a checksum for a whole file system tree, including data and partly metadata.
> 
> I don't feel like copying fssum from far-progs into xfstests, though it probably
> won't hurt much. However, I cannot promise we won't make changes to it for
> far-progs, probably creating two incompatible versions of fssum in the wild. Arne?
> 
> > Or does fssum exist in any standard distro package?
> 
> It doesn't. Perhaps Josef can hurry and make a Fedora package for it, if that
> prevents a separate copy to xfstests :-)

No, it doesn't. Packages would be needed for debian, suse, SLES,
RHEL, etc for that to be a useful method of distribution. Just dump
a snapshot of the utility in the xfstests src dir so we don't have
to care about distribution issues...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
