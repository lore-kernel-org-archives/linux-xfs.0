Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22L4ObD145967 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 15:04:24 -0600
Message-ID: <4F5135D6.3020207@sgi.com>
Date: Fri, 02 Mar 2012 15:04:22 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 8/8] xfs: reimplement fdatasync support
References: <20120229095347.009884687@bombadil.infradead.org>
	<20120229095509.559250501@bombadil.infradead.org>
In-Reply-To: <20120229095509.559250501@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 02/29/12 03:53, Christoph Hellwig wrote:
> Add an in-memory only flag to say we logged timestamps only, and use it to
> check if fdatasync can optimize away the log force.
>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> ---
>   fs/xfs/xfs_file.c       |    7 +++++--
>   fs/xfs/xfs_inode_item.c |    3 ++-
>   fs/xfs/xfs_inode_item.h |   11 ++++++++++-
>   fs/xfs/xfs_super.c      |    2 +-
>   4 files changed, 18 insertions(+), 5 deletions(-)


Reviewed-by: Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
