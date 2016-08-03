Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 83F4D7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 14:45:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4007F304048
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 12:45:42 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id 1QCep0oLcpFXrI8Q (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 12:45:38 -0700 (PDT)
Date: Wed, 3 Aug 2016 12:45:36 -0700
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH v7 00/47] xfs: add reverse mapping support
Message-ID: <20160803194536.GJ5316@wotan.suse.de>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
Reply-To: Mark Fasheh <mfasheh@suse.de>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Hi Darrick,

On Wed, Jul 20, 2016 at 09:55:55PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This is the seventh revision of a patchset that adds to XFS kernel
> support for tracking reverse-mappings of physical blocks to file and
> metadata (rmap).  Per reviewers' request with v6, I am splitting the
> gigantic patchbombs into separate functional areas.  Given the
> significant amount of design assumptions that change with block
> sharing, rmap and reflink are provided together.  There shouldn't be
> any incompatible on-disk format changes, pending a thorough review of
> the patches within.

Where can I the patches to enable dedupe_range on xfs? I tested your
previous devel branch based on Linux v4.7-rc3 with duperemove
(https://github.com/markfasheh/duperemove) and it worked extremely well -
even handling some cases that btrfs still has issues with. I actually
committed the code to enable xfs support in duperemove so anyone can test on
xfs with the dedupe_range patches.

I'd gladly test your latest patches by doing my usual 'large' duperemove
tests once I can get ahold of the dedupe_range work :)

Thanks,
	--Mark

--
Mark Fasheh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
