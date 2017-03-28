Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:32841 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754450AbdC1KvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2017 06:51:21 -0400
MIME-Version: 1.0
In-Reply-To: <22058.1490696551@warthog.procyon.org.uk>
References: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <22058.1490696551@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 28 Mar 2017 06:51:00 -0400
Message-ID: <CAOQ4uxhipk2anBVUh9eKL1A1RqDUMRci5rpYbrjQPo9voab5ZA@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: changes to statx interface
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 28, 2017 at 6:22 AM, David Howells <dhowells@redhat.com> wrote:
> Eric Sandeen <sandeen@sandeen.net> wrote:
>
>> Wire up the statx syscall to xfs_io.
>>
>> xfs_io> help statx
>> statx [-O | -m mask][-FDLA] -- extended information about the currently open file
>> ...
>
> I would like to make the attached changes, to make it more capable, except
> that xfs_io seems to precheck the "-m mask" argument somewhere:
>
>         [root@andromeda ~]# xfs_io -c statx -m all /dev/null
>         non-numeric mode -- all
>
> and interprets "-c" for itself on the command line:
>
>         [root@andromeda ~]# xfs_io -c statx -c /dev/null
>         command "/dev/null" not found

xfs_io -c "statx -c /dev/null"

is what you want

>
> though both these seem to work when used from xfs_io's command prompt.  I
> guess I should switch -c to -C and also -m to -M since it's not a file mode as
> I think the core is expecting.
>
> Also, how do you get xfs_io to tell you what fd it has opened from its own
> command prompt?  I would need to pass that to the -d flag as a dir fd.
>

See the output of 'file' command or the global var filetable.


