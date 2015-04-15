Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E6F4D7F3F
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 14:56:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6FFF0AC006
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2015 12:56:20 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id kWSFXaG7ZpiqDaH7 for <xfs@oss.sgi.com>;
	Wed, 15 Apr 2015 12:56:15 -0700 (PDT)
Date: Wed, 15 Apr 2015 15:56:14 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple segments
Message-ID: <20150415195614.GA31407@fieldses.org>
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
Cc: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Marc Eshel <eshel@us.ibm.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-nfs-owner@vger.kernel.org

On Wed, Apr 15, 2015 at 03:32:02PM -0400, Anna Schumaker wrote:
> I just ran some more tests comparing the directio case across
> different filesystem types.  These tests used three 1G files:  100%
> data, 100% hole, and mixed file with alternating 4k data and hole
> segments.  The mixed case seems to be consistently slower compared to
> NFS v4.1, and I'm at a loss for anything I could do to make it faster.
> Here are my numbers:

Have you tried the implementation we discussed that always returns a
single segment covering the whole requested range, by treating holes as
data if necessary when they don't cover the whole range?

(Also: I assume it's the same as before, but: when you post test
results, could you repost if necessary:

	- what the actual test is
	- what the hardware/software setup is on client and server

so that we have reproduceable results for posterity's sake.)

Interesting that "Mixed" is a little slower even before READ_PLUS.

And I guess we should really report this to ext4 people, looks like they
may have a bug.

--b.

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
> 
> 
> 
> 
> 
> ############
> #          #
> #   EXT4   #
> #          #
> ############
> 
> 
> NFS v4.1:
>                             Trial
> |---------|---------|---------|---------|---------|---------|---------|
> |         |    1    |    2    |    3    |    4    |    5    | Average |
> |---------|---------|---------|---------|---------|---------|---------|
> |    Data |  2.637s |  1.823s |  1.792s |  1.816s |  2.000s |  2.014s |
> |    Hole |  1.734s |  1.743s |  1.709s |  1.761s |  1.871s |  1.764s |
> |   Mixed |  5.465s |  2.158s |  2.254s |  2.676s |  2.422s |  2.995s |
> |---------|---------|---------|---------|---------|---------|---------|
> 
> 
> NFS v4.2:
>                             Trial
> |---------|---------|---------|---------|---------|---------|---------|
> |         |    1    |    2    |    3    |    4    |    5    | Average |
> |---------|---------|---------|---------|---------|---------|---------|
> |    Data |  1.934s |  1.783s |  1.800s |  2.010s |  1.982s |  1.902s |
> |    Hole | 63.568s | 63.423s | 64.671s | 66.190s | 65.985s | 64.767s |
> |   Mixed |  6.010s |  5.798s |  6.146s |  6.460s |  6.720s |  6.225s |
> |---------|---------|---------|---------|---------|---------|---------|
> 
> 
> 
> 
> 
> #############
> #           #
> #   BTRFS   #
> #           #
> #############
> 
> 
> NFS v4.1:
>                             Trial
> |---------|---------|---------|---------|---------|---------|---------|
> |         |    1    |    2    |    3    |    4    |    5    | Average |
> |---------|---------|---------|---------|---------|---------|---------|
> |    Data |  2.386s |  1.952s |  1.832s |  1.818s |  1.826s |  1.963s |
> |    Hole |  1.759s |  1.717s |  1.754s |  1.621s |  1.708s |  1.712s |
> |   Mixed |  2.889s |  2.272s |  2.778s |  2.277s |  2.255s |  2.494s |
> |---------|---------|---------|---------|---------|---------|---------|
> 
> 
> NFS v4.2:
>                             Trial
> |---------|---------|---------|---------|---------|---------|---------|
> |         |    1    |    2    |    3    |    4    |    5    | Average |
> |---------|---------|---------|---------|---------|---------|---------|
> |    Data |  2.586s |  1.816s |  2.022s |  1.862s |  1.975s |  2.052s |
> |    Hole |  0.646s |  0.659s |  0.669s |  0.628s |  0.605s |  0.641s |
> |   Mixed |  8.555s |  8.553s |  7.904s |  8.567s |  8.286s |  8.373s |
> |---------|---------|---------|---------|---------|---------|---------|

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
