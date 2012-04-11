Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3BKbcJY108042 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 15:37:38 -0500
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id OyuMIAuaQRVjKy7K (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Apr 2012 13:37:37 -0700 (PDT)
Date: Wed, 11 Apr 2012 16:37:35 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: detecting case-insensitivity
Message-ID: <20120411203735.GB31706@fieldses.org>
References: <20120407140029.GA24090@fieldses.org>
	<20120411200335.GD28816@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120411200335.GD28816@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Apr 11, 2012 at 04:03:35PM -0400, Christoph Hellwig wrote:
> Can you add a new s_feature_flags instead of s_flags which is shared
> with the mount user ABI?  MS_I_VERSION should also move there.

I was wondering about that.  Yes, that makes a lot more sense, I'll work
on it.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
