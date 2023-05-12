Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B415C77B7C
	for <linux-xfs@archiver.kernel.org>; Fri, 12 May 2023 03:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239856AbjELDbt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 May 2023 23:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239854AbjELDbr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2023 23:31:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F406E3A89;
        Thu, 11 May 2023 20:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AA5464D31;
        Fri, 12 May 2023 03:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1622C433D2;
        Fri, 12 May 2023 03:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683862304;
        bh=Wt8bj1gx1yl/2KVCHzXkOyL2kLtDdJfEOII4dqPZazM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WMdABvNaDSQ2Mk29cg30TBdYKvbcpYeObP390r3ATspI3JLasovKH5IHeiuGv55vF
         n697fg7aLqS4m9ioymmtDzhHIgf0xt4hkwhC5L5nFXQrGdGc9cHDeH6/xFiutfj7pc
         ktY1SOmfQBNK/76OhtFeJgHdugaGqMLmHRoYnVyccTuOL2aemEmRfRB98K88gvcuni
         bBli58b9F3SbcSWImImDSRCNCQUVt04JL8+Ah1YI3nevsNR7JTtMbTYxzBO39ku6DX
         9WvUxsWHnz2Le/TdLQZXJtq8h4wEXe0AE27VAfz2NDwEWaAz/2KB6Cw2lD323bfdlW
         kJWgeBidkqPAw==
Date:   Thu, 11 May 2023 20:31:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "renlei1@chinatelecom.cn" <renlei1@chinatelecom.cn>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] xfs: xfs_nfs_get_inode support zero generation
Message-ID: <20230512033143.GM858815@frogsfrogsfrogs>
References: <1683800241-14488-1-git-send-email-renlei1@chinatelecom.cn>
 <20230511232206.GG858799@frogsfrogsfrogs>
 <20230512020009.GB3223426@dread.disaster.area>
 <2023051210532845432129@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023051210532845432129@chinatelecom.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 12, 2023 at 10:53:29AM +0800, renlei1@chinatelecom.cn wrote:
> Yup, gen is 0 for the inodes created by libxfs, such as rootino, rbmino, rsumino.
> but those inodes will never be freed, and gen will always zero.
> so I think bypass the verification if gen==0 is still valid.

I disagree.  Handles have long encoded inode and generation to prevent
users from unintentionally modifying a file when the inode number is
recycled as a result of an unlink/create cycle.

--D

> Regards,
> Lei
>  
> From: Dave Chinner
> Date: 2023-05-12 10:00
> To: Darrick J. Wong
> CC: renlei1; linux-xfs; linux-kernel
> Subject: Re: [PATCH] xfs: xfs_nfs_get_inode support zero generation
> On Thu, May 11, 2023 at 04:22:06PM -0700, Darrick J. Wong wrote:
> > On Thu, May 11, 2023 at 06:17:21PM +0800, renlei1@chinatelecom.cn wrote:
> > > From: Ren Lei <renlei1@chinatelecom.cn>
> > > 
> > > If generation is zero, bypass the verification of generation number
> > > to avoid stale file error. (Be consistent with other fs, such as
> > > ext4, fat, jfs, etc.)
> > 
> > What code is affected by the gen==0 handles being rejected?  Is there a
> > user program or test case where this is required?
>  
> A generation number of 0 is perfectly valid in XFS. We've been
> creating them in XFS filesystems since 1993 and never had a problem
> with filehandle verification. Indeed, every root inode in every XFS
> filesystem ever made will have a generation number of 0.
>  
> Yup, a random XFS filesystem recently made from a current xfsprogs:
>  
> # xfs_db /dev/vdc
> xfs_db> sb 0
> xfs_db> a rootino
> xfs_db> p core.gen
> core.gen = 0
> xfs_db> 
>  
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
>  
