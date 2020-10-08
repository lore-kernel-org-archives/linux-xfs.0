Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC213C433E7
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 01:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 740772085B
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 01:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgJHByt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 21:54:49 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36735 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbgJHByt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 21:54:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 87FF65C0062;
        Wed,  7 Oct 2020 21:54:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 07 Oct 2020 21:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        km3qdFcRJYPdJKQDg+loghRSy27t64TYjdhRxiYpoMs=; b=Pjwr2HMD+1pAgCQy
        V6E5DFVxl5V/Qo1HXAnoH5hc2/hcfoOM+Q4oFoG+guFOpmtspDUwIBMK/IhKxFik
        jiUL7bVF8AHFOBOGPbi24GSw/V7LNSg+V6TShSZdz3VWvt6LpkQtTuHNx/R/h6/B
        Oqnp7tBzfA1X7rBm+YiV8hv70UwToE9CUwWesK3b+LJAOSOroqzBqg8XojdP/PS6
        z8q/Ls0C0Uz7ky6c2MYu0gTjM3ZeX7gEda1AolNh8Tq4rs4t3mKAfIw06tzMI6ne
        2J7UJFBiatSQM6KMzE/3hmJRE17sCFR+Wm2bXREEeEUocPK5x0E92stFWpGJj1Y1
        06r7GQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=km3qdFcRJYPdJKQDg+loghRSy27t64TYjdhRxiYpo
        Ms=; b=IXGfEqxlRzHRqaaUu2TNAQvxn/nPYwDle4coph9x3JmzB89lSzNRLHH0X
        kzrvad+BCVZtr/2dJC17d8vnTm0DsUkfgS2+/Kg7uryfqCk31TM/WbV+WoiHLGkr
        PtiHV96oRSBshroW327tdeVWG94PpVFJif3m4Qtuz3BoVl2BTDPFpNrdTLpT1RZs
        lQGeVrXBxYoiC08jjtEYXCKCw3VCEPDDkXpbLxIe9bKDIe8aBdn6pX3Pmxwp/RGq
        nnu/rFI3pExkYLqKoXGoITl1IXSa/239kAtIPNw+wDG5+AISR7O2z39swlv7K9OV
        xlfsCs6qAE6EMEzvY4YuTVt2k7vaA==
X-ME-Sender: <xms:aHF-X-TD9auHflcbjcUvdsyjBEviFOh-UBUWPer54HRGeh7gDuORhA>
    <xme:aHF-XzxcyZtWx1l41zY5kJGqhpYQbli6FrwGxWjcS8_9IxpdCLEUYJbWt73HHNUkU
    JstgiZ2LxvS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgeejgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuggftrfgrthhtvghrnhepfe
    efteetvdeguddvveefveeftedtffduudehueeihfeuvefgveehffeludeggfejnecukfhp
    pedutdeirdeiledrvddvhedrudefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvth
X-ME-Proxy: <xmx:aHF-X72FSkTXQ_syoNctD7cL8wdCTEnHqNTPk94F8wjxL1ZLRCybIw>
    <xmx:aHF-X6ArAn1SZtTK77tqSCZbfLZQ7s_uD_Smzh8ZyNxwIYi3BqHRAQ>
    <xmx:aHF-X3gX4mAe0aRwI3auuX8f5DrOqp7CSmxUfuNxpqglXizjJgumrQ>
    <xmx:aHF-XytHnUcfCzwMreB5FY_G-QzgNpCpw88I1-k4FrPseNS5Sr3s0w>
Received: from mickey.themaw.net (106-69-225-138.dyn.iinet.net.au [106.69.225.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id 17351328005A;
        Wed,  7 Oct 2020 21:54:46 -0400 (EDT)
Message-ID: <f7bf474dd31f10ddda77ca6cb076a9f888ed5d37.camel@themaw.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
From:   Ian Kent <raven@themaw.net>
To:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>
Date:   Thu, 08 Oct 2020 09:54:43 +0800
In-Reply-To: <160212194125.16851.17467120219710843339.stgit@mickey.themaw.net>
References: <160212194125.16851.17467120219710843339.stgit@mickey.themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Oops!

Didn't add v2 to [PATCH] in the title, sorry about that.

On Thu, 2020-10-08 at 09:52 +0800, Ian Kent wrote:
> Some of the xfsprogs utilities read the mount table via.
> getmntent(3).
> 
> The mount table may contain (almost always these days since /etc/mtab
> is
> symlinked to /proc/self/mounts) autofs mount entries. During
> processing
> of the mount table entries statfs(2) can be called on mount point
> paths
> which will trigger an automount if those entries are direct or offset
> autofs mount triggers (indirect autofs mounts aren't affected).
> 
> This can be a problem when there are a lot of autofs direct or offset
> mounts because real mounts will be triggered when statfs(2) is
> called.
> This can be particularly bad if the triggered mounts are NFS mounts
> and
> the server is unavailable leading to lengthy boot times or worse.
> 
> Simply ignoring autofs mount entries during getmentent(3) traversals
> avoids the statfs() call that triggers these mounts. If there are
> automounted mounts (real mounts) at the time of reading the mount
> table
> these will still be seen in the list so they will be included if that
> actually matters to the reader.
> 
> Recent glibc getmntent(3) can ignore autofs mounts but that requires
> the
> autofs user to configure autofs to use the "ignore" pseudo mount
> option
> for autofs mounts. But this isn't yet the autofs default (to prevent
> unexpected side effects) so that can't be used.
> 
> The autofs direct and offset automount triggers are pseudo file
> system
> mounts and are more or less useless in terms on file system
> information
> so excluding them doesn't sacrifice useful file system information
> either.
> 
> Consequently excluding autofs mounts shouldn't have any adverse side
> effects.
> 
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
> @@ -73,6 +73,8 @@ platform_check_mount(char *name, char *block,
> struct stat *s, int flags)
>  	 * servers.  So first, a simple check: does the "dev" start
> with "/" ?
>  	 */
>  	while ((mnt = getmntent(f)) != NULL) {
> +		if (!strcmp(mnt->mnt_type, "autofs"))
> +			continue;
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

