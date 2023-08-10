Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB5CC0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Aug 2023 00:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjHJApl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 20:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjHJApk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 20:45:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FBCB9
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 17:45:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB1BF63C3C
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 00:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBB5C433C8;
        Thu, 10 Aug 2023 00:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691628339;
        bh=G7Lu39S8pKC73ziX15WUGFAYI95N0m0dPPX8/MSFkbY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/i1+PhMryXKrZWfZrDfmehMiFte2THKzarMap1hVeDdEkpj9FyW9grDz1siQjzQw
         e6BxuJd0tsmjVVZ85bsABgJGWvamcmPoymXnYiqSmc3buKjjBIOcC23kxpAFQXvwvT
         GjIprnHkoAq9gJhpJ9srCUqa4qzNrYbbUkHd6F79n14n47WkhjI/ACVPiJ7h4ngdv4
         pZzyBU+e0MZ+N8nTGEwT75IAb7J5LUmTPD34LvRQd/mzQn2uT16gsx6gVNlZuUh/ok
         vyCYkgS+dG13Eeu/xZdIRmiSOiyO4J0Poy8lwPlsvztU0J1KjcwMZtGh5byTgwHAau
         YcZGu6m2p8YeA==
Date:   Wed, 9 Aug 2023 17:45:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v26.0 0/6] xfs: online repair of inodes and forks
Message-ID: <20230810004538.GB11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
 <169049626432.922543.2560381879385116722.stgit@frogsfrogsfrogs>
 <ZNNf4gIZg7j3SMpg@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNNf4gIZg7j3SMpg@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 09, 2023 at 07:44:02PM +1000, Dave Chinner wrote:
> On Thu, Jul 27, 2023 at 03:21:08PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > In this series, online repair gains the ability to repair inode records.
> > To do this, we must repair the ondisk inode and fork information enough
> > to pass the iget verifiers and hence make the inode igettable again.
> > Once that's done, we can perform higher level repairs on the incore
> > inode.  The fstests counterpart of this patchset implements stress
> > testing of repair.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> 
> Most of this makes sense. I think the main thing I'd suggest is
> documenting the repair decisions being made and how things that get
> zapped are then rebuilt - it seems like there is a lot of dependency
> on running other parts of repair after zapping for things to be
> rebuilt, but it's not immediately clear how the bits are supposed to
> go together so a little bit of documentation for that would go a
> long way....

Ok.  The comment for inode_repair.c now reads:

/*
 * Inode Record Repair
 * ===================
 *
 * Roughly speaking, inode problems can be classified based on whether
 * or not they trip the dinode verifiers.  If those trip, then we won't
 * be able to xfs_iget ourselves the inode.
 *
 * Therefore, the xrep_dinode_* functions fix anything that will cause
 * the inode buffer verifier or the dinode verifier.  The xrep_inode_*
 * functions fix things on live incore inodes.  The inode repair
 * functions make decisions with security and usability implications
 * when reviving a file:
 *
 * - Files with zero di_mode or a garbage di_mode are converted to a
 * file that only root can read.  If the immediate data fork area or
 * block 0 of the data fork look like a directory, the file type will be
 * set to a directory.  If the immediate data fork area has no nulls, it
 * will be turned into a symbolic link.  Otherwise, it is turned into a
 * regular file.  This file may not actually contain user data, if the
 * file was not previously a regular file.  Setuid and setgid bits are
 * cleared.
 *
 * - Zero-size directories can be truncated to look empty.  It is
 * necessary to run the bmapbtd and directory repair functions to fully
 * rebuild the directory.
 *
 * - Zero-size symbolic link targets can be truncated to '.'.  It is
 * necessary to run the bmapbtd and symlink repair functions to salvage
 * the symlink.
 *
 * - Invalid extent size hints will be removed.
 *
 * - Quotacheck will be scheduled if we repaired an inode that was so
 * badly damaged that the ondisk inode had to be rebuilt.
 *
 * - Invalid user, group, or project IDs (aka -1U) will be reset to
 * zero.  Setuid and setgid bits are cleared.
 *
 * - Data and attr forks are reset to extents format with zero extents
 * if the fork data is inconsistent.  It is necessary to run the bmapbtd
 * or bmapbta repair functions to recover the space mapping.
 *
 * - ACLs will not be recovered if the attr fork is zapped or the
 * extended attribute structure itself requires salvaging.
 *
 * - If the attr fork is zapped, the user and group ids are reset to
 * root and the setuid and setgid bits are removed.
 */

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
