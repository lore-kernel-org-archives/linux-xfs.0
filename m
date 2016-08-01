Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F0977D1C
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 12:08:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 32F58304039
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 10:08:52 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id a7fKUfYGCgLlI5pw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 10:08:50 -0700 (PDT)
Date: Mon, 1 Aug 2016 10:08:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/17] xfs: run xfs_repair at the end of each test
Message-ID: <20160801170814.GA8590@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914481474.11762.2741429828012981240.stgit@birch.djwong.org>
	<20160801062719.GH596@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801062719.GH596@infradead.org>
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
Cc: linux-btrfs@vger.kernel.org, eguan@redhat.com, fstests@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jul 31, 2016 at 11:27:19PM -0700, Christoph Hellwig wrote:
> On Thu, Jul 21, 2016 at 04:46:54PM -0700, Darrick J. Wong wrote:
> > Run xfs_repair twice at the end of each test -- once to rebuild
> > the btree indices, and again with -n to check the rebuild work.
> 
> This looks fine to me in general, but shouldn't we have specific
> tests that test the rebuilding in a normal auto run?

We do have specific tests that examine the outputs of rebuilding the
indices (all the fuzzer group tests do this too); this patch enables a
test runner to expand that coverage to all tests.  Running a
rebuilding xfs_repair for all the tests shook out some bugs in the
xfs_repair rmap handling code that only triggered under some of the
non-rmap non-reflink stressor tests.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
