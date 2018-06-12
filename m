Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44148 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933491AbeFLAXy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jun 2018 20:23:54 -0400
Date: Tue, 12 Jun 2018 02:23:52 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v5 4/4] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180612002352.GB5527@wotan.suse.de>
References: <20180607235533.20391-1-mcgrof@kernel.org>
 <20180607235533.20391-5-mcgrof@kernel.org>
 <fae34ad4-6e90-fda1-d3d5-5c85e655df83@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fae34ad4-6e90-fda1-d3d5-5c85e655df83@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Mon, Jun 11, 2018 at 06:12:01PM -0500, Eric Sandeen wrote:
> Darrick pointed out that this is a TOCTOU race between stat-ing and opening.
> I think it makes more sense to open it, then fstat it, and if it's not ok,
> close it and error out.  LIke this?
> 
> +       fd = openat(AT_FDCWD, cli_config_file, O_NOFOLLOW, O_RDONLY);
> +       if (fd >= 0) {
> +               /* file in CWD or absolute path */
> +               ret = fstat(fd, &st);
> +               if (ret < 0)
> +                       goto out_err;
> +
> +               if (!S_ISREG(st.st_mode)) {
> +                       errno = EINVAL;
> +                       goto out_err;
> +               }
> +
> +               memcpy(*fpath, cli_config_file, strlen(cli_config_file));
> +       } else {

I've addressed this but I put the memcpy() to  in effect if the file opens
as the context above is for CLI and if the CLI was used for a config file
it must exists, otherwise we want to explain which file we used which failed.

For the default it is different, if the default file opens then yes we copy
the name of the default file, however if it does not exists we immediately
bail.

  Luis
