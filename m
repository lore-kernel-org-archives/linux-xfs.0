Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45345 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbfFZOzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 10:55:22 -0400
MIME-Version: 1.0
References: <20190626061711.27690-1-amir73il@gmail.com> <fb00d61f-127e-b190-4059-81138279e0cc@sandeen.net>
In-Reply-To: <fb00d61f-127e-b190-4059-81138279e0cc@sandeen.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 26 Jun 2019 17:55:09 +0300
Message-ID: <CAOQ4uxjoXqSKWLxG5vp9O=Vvnrpd_RfocNX4LUp5UytvVMx9-Q@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_io: allow passing an open file to copy_range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Jun 26, 2019 at 5:41 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 6/26/19 1:17 AM, Amir Goldstein wrote:
> > Commit 1a05efba ("io: open pipes in non-blocking mode")
> > addressed a specific copy_range issue with pipes by always opening
> > pipes in non-blocking mode.
> >
> > This change takes a different approach and allows passing any
> > open file as the source file to copy_range.  Besides providing
> > more flexibility to the copy_range command, this allows xfstests
> > to check if xfs_io supports passing an open file to copy_range.
> >
> > The intended usage is:
> > $ mkfifo fifo
> > $ xfs_io -f -n -r -c "open -f dst" -C "copy_range -f 0" fifo
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >
> > Eric,
> >
> > Re-posting this patch with Darrick's RVB, since it was missed last
> > two for-next updates.
>
> Thanks.  See, this is why I send that email ;)
>
> I was wondering about a small tweak to the man page to make it clear
> that "-f N" refers to "open file number N as shown by the files command"
> but I guess sendfile already uses the same terminology with no further
> explanation, so maybe it's ok.
>
> my only concern is this:
>
> +       if (optind != argc - src_file_arg) {
> +               fprintf(stderr, "optind=%d, argc=%d, src_file_arg=%d\n", optind, argc, src_file_arg);
>                 return command_usage(&copy_range_cmd);
> +       }
>
> spitting out source code bits when the user misuses the command isn't
> my favorite thing.  Should remove the fprintf, I think, as it's apparently
> for debugging the patch, not for general use?  I can do that on commit
> if you're ok with it.

Of course. I just forgot to remove it. My bad.

Thanks,
Amir.
