Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33059 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753671AbcLPGjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Dec 2016 01:39:33 -0500
Received: by mail-oi0-f68.google.com with SMTP id f201so8910138oib.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Dec 2016 22:39:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161216044115.21287-7-david@fromorbit.com>
References: <20161216044115.21287-1-david@fromorbit.com> <20161216044115.21287-7-david@fromorbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Dec 2016 08:39:31 +0200
Message-ID: <CAOQ4uxgpFS5gcavtEGSxnFEiotX__4gMfoOAF=6mUW1sVxdYsA@mail.gmail.com>
Subject: Re: [PATCH 6/6] libxcmd: add non-iterating user commands
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 16, 2016 at 6:41 AM, Dave Chinner <david@fromorbit.com> wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Right now command iteration is not directly controllable by the
> user; it is controlled entirely by the application command flag
> setup. Sometimes we don't want commands to iterate but only operate
> on the currently selected object.
>
> For example, the stat command iterates:
>
> $ xfs_io -c "open -r foo" -c "open bar" -c "file" -c "stat" foo
>  000  foo            (foreign,non-sync,non-direct,read-write)
>  001  foo            (foreign,non-sync,non-direct,read-only)
> [002] bar            (foreign,non-sync,non-direct,read-write)
> fd.path = "foo"
> fd.flags = non-sync,non-direct,read-write
> stat.ino = 462399
> stat.type = regular file
> stat.size = 776508
> stat.blocks = 1528
> fd.path = "foo"
> fd.flags = non-sync,non-direct,read-only
> stat.ino = 462399
> stat.type = regular file
> stat.size = 776508
> stat.blocks = 1528
> fd.path = "bar"
> fd.flags = non-sync,non-direct,read-write
> stat.ino = 475227
> stat.type = regular file
> stat.size = 0
> stat.blocks = 0
> $
>
> To do this, add a function to supply a "non-iterating" user command
> that will execute an iterating-capable command as though it
> CMD_FLAG_ONESHOT was set. Add a new command line option to xfs_io to
> drive it (-C <command>) and connect it all up. Document it in the
> xfs_io man page, too.
>
> The result of "-C stat":
>
> $ xfs_io -c "open -r foo" -c "open bar" -c "file" -C "stat" foo
>  000  foo            (foreign,non-sync,non-direct,read-write)
>  001  foo            (foreign,non-sync,non-direct,read-only)
> [002] bar            (foreign,non-sync,non-direct,read-write)
> fd.path = "bar"
> fd.flags = non-sync,non-direct,read-write
> stat.ino = 475227
> stat.type = regular file
> stat.size = 0
> stat.blocks = 0
> $
>
> Is that we only see the stat output for the active open file
> which is "bar".
>
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  include/command.h |  1 +
>  io/init.c         |  7 +++++--
>  libxcmd/command.c | 33 +++++++++++++++++++++++++++------
>  man/man8/xfs_io.8 | 40 ++++++++++++++++++++++++++++++++++------
>  4 files changed, 67 insertions(+), 14 deletions(-)
>
> diff --git a/include/command.h b/include/command.h
> index 348002cbe3ed..fb3f5c79b991 100644
> --- a/include/command.h
> +++ b/include/command.h
> @@ -56,6 +56,7 @@ typedef int (*checkfunc_t)(const cmdinfo_t *ci);
>
>  extern void            add_command(const cmdinfo_t *ci);
>  extern void            add_user_command(char *optarg);
> +extern void            add_oneshot_user_command(char *optarg);
>  extern void            add_command_iterator(iterfunc_t func);
>  extern void            add_check_command(checkfunc_t cf);
>
> diff --git a/io/init.c b/io/init.c
> index 5ce627ef22c9..cf8573f0ecd5 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -34,7 +34,7 @@ void
>  usage(void)
>  {
>         fprintf(stderr,
> -               _("Usage: %s [-adfinrRstVx] [-m mode] [-p prog] [-c cmd]... file\n"),
> +_("Usage: %s [-adfinrRstVx] [-m mode] [-p prog] [[-c|-C] cmd]... file\n"),
>                 progname);
>         exit(1);
>  }
> @@ -145,7 +145,7 @@ init(
>         pagesize = getpagesize();
>         gettimeofday(&stopwatch, NULL);
>
> -       while ((c = getopt(argc, argv, "ac:dFfim:p:nrRstTVx")) != EOF) {
> +       while ((c = getopt(argc, argv, "ac:C:dFfim:p:nrRstTVx")) != EOF) {
>                 switch (c) {
>                 case 'a':
>                         flags |= IO_APPEND;
> @@ -153,6 +153,9 @@ init(
>                 case 'c':
>                         add_user_command(optarg);
>                         break;
> +               case 'C':
> +                       add_oneshot_user_command(optarg);
> +                       break;
>                 case 'd':
>                         flags |= IO_DIRECT;
>                         break;
> diff --git a/libxcmd/command.c b/libxcmd/command.c
> index decc442a9d03..5917aea42611 100644
> --- a/libxcmd/command.c
> +++ b/libxcmd/command.c
> @@ -25,8 +25,14 @@ int          ncmds;
>
>  static iterfunc_t      iter_func;
>  static checkfunc_t     check_func;
> -static int             ncmdline;
> -static char            **cmdline;
> +
> +struct cmdline {
> +       char    *cmdline;
> +       bool    iterate;
> +};
> +
> +static int     ncmdline;
> +struct cmdline *cmdline;
>
>  static int
>  compare(const void *a, const void *b)
> @@ -120,12 +126,27 @@ void
>  add_user_command(char *optarg)
>  {
>         ncmdline++;
> -       cmdline = realloc(cmdline, sizeof(char*) * (ncmdline));
> +       cmdline = realloc(cmdline, sizeof(struct cmdline) * (ncmdline));
> +       if (!cmdline) {
> +               perror("realloc");
> +               exit(1);
> +       }
> +       cmdline[ncmdline-1].cmdline = optarg;
> +       cmdline[ncmdline-1].iterate = true;
> +
> +}
> +
> +void
> +add_oneshot_user_command(char *optarg)
> +{
> +       ncmdline++;
> +       cmdline = realloc(cmdline, sizeof(struct cmdline) * (ncmdline));
>         if (!cmdline) {
>                 perror("realloc");
>                 exit(1);
>         }
> -       cmdline[ncmdline-1] = optarg;
> +       cmdline[ncmdline-1].cmdline = optarg;
> +       cmdline[ncmdline-1].iterate = false;
>  }
>
>  /*
> @@ -212,14 +233,14 @@ command_loop(void)
>
>         /* command line mode */
>         for (i = 0; !done && i < ncmdline; i++) {
> -               input = strdup(cmdline[i]);
> +               input = strdup(cmdline[i].cmdline);
>                 if (!input) {
>                         fprintf(stderr,
>                                 _("cannot strdup command '%s': %s\n"),
>                                 cmdline[i], strerror(errno));

cmdline[i].cmdline, strerror(errno));

I wonder how come you don't get a build warning on this?

>                         exit(1);
>                 }
> -               done = process_input(input, true);
> +               done = process_input(input, cmdline[i].iterate);
>         }
>         free(cmdline);
>         return;
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 885df7f141e2..9db2d97d8310 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -9,10 +9,13 @@ xfs_io \- debug the I/O path of an XFS filesystem
>  .B \-c
>  .I cmd
>  ] ... [
> +.B \-C
> +.I cmd
> +] ... [
>  .B \-p
>  .I prog
>  ]
> -.I file
> +.I [ file ]
>  .br
>  .B xfs_io \-V
>  .SH DESCRIPTION
> @@ -25,14 +28,39 @@ These code paths include not only the obvious read/write/mmap interfaces
>  for manipulating files, but also cover all of the XFS extensions (such
>  as space preallocation, additional inode flags, etc).
>  .SH OPTIONS
> +.B xfs_io
> +commands may be run interactively (the default) or as arguments on the
> +command line.
> +Interactive mode always runs commands on the current open file, whilst commands
> +run from the command line may be repeated on all open files rather than just the current
> +open file.
> +In general, open file iteration will occur for commands that operate on file
> +content or state. In contrast, commands that operate on filesystem or
> +system-wide state will only be run on the current file regardless of how many
> +files are currently open.
> +Multiple arguments may be given on the command line and they are run in the
> +sequence given. The program exits one all commands have
> +been run.
>  .TP 1.0i
>  .BI \-c " cmd"
> -.B xfs_io
> -commands may be run interactively (the default) or as arguments on
> -the command line. Multiple
> +Run the specified command on all currently open files.
> +To maintain compatibility with historical usage, commands that can not be run on
> +all open files will still be run but only execute once on the current open file.
> +Multiple
> +.B \-c
> +arguments may be given and may be interleaved on the command line in any order
> +with
> +.B \-C
> +commands.
> +.TP
> +.BI \-C " cmd"
> +Run the specified command only on the current open file.
> +Multiple
> +.B \-C
> +arguments may be given and may be interleaved on the command line in any order
> +with
>  .B \-c
> -arguments may be given. The commands are run in the sequence given,
> -then the program exits.
> +commands.
>  .TP
>  .BI \-p " prog"
>  Set the program name for prompts and some error messages,
> --
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
