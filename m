Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C2587F37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 16:43:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 278738F8054
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 14:43:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iqPhbnAen89L11sm for <xfs@oss.sgi.com>;
	Wed, 23 Oct 2013 14:43:27 -0700 (PDT)
Date: Thu, 24 Oct 2013 08:43:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests btrfs/020: test device replace on RO btrfs
Message-ID: <20131023214323.GQ2797@dastard>
References: <1382527446-16053-1-git-send-email-eguan@redhat.com>
	<1382546683-454-1-git-send-email-eguan@redhat.com>
	<526801EF.8030307@giantdisaster.de> <52680B23.9020604@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52680B23.9020604@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, Stefan Behrens <sbehrens@giantdisaster.de>, xfs@oss.sgi.com

On Wed, Oct 23, 2013 at 12:45:07PM -0500, Eric Sandeen wrote:
> On 10/23/13 12:05 PM, Stefan Behrens wrote:
> > On Thu, 24 Oct 2013 00:44:43 +0800, Eryu Guan wrote:
> >> +# real QA test starts here
> >> +_supported_fs btrfs
> >> +_supported_os Linux
> > 
> > It is still unclear to me why everybody adds this "_supported_os Linux"
> > to the Btrfs tests. Is it because loop devices are used in this
> > particular test btrfs/020 or is it because of Btrfs itself?
> > tests/btrfs/001..010 and tests/btrfs/012..020 contain the "_supported_os
> > Linux".
> 
> Historically xfstests could be run on IRIX & Linux, so some tests needed
> to differentiate for the capabilities of the OS.
> 
> We could probably look at how _supported_os works, and make sure that
> if it's absent, it means "no OS restrictions" and document it as such.

It already does work this way. If you don't add it, then the test
will always run.

However, it also has the documentation factor of saying "we expect
this to work on Linux's btrfs implementation *only*". IOWs, it's
good practice to add the _supported_os field as xfstests is not
designed to be Linux specific....

> "_supported_fs btrfs" is probably sufficient to know that we can run this
> test; if btrfs is ever ported to, say, Solaris, it *should* run there too.  ;)

Unless, of course, there are differences in implementation, which
there would be given that, for example, Solaris handles devices
significantly differently to Linux. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
