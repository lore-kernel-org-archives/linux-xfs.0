Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 393E27F53
	for <xfs@oss.sgi.com>; Tue, 10 Sep 2013 17:40:36 -0500 (CDT)
Date: Tue, 10 Sep 2013 17:40:35 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/2] xfs: fix some new memory allocation failures
Message-ID: <20130910224035.GW1935@sgi.com>
References: <1378119180-31380-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378119180-31380-1-git-send-email-david@fromorbit.com>
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

On Mon, Sep 02, 2013 at 08:52:58PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> These failures are a result of order-4 allocations being done on v5
> filesystems to support the large ACL count xattrs. The first patch
> puts out usual falbback to vmalloc workaround in place. The second
> patch factors all the places we now have this fallback-to-vmalloc
> and makes it transparent to the callers.

Applied these 2.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
