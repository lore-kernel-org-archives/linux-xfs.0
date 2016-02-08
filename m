Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A645D7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 01:31:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48FFEAC002
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 23:31:26 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id hNXFaDMknq4e2Sgn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Feb 2016 23:31:24 -0800 (PST)
Date: Mon, 8 Feb 2016 08:31:21 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: don't use ioends for direct write completions
Message-ID: <20160208073121.GA30092@lst.de>
References: <1454524816-11392-1-git-send-email-hch@lst.de>
	<1454524816-11392-3-git-send-email-hch@lst.de>
	<20160208010026.GL31407@dastard> <20160208061731.GC27429@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208061731.GC27429@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 05:17:31PM +1100, Dave Chinner wrote:
> Right now this series is in a stable branch in the XFS tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-dio-fix-4.6
> 
> If you want to push it through some other tree, please let me know
> when/where it is committed so I can rebuild the XFS for-next branch
> appropriately from a stable commit/branch...

That's how I think it should be handled.  This would also allow the
ext4 and ocfs2 maintainers to depend on the stable branch to clean
up their direct I/O completion handling in this merge window if they
want to.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
