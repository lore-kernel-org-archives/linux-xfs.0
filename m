Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47830 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933016AbeFLBCX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 21:02:23 -0400
Date: Mon, 11 Jun 2018 18:02:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v5 4/4] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180612010200.GK22045@magnolia>
References: <20180607235533.20391-1-mcgrof@kernel.org>
 <20180607235533.20391-5-mcgrof@kernel.org>
 <fae34ad4-6e90-fda1-d3d5-5c85e655df83@sandeen.net>
 <20180612002352.GB5527@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180612002352.GB5527@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Tue, Jun 12, 2018 at 02:23:52AM +0200, Luis R. Rodriguez wrote:
> On Mon, Jun 11, 2018 at 06:12:01PM -0500, Eric Sandeen wrote:
> > Darrick pointed out that this is a TOCTOU race between stat-ing and opening.
> > I think it makes more sense to open it, then fstat it, and if it's not ok,
> > close it and error out.  LIke this?
> > 
> > +       fd = openat(AT_FDCWD, cli_config_file, O_NOFOLLOW, O_RDONLY);
> > +       if (fd >= 0) {
> > +               /* file in CWD or absolute path */
> > +               ret = fstat(fd, &st);

The TOCTOU race is between statat (in the original code) and openat --
the statat succeeds and S_ISREG returns true, but someone else removes
and replaces the file path with (say) a socket in between the statat and
the openat, and now we're not reading what we thought we were.

The memcpy works exactly as you point out, but that's not the issue
here.

(Granted, I don't know that we actually /care/ from what kind of
filesystem object the configuration data came, but if that were the case
we wouldn't bother stat'ing.)

--D

> > +               if (ret < 0)
> > +                       goto out_err;
> > +
> > +               if (!S_ISREG(st.st_mode)) {
> > +                       errno = EINVAL;
> > +                       goto out_err;
> > +               }
> > +
> > +               memcpy(*fpath, cli_config_file, strlen(cli_config_file));
> > +       } else {
> 
> I've addressed this but I put the memcpy() to  in effect if the file opens
> as the context above is for CLI and if the CLI was used for a config file
> it must exists, otherwise we want to explain which file we used which failed.
> 
> For the default it is different, if the default file opens then yes we copy
> the name of the default file, however if it does not exists we immediately
> bail.
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
