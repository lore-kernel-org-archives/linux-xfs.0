Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A6E3E7F87
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 10:55:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85D0930406A
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 08:55:30 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id BZ5TAEgim7w193Z3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 08:55:29 -0700 (PDT)
Date: Wed, 1 Oct 2014 08:55:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: don't send null bp to xfs_trans_brelse()
Message-ID: <20141001155529.GA787@infradead.org>
References: <542C1B36.5080804@redhat.com>
 <542C1C2B.5020803@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <542C1C2B.5020803@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 01, 2014 at 10:22:19AM -0500, Eric Sandeen wrote:
> In this case, if bp is NULL, error is set, and we send a
> NULL bp to xfs_trans_brelse, which will try to dereference it.
> 
> Test whether we actually have a buffer before we try to
> free it.
> 
> Coverity spotted this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
