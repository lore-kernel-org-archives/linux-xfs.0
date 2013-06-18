Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 487A07CBF
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 17:02:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD284AC004
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 15:02:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	97H9UvU85bmBW2zr for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 15:02:33 -0700 (PDT)
Date: Wed, 19 Jun 2013 08:02:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/27] xfs: split out xfs inode operations into separate
	file
Message-ID: <20130618220221.GA29338@dastard>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-19-git-send-email-david@fromorbit.com>
	<20130612140519.GB28988@infradead.org>
	<20130613011414.GB29338@dastard> <20130613080009.GL29338@dastard>
	<20130617155644.GA26043@infradead.org>
	<20130617181411.GE20932@sgi.com> <20130618204011.GU29338@dastard>
	<20130618213715.GM32736@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130618213715.GM32736@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jun 18, 2013 at 04:37:15PM -0500, Ben Myers wrote:
> On Wed, Jun 19, 2013 at 06:40:11AM +1000, Dave Chinner wrote:
> > On Mon, Jun 17, 2013 at 01:14:11PM -0500, Ben Myers wrote:
> > > > Using a directly also would make
> > > > sense, but for some reason Kbuild always had problems with modules built
> > > > from multiple directories and I'm more than glad that we finally managed
> > > > to get rid of the subdirectories.
> > > 
> > > but I really like the libxfs subdirectory idea.  Any idea if the Kbuild issues
> > > are sorted out?
> > 
> > No idea - I don't know the issue is.
> > 
> > However, if the issue has been fixed (or could be easily solved)
> > then it seems like there is a rough agreement on moving towards a
> > common shared libxfs base?
> 
> Yeah, it sounds like it... regardless of whether it goes into a separate
> directory.  I would also be good to get that old xfstest going again.  Looks
> like it was 040.

Which was dependent on the old integrated Irix ptools source tree
structure for xfs-cmds (i.e. prior to separate GPL source trees for
xfsprogs, etc). It hasn't been updated since 2003 and so doesn't
even have "supported_os" tag in it. I'm pretty sure that getting it
to "work" is more hassle than it's worth because the diffs will
never been clean like they were on irix where libxfs was an ism link
to the kernel code from within the xfs-cmds ism...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
