Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6CE127F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 11:06:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5653C8F8084
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 09:06:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id Xlkm8q5izFcrRkXs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Mar 2014 09:06:33 -0800 (PST)
Date: Wed, 5 Mar 2014 09:06:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: xfs_check_page_type buffer checks need help
Message-ID: <20140305170632.GC11667@infradead.org>
References: <1393981893-2497-1-git-send-email-david@fromorbit.com>
	<1393981893-2497-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393981893-2497-2-git-send-email-david@fromorbit.com>
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

This looks correct, but why don't we simply have a special cased
function looking or any delalloc page for xfs_aops_discard_page instead
of having one that is fairly over-general?

Reviewed-by: Christoph Hellwig <hch@lst.de>

if you want to go down this route anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
