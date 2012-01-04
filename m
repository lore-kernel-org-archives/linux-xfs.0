Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04Gdqj8157798 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 10:39:53 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1tbESS7YYIM9YDqV for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 08:39:48 -0800 (PST)
Date: Wed, 4 Jan 2012 11:39:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfstests: new check 278 to ensure btrfs backref
	integrity
Message-ID: <20120104163946.GA8153@infradead.org>
References: <1324552138-30584-1-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1324552138-30584-1-git-send-email-list.btrfs@jan-o-sch.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: sandeen@sandeen.net, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Dec 22, 2011 at 12:08:58PM +0100, Jan Schmidt wrote:
> This is a btrfs specific scratch test checking the backref walker. It
> creates a file system with compressed and uncompressed data extents, picks
> files randomly and uses filefrag to get their extents. It then asks the
> btrfs utility (inspect-internal) to do the backref resolving from fs-logical
> address (the one filefrag calls "physical") back to the inode number and
> file-logical offset, verifying the result.

I was about to apply this, but for some reason it fails for me when
running xfstest on xfs:

276	 [failed, exit status 1] - output mismatch (see 276.out.bad)
--- 276.out	2012-01-04 16:14:36.000000000 +0000
+++ 276.out.bad	2012-01-04 16:32:26.000000000 +0000
@@ -1,4 +1,5 @@
QA output created by 276
-*** test backref walking
-*** done
+common.rc: Error: $TEST_DEV (/dev/vdb1) is not a MOUNTED btrfs
filesystem
+Filesystem    Type   1K-blocks      Used Available Use% Mounted on
+/dev/vdb1      xfs    39042944     32928  39010016   1% /mnt/test
 *** unmount

which is a bit confusing

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
