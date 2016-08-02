Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E2B257CA0
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 07:24:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72659AC002
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 05:24:11 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id IaOJHRTsKkCrp1XA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 05:24:08 -0700 (PDT)
Date: Tue, 2 Aug 2016 05:24:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/17] xfs: run xfs_repair at the end of each test
Message-ID: <20160802122401.GA31492@infradead.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914481474.11762.2741429828012981240.stgit@birch.djwong.org>
	<20160801062719.GH596@infradead.org>
	<20160801170814.GA8590@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801170814.GA8590@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org, eguan@redhat.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

> We do have specific tests that examine the outputs of rebuilding the
> indices (all the fuzzer group tests do this too); this patch enables a
> test runner to expand that coverage to all tests.  Running a
> rebuilding xfs_repair for all the tests shook out some bugs in the
> xfs_repair rmap handling code that only triggered under some of the
> non-rmap non-reflink stressor tests.

Ok, looks fine then:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
