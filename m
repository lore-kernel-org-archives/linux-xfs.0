Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD80E7F63
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 07:56:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AEA60304032
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 05:56:47 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id EbYpAtXC1otHajzO (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 05:56:46 -0800 (PST)
Date: Wed, 11 Nov 2015 05:56:39 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3 00/12] xfstests: test the btrfs/xfs reflink/dedupe ioctls
Message-ID: <20151111135639.GA4760@infradead.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
	<20151109075926.GB17974@infradead.org>
	<20151109184913.GB3255@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151109184913.GB3255@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Mon, Nov 09, 2015 at 10:49:13AM -0800, Darrick J. Wong wrote:
> I found a few more bugs in the kernel-side implementation, which might explain
> that.  I'm about to start working on making CoW less crappy, but I'll push all
> the patches out to github.  (I wasn't planning on patchbombing again until
> December.)

Yes, please push your WIP code out as often as possible!

Btw, here is another additional fixup, as two tests were wrongly
tagged as needing reflink instead of dedupe:


diff --git a/tests/generic/827 b/tests/generic/827
index cc1bc52..c8ce7cf 100755
--- a/tests/generic/827
+++ b/tests/generic/827
@@ -47,7 +47,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_scratch
-_require_xfs_io_command "reflink"
+_require_xfs_io_command "dedupe"
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/generic/828 b/tests/generic/828
index 1757985..f5b7298 100755
--- a/tests/generic/828
+++ b/tests/generic/828
@@ -47,7 +47,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_scratch
-_require_xfs_io_command "reflink"
+_require_xfs_io_command "dedupe"
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
