Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34838 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbeLCKJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 05:09:25 -0500
Received: by mail-wr1-f68.google.com with SMTP id 96so11490946wrb.2
        for <linux-xfs@vger.kernel.org>; Mon, 03 Dec 2018 02:09:03 -0800 (PST)
MIME-Version: 1.0
References: <20181202205343.7104-1-david@fromorbit.com> <20181203002036.GB6311@dastard>
In-Reply-To: <20181203002036.GB6311@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 3 Dec 2018 11:08:51 +0100
Message-ID: <CACj3i70DV-ugFQxMU5XPvmNF=VMZ5yvUOQS-EVHgCqGw95K2CA@mail.gmail.com>
Subject: Re: [PATCH 3/2] xfs_io: copy_file_range length is a size_t
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Chinner, Dave" <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Dec 3, 2018 at 1:20 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> copy_file_range() takes a size_t as it's length, not a "long long".
> Therefore we need to be able to pass sizes larger than 8EB to it
> to be able to test the interface fully and that requires copy_range
> to accept all values except an explicit error value of "-1LL".
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Jan Tulak <jtulak@redhat.com>

> ---
>  io/copy_file_range.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index f118a3bfd506..4e2969c9ca47 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -34,7 +34,7 @@ copy_range_help(void)
>   * glibc buffered copy fallback.
>   */
>  static loff_t
> -copy_file_range_cmd(int fd, long long *src, long long *dst, long long len)
> +copy_file_range_cmd(int fd, long long *src, long long *dst, size_t len)
>  {
>         loff_t ret;
>
> @@ -78,7 +78,7 @@ copy_range_f(int argc, char **argv)
>  {
>         long long src = 0;
>         long long dst = 0;
> -       long long len = 0;
> +       size_t len = 0;
>         int opt;
>         int ret;
>         int fd;
> @@ -104,7 +104,7 @@ copy_range_f(int argc, char **argv)
>                         break;
>                 case 'l':
>                         len = cvtnum(fsblocksize, fssectsize, optarg);
> -                       if (len < 0) {
> +                       if (len == -1LL) {
>                                 printf(_("invalid length -- %s\n"), optarg);
>                                 return 0;
>                         }
>


-- 
Jan Tulak
