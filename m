Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FCA87F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 21:58:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1DFCAC001
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 19:58:24 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	3IiigJC5P338zDIB for <xfs@oss.sgi.com>;
	Thu, 17 Oct 2013 19:58:22 -0700 (PDT)
Date: Fri, 18 Oct 2013 13:58:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfstests: New _require_* tests for CRC enabled
	filesystems
Message-ID: <20131018025819.GR4446@dastard>
References: <1370610398-14630-1-git-send-email-david@fromorbit.com>
	<1370610398-14630-6-git-send-email-david@fromorbit.com>
	<5260557D.8050404@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5260557D.8050404@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Thu, Oct 17, 2013 at 04:24:13PM -0500, Eric Sandeen wrote:
> On 6/7/13 8:06 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > CRCs always enabled 32 bit project inodes and attr2 formats, hence
> > they cannot be turned off. Add new require rules for the tests that
> > require attr and 16 bit project IDs so these tests are avoided on
> > CRC enabled filesystems.
> > 
> > Also, add a xfs_db write check so that we can avoid tests that are
> > dependent on xfs_db modifying filesystem structures as they will
> > fail on CRC enabled filessystems right now. This is just temporary
> > until full write xfs_db support is available.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> small optimization question below

Using -N makes sense. I forgot about that option :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
