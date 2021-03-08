Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B20C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 17:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A748652AB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 17:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhCHRu5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 12:50:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhCHRuv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 12:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AD19652AC;
        Mon,  8 Mar 2021 17:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615225850;
        bh=m8XG6MwIvTCKI3P8BBTnFO4P3KGTQn2ZqjhTJOGU+UY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oM5ApqXw2Zo/iG34UvBtrASG4zOHgcGTuO+ld9UAKe7ql9J/v71FzI8d6B/QUg0Z2
         m/25L4HYG/M6xGgA29G2qXmuhql/6HXkGBfuPF8igrpyJwQpdWo46nGLELEEFZ1rfT
         5TaVd+9iDlHdJ5zhIwf4zfjLb2XlR45QLwwWQ2DFwzuVDT3e6wSMiXMnULQfi9GzW0
         67CBg0EQHwjthXRNRrCVBBUc2g+xLu17ConNagz3SlZn2v09TfPKQEF8OtHX0k6Zvq
         /2l8ueLVFVbBXda3CF8OpX4o+CkRJE4ZULTuI4054fhxbpNWpTPuEWlxaaMxvtooGi
         7MSgLuVVY+jxA==
Date:   Mon, 8 Mar 2021 09:50:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 01/13] _check_xfs_filesystem: sync fs before running
 scrub
Message-ID: <20210308175048.GO3419940@magnolia>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
 <20210308155111.53874-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308155111.53874-2-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 09:20:59PM +0530, Chandan Babu R wrote:
> Tests can create a scenario in which a call to syncfs() issued at the end of
> the execution of the test script would return an error code. xfs_scrub
> internally calls syncfs() before starting the actual online consistency check
> operation. Since this call to syncfs() fails, xfs_scrub ends up returning
> without performing consistency checks on the test filesystem. This can mask a
> possible on-disk data structure corruption.

This explanation for why we're calling syncfs before invoking scrub
ought to be captured in a comment preceeding the syncfs call.

--D

> To fix the above stated problem, this commit invokes syncfs() prior to
> executing xfs_scrub.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  common/xfs | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 2156749d..7ec89492 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -467,6 +467,7 @@ _check_xfs_filesystem()
>  	# Run online scrub if we can.
>  	mntpt="$(_is_dev_mounted $device)"
>  	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
> +		$XFS_IO_PROG -c syncfs $mntpt >> $seqres.full 2>&1
>  		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $mntpt > $tmp.scrub 2>&1
>  		if [ $? -ne 0 ]; then
>  			_log_err "_check_xfs_filesystem: filesystem on $device failed scrub"
> -- 
> 2.29.2
> 
