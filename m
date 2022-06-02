Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466F9C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 10:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbiFBKRq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 06:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiFBKRp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 06:17:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B500813F40;
        Thu,  2 Jun 2022 03:17:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BBE97CE1FB0;
        Thu,  2 Jun 2022 10:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C08C385A5;
        Thu,  2 Jun 2022 10:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654165061;
        bh=e0B+Pv+fJ50aJwinl0I363bNkYhFiY8LrY3tt2aM96Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XSo+D4TvwX4Z4FFgmeRzkmnzKV8SzFgHGUCVVV2xE1QrgmFXVPBVqhKNkrTYwsyTG
         h3P0jNIKeeKCjOJrQw9oS58S8BPn1INejjKGmPscA5++j6z10BHzZbli/jRmTd330q
         22s26IOheGJRdjxJcbJX+IYtjostTsHEOl6bd2ea8KcH6CJlO3Nj06usO71xlzfTgq
         Q+fpX9HW+ocWBmoX1bufQvwk6o2Xz+yA1IuHWLFYFK4+ktxp/XW+1FUdRYh2auFtog
         ELn+ZSw3bMtFUkWUjEY7eKPi47im1oaJlBhm4s1PE5IvLcYl4etLDuKW1LKfzZhidM
         qQVv4YpFSrHTA==
Date:   Thu, 2 Jun 2022 12:17:36 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 5.10 CANDIDATE 1/8] xfs: fix up non-directory creation in
 SGID directories
Message-ID: <20220602101736.lrxg2vp4tf6ph2kh@wittgenstein>
References: <20220601104547.260949-1-amir73il@gmail.com>
 <20220601104547.260949-2-amir73il@gmail.com>
 <20220602005238.GK227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220602005238.GK227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 02, 2022 at 10:52:38AM +1000, Dave Chinner wrote:
> On Wed, Jun 01, 2022 at 01:45:40PM +0300, Amir Goldstein wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.
> > 
> > XFS always inherits the SGID bit if it is set on the parent inode, while
> > the generic inode_init_owner does not do this in a few cases where it can
> > create a possible security problem, see commit 0fa3ecd87848
> > ("Fix up non-directory creation in SGID directories") for details.
> 
> inode_init_owner() introduces a bunch more SGID problems because
> it strips the SGID bit from the mode passed to it, but all the code
> outside it still sees the SGID bit set. IIRC, that means we do the
> wrong thing when ACLs are present. IIRC, there's an LTP test for
> this CVE now, and it also has a variant which uses ACLs and that
> fails too....
> 
> I'm kinda wary about mentioning a security fix and then not
> backporting the entire set of fixes the CVE requires in the same
> patchset.  I have no idea what the status of the VFS level fixes
> that are needed to fix this properly - I thought they were done and
> reviewed, but they don't appear to be in 5.19 yet.

There were a few outstanding issues and we didn't receive a new
submission for them right before or during the merge window.

I'm at a conference this week but I'll get back to review the patches
and associated tests on Monday.

Christian
