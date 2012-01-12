Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CKBNiR016960 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 14:11:24 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id wUWYqACLjqStwv6W for <xfs@oss.sgi.com>;
	Thu, 12 Jan 2012 12:11:22 -0800 (PST)
Date: Thu, 12 Jan 2012 21:11:21 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] vfs: Protect write paths by sb_start_write -
	sb_end_write
Message-ID: <20120112201121.GD8778@quack.suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
	<1326331253-6497-3-git-send-email-jack@suse.cz>
	<FA7A1011-4312-4050-8AD5-C6060CFF3A55@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <FA7A1011-4312-4050-8AD5-C6060CFF3A55@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu 12-01-12 12:56:01, Andreas Dilger wrote:
> On 2012-01-11, at 6:20 PM, Jan Kara wrote:
> > There are three entry points which dirty pages in a filesystem.  mmap (handled
> > by block_page_mkwrite()), buffered write (handled by
> > __generic_file_aio_write()), and truncate (it can dirty last partial page -
> > handled by do_truncate()). Protect these places with sb_start_write() and
> > sb_end_write().
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> > fs/buffer.c  |   18 ++----------------
> > fs/open.c    |    6 ++++++
> > mm/filemap.c |    3 ++-
> > 3 files changed, 10 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 19d8eb7..8519405 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -2371,18 +2371,7 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> 
> The comment for __block_page_mkwrite() needs to be updated to reference
> sb_start_write() and sb_end_write() instead of vfs_check_frozen().
  Thanks. Fixed.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
