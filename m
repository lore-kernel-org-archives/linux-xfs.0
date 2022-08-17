Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A27C28B2B
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 17:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239344AbiHQRWM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Aug 2022 13:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240374AbiHQRWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Aug 2022 13:22:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095379F1B4
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 10:22:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A415D611F1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 17:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0936BC433C1;
        Wed, 17 Aug 2022 17:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660756926;
        bh=upmNHzrPBXooPjgRjVbP5rtn12jBmUpAf750cmD/GJk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kAqxulDspXTCcpryMplH0d+PwkwSkoZAO8nJF3KJJ1gA/jXym5Ltso1pTDOytktvo
         12lJtSBIuE9omQFPDC/rgAqermqGFVs9/Ybhz5hdR3Sis82uNCTOKqC1GZ6xbcDlOu
         +AJBmwlMJTc586QJrJi5EQgC+0IyUwW6h5cgvz7XJzUIPnsB+siIs/xyhGVi6NcMpv
         +gtzZ3xS/kAmYiyoqOJBnH5xNlNDfTIp1BgGZz9LfnO9NM5wnWVxeH7i1TRYby3OUO
         +g1vIc9Nhm3RwLz0ncBGAwJ7rq/Mw8dYOe6J2h7M22C+b3pLYN/jMKtAEo4p4IYelV
         i9xNaatk54eFw==
Date:   Wed, 17 Aug 2022 10:22:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Xiaole He <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, hexiaole <hexiaole@kylinos.cn>
Subject: Re: Re: [PATCH v2] libxfs: fix inode reservation space for removing
 transaction
Message-ID: <Yv0jvckQV7EcE1Mt@magnolia>
References: <20220815025458.137-1-hexiaole1994@126.com>
 <Yvu2fcKnPkhlxq5v@magnolia>
 <afd9ebb.1f54.182aa83c998.Coremail.hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afd9ebb.1f54.182aa83c998.Coremail.hexiaole1994@126.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 17, 2022 at 02:35:39PM +0800, Xiaole He wrote:
> Yes, Darrick, I already see the patch been merged into the kernel
> source 'xfs-linux', thanks, but not see it in the userspace utilities
> source 'xfsprogs-dev', so I resend this patch again for the userspace
> utilities source 'xfsprogs-dev'.
>
> Is this action of resend neccesary? Sorry I do not know what is
> workflow of the 'libxfs' between the kernel source 'xfs-linux' and the
> userspace utilities souce 'xfsprogs-dev', is the patch of 'libxfs'
> will be merged into userspace utilities source 'xfsprogs-dev'
> automatically because it had been merged into the kernel source
> 'xfs-linux'? If so, I'm sorry for bother you and please ignore this
> mail.

Ah, sorry, I missed that.  The xfsprogs maintainer automatically pulls
kernel libxfs changes into xfsprogs before the (xfsprogs) 6.0.0-rc1
release.  It isn't usually necessary to submit a straight port, unless
you've tried porting it to userspace yourself and discovered that there
are other non-trivial changes needed.

--D

> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> At 2022-08-16 23:23:41, "Darrick J. Wong" <djwong@kernel.org> wrote:
> >On Mon, Aug 15, 2022 at 10:54:58AM +0800, Xiaole He wrote:
> >> From: hexiaole <hexiaole@kylinos.cn>
> >> 
> >> In 'libxfs/xfs_trans_resv.c', the comment for transaction of removing a
> >> directory entry mentions that there has 2 inode size of space to be
> >> reserverd, but the actual code only count for 1 inode size:
> >
> >Already merged, see 6.0-rc1.
> >
> >--D
> >
> >> 
> >> /* libxfs/xfs_trans_resv.c begin */
> >> /*
> >>  * For removing a directory entry we can modify:
> >>  *    the parent directory inode: inode size
> >>  *    the removed inode: inode size
> >> ...
> >> xfs_calc_remove_reservation(
> >>         struct xfs_mount        *mp)
> >> {
> >>         return XFS_DQUOT_LOGRES(mp) +
> >>                 xfs_calc_iunlink_add_reservation(mp) +
> >>                 max((xfs_calc_inode_res(mp, 1) +
> >> ...
> >> /* libxfs/xfs_trans_resv.c end */
> >> 
> >> Here only count for 1 inode size to be reserved in
> >> 'xfs_calc_inode_res(mp, 1)', rather than 2.
> >> 
> >> Signed-off-by: hexiaole <hexiaole@kylinos.cn>
> >> ---
> >> V1 -> V2: djwong: remove redundant code citations
> >> 
> >>  libxfs/xfs_trans_resv.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
> >> index d4a9f69e..797176d7 100644
> >> --- a/libxfs/xfs_trans_resv.c
> >> +++ b/libxfs/xfs_trans_resv.c
> >> @@ -514,7 +514,7 @@ xfs_calc_remove_reservation(
> >>  {
> >>  	return XFS_DQUOT_LOGRES(mp) +
> >>  		xfs_calc_iunlink_add_reservation(mp) +
> >> -		max((xfs_calc_inode_res(mp, 1) +
> >> +		max((xfs_calc_inode_res(mp, 2) +
> >>  		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
> >>  				      XFS_FSB_TO_B(mp, 1))),
> >>  		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
> >> -- 
> >> 2.27.0
> >> 
