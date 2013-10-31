Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D8AC57F9F
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 10:06:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A954C8F8039
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 08:06:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 2CZ971rua5J0kR8k (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 08:06:22 -0700 (PDT)
Date: Thu, 31 Oct 2013 08:06:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/30] db: rewrite bbmap to use xfs_buf_map
Message-ID: <20131031150622.GA7457@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-17-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-17-git-send-email-david@fromorbit.com>
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

On Wed, Oct 30, 2013 at 03:31:07PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Use the libxfs struct xfs_buf_map for recording the extent layout of
> discontiguous buffers and convert the read/write to decode them
> directory and use read_buf/write_buf to do the extent IO. This
> brings the physical xfs_db IO code to be very close to the model
> that libxfs uses.

Looks reasonable.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
