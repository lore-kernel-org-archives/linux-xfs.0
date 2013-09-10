Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7177A7F54
	for <xfs@oss.sgi.com>; Tue, 10 Sep 2013 12:51:41 -0500 (CDT)
Date: Tue, 10 Sep 2013 12:51:37 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/2] xfs: defrag support for v5 filesystems
Message-ID: <20130910175137.GT1935@sgi.com>
References: <1377822225-17621-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377822225-17621-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Fri, Aug 30, 2013 at 10:23:43AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> The following 2 patches implement the BMBT owner change transaction
> that is necessary to enable the XFS_IOC_SWAPEXT ioctl to operate on
> v5 filesystems correctly. The first patch implements the
> transactional runtime change, and the second patch implements the
> recovery of that change.
> 
> Both the run time and recovery code use the same mechanism for
> changing the owner field in all the blocks in the BMBT on an inode,
> and even though XFS_IOC_SWAPEXT only swaps the data fork, the code
> has been written to be fork neutral so if we even need to swap
> attribute forks it should just work for that, too.
> 
> Further, because the BMBT code uses the generic btree
> infrastructure, the btree modification is done as a generic function
> as well and so should work for all types of btrees supported by the
> generic code. Hence if the need arises we can easily change the
> owner of any btree that uses the generic code.
> 
> The testing carried out is documented in the description of the
> second patch.
> 
> AFAIA, this is the only remaining feature that the kernel v5
> filesystem implementation didn't support. Hence, with this patchset,
> there are no more feature checkboxes that need to be ticked that
> would prevent us from removing the experimental tag from it. Testing
> is the only remaining gate to removing the tag from the kernel
> code...

Applied these 2.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
