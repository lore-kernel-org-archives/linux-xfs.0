Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6BAC43467
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 20:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6CF022226
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 20:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgJHUDh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 16:03:37 -0400
Received: from sandeen.net ([63.231.237.45]:47186 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729877AbgJHUDh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Oct 2020 16:03:37 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D720F48C706;
        Thu,  8 Oct 2020 15:02:34 -0500 (CDT)
To:     Ian Kent <raven@themaw.net>, xfs <linux-xfs@vger.kernel.org>
References: <160212194125.16851.17467120219710843339.stgit@mickey.themaw.net>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
Message-ID: <c3e211d0-48d7-c26f-b64d-b730fe997c4b@sandeen.net>
Date:   Thu, 8 Oct 2020 15:03:35 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <160212194125.16851.17467120219710843339.stgit@mickey.themaw.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/7/20 8:52 PM, Ian Kent wrote:
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

(usually this'd go below the "---")

> Changes since v1:
> - drop hunk from fsr/xfs_fsr.c.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  libfrog/linux.c |    2 ++
>  libfrog/paths.c |    2 ++
>  2 files changed, 4 insertions(+)
> 
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

I may change the order of this test and the next, just so it continues to
align with the comment above.  Shouldn't make any difference, right?

Otherwise:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  		if (mnt->mnt_fsname[0] != '/')
>  			continue;
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
