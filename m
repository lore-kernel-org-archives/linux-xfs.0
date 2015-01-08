Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B90A7F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 06:46:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ECF15AC005
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 04:46:28 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id V3Tg1c3qLzUhmTw7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 04:46:27 -0800 (PST)
Date: Thu, 8 Jan 2015 04:46:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: move xfs_bmap_finish prototype
Message-ID: <20150108124627.GD3424@infradead.org>
References: <1420666983-7275-1-git-send-email-david@fromorbit.com>
	<1420666983-7275-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420666983-7275-5-git-send-email-david@fromorbit.com>
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

On Thu, Jan 08, 2015 at 08:43:03AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This function is used libxfs code, but is implemented separately in
> userspace. Move the function prototype to xfs_bmap.h so that the
> prototype is shared even if the implementations aren't.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Does this help you a lot?  Seems a little on the fringe to me, but
if it helps I'm fine with it:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
