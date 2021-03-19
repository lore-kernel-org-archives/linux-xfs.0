Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349CDC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 18:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEAD46196F
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 18:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhCSSZc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 14:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhCSSZJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Mar 2021 14:25:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C8426196D;
        Fri, 19 Mar 2021 18:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616178309;
        bh=1s+wfjHK+UAofgQw4ucmrXlmryCggBQFMJM0P8Qas50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G6vXBmwrQC7R9so0pq3Lch2K5y8rEgVjHlsMLVbez8XDApg2yv60+LygylW10t+B+
         08z+pXJ2148ioflBoo/DIxETdsLSgVZNuqmQVXX8ZCZtPdtXZJYawoyqQs9fHEa0Q2
         UEPBW/n6E7vKhnrQ9WzfnI2hiZNno1nOH7905hntz/tdbM5aIUuTsE4qCnmNQ18EGn
         TMU2qEMJYkTIwAJHX10CQdFA+V12fZxE5xJXsk5GovYaoglusrfOf24qtvIEKXwkav
         d8nFo12rGvhjTyr9p0uqYQ8xFs+nUnZz6MW9Gt4xeL9qufGG5f3iRRIy8Y4W8dglMM
         i9rjSSwOlP/Xw==
Date:   Fri, 19 Mar 2021 11:25:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] xfs: Skip repetitive warnings about mount options
Message-ID: <20210319182508.GV22100@magnolia>
References: <20210319153251.476606-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319153251.476606-1-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 04:32:49PM +0100, Pavel Reichl wrote:
> Hello,
> 
> I belive that this patch set was missed in recent for-next branch update.
> 
> Patches are the same as before I just added the reviewed-by tags.

Yeah, I'll have time to start on xfs-5.13-merge next week.
Thanks for respinning this. :)

--D

> Thanks!
> 
> ...
> At least some version of mount will look in /proc/mounts and send in all of the 
> options that it finds as part of a remount command. We also /do/ still emit
> "attr2" in /proc/mounts (as we probably should), so remount passes that back
> in, and we emit a warning, which is not great.
> 
> In other words mount passes in "attr2" and the kernel emits a deprecation
> warning for attr2, even though the user/admin never explicitly asked for the
> option.
> 
> So, lets skip the warning if (we are remounting && deprecated option
> state is not changing).
> 
> I also attached test for xfstests that I used for testing (the test
> will be proposed on xfstests-list after/if this patch is merged).
> 
> V2 vs. V1
> 
> * Added new patch that renames mp to parsing_mp in xfs_fs_parse_param()
> * Added new function xfs_fs_warn_deprecated() to encapsulate the logic for displaying the deprecation warning.
> * Fixed some white space issues.
> 
> Pavel Reichl (2):
>   xfs: rename variable mp to parsing_mp
>   xfs: Skip repetitive warnings about mount options
> 
>  fs/xfs/xfs_super.c | 118 +++++++++++++++++++++++++--------------------
>  1 file changed, 67 insertions(+), 51 deletions(-)
> 
> -- 
> 2.30.2
> 
