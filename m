Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D1B0D7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 15:55:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 886628F8033
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 13:55:37 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ywZCBWKzmeM0oz5z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 13:55:35 -0700 (PDT)
Date: Wed, 3 Aug 2016 13:55:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v7 00/47] xfs: add reverse mapping support
Message-ID: <20160803205520.GQ8590@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<20160803194536.GJ5316@wotan.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803194536.GJ5316@wotan.suse.de>
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
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 12:45:36PM -0700, Mark Fasheh wrote:
> Hi Darrick,
> 
> On Wed, Jul 20, 2016 at 09:55:55PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This is the seventh revision of a patchset that adds to XFS kernel
> > support for tracking reverse-mappings of physical blocks to file and
> > metadata (rmap).  Per reviewers' request with v6, I am splitting the
> > gigantic patchbombs into separate functional areas.  Given the
> > significant amount of design assumptions that change with block
> > sharing, rmap and reflink are provided together.  There shouldn't be
> > any incompatible on-disk format changes, pending a thorough review of
> > the patches within.
> 
> Where can I the patches to enable dedupe_range on xfs? I tested your
> previous devel branch based on Linux v4.7-rc3 with duperemove
> (https://github.com/markfasheh/duperemove) and it worked extremely well -
> even handling some cases that btrfs still has issues with. I actually
> committed the code to enable xfs support in duperemove so anyone can test on
> xfs with the dedupe_range patches.
> 
> I'd gladly test your latest patches by doing my usual 'large' duperemove
> tests once I can get ahold of the dedupe_range work :)

Your best bets are probably the -experimental trees:
https://github.com/djwong/linux/commits/djwong-experimental
https://github.com/djwong/xfsprogs/commits/djwong-experimental

I haven't updated them in a while because I've been busy trying
to get reverse-mapping (the start of those patchbombs) into 4.8.

Just as a warning, don't put anything critical on those XFS filesystems
because there's going to be a disk format update between now and the
next time I post the patches because Dave and I decided to cache the
block counts for the new btrees in order to speed up mounting.  I don't
anticipate having time to clean up my dev tree and push to github until
a week or two after the merge window closes.

--D

> 
> Thanks,
> 	--Mark
> 
> --
> Mark Fasheh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
