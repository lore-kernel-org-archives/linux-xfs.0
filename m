Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F2C67F3F
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 04:08:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01131304053
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 02:08:25 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id LbE0BlFQVl8eyl3P (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Dec 2013 02:08:25 -0800 (PST)
Date: Thu, 26 Dec 2013 02:08:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: rename mem_to_page to xfs_bufmem_to_page
Message-ID: <20131226100825.GB11950@infradead.org>
References: <52B982AF.2060607@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52B982AF.2060607@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Dec 24, 2013 at 08:48:47PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Rename mem_to_page() to xfs_bufmem_to_page() for XFS convention.

There's nothing inherently buffere related in the function, it doesn't
even take an argument related to buffers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
