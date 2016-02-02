Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A9E47CB3
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 12:08:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27D32AC004
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 10:08:33 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id nZxH990CR2T0mKRz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 10:08:31 -0800 (PST)
Date: Tue, 2 Feb 2016 10:08:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs: Add BUILD_CFLAGS for cross compilation
Message-ID: <20160202180828.GA13880@infradead.org>
References: <1437913255-7524-4-git-send-email-tytso@mit.edu>
	<1454361909-36538-1-git-send-email-gwendal@chromium.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454361909-36538-1-git-send-email-gwendal@chromium.org>
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
To: Gwendal Grignou <gwendal@chromium.org>
Cc: hch@infradead.org, tytso@mit.edu, fstests@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 01, 2016 at 01:25:09PM -0800, Gwendal Grignou wrote:
> When cross compiling, CFLAGS may contains option for the cros-compiler the
> host compiler can not handle.
> Add BUILD_CFLAGS variable that does not include $OPTIMIZER options.

I would have expected this to be HOST_CFLAGS, but it seems the
BUILD_ convention already exists in xfsprogs, so sticking to it
looks fine to me.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
