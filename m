Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C35017FA6
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 17:35:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B2FF5304051
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 15:35:34 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	FVdne5VCEewNqLCX for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 15:35:32 -0800 (PST)
Date: Wed, 7 Jan 2015 10:18:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/18] xfs: recall pNFS layouts on conflicting access
Message-ID: <20150106231846.GE31508@dastard>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-19-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420561721-9150-19-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 05:28:41PM +0100, Christoph Hellwig wrote:
> Recall all outstanding pNFS layouts and truncates, writes and similar extent
> list modifying operations.

This is not sufficient to isolate extent manipulations. mmap writes
can trigger allocation through ->page_mkwrite, and can also trigger
extent conversion at IO completion without first needing allocation.

Maybe I'm missing something - this patchset needs some comments
documenting the locking used in XFS to co-ordinate layout coherency
at the client side with IO that is in progress for clients with
overlapping block maps, as well as against server side application
IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
