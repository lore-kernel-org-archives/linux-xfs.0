Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8TB7qbN185412 for <xfs@oss.sgi.com>; Thu, 29 Sep 2011 06:07:52 -0500
Date: Thu, 29 Sep 2011 07:07:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfsprogs: xfs_quota: kill local variable "type" from
	free_f()
Message-ID: <20110929110750.GC509@infradead.org>
References: <a14d653e8a238b3207c5076eb6e6f3358e433422.1317210237.git.aelder@sgi.com>
	<ccff8f308fbc7e15e9a74f28b5eb98490a0e3c82.1317210237.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ccff8f308fbc7e15e9a74f28b5eb98490a0e3c82.1317210237.git.aelder@sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 28, 2011 at 06:44:34AM -0500, Alex Elder wrote:
> Only one value is ever really used for the  "type" variable in
> free_f(), and it indicates that either type of entry in fs_table
> is wanted.  Just get rid of the variable and make use of the
> ability to provide 0 to free_space_list() to indicate that.

This sounds like someone planned to add an argument to it to support
looking at just normal or project quotas.

Given that it never materialized and no one asked for it I'm fine
with your cleanup.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
