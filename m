Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB01DC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 02:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiADCfA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jan 2022 21:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiADCfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jan 2022 21:35:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F058FC061761
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jan 2022 18:34:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA6BEB80259
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 02:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4C4C36AEE;
        Tue,  4 Jan 2022 02:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641263697;
        bh=a5Ko9CFArhHgFvaF/DazCOjWsBD54sI8wkYTJLoieIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z19HPvQjrTsRGYgFtnmCkVZkafwqUqeb3M3/bijuu/g0qalzZeJjAHbwaEKPcQvK6
         ZykMAaw9ZOPLS8JBq9zFwgg8ENsMRBRDg2vDHgQ1WfNk9ou3ASx+Qn/lyNjawZECeG
         8IqfGfqh6rRqlc7qkqmmAdEf3tRDo1a5NCeVTiDbJAWOvfjr4WX3xXmcHEBpHRuQXI
         G3BBdOIeL40QLGyUzcmlTBHheqMgTOfQA/QW327KRjx256i3LnMai4rVopnpfoSsJQ
         BUUtI2qsK7U2Obv+/LIFc2L0pV7UHkoFznu0ZU1CeLtZzfzoo/VEA/R+cpWqXVoB+b
         3rwQNO0+e/4CA==
Date:   Mon, 3 Jan 2022 18:34:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: The question of Q_XQUOTARM ioctl
Message-ID: <20220104023456.GE31606@magnolia>
References: <616F9367.3030801@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <616F9367.3030801@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 20, 2021 at 03:56:10AM +0000, xuyang2018.jy@fujitsu.com wrote:
> Hi Darrick
> 
> Sorry for bothering you again.

No problem.  Sorry I lost this email for 2+ months. :(

> After Christoph Hellwig kernel patch("xfs: remove support for disabling
> quota accounting on a mounted file system"), we can't disable quota
> account feature on a mounted file system.
> 
> It causes Q_XQUOTARM ioctl doesn't work well because this ioctl needs
> quota accouting feature is off and it also needs super block has quota
> feature[1].
> 
> For quotactl man-pages about Q_XQUOTARM ioctl, it said "Free the disk
> space taken by disk quotas". I guess it free u/g/p inode.

Yes, that's what it's supposed to do.

> If we do normal mount with uquota feature and umount, then we should
> have free the inode(also changes in disk).
> 
> I don't know the right intention for Q_XQUOTARM now. Can you give me
> some advise? Or, we should remove Q_XQUOTARM ioctl and
> xfs_qm_scall_trunc_qfile code.

I think xfs_qm_scall_trunc_qfiles probably should be doing:

	if (xfs_has_quota(mp) || flags == 0 ||
	    (flags & ~XFS_QMOPT_QUOTALL)) {
		xfs_debug(...);
		return -EINVAL;
	}

Note the inversion in the has_quota test.  That would make it so that
you can truncate the quota files if quota is not on.

> If I understand wrong, please tell me.
> 
> ps: Christoph Hellwig kernel patch causes ltp quotactl07 fail, I found
> his patch by this case.
> 
> [1]https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/xfs_qm_syscalls.c#n108

Why doesn't xfs/220 fail on the remove command?

Oh, because we patched it to filter that out, even though that's the
wrong thing to do.  That test really ought to remount with noquota and
then run xfs_quota -c remove $SCRATCH_DEV

--D

> Best Regards
> Yang Xu
