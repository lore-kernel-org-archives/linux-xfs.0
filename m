Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52120 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbeLCKIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 05:08:02 -0500
Received: by mail-wm1-f67.google.com with SMTP id s14so5104842wmh.1
        for <linux-xfs@vger.kernel.org>; Mon, 03 Dec 2018 02:07:40 -0800 (PST)
MIME-Version: 1.0
References: <20181202205343.7104-1-david@fromorbit.com> <20181202205343.7104-2-david@fromorbit.com>
In-Reply-To: <20181202205343.7104-2-david@fromorbit.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 3 Dec 2018 11:07:28 +0100
Message-ID: <CACj3i703dhKvL+M8FFJLQBhO87fsqhLu6owwYYCG9V-8xBfDmQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] io: open pipes in non-blocking mode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Chinner, Dave" <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Dec 2, 2018 at 9:54 PM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> So that O_RDONLY open commands (such as from copy_range) do not
> block forever waiting on a non-existent writer.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Jan Tulak <jtulak@redhat.com>

> ---
>  io/open.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/io/open.c b/io/open.c
> index 6ea3e9a2019f..b1d9a0fa317c 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -56,6 +56,7 @@ openfile(
>         struct fs_path  *fs_path)
>  {
>         struct fs_path  *fsp;
> +       struct stat     st;
>         int             fd;
>         int             oflags;
>
> @@ -79,6 +80,18 @@ openfile(
>         if (flags & IO_NOFOLLOW)
>                 oflags |= O_NOFOLLOW;
>
> +       /*
> +        * if we've been passed a pipe to open, don't block waiting for a
> +        * reader or writer to appear. We want to either succeed or error out
> +        * immediately.
> +        */
> +       if (stat(path, &st) < 0 && errno != ENOENT) {
> +               perror("stat");
> +               return -1;
> +       }
> +       if (S_ISFIFO(st.st_mode))
> +               oflags |= O_NONBLOCK;
> +
>         fd = open(path, oflags, mode);
>         if (fd < 0) {
>                 if (errno == EISDIR &&
> --
> 2.19.1
>


-- 
Jan Tulak
