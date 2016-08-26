Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3580F7CA1
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 02:48:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F40FB8F8033
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 00:48:48 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 7enCOXsbl15Y5BKZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Aug 2016 00:48:46 -0700 (PDT)
Date: Fri, 26 Aug 2016 00:48:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to 800b269
Message-ID: <20160826074844.GA17137@infradead.org>
References: <20160826062508.GG19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160826062508.GG19025@dastard>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Hi Dave,

please consider: "[PATCH] iomap: don't set FIEMAP_EXTENT_MERGED for
extent based filesystems"

for 4.8.  It fixes a regression in the iomap-based fiemap
implementation, and it's fairly trivial as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
