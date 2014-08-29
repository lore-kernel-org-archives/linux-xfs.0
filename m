Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B35AC7F58
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 19:28:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A1DB88F8050
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:28:26 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id OADylS16aNAkC9r9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 17:28:25 -0700 (PDT)
Date: Thu, 28 Aug 2014 17:28:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] xfs: xfs_bioerror can die.
Message-ID: <20140829002825.GE17502@infradead.org>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408084747-4540-6-git-send-email-david@fromorbit.com>
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

On Fri, Aug 15, 2014 at 04:39:03PM +1000, Dave Chinner wrote:
> Internal buffer write error handling is a mess due to the unnatural
> split between xfs_bioerror and xfs_bioerror_relse(). The buffer
> reference counting is also wrong for the xfs_bioerror path for
> xfs_bwrite - it uses sync IO and so xfs_buf_ioend will release a
> hold count that was never taken.

Which seems to be cause by patch 1 in the series, and thus the
additional hold for the error case should be introduced there.

Otherwise this looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
