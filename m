Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B942C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 13:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11E6A20835
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 13:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfIZN1f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 09:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbfIZN1f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 09:27:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F07F30860DE;
        Thu, 26 Sep 2019 13:27:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D06D23D8E;
        Thu, 26 Sep 2019 13:27:34 +0000 (UTC)
Date:   Thu, 26 Sep 2019 09:27:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Max Reitz <mreitz@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: xfs_alloc_file_space() rounds len independently of offset
Message-ID: <20190926132733.GE26832@bfoster>
References: <6d62fb2a-a4e6-3094-c1bf-0ca5569b244c@redhat.com>
 <20190926125928.GC26832@bfoster>
 <3e2c1587-4f8d-0425-bb76-70d4325bdf90@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e2c1587-4f8d-0425-bb76-70d4325bdf90@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 26 Sep 2019 13:27:35 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 03:16:47PM +0200, Max Reitz wrote:
> On 26.09.19 14:59, Brian Foster wrote:
> > On Thu, Sep 26, 2019 at 12:57:49PM +0200, Max Reitz wrote:
> >> Hi,
> >>
> >> I’ve noticed that fallocating some range on XFS sometimes does not
> >> include the last block covered by the range, when the start offset is
> >> unaligned.
> >>
> >> (Tested on 5.3.0-gf41def397.)
> >>
> >> This happens whenever ceil((offset + len) / block_size) - floor(offset /
> >> block_size) > ceil(len / block_size), for example:
> >>
> >> Let block_size be 4096.  Then (on XFS):
> >>
> >> $ fallocate -o 2048 -l 4096 foo   # Range [2048, 6144)
> >> $ xfs_bmap foo
> >> foo:
> >>         0: [0..7]: 80..87
> >>         1: [8..15]: hole
> >>
> >> There should not be a hole there.  Both of the first two blocks should
> >> be allocated.  XFS will do that if I just let the range start one byte
> >> sooner and increase the length by one byte:
> >>
> >> $ rm -f foo
> >> $ fallocate -o 2047 -l 4097 foo   # Range [2047, 6144)
> >> $ xfs_bmap foo
> >> foo:
> >>         0: [0..15]: 88..103
> >>
> >>
> >> (See [1] for a more extensive reasoning why this is a bug.)
> >>
> >>
> >> The problem is (as far as I can see) that xfs_alloc_file_space() rounds
> >> count (which equals len) independently of the offset.  So in the
> >> examples above, 4096 is rounded to one block and 4097 is rounded to two;
> >> even though the first example actually touches two blocks because of the
> >> misaligned offset.
> >>
> >> Therefore, this should fix the problem (and does fix it for me):
> >>
> >> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> >> index 0910cb75b..4f4437030 100644
> >> --- a/fs/xfs/xfs_bmap_util.c
> >> +++ b/fs/xfs/xfs_bmap_util.c
> >> @@ -864,6 +864,7 @@ xfs_alloc_file_space(
> >>  	xfs_filblks_t		allocatesize_fsb;
> >>  	xfs_extlen_t		extsz, temp;
> >>  	xfs_fileoff_t		startoffset_fsb;
> >> +	xfs_fileoff_t		endoffset_fsb;
> >>  	int			nimaps;
> >>  	int			quota_flag;
> >>  	int			rt;
> >> @@ -891,7 +892,8 @@ xfs_alloc_file_space(
> >>  	imapp = &imaps[0];
> >>  	nimaps = 1;
> >>  	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
> >> -	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
> >> +	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
> >> +	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
> >>
> >>  	/*
> >>  	 * Allocate file space until done or until there is an error
> >>
> > 
> > That looks like a reasonable fix to me and it's in the spirit of how
> > xfs_free_file_space() works as well (outside of the obvious difference
> > in how unaligned boundary blocks are handled). Care to send a proper
> > patch?
> 
> I’ve never sent a kernel patch before, but I’ll give it a go.
> 

Heh.. well you've already done the hard part. ;) If you already have a
local commit in a git tree, just write up a proper commit log based on
what you've described above (no need to include the "proof," I think),
make sure there's a Signed-off-by: tag and 'git format-patch ..' / 'git
send-email' to the list.

If you want to be sure everything is formatted correctly, it can be
useful to mail the patch to yourself and verify that you can save it and
apply it locally to a clean branch before sending to the list.

Brian

> Max
> 



