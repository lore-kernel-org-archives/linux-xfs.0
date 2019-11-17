Return-Path: <SRS0=Bs8E=ZJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF6AC432C0
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Nov 2019 14:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC29E20718
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Nov 2019 14:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574000400;
	bh=pEX34XH2N4djAt2Brtgsng1QfYeQer2W/jIKcpN+Bkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=h7lVFxBl9e57R+zCSaZdh8umbNnzt5gYUvLP0s8HSUGKY/YnCN/BEo0/Ih08Jyhoc
	 l14KPRDaSob5bTsiOw4LXRNi9RxQI89uBf1/dH4eQETuqg9r33r3ifyNKXCK7/mwwm
	 j5oo7rjWkRwIF/l4uigt4k+bMgqoaPezAAHpbtzI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfKQOT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Nov 2019 09:19:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbfKQOTz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 17 Nov 2019 09:19:55 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AB8F20718;
        Sun, 17 Nov 2019 14:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574000395;
        bh=pEX34XH2N4djAt2Brtgsng1QfYeQer2W/jIKcpN+Bkc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GYhZpDa3kDgnoHyT7acegKOfE0xvbaMhohEPn/Zog+Bl4xkKZKiXKQXY5s7uqwh2p
         +gvYzIGVJ7xcXDXNGcE1cQ5Xva6KFdS7Ugbmmn+cH7JTJb8ckYNQ/MIHDcKkvppn6Z
         2lY7m9icUZIiu/BB66CYiPfYPF9YYoyCiAq7tdB4=
Date:   Sun, 17 Nov 2019 09:19:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 069/237] xfs: fix use-after-free race in
 xfs_buf_rele
Message-ID: <20191117141950.GF2261@sasha-vm>
References: <20191116154113.7417-1-sashal@kernel.org>
 <20191116154113.7417-69-sashal@kernel.org>
 <20191116215423.GG25427@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191116215423.GG25427@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 17, 2019 at 08:54:23AM +1100, Dave Chinner wrote:
>[cc linux-xfs@vger.kernel.org]
>
>Hi Sasha,
>
>Any reason these these autosel patches are not being cc'd to the XFS
>list for XFS maintainer visibility and review?

Interesting! It looks like the XFS entry in MAINTAINERS has duplicate
entries for the mailing list, once with the M: tag and once with the L:
tag, so when I run get_maintainer.pl I see:

$ scripts/get_maintainer.pl -f fs/xfs/
"Darrick J. Wong" <darrick.wong@oracle.com> (supporter:XFS FILESYSTEM)
linux-xfs@vger.kernel.org (supporter:XFS FILESYSTEM)
linux-kernel@vger.kernel.org (open list)

Which doesn't list an "open list" besides LKML.

I've fixed up my scripts to address that, sorry for missing it.

-- 
Thanks,
Sasha
