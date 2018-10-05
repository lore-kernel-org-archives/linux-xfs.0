Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:35135 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbeJEPhS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 11:37:18 -0400
MIME-Version: 1.0
References: <153870027422.29072.7433543674436957232.stgit@magnolia> <153870032167.29072.11158511021942868400.stgit@magnolia>
In-Reply-To: <153870032167.29072.11158511021942868400.stgit@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 5 Oct 2018 11:39:24 +0300
Message-ID: <CAOQ4uxha3=jyVmZ0ArbSsO-CSMeQb43p7YTMGazZRB_M8zS0SQ@mail.gmail.com>
Subject: Re: [PATCH 07/15] vfs: skip zero-length dedupe requests
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>

On Fri, Oct 5, 2018 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Don't bother calling the filesystem for a zero-length dedupe request;
> we can return zero and exit.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/read_write.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 973d3da78c09..99b2f809180c 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1966,6 +1966,11 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
>         if (!dst_file->f_op->dedupe_file_range)
>                 goto out_drop_write;
>
> +       if (len == 0) {
> +               ret = 0;
> +               goto out_drop_write;
> +       }
> +
>         ret = dst_file->f_op->dedupe_file_range(src_file, src_pos,
>                                                 dst_file, dst_pos, len);

I suppose it is best to let user get the same errors he would get
before this change rather than skipping zero length copy at
vfs_dedupe_file_range() level, so looks fine.

Thanks,
Amir.
