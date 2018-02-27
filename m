Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:52063 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753218AbeB0NoG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Feb 2018 08:44:06 -0500
Received: by mail-wm0-f46.google.com with SMTP id h21so24160260wmd.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2018 05:44:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180227034545.GC24294@thunk.org>
References: <20180226224224.GE19312@magnolia> <20180227000122.GR14069@wotan.suse.de>
 <3e239e61-bc79-c594-c1fd-44fa3efe779d@sandeen.net> <CAB=NE6U+7hmRhrkkd1v=rEKrcY+NNf61jL9B4nm=kDbTPvy--w@mail.gmail.com>
 <20180227002550.GH19312@magnolia> <20180227031757.GB24294@thunk.org> <20180227034545.GC24294@thunk.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 27 Feb 2018 14:43:44 +0100
Message-ID: <CACj3i72YvAhVfqT-oVkFdrEfBjKOXqtbedMQS2uydBuX_WXhjQ@mail.gmail.com>
Subject: Re: [RFC] mkfs config file bikeshed now!
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.com>, Jeff Mahoney <jeffm@suse.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 27, 2018 at 4:45 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> One other thing I'll mention is that it was really important to me
> that it was very easy to look up values from the config file.  So for
> me it was a lot more than just the parser.  So I can fetch a read a
> config parameter from the config file like this:
>
>         profile_get_boolean(ctx->profile, "options", "no_optimize_extents",
>                             0, 0, &c);
>
> That's because I use this for a lot more than just file system tuning
> parametres, but also for changing how e2fsck / mke2fs behaves.  So
> trying to parse all of the config file at startup time and having to
> stash that in some global context structure is just lot of extra work
> that isn't necessary with the profile library compared with other
> libraries which are focused exclusively on the parsing aspect of
> things (which is actually pretty trivial).
>
> Maybe this doesn't matter for XFS, but other file system utilities may
> find this issue to be something worthy of consideration when trying to
> pick a config file library.

Neat. But yeah, I don't think the nesting would be useful for xfs.
Especially as I prefer the /etc/mkfs.xfs.d/ idea. It might make sense
to use something like this, instead of foo.bar style prefixing,
though.

/etc/mkfs.xfs.d/default:

[metadata]
crc = 0

[naming]
ftype = 0


Cheers,
Jan

>
>                                                         - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
