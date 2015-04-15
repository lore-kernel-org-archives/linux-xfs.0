Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E3FA87F50
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 17:57:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D48AC30404E
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 15:57:55 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	38PsjWqMLwGk75To for <xfs@oss.sgi.com>;
	Wed, 15 Apr 2015 15:57:53 -0700 (PDT)
Date: Thu, 16 Apr 2015 08:57:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple segments
Message-ID: <20150415225745.GW13731@dastard>
References: <CAHQdGtRCrrhdS8F4FjZFT-CnRRGm8eZR07v8WnK7bwagKgmPcw@mail.gmail.com>
	<55142FB4.2070408@Netapp.com>
	<CAHQdGtS_VuBOzRZjsiYdjZS8qMj2Sw65BYdFmWWf-LJhQL6yOg@mail.gmail.com>
	<5515A9C8.6090400@Netapp.com>
	<CAHQdGtRaUYxU2JAAWErH7FT=Gy5JLzAKi-RtqqBSkNFZrhaB9Q@mail.gmail.com>
	<5515C1BF.8000907@Netapp.com> <20150327205414.GD27889@fieldses.org>
	<5515C3BE.3040807@Netapp.com> <20150327210839.GE27889@fieldses.org>
	<552EBCB2.1040609@Netapp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <552EBCB2.1040609@Netapp.com>
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
To: Anna Schumaker <Anna.Schumaker@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Marc Eshel <eshel@us.ibm.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs-owner@vger.kernel.org

On Wed, Apr 15, 2015 at 03:32:02PM -0400, Anna Schumaker wrote:
> I just ran some more tests comparing the directio case across
> different filesystem types.  These tests used three 1G files:
> 100% data, 100% hole, and mixed file with alternating 4k data and
> hole segments.  The mixed case seems to be consistently slower
> compared to NFS v4.1, and I'm at a loss for anything I could do to
> make it faster.  Here are my numbers:
> 
> ###########
> #         #
> #   XFS   #
> #         #
> ###########
> 
> 
> NFS v4.1:
>                             Trial
> |---------|---------|---------|---------|---------|---------|---------|
> |         |    1    |    2    |    3    |    4    |    5    | Average |
> |---------|---------|---------|---------|---------|---------|---------|
> |    Data |  1.883s |  1.808s |  1.781s |  1.685s |  1.591s |  1.746s |
> |    Hole |  1.815s |  1.635s |  1.682s |  1.698s |  1.653s |  1.697s |
> |   Mixed |  2.089s |  2.024s |  1.970s |  1.925s |  2.049s |  2.011s |
> |---------|---------|---------|---------|---------|---------|---------|
> 
> 
> NFS v4.2:
>                             Trial
> |---------|---------|---------|---------|---------|---------|---------|
> |         |    1    |    2    |    3    |    4    |    5    | Average |
> |---------|---------|---------|---------|---------|---------|---------|
> |    Data |  1.849s |  1.879s |  1.852s |  1.799s |  1.781s |  1.832s |
> |    Hole |  0.668s |  0.600s |  0.611s |  0.619s |  0.617s |  0.623s |
> |   Mixed |  5.913s |  5.811s |  5.952s |  5.962s |  5.806s |  5.889s |
> |---------|---------|---------|---------|---------|---------|---------|

What that says to me is that the READ_PLUS when there are (worst
case) mixed holes is either burning a lot more CPU than we expected
or it is serialising somewhere (not sure where, everything in XFS
should be shared locks on read/seek).

Can you run a perf profile (even just a snapshot from perf top) on
the server so we can see a bit about what is happening on the CPU
for the different workloads?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
