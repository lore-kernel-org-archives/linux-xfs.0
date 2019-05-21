Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33725 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfEUFCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 01:02:09 -0400
MIME-Version: 1.0
References: <155839145160.62682.10916303376882370723.stgit@magnolia> <155839145791.62682.9311727733965110633.stgit@magnolia>
In-Reply-To: <155839145791.62682.9311727733965110633.stgit@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 21 May 2019 08:01:57 +0300
Message-ID: <CAOQ4uxiaU2aJ6h1NGv=S8guuFgbPEQ+HwhQ_gPbsCFXmy+Ju+g@mail.gmail.com>
Subject: Re: [PATCH 1/3] generic/530: revert commit f8f57747222
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jeffle Xu <jefflexu@linux.alibaba.com>, fstests <fstests@vger.kernel.org>

On Tue, May 21, 2019 at 1:31 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Commit f8f57747222 ("generic/530: fix shutdown failure of generic/530 in
> overlay") improperly clears an overlayfs test failure by shutting down
> the filesystem after all the tempfiles are closed, which totally defeats
> the purpose of both generic/530 and xfs/501.  Revert this commit so we
> can fix it properly.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  src/t_open_tmpfiles.c |   19 +++++++++++++++++++
>  tests/generic/530     |    4 +---
>  tests/xfs/501         |    4 +---
>  3 files changed, 21 insertions(+), 6 deletions(-)
>
>
> diff --git a/src/t_open_tmpfiles.c b/src/t_open_tmpfiles.c
> index 0393c6bd..da9390fd 100644
> --- a/src/t_open_tmpfiles.c
> +++ b/src/t_open_tmpfiles.c
> @@ -24,6 +24,7 @@ static int min_fd = -1;
>  static int max_fd = -1;
>  static unsigned int nr_opened = 0;
>  static float start_time;
> +static int shutdown_fs = 0;
>
>  void clock_time(float *time)
>  {
> @@ -68,6 +69,22 @@ void die(void)
>                                 end_time - start_time);
>                 fflush(stdout);
>
> +               if (shutdown_fs) {
> +                       /*
> +                        * Flush the log so that we have to process the
> +                        * unlinked inodes the next time we mount.
> +                        */
> +                       int flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
> +                       int ret;
> +
> +                       ret = ioctl(min_fd, XFS_IOC_GOINGDOWN, &flag);
> +                       if (ret) {
> +                               perror("shutdown");
> +                               exit(2);
> +                       }
> +                       exit(0);
> +               }
> +
>                 clock_time(&start_time);
>                 for (fd = min_fd; fd <= max_fd; fd++)
>                         close(fd);
> @@ -143,6 +160,8 @@ int main(int argc, char *argv[])
>                 if (ret)
>                         perror(argv[1]);
>         }
> +       if (argc > 2 && !strcmp(argv[2], "shutdown"))
> +               shutdown_fs = 1;
>
>         clock_time(&start_time);
>         while (1)
> diff --git a/tests/generic/530 b/tests/generic/530
> index 56c6d32a..b0d188b1 100755
> --- a/tests/generic/530
> +++ b/tests/generic/530
> @@ -49,9 +49,7 @@ ulimit -n $max_files
>
>  # Open a lot of unlinked files
>  echo create >> $seqres.full
> -$here/src/t_open_tmpfiles $SCRATCH_MNT >> $seqres.full
> -_scratch_shutdown -f
> -
> +$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
>
>  # Unmount to prove that we can clean it all
>  echo umount >> $seqres.full
> diff --git a/tests/xfs/501 b/tests/xfs/501
> index 4be9997c..974f3414 100755
> --- a/tests/xfs/501
> +++ b/tests/xfs/501
> @@ -54,9 +54,7 @@ ulimit -n $max_files
>
>  # Open a lot of unlinked files
>  echo create >> $seqres.full
> -$here/src/t_open_tmpfiles $SCRATCH_MNT >> $seqres.full
> -_scratch_shutdown -f
> -
> +$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
>
>  # Unmount to prove that we can clean it all
>  echo umount >> $seqres.full
>
