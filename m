Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16C5C4727E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 21:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94E4420796
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 21:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgJAVW5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 17:22:57 -0400
Received: from sandeen.net ([63.231.237.45]:48116 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgJAVW5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Oct 2020 17:22:57 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1C027483504;
        Thu,  1 Oct 2020 16:22:07 -0500 (CDT)
To:     Ian Kent <raven@themaw.net>, xfs <linux-xfs@vger.kernel.org>
References: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
Message-ID: <974aaec3-17e4-ecc0-2220-f34ce19348c8@sandeen.net>
Date:   Thu, 1 Oct 2020 16:22:55 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/30/20 8:06 PM, Ian Kent wrote:
> Some of the xfsprogs utilities read the mount table via. getmntent(3).
> 
> The mount table may contain (almost always these days since /etc/mtab is
> symlinked to /proc/self/mounts) autofs mount entries. During processing
> of the mount table entries statfs(2) can be called on mount point paths
> which will trigger an automount if those entries are direct or offset
> autofs mount triggers (indirect autofs mounts aren't affected).
> 
> This can be a problem when there are a lot of autofs direct or offset
> mounts because real mounts will be triggered when statfs(2) is called.
> This can be particularly bad if the triggered mounts are NFS mounts and
> the server is unavailable leading to lengthy boot times or worse.
> 
> Simply ignoring autofs mount entries during getmentent(3) traversals
> avoids the statfs() call that triggers these mounts. If there are
> automounted mounts (real mounts) at the time of reading the mount table
> these will still be seen in the list so they will be included if that
> actually matters to the reader.
> 
> Recent glibc getmntent(3) can ignore autofs mounts but that requires the
> autofs user to configure autofs to use the "ignore" pseudo mount option
> for autofs mounts. But this isn't yet the autofs default (to prevent
> unexpected side effects) so that can't be used.
> 
> The autofs direct and offset automount triggers are pseudo file system
> mounts and are more or less useless in terms on file system information
> so excluding them doesn't sacrifice useful file system information
> either.
> 
> Consequently excluding autofs mounts shouldn't have any adverse side
> effects.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fsr/xfs_fsr.c   |    3 +++
>  libfrog/linux.c |    2 ++
>  libfrog/paths.c |    2 ++
>  3 files changed, 7 insertions(+)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 77a10a1d..466ad9e4 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -323,6 +323,9 @@ initallfs(char *mtab)
>  	while ((mnt = platform_mntent_next(&cursor)) != NULL) {
>  		int rw = 0;
>  
> +		if (!strcmp(mnt->mnt_type, "autofs"))
> +			continue;
> +
>  		if (strcmp(mnt->mnt_type, MNTTYPE_XFS ) != 0 ||
>  		    stat(mnt->mnt_fsname, &sb) == -1 ||
>  		    !S_ISBLK(sb.st_mode))
>			continue;

Forgive me if I'm missing something obvious but isn't this added check redundant?

If mnt_type == "autofs" then mnt_type != MNTTYPE_XFS and we're ignoring it
already in this loop, no?  In this case, the loop is for xfs_fsr so we are really
only ever going to be looking for xfs mounts, as opposed to fs_table_initialise_mounts
which may accept "foreign" (non-xfs) filesystems.

> diff --git a/libfrog/linux.c b/libfrog/linux.c
> index 40a839d1..a45d99ab 100644
> --- a/libfrog/linux.c
> +++ b/libfrog/linux.c
> @@ -73,6 +73,8 @@ platform_check_mount(char *name, char *block, struct stat *s, int flags)
>  	 * servers.  So first, a simple check: does the "dev" start with "/" ?
>  	 */
>  	while ((mnt = getmntent(f)) != NULL) {
> +		if (!strcmp(mnt->mnt_type, "autofs"))
> +			continue;
>  		if (mnt->mnt_fsname[0] != '/')
>  			continue;

Same sort of question here, but I don't know what these autofs entries look like.
Can their "device" (mnt_fsname) begin with "/" ?

Backing up a bit, which xfsprogs utility saw this behavior with autofs mounts?

I'm mostly ok with just always and forever filtering out anything that matches
"autofs" but if it's unnecessary (like the first case I think?) it may lead
to confusion for future code readers.

Thanks,
-Eric

>  		if (stat(mnt->mnt_dir, &mst) < 0)
> diff --git a/libfrog/paths.c b/libfrog/paths.c
> index 32737223..d6793764 100644
> --- a/libfrog/paths.c
> +++ b/libfrog/paths.c
> @@ -389,6 +389,8 @@ fs_table_initialise_mounts(
>  			return errno;
>  
>  	while ((mnt = getmntent(mtp)) != NULL) {
> +		if (!strcmp(mnt->mnt_type, "autofs"))
> +			continue;
>  		if (!realpath(mnt->mnt_dir, rmnt_dir))
>  			continue;
>  		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
> 
> 
