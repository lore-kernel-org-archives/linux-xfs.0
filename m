Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B67E7F56
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:16:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3FC938F804B
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:16:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id PiXMdKaLFBpdavyQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:16:07 -0700 (PDT)
Date: Sun, 21 Jun 2015 02:16:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] xfs_repair: reformat lines to fit within 80
	characters
Message-ID: <20150621091606.GB26833@infradead.org>
References: <1434726241-11606-1-git-send-email-mggr@pml.ac.uk>
	<1434726241-11606-2-git-send-email-mggr@pml.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1434726241-11606-2-git-send-email-mggr@pml.ac.uk>
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
To: Mike Grant <mggr@pml.ac.uk>
Cc: xfs@oss.sgi.com

On Fri, Jun 19, 2015 at 04:03:59PM +0100, Mike Grant wrote:
> Also introduces a const to improve readability

Wouldn't just using sizeof(*bplist) be easier?

>  {
>  	struct xfs_buf		**bplist;
> +	const size_t 		bpsz = sizeof(struct xfs_buf*);

Also if we stay with this version please add a space before the star,
e.g.

	const size_t		bpsz = sizeof(struct xfs_buf *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
