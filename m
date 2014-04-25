Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 848DA7F52
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 00:36:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A907304051
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 22:36:50 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ETZYqd2DDeTZDaXX (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Apr 2014 22:36:49 -0700 (PDT)
Date: Thu, 24 Apr 2014 22:36:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6 v2] generic: introduce new large ACL test
Message-ID: <20140425053648.GA9435@infradead.org>
References: <1398204274-2113-1-git-send-email-david@fromorbit.com>
	<1398204274-2113-4-git-send-email-david@fromorbit.com>
	<20140423152313.GC26128@infradead.org>
	<20140423230915.GV15995@dastard> <20140423234452.GW15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140423234452.GW15995@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Apr 24, 2014 at 09:44:53AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Having just removed the largeacl test from the shared ACL test,
> reintroduce the same test as an generic test so that we can
> handle the different limits in supported ACL count appropriately
> across different filesystems and different configurations within
> filesystem types.
> 
> Filesystems have to add support to _acl_get_max to run
> this test - the default behaviour right now is to throw a
> notrun error like this:
> 
> generic/026 14s ... [not run] ext4 does not define maximum ACL count
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
