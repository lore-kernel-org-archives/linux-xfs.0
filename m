Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 679BD7F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 10:42:44 -0500 (CDT)
Date: Thu, 9 Oct 2014 10:42:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 05/16] xfs: return the first match during
	case-insensitive lookup.
Message-ID: <20141009154240.GC1865@sgi.com>
References: <20141003214758.GY1865@sgi.com> <20141003215542.GD1865@sgi.com>
	<20141006221928.GJ2301@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141006221928.GJ2301@dastard>
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

On Tue, Oct 07, 2014 at 09:19:28AM +1100, Dave Chinner wrote:
> On Fri, Oct 03, 2014 at 04:55:42PM -0500, Ben Myers wrote:
> > From: Olaf Weber <olaf@sgi.com>
> > 
> > Change the XFS case-insensitive lookup code to return the first match
> > found, even if it is not an exact match. Whether a filesystem uses
> > case-insensitive lookups is determined by a superblock bit set during
> > filesystem creation.  This means that normal use cannot create two files
> > that both match the same filename.
> > 
> > Signed-off-by: Olaf Weber <olaf@sgi.com>
> 
> This is really dependent on whether we want to support mixed
> CI/non-CI filesystems, yes? i.e. if we want to support mixed case
> setups, then we need to keep the code as it stands?

It depends upon what semantics you decide are correct in the mixed case.
This is just one solution.

> What is the
> downside of keeping the code unchaged and our options open?

The code that is being removed here was for the case when you could have
multiple filenames that match for a lookup, which was only possible when
the ascii-ci bit was implemented as a mount option.  The mount option
was never merged, and the ascii-ci bit is implemented at mkfs and is not
changeable over the lifetime of the filesystem.  So today this code is
not doing us much good.  Maybe there are performance implications where
you have a hash collision, but mostly I think it makes sense to remove
this code from a maintainability standpoint.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
