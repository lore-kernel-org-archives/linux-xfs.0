Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB32429DF5
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 14:22:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57478AC007
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 12:22:30 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id DSqQaKc4h8RXykvr (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 12:22:29 -0700 (PDT)
Date: Mon, 17 Aug 2015 12:22:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] xfsprogs: undefined variable fix
Message-ID: <20150817192228.GB26222@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-2-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439828606-7886-2-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Aug 17, 2015 at 06:23:16PM +0200, Jan Tulak wrote:
> Typo fix, which wasn't caught earlier due to #ifdef branching.  The
> 'rmnttomname' does not exists anywhere and looks like a hybrid between
> rmntfromname and rmntonname. And because the previous 'if' has
> 'fromname' on both arguments of realpath, I choosed the same approach
> when fixing it.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
