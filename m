Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3BK3bgS106048 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 15:03:37 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	yZVVApHPM3vNBU4l (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Apr 2012 13:03:36 -0700 (PDT)
Date: Wed, 11 Apr 2012 16:03:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: detecting case-insensitivity
Message-ID: <20120411200335.GD28816@infradead.org>
References: <20120407140029.GA24090@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120407140029.GA24090@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: xfs@oss.sgi.com

Can you add a new s_feature_flags instead of s_flags which is shared
with the mount user ABI?  MS_I_VERSION should also move there.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
