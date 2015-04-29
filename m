Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BCBCA7F37
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 16:28:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 59640AC002
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 14:28:05 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	H85QMYC5NVBsGRvo for <xfs@oss.sgi.com>;
	Wed, 29 Apr 2015 14:27:59 -0700 (PDT)
Date: Thu, 30 Apr 2015 07:27:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Proposal/RFC: new metadata-specific UUID for V5 supers
Message-ID: <20150429212756.GW15810@dastard>
References: <553EB3D1.10602@sandeen.net> <20150427233754.GT21261@dastard>
	<553ED9D8.4050106@sandeen.net> <20150428012003.GS15810@dastard>
	<553EEB36.4080200@sandeen.net> <5541253D.4090701@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5541253D.4090701@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 29, 2015 at 01:38:53PM -0500, Eric Sandeen wrote:
> On 4/27/15 9:06 PM, Eric Sandeen wrote:
> > On 4/27/15 8:20 PM, Dave Chinner wrote:
> > 
> >> I think that labels are a far better way of dealing with this
> >> problem. Get rid of the UUID mount checking (and hence the nouuid
> >> mount option), and tell people to use by-label instead of by-uuid to
> >> identify their filesystems when doing clones and snapshots. Labels
> >> make it much easier for humans to identify the filesystem than
> >> UUIDs...
> > 
> > I suppose so.  Withdrawn.  ;)
> 
> One more thought.  ;)
> 
> It'd be quite possible to keep defaults compatible with old kernels,
> and only set the new feature if/when a user requests a UUID change.
> 
> If UUID changes are rare, it'll rarely matter; if they are required,
> it'll be possible.  I might send a patch just to make the discussion
> a bit more concrete.

Yes, we have precedence for doing things like that - v2 inodes,
attr2, etc. See what you come up with ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
