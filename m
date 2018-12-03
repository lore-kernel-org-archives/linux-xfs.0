Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56049 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbeLCKRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 05:17:42 -0500
Received: by mail-wm1-f67.google.com with SMTP id y139so5099888wmc.5
        for <linux-xfs@vger.kernel.org>; Mon, 03 Dec 2018 02:17:17 -0800 (PST)
MIME-Version: 1.0
References: <20181202205343.7104-1-david@fromorbit.com> <20181202205343.7104-3-david@fromorbit.com>
In-Reply-To: <20181202205343.7104-3-david@fromorbit.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 3 Dec 2018 11:17:05 +0100
Message-ID: <CACj3i73vnbe7P_HcdjGyBjThSZ-hMUCvTuVCzfMHMO_W7m2rxA@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs_io: allow open file permissions to be changed
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
> I need to be able to open a file read-write, then change the
> permissions on the file to read-only to check that copy_file_range
> returns EPERM correctly in that case. This can't be done as root,
> because root ignores file permissions, but as a normal user we can't
> open a 0444 file for writing and so can't actually test writing to
> a read-only file without some method of "open read-write, change
> permissions to read-only, try to write to file through open
> read-write file".
>
> So, allow adding or removing write permissions on an open file.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Should there be a man page update as well? Other commands from open.c
have a corresponding man section, but:
$ grep -c chmod man/man8/xfs_io.8
0

And I wonder if the two permissions (0444 and 0664) are enough, or we
might want to add other modes as well. But maybe that can be added
when the need comes... Otherwise it looks good.

> ---
>  io/open.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
>
> diff --git a/io/open.c b/io/open.c
> index b1d9a0fa317c..153d4a836d4c 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -44,6 +44,7 @@ static cmdinfo_t chproj_cmd;
>  static cmdinfo_t lsproj_cmd;
>  static cmdinfo_t extsize_cmd;
>  static cmdinfo_t inode_cmd;
> +static cmdinfo_t chmod_cmd;
>  static prid_t prid;
>  static long extsize;
>
> @@ -809,6 +810,48 @@ inode_f(
>         return 0;
>  }
>
> +static void
> +chmod_help(void)
> +{
> +       printf(_(
> +"\n"
> +" Change the read/write permissions on the current file\n"
> +"\n"
> +" Options:\n"
> +" -r -- make the file read only (0444 permissions)\n"
> +" -w -- make the file read/write (0664 permissions)\n"
> +"\n"));
> +}
> +
> +static int
> +chmod_f(
> +       int             argc,
> +       char            **argv)
> +{
> +       mode_t          mode = S_IRUSR | S_IRGRP | S_IROTH;
> +       int             c;
> +
> +       while ((c = getopt(argc, argv, "rw")) != EOF) {
> +               switch (c) {
> +               case 'r':
> +                       break;
> +               case 'w':
> +                       mode |= S_IWUSR | S_IWGRP;
> +                       break;
> +               default:
> +                       return command_usage(&chmod_cmd);
> +               }
> +       }
> +
> +       if (argc != optind)
> +               return command_usage(&chmod_cmd);
> +
> +       if (fchmod(file->fd, mode) < 0) {
> +               exitcode = 1;
> +               perror("fchmod");
> +       }
> +       return 0;
> +}
>  void
>  open_init(void)
>  {
> @@ -871,10 +914,21 @@ open_init(void)
>                 _("Query inode number usage in the filesystem");
>         inode_cmd.help = inode_help;
>
> +       chmod_cmd.name = "chmod";
> +       chmod_cmd.cfunc = chmod_f;
> +       chmod_cmd.args = _("-r | -w");
> +       chmod_cmd.argmin = 1;
> +       chmod_cmd.argmax = 1;
> +       chmod_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
> +       chmod_cmd.oneline =
> +               _("change the read/write permissios on the currently open file");
> +       chmod_cmd.help = chmod_help;
> +
>         add_command(&open_cmd);
>         add_command(&close_cmd);
>         add_command(&chproj_cmd);
>         add_command(&lsproj_cmd);
>         add_command(&extsize_cmd);
>         add_command(&inode_cmd);
> +       add_command(&chmod_cmd);
>  }
> --
> 2.19.1
>


-- 
Jan Tulak
