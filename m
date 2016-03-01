Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC86A7CBB
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 06:55:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD93E8F8039
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 04:55:18 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 8XSsM3mywQ1nSBiX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 04:55:16 -0800 (PST)
Date: Tue, 1 Mar 2016 04:55:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 1/3] xfs: debug mode forced buffered write failure
Message-ID: <20160301125516.GB3540@infradead.org>
References: <1456756170-51248-1-git-send-email-bfoster@redhat.com>
	<1456756170-51248-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456756170-51248-2-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 29, 2016 at 09:29:28AM -0500, Brian Foster wrote:
> Add a DEBUG mode-only sysfs knob to enable forced buffered write
> failure. An additional side effect of this mode is brute force killing
> of delayed allocation blocks in the range of the write. The latter is
> the prime motiviation behind this patch, as userspace test
> infrastructure requires a reliable mechanism to create and split
> delalloc extents without causing extent conversion.
> 
> Certain fallocate operations (i.e., zero range) were used for this in
> the past, but the implementations have changed such that delalloc
> extents are flushed and converted to real blocks, rendering the test
> useless.

Looks harmless, but I'd add a inline function to check for the failed
writes field so that we can compile it away entirely for !DEBUG builds.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
