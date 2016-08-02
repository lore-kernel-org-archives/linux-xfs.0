Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 50C3D7CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 17:39:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 223048F8035
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 15:39:58 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	W1D1PdgbHqmMKoJd for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 15:39:52 -0700 (PDT)
Date: Wed, 3 Aug 2016 08:39:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/47] xfs: move deferred operations into a separate file
Message-ID: <20160802223950.GN16044@dastard>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907703710.25461.16650495404061662831.stgit@birch.djwong.org>
	<20160801080223.GB30547@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801080223.GB30547@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Mon, Aug 01, 2016 at 01:02:23AM -0700, Christoph Hellwig wrote:
> I looked over this again and I really don't see the use case of merging
> it.  Yes, the freed extent, rmap and reflink code is fairly similar, but
> there is all kinds of subtile differences that we need to paper over using
> methods and flags.  I think we're better off not trying to share this
> code and have a separate, but easily understandable implementation
> for each btree.  At least for the traditional traditional freed extent
> case the new code also is a lot less optimal than the previous version.

Rather than have to make major changes to core infrastructure now,
let's work this out as a separate patchset to clean up the rmap and
reflink code in the next couple of releases. It's going to be better
to get working code out there now under the experimental tag than it
is is to keep it as an out of tree patchset for another cycle.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
