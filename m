Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:34901 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753846AbdF0Wt3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2017 18:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <20170627224326.GA12755@lst.de>
References: <20170627214828.1029-1-hch@lst.de> <20170627214828.1029-5-hch@lst.de>
 <CAHpGcM+Dy+9dNwNpCmu492ayjbSnW-eeivw3+CfJUfbDHajn9w@mail.gmail.com> <20170627224326.GA12755@lst.de>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Wed, 28 Jun 2017 00:49:27 +0200
Message-ID: <CAHpGcM+EqF6-q2jRYVbgZ-5rXA-pbVys7RumAAGOJgfppup5kg@mail.gmail.com>
Subject: Re: [PATCH 4/6] vfs: Add iomap_seek_hole and iomap_seek_data helpers
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

2017-06-28 0:43 GMT+02:00 Christoph Hellwig <hch@lst.de>:
> On Wed, Jun 28, 2017 at 12:14:57AM +0200, Andreas Gr=C3=BCnbacher wrote:
>> This shouldn't be true anymore now that the actors don't recompute the
>> length; the above three lines should be obsolete.
>
> Indeed.
>
>> This comment makes more sense in iomap_seek_hole now.
>
> Or just drop it..
>
> What about the incremental patch below?

Ok.

> diff --git a/fs/iomap.c b/fs/iomap.c
> index c90cda33994b..432eed8f091f 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -626,9 +626,6 @@ iomap_seek_hole(struct inode *inode, loff_t offset, c=
onst struct iomap_ops *ops)
>                 length -=3D ret;
>         }
>
> -       /* The last segment can extend beyond the end of the file. */
> -       if (length <=3D 0)
> -               return min(offset, size);
>         return offset;
>  }
>  EXPORT_SYMBOL_GPL(iomap_seek_hole);
> @@ -675,7 +672,6 @@ iomap_seek_data(struct inode *inode, loff_t offset, c=
onst struct iomap_ops *ops)
>                 length -=3D ret;
>         }
>
> -       /* There is an implicit hole at the end of the file. */
>         if (length <=3D 0)
>                 return -ENXIO;
>         return offset;

Thanks,
Andreas
