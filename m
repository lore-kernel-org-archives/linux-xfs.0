Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C0BCD98C8
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 04:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344777AbjJKEFt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 00:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344687AbjJKEFs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 00:05:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7088F
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2023 21:05:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27349C433C8;
        Wed, 11 Oct 2023 04:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696997146;
        bh=1JQP12Rvs/L7oR0sDRqcZzvxymBN3sh9uR3BEuj025o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YfNjOtR6nd0yyagEXkt7xRhy4l38kptv6SPKpNrLadp7GIdIuHTUTP8jdTGFJ9mJn
         6VPey3PLAgJs3FFY5+ZH7PJyWU/xntlp3oGqw5tjgKH8JcefVb8blb7mruciB8s8tG
         iRr+6fzH82d3SwYvy588qsTfyngYvesIRRLcKJCJekcAMugyFdwYS8im3o8hnD9nbH
         NLn64OhGlqkuuriOSALE8eXsHGSQ577V2eeJfHkZxeJqu5L37XmdYZ5uWAFz6ei2aZ
         RGPA/kNabIqlwdXqxtKVV5SRaULZ7e+7ifDMqZWjhxmUh4bfzWI5MJpkJ7Ud3i1PgX
         T5L5eM2RaqJww==
Date:   Tue, 10 Oct 2023 21:05:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 05/28] fs: add FS_XFLAG_VERITY for fs-verity sealed
 inodes
Message-ID: <20231011040544.GF1185@sol.localdomain>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-6-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006184922.252188-6-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 08:48:59PM +0200, Andrey Albershteyn wrote:
> Add extended file attribute FS_XFLAG_VERITY for inodes sealed with
> fs-verity.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  Documentation/filesystems/fsverity.rst | 9 +++++++++
>  include/uapi/linux/fs.h                | 1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
> index 13e4b18e5dbb..af889512c6ac 100644
> --- a/Documentation/filesystems/fsverity.rst
> +++ b/Documentation/filesystems/fsverity.rst
> @@ -326,6 +326,15 @@ the file has fs-verity enabled.  This can perform better than
>  FS_IOC_GETFLAGS and FS_IOC_MEASURE_VERITY because it doesn't require
>  opening the file, and opening verity files can be expensive.
>  
> +Extended file attributes
> +------------------------
> +
> +For fs-verity sealed files the FS_XFLAG_VERITY extended file
> +attribute is set. The attribute can be observed via lsattr.
> +
> +    [root@vm:~]# lsattr /mnt/test/foo
> +    --------------------V- /mnt/test/foo
> +

There's currently nowhere in the documentation or code that uses the phrase
"fs-verity sealed file".  It's instead called a verity file, or a file that has
fs-verity enabled.  I suggest we try to avoid inconsistent terminology.

Also, it should be mentioned which kernel versions this works on.

See for example what the statx section of the documentation says just above the
new section that you're adding:

    Since Linux v5.5, the statx() system call sets STATX_ATTR_VERITY if
    the file has fs-verity enabled.

Also, is FS_XFLAG_VERITY going to work on all filesystems?  The existing ways to
query the verity flag work on all filesystems.  Hopefully any new API will too.

Also, "Extended file attributes" is easily confused with, well, extended file
attributes (xattrs).  It should be made clear that this is talking about the
FS_IOC_FSGETXATTR ioctl, not real xattrs.

Also, it should be made clear that FS_XFLAG_VERITY cannot be set using
FS_IOC_FSSETXATTR.  See e.g. how the existing documentation says that
FS_IOC_GETFLAGS can get FS_VERITY_FL but FS_IOC_SETFLAGS cannot set it.

- Eric
