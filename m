Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB84BC2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 12:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B792424684
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 12:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgAVMiw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 07:38:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:45054 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgAVMiw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Jan 2020 07:38:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 316C0B24F;
        Wed, 22 Jan 2020 12:38:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 35F8EDA738; Wed, 22 Jan 2020 13:38:34 +0100 (CET)
Date:   Wed, 22 Jan 2020 13:38:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Filipe Manana <fdmanana@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] fs: allow deduplication of eof block into the end of
 the destination file
Message-ID: <20200122123833.GZ3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Filipe Manana <fdmanana@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <20191216182656.15624-1-fdmanana@kernel.org>
 <20191216182656.15624-2-fdmanana@kernel.org>
 <CAL3q7H5+CMRkJ9yAa2AeB0aKtA=b_yW2g9JSQwCOhOtLNrH1iQ@mail.gmail.com>
 <20200107175739.GC472651@magnolia>
 <CAL3q7H5TuaLDW3aXSa68pxvLu4s1Gg38RRSRyA430LxK302k3A@mail.gmail.com>
 <20200108161536.GC5552@magnolia>
 <CAL3q7H7jOD6eEurdEb-VHn3_xcZVnYEJxnaomgUHtFcH5XowHw@mail.gmail.com>
 <20200109191201.GC8247@magnolia>
 <CAL3q7H79W2b2P5snLxsoAy=iAPByiKu1dDEt0=Np2RHUXhfafQ@mail.gmail.com>
 <20200122003532.GR8257@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122003532.GR8257@magnolia>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 04:35:32PM -0800, Darrick J. Wong wrote:
> Urk, I never reviewed this, did I...
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, so with this we can proceed with merging, the question is how.
This is in generic fs/ code but not plain VFS and affecting only btrfs
and xfs. I suggest the following:

I'll take the patches to a branch separate from other btrfs patches, add
rev-by and stable tags and send an extra pull request to Linus.

Before that the branch can spend some time in btrfs' for-next among
other topic branches so there's linux-next exposure.

I don't mean to sidestep VFS maintainers, but previous remap changes
don't have Al Viro's signed-off either, so I hope that when at least
Darrick is fine with the proposed way then let's do it. If not, please
let me know.
