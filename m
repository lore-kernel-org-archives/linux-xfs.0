Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 865F47F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 17:01:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 590B53040BC
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 15:01:06 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bYgQaLBEPM2gYOoC for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 15:01:01 -0700 (PDT)
Date: Tue, 13 May 2014 08:00:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH -v2] check: add support for an external file containing
	tests to exclude
Message-ID: <20140512220027.GM26353@dastard>
References: <20140416001530.GU15995@dastard>
	<1397624302-9577-1-git-send-email-tytso@mit.edu>
	<20140416064018.GJ15995@dastard> <20140512124232.GB31376@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140512124232.GB31376@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Mon, May 12, 2014 at 08:42:32AM -0400, Theodore Ts'o wrote:
> On Wed, Apr 16, 2014 at 04:40:18PM +1000, Dave Chinner wrote:
> > On Wed, Apr 16, 2014 at 12:58:22AM -0400, Theodore Ts'o wrote:
> > > Currently the -X option is intended to specify a set of expunging
> > > files which are stored in each test/* subdirectory.  As described in
> > > the commit description for 0b1e8abd4, in order to exclude the test
> > > generic/280, the -X option is used as follows:
> > > 
> > >     $ cat tests/generic/3.0-stable-avoid
> > >     280
> > >     $ sudo ./check -X 3.0-stable-avoid generic/280
> > > 
> > > However, it is sometimes useful to store the set of expunged tests in
> > > a single file, outside of tests/* subdirectories.  This commit enables
> > > the following:
> > > 
> > >     $ cat /root/conf/data_journal.exclude
> > >     generic/068
> > >     ext4/301
> > >     $ sudo ./check -E /root/conf/data_journal.exclude -g auto
> > > 
> > > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > 
> > Looks good.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> This patch has apparently not hit the xfstests repository.  Would you
> like me to resend it?

No, I just haven't done an xfstests update for the past couple of
weeks because there haven't been a lot of patches and I've been busy
with other stuff. I'll do one later in the week.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
