Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 307D27CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 11:00:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA0C3304075
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 09:00:14 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id jPRV8lhD6fEExrmG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Aug 2016 09:00:13 -0700 (PDT)
Date: Thu, 4 Aug 2016 09:00:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/47] xfs: move deferred operations into a separate file
Message-ID: <20160804160007.GA7649@infradead.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907703710.25461.16650495404061662831.stgit@birch.djwong.org>
	<20160801080223.GB30547@infradead.org>
	<20160802223950.GN16044@dastard>
	<20160803091627.GA5289@infradead.org>
	<20160803225756.GW16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803225756.GW16044@dastard>
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
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org

On Thu, Aug 04, 2016 at 08:57:56AM +1000, Dave Chinner wrote:
> So, please explain in more detail what the problem is and what the
> proposed solution is so I (and probably Darrick, too) have some
> understanding of the issue you see with this code.

We were doing 1 (actually 2 with the busy extent tracking) allocations
for each free extent, and now we're up to three.  We need to get this
down to 1 and not increase it for no benefit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
