Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D1ADD7F3F
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 04:07:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C176C8F8049
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 02:07:22 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rN0AbkJCyC7xZSff (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Dec 2013 02:07:22 -0800 (PST)
Date: Thu, 26 Dec 2013 02:07:21 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: simplify xfs_ail_max
Message-ID: <20131226100721.GA11950@infradead.org>
References: <52B9829A.10804@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52B9829A.10804@oracle.com>
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

On Tue, Dec 24, 2013 at 08:48:26PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> We have already simplified xfs_ail_min() with a new list helper, i.e,
> list_first_entry_or_null(), but xfs_ail_max() still remains as same
> as there is no corresponding list helper we can use for now.  It's
> fairly easy to simulate the list behavior of getting the last item
> in the AIL, therefore we can simplify xfs_ail_max() and move it to
> the header file to make this pair of AIL routines looks symmetrical.

The usageof list_last_entry is fine with me, as is making it inline.
But I think using the explicit if is a lot more readable than the ? :
expression.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
