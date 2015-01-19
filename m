Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 39E7E7F54
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2015 03:02:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 17A598F8040
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2015 01:02:51 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QcEuE7PG7Pv2UZqe (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Jan 2015 01:02:50 -0800 (PST)
Date: Mon, 19 Jan 2015 01:02:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/17] quota: Add ->quota_{enable,disable} callbacks for
	VFS quotas
Message-ID: <20150119090248.GC27474@infradead.org>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421412471-4747-4-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Fri, Jan 16, 2015 at 01:47:37PM +0100, Jan Kara wrote:
> +EXPORT_SYMBOL(dquot_quota_enable);

> +EXPORT_SYMBOL(dquot_quota_disable);

I can't find any modular users of this (in fact none outside this
file), so I'd suggest to keep these local.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