> David
> ---
> commit 03e4ca1cdc59aaa362fdd51f079493a1f0da254c
> Author: David Howells <dhowells@redhat.com>
> Date:   Tue Mar 28 10:42:23 2017 +0100
>
>     changes
>
> diff --git a/io/stat.c b/io/stat.c
> index a7aebcd..0b05ec9 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -189,12 +189,14 @@ statx_help(void)
>  " Display extended file status.\n"
>  "\n"
>  " Options:\n"
> -" -m mask -- Specify the field mask for the statx call (default STATX_ALL)\n"
> +" -c -- Compare against fstat/fstatat on the same file/fd\n"
> +" -d dirfd -- Use a specific directory fd\n"
> +" -f -- Do fstat equivalent and operate on fd\n"
> +" -m mask -- Specify the field mask for the statx call (can also be 'basic' or 'all'; default STATX_ALL)\n"
>  " -A -- Suppress terminal automount traversal\n"
>  " -D -- Don't sync attributes with the server\n"
>  " -F -- Force the attributes to be sync'd with the server\n"
>  " -L -- Follow symlinks (statx link target)\n"
> -" -O -- Add only basic stats (STATX_BASIC_STATS) to default mask\n"
>  "\n"));
>  }
>
> @@ -227,6 +229,65 @@ dump_statx(struct statx *stx)
>  }
>
>  /*
> + * Compare the contents of a statx struct with that of a stat struct and check
> + * that they're the same.
> + */
> +static int
> +cmp_statx(const struct statx *stx, const struct stat *st)
> +{
> +       const char *what = NULL;
> +
> +#define cmp(x) \
> +       do {                                    \
> +               what = #x;              \
> +               if (stx->stx_##x != st->st_##x) \
> +                       goto mismatch;          \
> +       } while (0)
> +
> +       cmp(blksize);
> +       cmp(nlink);
> +       cmp(uid);
> +       cmp(gid);
> +       cmp(mode);
> +       cmp(ino);
> +       cmp(size);
> +       cmp(blocks);
> +
> +#define devcmp(x) \
> +       do {                                            \
> +               what = #x".major";                      \
> +               if (stx->stx_##x##_major != major(st->st_##x))  \
> +                       goto mismatch;                  \
> +               what = #x".minor";                      \
> +               if (stx->stx_##x##_minor != minor(st->st_##x))  \
> +                       goto mismatch;                  \
> +       } while (0)
> +
> +       devcmp(dev);
> +       devcmp(rdev);
> +
> +#define timecmp(x) \
> +       do {                                            \
> +               what = #x".tv_sec";                     \
> +               if (stx->stx_##x##time.tv_sec != st->st_##x##tim.tv_sec)        \
> +                       goto mismatch;                  \
> +               what = #x".tv_nsec";                    \
> +               if (stx->stx_##x##time.tv_nsec != st->st_##x##tim.tv_nsec)      \
> +                       goto mismatch;                  \
> +       } while (0)
> +
> +       timecmp(a);
> +       timecmp(c);
> +       timecmp(m);
> +
> +       return 0;
> +
> +mismatch:
> +       fprintf(stderr, "Mismatch between stat and statx output (%s)\n", what);
> +       return -1;
> +}
> +
> +/*
>   * options:
>   *     - input flags - query type
>   *     - output style for flags (and all else?) (chars vs. hex?)
> @@ -239,16 +300,31 @@ statx_f(
>  {
>         int             c;
>         struct statx    stx;
> +       struct stat     st;
>         int             atflag = AT_SYMLINK_NOFOLLOW;
> -       unsigned int    m_mask = 0;     /* mask requested with -m */
> -       int             Oflag = 0, mflag = 0;   /* -O or -m was used */
>         unsigned int    mask = STATX_ALL;
> +       int             use_fd = 0;
> +       int             dirfd = AT_FDCWD;
> +       int             compare = 0;
>
> -       while ((c = getopt(argc, argv, "m:FDLOA")) != EOF) {
> +       while ((c = getopt(argc, argv, "d:cfm:FDLA")) != EOF) {
>                 switch (c) {
> +               case 'c':
> +                       compare = 1;
> +                       break;
> +               case 'd':
> +                       dirfd = strtoul(optarg, NULL, 0);
> +                       break;
> +               case 'f':
> +                       use_fd = 1;
> +                       break;
>                 case 'm':
> -                       m_mask = atoi(optarg);
> -                       mflag = 1;
> +                       if (strcmp(optarg, "basic") == 0)
> +                               mask = STATX_BASIC_STATS;
> +                       else if (strcmp(optarg, "all") == 0)
> +                               mask = STATX_ALL;
> +                       else
> +                               mask = strtoul(optarg, NULL, 0);
>                         break;
>                 case 'F':
>                         atflag &= ~AT_STATX_SYNC_TYPE;
> @@ -261,10 +337,6 @@ statx_f(
>                 case 'L':
>                         atflag &= ~AT_SYMLINK_NOFOLLOW;
>                         break;
> -               case 'O':
> -                       mask = STATX_BASIC_STATS;
> -                       Oflag = 1;
> -                       break;
>                 case 'A':
>                         atflag |= AT_NO_AUTOMOUNT;
>                         break;
> @@ -273,23 +345,38 @@ statx_f(
>                 }
>         }
>
> -       if (Oflag && mflag) {
> -               printf("Cannot specify both -m mask and -O\n");
> -               return 0;
> +       memset(&stx, 0xbf, sizeof(stx));
> +
> +       if (use_fd) {
> +               if (statx(file->fd, NULL, atflag, mask, &stx) < 0) {
> +                       perror("statx");
> +                       return 0;
> +               }
> +       } else {
> +               if (statx(dirfd, file->name, atflag, mask, &stx) < 0) {
> +                       perror("statx");
> +                       return 0;
> +               }
>         }
>
> -       /* -m overrides any other mask options */
> -       if (mflag)
> -               mask = m_mask;
> +       if (compare) {
> +               if (use_fd) {
> +                       if (fstat(file->fd, &st) < 0) {
> +                               perror("fstat");
> +                               return 0;
> +                       }
> +               } else {
> +                       if (fstatat(dirfd, file->name, &st,
> +                                   atflag & ~AT_STATX_SYNC_TYPE) < 0) {
> +                               perror("fstatat");
> +                               return 0;
> +                       }
> +               }
>
> -       memset(&stx, 0xbf, sizeof(stx));
> -       if (statx(AT_FDCWD, file->name, atflag, mask, &stx) < 0) {
> -               perror("statx");
> -               return 0;
> +               cmp_statx(&stx, &st);
>         }
> -
> +
>         dump_statx(&stx);
> -
>         return 0;
>  }
>
