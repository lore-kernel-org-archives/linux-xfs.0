Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA56BC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50F916529E
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhCIFEJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:04:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhCIFDo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Mar 2021 00:03:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7919F65199;
        Tue,  9 Mar 2021 05:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615266224;
        bh=sSvr1eK3+qtc0AtpOlcymaTi8kiGWtBkPg2h3crxzk8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nwV2ybnm0A8SKX7lnkFxCzwgCF7gSqPtPdW48gDv5lKFoi3oOaFxZKNfC+Qa7G86W
         7e3YT4N+u6GjTITOjjjoVxPPYn5y7iyR4S9/D+qYsRQHT6D1wjmVGaBVZZ0riETgqh
         EEebuStD0aBhiV+HukrNpVb0TH1q1M5IAlO02Je+igXUprvZd3OURFlok32pMhmzQM
         yhdMo+CrTqKPw8HJWf+oH+/sSPnODo14LkN5Xoi7ojsPkKLD5wXU5gVPGIxZSej7u5
         bBQhO2q0zKUf0uo2MLVFiQNqAcjCpiJjA+XpLQfNTvpIqgAPg/ydoqiyde57ezc08Q
         ShM2LYuA9ZaAA==
Date:   Mon, 8 Mar 2021 21:03:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 01/13] _check_xfs_filesystem: sync fs before running
 scrub
Message-ID: <20210309050343.GZ7269@magnolia>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309050124.23797-2-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 10:31:12AM +0530, Chandan Babu R wrote:
> Tests can create a scenario in which a call to syncfs() issued at the end of
> the execution of the test script would return an error code. xfs_scrub
> internally calls syncfs() before starting the actual online consistency check
> operation. Since this call to syncfs() fails, xfs_scrub ends up returning
> without performing consistency checks on the test filesystem. This can mask a
> possible on-disk data structure corruption.
> 
> To fix the above stated problem, this commit invokes syncfs() prior to
> executing xfs_scrub.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/xfs | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 2156749d..41dd8676 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -467,6 +467,17 @@ _check_xfs_filesystem()
>  	# Run online scrub if we can.
>  	mntpt="$(_is_dev_mounted $device)"
>  	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
> +		# Tests can create a scenario in which a call to syncfs() issued
> +		# at the end of the execution of the test script would return an
> +		# error code. xfs_scrub internally calls syncfs() before
> +		# starting the actual online consistency check operation. Since
> +		# such a call to syncfs() fails, xfs_scrub ends up returning
> +		# without performing consistency checks on the test
> +		# filesystem. This can mask a possible on-disk data structure
> +		# corruption. Hence consume such a possible syncfs() failure
> +		# before executing a scrub operation.
> +		$XFS_IO_PROG -c syncfs $mntpt >> $seqres.full 2>&1
> +
>  		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $mntpt > $tmp.scrub 2>&1
>  		if [ $? -ne 0 ]; then
>  			_log_err "_check_xfs_filesystem: filesystem on $device failed scrub"
> -- 
> 2.29.2
> 
