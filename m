Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A7237F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 15:38:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28CE230405F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 13:38:20 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZoqefTh0zzpR9FkS for <xfs@oss.sgi.com>;
	Thu, 09 Oct 2014 13:38:17 -0700 (PDT)
Date: Fri, 10 Oct 2014 07:38:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/16] xfs: return the first match during
	case-insensitive lookup.
Message-ID: <20141009203814.GB4376@dastard>
References: <20141003214758.GY1865@sgi.com> <20141003215542.GD1865@sgi.com>
	<20141006221928.GJ2301@dastard> <20141009154240.GC1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141009154240.GC1865@sgi.com>
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
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

On Thu, Oct 09, 2014 at 10:42:40AM -0500, Ben Myers wrote:
> On Tue, Oct 07, 2014 at 09:19:28AM +1100, Dave Chinner wrote:
> > On Fri, Oct 03, 2014 at 04:55:42PM -0500, Ben Myers wrote:
> > > From: Olaf Weber <olaf@sgi.com>
> > > 
> > > Change the XFS case-insensitive lookup code to return the first match
> > > found, even if it is not an exact match. Whether a filesystem uses
> > > case-insensitive lookups is determined by a superblock bit set during
> > > filesystem creation.  This means that normal use cannot create two files
> > > that both match the same filename.
> > > 
> > > Signed-off-by: Olaf Weber <olaf@sgi.com>
> > 
> > This is really dependent on whether we want to support mixed
> > CI/non-CI filesystems, yes? i.e. if we want to support mixed case
> > setups, then we need to keep the code as it stands?
> 
> It depends upon what semantics you decide are correct in the mixed case.
> This is just one solution.

Ok, so we need this code or somethign very similar to support mixed
case filesystems.  Can you tell us what the other possible solutions
and semantics have been considered?

> > What is the downside of keeping the code unchaged and our
> > options open?
> 
> The code that is being removed here was for the case when you
> could have multiple filenames that match for a lookup, which was
> only possible when the ascii-ci bit was implemented as a mount
> option.

Yes, I know what the code did - it allowed us to support mixed case
ascii-ci filesystems. All you've said is "if we remove mixed case
support the code is cleaner" but not addressed the issue at hand.

I'll try asking the same question a different way: if we keep this
code, will it work for mixed case unicode filesystem or do we have
to re-implement mixed case matching differently?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
