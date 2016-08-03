Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 09BAF7CA4
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 04:16:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0D088F8033
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 02:16:36 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id RX4CIzSHCoIsQrhW (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 02:16:34 -0700 (PDT)
Date: Wed, 3 Aug 2016 02:16:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/47] xfs: move deferred operations into a separate file
Message-ID: <20160803091627.GA5289@infradead.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907703710.25461.16650495404061662831.stgit@birch.djwong.org>
	<20160801080223.GB30547@infradead.org>
	<20160802223950.GN16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160802223950.GN16044@dastard>
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

On Wed, Aug 03, 2016 at 08:39:50AM +1000, Dave Chinner wrote:
> Rather than have to make major changes to core infrastructure now,
> let's work this out as a separate patchset to clean up the rmap and
> reflink code in the next couple of releases. It's going to be better
> to get working code out there now under the experimental tag than it
> is is to keep it as an out of tree patchset for another cycle.

The problm is that this does not only affect the rmap code (for which
I suspect it actually is fine), but also regresses the freed extent
logging.  If you want minimal changes we should simply drop the patches
to move over the freed extent tracking to the new deferred ops
mechanism for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
