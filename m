Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:41540 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752939AbdK2XsQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 18:48:16 -0500
MIME-Version: 1.0
In-Reply-To: <20171129232356.28296-6-mcgrof@kernel.org>
References: <20171129232356.28296-1-mcgrof@kernel.org> <20171129232356.28296-6-mcgrof@kernel.org>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Thu, 30 Nov 2017 00:48:15 +0100
Message-ID: <CAJZ5v0gO49=pXGEdi42Hka=Rf=SqVWp-QSJf9_+bGuOgsHMFig@mail.gmail.com>
Subject: Re: [PATCH 05/11] fs: add iterate_supers_excl() and iterate_supers_reverse_excl()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, bart.vanassche@wdc.com, ming.lei@redhat.com, Ted Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jiri Kosina <jikos@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, linux-fsdevel@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Todd Brandt <todd.e.brandt@linux.intel.com>, nborisov@suse.com, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Oliver Neukum <ONeukum@suse.com>, oleksandr@natalenko.name, Oleg Antonyan <oleg.b.antonyan@gmail.com>, Yu Chen <yu.chen.surf@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Linux PM <linux-pm@vger.kernel.org>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Nov 30, 2017 at 12:23 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> There are use cases where we wish to traverse the superblock list
> but also capture errors, and in which case we want to avoid having
> our callers issue a lock themselves since we can do the locking for
> the callers. Provide a iterate_supers_excl() which calls a function
> with the write lock held. If an error occurs we capture it and
> propagate it.
>
> Likewise there are use cases where we wish to traverse the superblock
> list but in reverse order. The new iterate_supers_reverse_excl() helpers
> does this but also also captures any errors encountered.
>
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  fs/super.c         | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h |  2 ++
>  2 files changed, 93 insertions(+)
>
> diff --git a/fs/super.c b/fs/super.c
> index a63513d187e8..885711c1d35b 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -605,6 +605,97 @@ void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
>         spin_unlock(&sb_lock);
>  }
>
> +/**
> + *     iterate_supers_excl - exclusively call func for all active superblocks
> + *     @f: function to call
> + *     @arg: argument to pass to it
> + *
> + *     Scans the superblock list and calls given function, passing it
> + *     locked superblock and given argument. Returns 0 unless an error
> + *     occurred on calling the function on any superblock.
> + */
> +int iterate_supers_excl(int (*f)(struct super_block *, void *), void *arg)
> +{
> +       struct super_block *sb, *p = NULL;
> +       int error = 0;
> +
> +       spin_lock(&sb_lock);
> +       list_for_each_entry(sb, &super_blocks, s_list) {
> +               if (hlist_unhashed(&sb->s_instances))
> +                       continue;
> +               sb->s_count++;
> +               spin_unlock(&sb_lock);

Can anything bad happen if the list is modified at this point by a
concurrent thread?

> +
> +               down_write(&sb->s_umount);
> +               if (sb->s_root && (sb->s_flags & SB_BORN)) {
> +                       error = f(sb, arg);
> +                       if (error) {
> +                               up_write(&sb->s_umount);
> +                               spin_lock(&sb_lock);
> +                               __put_super(sb);
> +                               break;
> +                       }
> +               }
> +               up_write(&sb->s_umount);
> +
> +               spin_lock(&sb_lock);
> +               if (p)
> +                       __put_super(p);
> +               p = sb;
> +       }
> +       if (p)
> +               __put_super(p);
> +       spin_unlock(&sb_lock);
> +
> +       return error;
> +}
> +
