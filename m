Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F19C678D4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 10:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCCKpy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 05:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCCKpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 05:45:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBE45D8A5
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 02:45:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CECBA617A6
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 10:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705C2C433EF;
        Fri,  3 Mar 2023 10:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677840352;
        bh=NZli42HebBgPdRLoGFYVVBb6T6+KFmnwmWiBIS9UTuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u8Fb+KbONVnGoGTHnnZxKD0QXMcnVp18a3HbLV3RNergF23CAwtpFen1PSlV8lBsR
         wTXbBQg45drxHzpljeptFj94+wY+oPIAC0eSEyihKfeGwWvsR6mQQSv+nZVMbJgiHL
         A6e7jZEZUlN++eGVNB/O9rC+FfcL13sbGA880S2Nqz6nqLpUv9aYU96haF1otO3egu
         uN9ZOG0ZFBuceAZ/A2YR5t9Q9md+Ww9dn7qO4Dj2yL+gGevrQdITu6bjBF43fNd/gr
         BGqmuOt0QW1eoynJch9KAE8C1J8cckYBX/ZC8ieouMW/mbtfoVFSopD7mdaWSWde8p
         q/1Gsd265ogmQ==
Date:   Fri, 3 Mar 2023 11:45:48 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Subject: Re: [PATCH 1/3] mkfs: check dirent names when reading protofile
Message-ID: <20230303104548.hb4isyjjirtofbvh@andromeda>
References: <167768672841.4130726.1758921319115777334.stgit@magnolia>
 <ED16BgxEjmojPneowA7vF2dI6lOm4dx4MP3mJDz3ayovku7hh0us4acUn7oXkbA_S92b_LxKnXyclnvmZ9xATQ==@protonmail.internalid>
 <167768673411.4130726.18042131075742150245.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167768673411.4130726.18042131075742150245.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 01, 2023 at 08:05:34AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The protofile parser in mkfs does not check directory entry names when
> populating the filesystem.  The libxfs directory code doesn't check them
> either, since they depend on the Linux VFS to sanitize incoming names.
> If someone puts a slash in the first (name) column in the protofile,
> this results in a successful format and xfs_repair -n immediately
> complains.
> 
> Screen the names that are being read from the protofile.

Looks good
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/proto.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 68ecdbf3632..7e3fc1b8134 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -326,6 +326,12 @@ newdirent(
>  	int	error;
>  	int	rsv;
> 
> +	if (!libxfs_dir2_namecheck(name->name, name->len)) {
> +		fprintf(stderr, _("%.*s: invalid directory entry name\n"),
> +				name->len, name->name);
> +		exit(1);
> +	}
> +
>  	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
> 
>  	error = -libxfs_dir_createname(tp, pip, name, inum, rsv);
> 

-- 
Carlos Maiolino
