Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p36DZ4bS037020 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 08:35:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5EB51E02C65
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 06:38:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id s4IDmDfMMyeAdSxv for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2011 06:38:21 -0700 (PDT)
Date: Wed, 6 Apr 2011 09:38:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] xfs: fix extent format buffer allocation size
Message-ID: <20110406133816.GA16276@infradead.org>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302070758-17312-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 06, 2011 at 04:19:10PM +1000, Dave Chinner wrote:
> +	ext_buffer = kmem_alloc(XFS_IFORK_SIZE(ip, whichfork),
> +							KM_SLEEP | KM_NOFS);

As mentioned before the KM_NOFS is a change from the previous version
and really should not be needed.

Also the feedback that the new helper needs to be under the
!XFS_NATIVE_ENDIAN ifdef wasn't picked up either.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
