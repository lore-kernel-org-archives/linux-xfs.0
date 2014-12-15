Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 66C8A7F4E
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2014 12:24:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3AD56304039
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2014 10:24:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id J4vjG75ApM2n38E4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Dec 2014 10:24:53 -0800 (PST)
Date: Mon, 15 Dec 2014 10:24:53 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove extra newlines from xfs messages
Message-ID: <20141215182453.GA15673@infradead.org>
References: <548B6E07.8080302@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <548B6E07.8080302@redhat.com>
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

On Fri, Dec 12, 2014 at 04:36:55PM -0600, Eric Sandeen wrote:
> xfs_warn() and friends add a newline by default, but some
> messages add another one.  
> 
> Particularly for the failing write message below, this can
> waste a lot of console real estate!
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
