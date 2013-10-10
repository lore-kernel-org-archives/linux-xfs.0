Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AFC7E7F51
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 22:22:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D9E6AC002
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 20:22:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hsKDEItc4AechGJw for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 20:22:18 -0700 (PDT)
Date: Thu, 10 Oct 2013 14:21:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs_fsr: create extent-based attr to grow forkoff
Message-ID: <20131010032144.GV4446@dastard>
References: <4F75C939.6030009@redhat.com> <4F75CAD9.60808@redhat.com>
	<52561AE1.8010902@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52561AE1.8010902@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 09, 2013 at 10:11:29PM -0500, Eric Sandeen wrote:
> On 3/30/12 10:01 AM, Eric Sandeen wrote:
> > In some cases the target file may have a non-local attribute,
> > but the temp file gets assigned a local attribute on creation,
> > due to selinux, for example.
> > 
> > In this case, the large-ish selinux attr will create a forkoff
> > in the temp file smaller than the forkoff in the target file,
> > because the FMT_EXTENTS attr takes up less space.  There is
> > no mechanism to grow the forkoff to match, so we can end up
> > failing to swap these 2 inodes if the result is not enough
> > data space in the temp inode as a result.
> > 
> > After testing the target file for a non-local extent, and
> > checking to see if the forkoff needs to be grown on the first
> > pass, we can add a large attr to knock all attributes of the
> > temp file out of local format, and grow the fork offset.
> > 
> > This passes xfstest 227, and also resolves issues seen on
> > a metadata image provided by Gabriel.
> > 
> > Reported-by: Gabriel VLASIU <gabriel@vlasiu.net>
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> 
> Ping #2?  This was a real bug once, IIRC.  Probably still is...
> 
> Patch 1/2 helped identify the problem, so ping on that too I guess.

Can you repost all these old patches as a new series to make it easy
to apply and test them?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
