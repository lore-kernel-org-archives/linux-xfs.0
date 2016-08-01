Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1EC877CFD
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 03:02:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1FD7AC002
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:02:30 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id qb8LzLZHVbngJ7xQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 01:02:29 -0700 (PDT)
Date: Mon, 1 Aug 2016 01:02:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/47] xfs: move deferred operations into a separate file
Message-ID: <20160801080223.GB30547@infradead.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907703710.25461.16650495404061662831.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146907703710.25461.16650495404061662831.stgit@birch.djwong.org>
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

I looked over this again and I really don't see the use case of merging
it.  Yes, the freed extent, rmap and reflink code is fairly similar, but
there is all kinds of subtile differences that we need to paper over using
methods and flags.  I think we're better off not trying to share this
code and have a separate, but easily understandable implementation
for each btree.  At least for the traditional traditional freed extent
case the new code also is a lot less optimal than the previous version.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
