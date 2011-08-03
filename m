Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73M3lRD216849 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 17:03:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1ECAFF3D97B
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 15:04:37 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AtWOiXmdp4Ti0viY for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2011 15:04:37 -0700 (PDT)
Date: Wed, 3 Aug 2011 18:03:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: Call filemap_flush_range() for async
	xfs_flush_pages() call
Message-ID: <20110803220344.GA9435@infradead.org>
References: <1312404545-15400-1-git-send-email-jack@suse.cz>
	<1312404545-15400-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1312404545-15400-3-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 03, 2011 at 10:49:05PM +0200, Jan Kara wrote:
> XFS does its own data writeout from several places using xfs_flush_pages().
> When this writeout is racing with flusher thread writing the same inode the
> performance gets bad because flusher thread submits writes as normal WRITE
> commands while xfs_flush_pages() submits them as WRITE_SYNC (as it uses

Oh, I think you really want commit

	xfs: improve sync behaviour in the face of aggressive dirtying

for your vendor tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
