Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64CA67F3F
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 10:04:09 -0500 (CDT)
Date: Tue, 14 Oct 2014 10:04:05 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 05/16] xfs: return the first match during
	case-insensitive lookup.
Message-ID: <20141014150405.GA2199@sgi.com>
References: <20141003214758.GY1865@sgi.com> <20141003215542.GD1865@sgi.com>
	<20141006221928.GJ2301@dastard> <20141009154240.GC1865@sgi.com>
	<20141009203814.GB4376@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141009203814.GB4376@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

Dave,

On Fri, Oct 10, 2014 at 07:38:14AM +1100, Dave Chinner wrote:
> On Thu, Oct 09, 2014 at 10:42:40AM -0500, Ben Myers wrote:
> > On Tue, Oct 07, 2014 at 09:19:28AM +1100, Dave Chinner wrote:
> > > On Fri, Oct 03, 2014 at 04:55:42PM -0500, Ben Myers wrote:
> > > > From: Olaf Weber <olaf@sgi.com>
> > > > 
> > > > Change the XFS case-insensitive lookup code to return the first match
> > > > found, even if it is not an exact match. Whether a filesystem uses
> > > > case-insensitive lookups is determined by a superblock bit set during
> > > > filesystem creation.  This means that normal use cannot create two files
> > > > that both match the same filename.
> > > > 
> > > > Signed-off-by: Olaf Weber <olaf@sgi.com>
> > > 
> > > This is really dependent on whether we want to support mixed
> > > CI/non-CI filesystems, yes? i.e. if we want to support mixed case
> > > setups, then we need to keep the code as it stands?
> > 
> > It depends upon what semantics you decide are correct in the mixed case.
> > This is just one solution.
> 
> Ok, so we need this code or somethign very similar to support mixed
> case filesystems.  Can you tell us what the other possible solutions
> and semantics have been considered?

There was some discussion of this in the v2 posting of this rfc.

http://marc.info/?l=linux-xfs&m=141176024430150&w=2

Olaf's "readme" example at the above link is a pretty good example of
what we're facing.  And I don't have a good answer for which file to
open.  So for now we're just going for the cleanest solution.

> > > What is the downside of keeping the code unchaged and our
> > > options open?
> > 
> > The code that is being removed here was for the case when you
> > could have multiple filenames that match for a lookup, which was
> > only possible when the ascii-ci bit was implemented as a mount
> > option.
> 
> Yes, I know what the code did - it allowed us to support mixed case
> ascii-ci filesystems. All you've said is "if we remove mixed case
> support the code is cleaner" but not addressed the issue at hand.

I also tried to explain that as the codebase stands today, removal of
this code does not represent a loss of functionality.  It is dead code.

> I'll try asking the same question a different way: if we keep this
> code, will it work for mixed case unicode filesystem or do we have
> to re-implement mixed case matching differently?

If you definately want to keep this code around I'll look into this, but
right now I don't have plans to extend the patchset to support mixed
case insensitivity in a single filesystem.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
