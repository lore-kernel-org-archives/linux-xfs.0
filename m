Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 503297CBA
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 09:57:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 118C68F8035
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 07:57:55 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 5SjYtBsBqE2dIaLw (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 May 2016 07:57:53 -0700 (PDT)
Date: Mon, 2 May 2016 07:57:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 5/8] fs: xfs: replace BIO_MAX_SECTORS with BIO_MAX_PAGES
Message-ID: <20160502145746.GH20589@infradead.org>
References: <1460928615-20894-1-git-send-email-ming.lei@canonical.com>
	<1460928615-20894-6-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460928615-20894-6-git-send-email-ming.lei@canonical.com>
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
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>

On Mon, Apr 18, 2016 at 05:29:54AM +0800, Ming Lei wrote:
> BIO_MAX_PAGES is used as maximum count of bvecs, so
> replace BIO_MAX_SECTORS with BIO_MAX_PAGES since
> BIO_MAX_SECTORS is to be removed.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
