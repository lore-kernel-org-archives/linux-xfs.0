Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OBw1F6206950 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 06:58:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 439BF91874
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 04:58:00 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	pTq5Mpb7FAnL1nde for <xfs@oss.sgi.com>;
	Sun, 24 Jul 2011 04:58:00 -0700 (PDT)
Date: Sun, 24 Jul 2011 07:57:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Fix wrong return value of xfs_file_aio_write
Message-ID: <20110724115752.GA11048@infradead.org>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
	<20110723180942.GA1616@x4.trippels.de>
	<4E2B2E88.8080006@redhat.com>
	<20110723203824.GB1652@x4.trippels.de>
	<20110723220212.GA1648@x4.trippels.de>
	<20110724111625.GA12658@infradead.org>
	<20110724115420.GA1626@x4.trippels.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110724115420.GA1626@x4.trippels.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Josef Bacik <josef@redhat.com>

On Sun, Jul 24, 2011 at 01:54:20PM +0200, Markus Trippelsdorf wrote:
> On 2011.07.24 at 07:16 -0400, Christoph Hellwig wrote:
> > On Sun, Jul 24, 2011 at 12:02:12AM +0200, Markus Trippelsdorf wrote:
> > > The following patch fixes the problem for me:
> > 
> > Good catch, can you send it with a proper signoff and description?
> 
> The fsync prototype change commit 02c24a82187d accidentally overwrote
> the ssize_t return value of xfs_file_aio_write with 0 for SYNC type
> writes. Fix this by checking if an error occured when calling
> xfs_file_fsync and only change the return value in this case.
> In addition xfs_file_fsync actually returns a normal negative error, so
> fix this, too.
> ---
>  fs/xfs/linux-2.6/xfs_file.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

The Signed-off-by: line is still missing, and you normally shouldn't
quote the previous mail you reply to for patches.  Sorry for beeing
nit-picky, but see this as a training exercise :)

You can also add:

Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Christoph Hellwig <hch@lst.de>

as I've run this through xfsqa (strictly speaking it's still running,
but it looks good so far)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
