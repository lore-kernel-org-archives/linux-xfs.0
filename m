Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 131377CA0
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 08:18:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E215AC002
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 06:18:38 -0700 (PDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com
	[74.125.82.68]) by cuda.sgi.com with ESMTP id 2oJFt3SpamtTzAAb
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Aug 2016 06:18:36 -0700 (PDT)
Received: by mail-wm0-f68.google.com with SMTP id o80so5612005wme.0
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 06:18:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464792297-13185-9-git-send-email-hch@lst.de>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<1464792297-13185-9-git-send-email-hch@lst.de>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Thu, 18 Aug 2016 15:18:34 +0200
Message-ID: <CAHpGcMLUtVDiW1e_kuviBNXsn1z_FR0raS3xo9t1bdXyx7kX2g@mail.gmail.com>
Subject: Re: [PATCH 08/14] fs: iomap based fiemap implementation
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
To: Christoph Hellwig <hch@lst.de>
Cc: Bob Peterson <rpeterso@redhat.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

Christoph,

2016-06-01 16:44 GMT+02:00 Christoph Hellwig <hch@lst.de>:
> Add a simple fiemap implementation based on iomap_ops, partially based
> on a previous implementation from Bob Peterson <rpeterso@redhat.com>.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap.c            | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/iomap.h |  3 ++
>  2 files changed, 93 insertions(+)
>
> diff --git a/fs/iomap.c b/fs/iomap.c
> index e51adb6..e874c78 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -405,3 +405,93 @@ out_unlock:
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(iomap_page_mkwrite);
> +
> +struct fiemap_ctx {
> +       struct fiemap_extent_info *fi;
> +       struct iomap prev;
> +};
> +
> +static int iomap_to_fiemap(struct fiemap_extent_info *fi,
> +               struct iomap *iomap, u32 flags)
> +{
> +       switch (iomap->type) {
> +       case IOMAP_HOLE:
> +               /* skip holes */
> +               return 0;
> +       case IOMAP_DELALLOC:
> +               flags |= FIEMAP_EXTENT_DELALLOC | FIEMAP_EXTENT_UNKNOWN;
> +               break;
> +       case IOMAP_UNWRITTEN:
> +               flags |= FIEMAP_EXTENT_UNWRITTEN;
> +               break;
> +       case IOMAP_MAPPED:
> +               break;
> +       }
> +
> +       return fiemap_fill_next_extent(fi, iomap->offset,
> +                       iomap->blkno != IOMAP_NULL_BLOCK ? iomap->blkno << 9: 0,
> +                       iomap->length, flags | FIEMAP_EXTENT_MERGED);

According to Documentation/filesystems/fiemap.txt, it seems that
FIEMAP_EXTENT_MERGED flag should only be set by filesystems with
block-based rather than extent-based allocation. Am I overlooking
something?

> +
> +}
> +
> +static loff_t
> +iomap_fiemap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> +               struct iomap *iomap)
> +{
> +       struct fiemap_ctx *ctx = data;
> +       loff_t ret = length;
> +
> +       if (iomap->type == IOMAP_HOLE)
> +               return length;
> +
> +       ret = iomap_to_fiemap(ctx->fi, &ctx->prev, 0);
> +       ctx->prev = *iomap;
> +       switch (ret) {
> +       case 0:         /* success */
> +               return length;
> +       case 1:         /* extent array full */
> +               return 0;
> +       default:
> +               return ret;
> +       }
> +}
> +
> +int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
> +               loff_t start, loff_t len, struct iomap_ops *ops)
> +{
> +       struct fiemap_ctx ctx;
> +       loff_t ret;
> +
> +       memset(&ctx, 0, sizeof(ctx));
> +       ctx.fi = fi;
> +       ctx.prev.type = IOMAP_HOLE;
> +
> +       ret = fiemap_check_flags(fi, FIEMAP_FLAG_SYNC);
> +       if (ret)
> +               return ret;
> +
> +       ret = filemap_write_and_wait(inode->i_mapping);
> +       if (ret)
> +               return ret;
> +
> +       while (len > 0) {
> +               ret = iomap_apply(inode, start, len, 0, ops, &ctx,
> +                               iomap_fiemap_actor);
> +               if (ret < 0)
> +                       return ret;
> +               if (ret == 0)
> +                       break;
> +
> +               start += ret;
> +               len -= ret;
> +       }
> +
> +       if (ctx.prev.type != IOMAP_HOLE) {
> +               ret = iomap_to_fiemap(fi, &ctx.prev, FIEMAP_EXTENT_LAST);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(iomap_fiemap);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 854766f..b3deee1 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -3,6 +3,7 @@
>
>  #include <linux/types.h>
>
> +struct fiemap_extent_info;
>  struct inode;
>  struct iov_iter;
>  struct kiocb;
> @@ -63,5 +64,7 @@ int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
>                 struct iomap_ops *ops);
>  int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>                 struct iomap_ops *ops);
> +int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> +               loff_t start, loff_t len, struct iomap_ops *ops);
>
>  #endif /* LINUX_IOMAP_H */
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
