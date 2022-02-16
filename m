Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04994C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 17:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbiBPRPX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 12:15:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbiBPRPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 12:15:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5012A7970
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 09:15:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38D3561B95
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 17:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9BBC340E8;
        Wed, 16 Feb 2022 17:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645031709;
        bh=i2ETiOCZ8LKbGyNfK7OBZuVH5C22FDSHK5/NwhgsH64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pcTKbastPsJbzCVxqyYX6UWNsInTOwIlwbYZ7RjvifR6zYQy2RHT6xSnJVl9qp5Jj
         yRs6zQgcZds48plxkcOzl2fdvkR4e+v0e5bcnAJD3+6OVlfTD0YfFYwp7CQSWHauEF
         YZrIaEagHCHQLI4+MBX1GoGuQb83Pz5j51QU12TE+LNh7VoWk9YQD6GH31XTqK07+5
         NGCZuAD4UwkFLJaosHiBuXZ0YyYXFDy4BsKof+fsuMJ5UZp6N4n+HO24Pqv4z8gm74
         Xmym/MI4zalDi5l000REH+M2kGaSY74Oe9RnwufM5qLtP8u2yyOub3rtyGHQuu+RmX
         j543ZfolA8KMw==
Date:   Wed, 16 Feb 2022 09:15:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_admin: open with O_EXCL if we will be writing
Message-ID: <20220216171508.GL8313@magnolia>
References: <15b6f52f-a90b-7056-8b2e-e2d4dde1ef5d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15b6f52f-a90b-7056-8b2e-e2d4dde1ef5d@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 15, 2022 at 11:35:23PM -0600, Eric Sandeen wrote:
> So, coreOS has a systemd unit which changes the UUID of a filesystem
> on first boot, and they're currently racing that with mount.
> 
> This leads to corruption and mount failures.
> 
> If xfs_db is running as xfs_admin in a mode that can write to the
> device, open that device exclusively.
> 
> This might still lead to mount failures if xfs_admin wins the open race,
> but at least it won't corrupt the filesystem along the way.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (this opens plain files O_EXCL is well, which is undefined without O_CREAT.
> I'm not sure if we need to worry about that.)
> 
> diff --git a/db/init.c b/db/init.c
> index eec65d0..f43be6e 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -97,6 +97,14 @@ init(
>  	else
>  		x.dname = fsdevice;
>  
> +	/*
> +	 * If running as xfs_admin in RW mode, prevent concurrent
> +	 * opens of a block device.
> + 	 */
> +	if (!strcmp(progname, "xfs_admin") &&

Hmm, it seems like sort of a hack to key this off the program name.
Though Eric mentioned on IRC that Dave or someone expressed a preference
for xfs_db not being gated on O_EXCL when a user is trying to run the
program for *debugging*.

Perhaps "if (strcmp(progname, "xfs_db") &&" here?  Just in case we add
more shell script wrappers for xfs_db in the future?  I prefer loosening
restrictions as new functionality asks for them, rather than risk
breaking scripts when we discover holes in new code later on.

> +	    (x.isreadonly != LIBXFS_ISREADONLY))

At first I wondered about the -i case where ISREADONLY and ISINACTIVE
are set, but then I realized that -i ("do it even if mounted") isn't
used by xfs_admin and expressly forbids the use of O_EXCL.  So I guess
the equivalence test and the assignment below are ok, since x.isreadonly
is zero at the start of xfs_db's init() function, and we'll never have
to deal with other flags combinations that might've snuck in from
somewhere else.  Right?

> +		x.isreadonly = LIBXFS_EXCLUSIVELY;

But this is still a mess.  Apparently libxfs_init_t.isdirect is for
LIBXFS_DIRECT, but libxfs_init_t.isreadonly is for other four flags?
But it doesn't really make much difference to libxfs_init() because it
combines both fields?

Can we turn this into a single flags field?  Not necessarily here, but
as a general cleanup?

> +
>  	x.bcache_flags = CACHE_MISCOMPARE_PURGE;

...and maybe teach libxlog not to have this global variable?

--D

>  	if (!libxfs_init(&x)) {
>  		fputs(_("\nfatal error -- couldn't initialize XFS library\n"),
> 
