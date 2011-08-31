Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7V1ID6J169121 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 20:18:14 -0500
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DD951E7F0F9
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 18:18:12 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id IPvEdJfiJf0V63Ff for
	<xfs@oss.sgi.com>; Tue, 30 Aug 2011 18:18:12 -0700 (PDT)
Message-ID: <4E5D8B8E.8030401@oracle.com>
Date: Tue, 30 Aug 2011 18:17:02 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110825060632.GA9933@infradead.org>
	<20110825064039.GO3162@dastard>
	<0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
	<20110826013528.GW3162@dastard>
In-Reply-To: <20110826013528.GW3162@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, viro@ZenIV.linux.org.uk

On 08/25/2011 06:35 PM, Dave Chinner wrote:
> Agreed, that's the way I'd interpret it, too. So perhaps we need to
> ensure that this interpretation is actually tested by this test?
>
> How about some definitions to work by:
>
> Data: a range of the file that contains valid data, regardless of
> whether it exists in memory or on disk. The valid data can be
> preceeded and/or followed by an arbitrary number of zero bytes
> dependent on the underlying implementation of hole detection.
>
> Hole: a range of the file that contains no data or is made up
> entirely of  NULL (zero) data. Holes include preallocated ranges of
> files that have not had actual data written to them.
>
> Does that make sense? It has sufficient flexibility in it for the
> existing generic "non-implementation", allows for filesystems to
> define their own hole detection boundaries (e.g. filesystem block
> size), and effectively defines how preallocated ranges from
> fallocate() should be treated (i.e. as holes). If we can agree on
> those definitions, I think that we should document them in both the
> kernel and the man page that defines SEEK_HOLE/SEEK_DATA so everyone
> is on the same page...

We should not tie in the definition to existing fs technologies. Instead
we should let the fs weigh the cost of providing accurate information
with the possible gain in performance.

Data:
A range in a file that could contain something other than nulls.
If in doubt, it is data.

Hole:
A range in a file that only contains nulls.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
