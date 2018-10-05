Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35162 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbeJENpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 09:45:09 -0400
MIME-Version: 1.0
References: <153870027422.29072.7433543674436957232.stgit@magnolia> <153870034823.29072.4817036324117498634.stgit@magnolia>
In-Reply-To: <153870034823.29072.4817036324117498634.stgit@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 5 Oct 2018 09:47:41 +0300
Message-ID: <CAOQ4uxjXt35dUxwrRpVaRf048+edD5RRtHD2aqSOA-2C_=BnEw@mail.gmail.com>
Subject: Re: [PATCH 10/15] vfs: make cloning to source file eof more explicit
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
> Use the new CLONE_RANGE_EOF flag to explicitly declare that the caller
> wants the clone implementation to set *len appropriately once the files
> are locked.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/read_write.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 7cfff497263b..4eaea52f70a8 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1747,11 +1747,12 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
>
>         isize = i_size_read(inode_in);
>
> -       /* Zero length dedupe exits immediately; reflink goes to EOF. */
> -       if (*len == 0) {
> -               if (is_dedupe || pos_in == isize)
> -                       return 0;
> -               if (pos_in > isize)
> +       /*
> +        * If the caller asked to go all the way to the end of the source file,
> +        * set *len now that we have the file locked.
> +        */
> +       if ((flags & CLONERANGE_EOF) && *len == 0) {
> +               if (pos_in >= isize)
>                         return -EINVAL;

Slight change of behavior with clone of 0 bytes at EOF.
Is that intentional?
Does not change behavior through the entire series?
Please drop a work about this in commit message.

Thanks,
Amir.
