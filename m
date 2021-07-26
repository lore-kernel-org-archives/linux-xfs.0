Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70644C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FC3E60F9C
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbhGZQjV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 12:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235707AbhGZQis (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 12:38:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7860C60F5E;
        Mon, 26 Jul 2021 17:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627319956;
        bh=uUyR9iz9/c5xWWOoDXwaUyGkBDLXSd+6og/z386DWxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AC/uc7/i1wdPw4QOdtYaEtWeHG5OjN46jEp6QFJIcUvHOKy4Ec5dzsudSGpJT309j
         o4iFIx8xQm+eh2XCVXHC6yDtEeFfgAGeaOwgidIEN6VH/IwpYPfTAgCM3YLCPgikG2
         XyQk/5+e+3MYxDZvokSgbVihe8cFoE9P+KXvRnRC15hMpjl1oK6+wRvKS9AO9QlxpL
         iKcOSDWlb5aOImVAS5CsWntUZ9q9kK1k9nOcGsWpG6S6u738fda9VxLJMCL/WiSS7J
         GF1a/9c+zWb0NvJXv01tJmQc/e2+GctPFdLkLr0emBmet6iU9wArXjIa3wc60Io+ZC
         /w6TlcRJN5Dvw==
Date:   Mon, 26 Jul 2021 10:19:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/530: Bail out if either of reflink or rmapbt is
 enabled
Message-ID: <20210726171916.GV559212@magnolia>
References: <20210726064313.19153-1-chandanrlinux@gmail.com>
 <20210726064313.19153-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726064313.19153-3-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 12:13:13PM +0530, Chandan Babu R wrote:
> _scratch_do_mkfs constructs a mkfs command line by concatenating the values of
> 1. $mkfs_cmd
> 2. $MKFS_OPTIONS
> 3. $extra_mkfs_options
> 
> The corresponding mkfs command line fails if $MKFS_OPTIONS enables either
> reflink or rmapbt feature. The failure occurs because the test tries to create
> a filesystem with realtime device enabled. In such a case, _scratch_do_mkfs()
> will construct and invoke an mkfs command line without including the value of
> $MKFS_OPTIONS.
> 
> To prevent such silent failures, this commit causes the test to exit if it
> detects either reflink or rmapbt feature being enabled.

Er, what combinations of mkfs.xfs and MKFS_OPTIONS cause this result?
What kind of fs configuration comes out of that?

Eventually, the plan is to support rmap[1] and reflink[2] on the
realtime device, at which point this will have to be torn out and a
better solution found.

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap
[2] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink

> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/530 | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tests/xfs/530 b/tests/xfs/530
> index 16dc426c..669b061d 100755
> --- a/tests/xfs/530
> +++ b/tests/xfs/530
> @@ -39,6 +39,12 @@ _require_scratch_nocheck
>  echo "* Test extending rt inodes"
>  
>  _scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> +
> +_xfs_is_reflink_enabled $SCRATCH_DEV && \
> +	_notrun "Realtime device cannot be used when reflink feature is enabled"
> +_xfs_is_rmapbt_enabled $SCRATCH_DEV && \
> +	_notrun "Realtime device cannot be used when rmapbt feature is enabled"
> +
>  . $tmp.mkfs
>  
>  echo "Create fake rt volume"
> -- 
> 2.30.2
> 
