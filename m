Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C1D17F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 14:21:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B9D5AC008
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:21:30 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id lfG3wLLYqAEboplH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 12:21:28 -0800 (PST)
Date: Thu, 27 Feb 2014 12:21:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: add missing break in O_TMPFILE case
Message-ID: <20140227202127.GA21998@infradead.org>
References: <530F9D31.5070103@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530F9D31.5070103@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 27, 2014 at 02:16:49PM -0600, Eric Sandeen wrote:
> Coverity spotted this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (I assume that -T isn't supposed to imply -x?)

It's not, thanks!

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
