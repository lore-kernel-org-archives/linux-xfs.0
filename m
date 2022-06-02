Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BDFC43334
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 10:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbiFBKcK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 06:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbiFBKb7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 06:31:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD40CE5E9;
        Thu,  2 Jun 2022 03:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F10D3CE1FBF;
        Thu,  2 Jun 2022 10:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACBDC3411D;
        Thu,  2 Jun 2022 10:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654165914;
        bh=rdUh4pudkQTXkq1jdkFy/4Q5VmNwASbwsBGgir3cqmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sCN6nkNs4IvFSG29ACvKRZZDlFHTKw3AtdvRi+8PRCMrR5twdL9XcofQaMRuGOJVS
         jSzJZZ4XCBREiyUvvHZWwMa5/t2VQR/8M04rye5/lUZn7EOE0NRKtBw6qFrRxjmlK3
         fCvnnfNEA7pIkmu0rxoKCYCAJHaL18WBqGqIkcg+MJRPY2+5IbWTK8L5yPxo3Jx3MR
         e9o2U3ddkgfJjhUDV+i9jttRIu1tx1gXCDolla1CqkGlKkdIhA3ESTxNGMguqQquWR
         pJW1zBAmO9tSN7TYwEL2Tr7kbzFtS8jsscXwbSrX3Y39XJ8p847/sLJe/U8f7MdV91
         c2Iu7YbFHzOug==
Date:   Thu, 2 Jun 2022 12:31:49 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: Re: [PATCH 5.10 CANDIDATE 1/8] xfs: fix up non-directory creation in
 SGID directories
Message-ID: <20220602103149.gc6b5hzkense5nrs@wittgenstein>
References: <20220601104547.260949-1-amir73il@gmail.com>
 <20220601104547.260949-2-amir73il@gmail.com>
 <20220602005238.GK227878@dread.disaster.area>
 <CAOQ4uxjcumjxeWypahgYd9wLExLuipd9MTCc_8vfq6SFY7L4dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjcumjxeWypahgYd9wLExLuipd9MTCc_8vfq6SFY7L4dA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 02, 2022 at 07:13:56AM +0300, Amir Goldstein wrote:
> On Thu, Jun 2, 2022 at 3:52 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Wed, Jun 01, 2022 at 01:45:40PM +0300, Amir Goldstein wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > >
> > > commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.
> > >
> > > XFS always inherits the SGID bit if it is set on the parent inode, while
> > > the generic inode_init_owner does not do this in a few cases where it can
> > > create a possible security problem, see commit 0fa3ecd87848
> > > ("Fix up non-directory creation in SGID directories") for details.
> >
> > inode_init_owner() introduces a bunch more SGID problems because
> > it strips the SGID bit from the mode passed to it, but all the code
> > outside it still sees the SGID bit set. IIRC, that means we do the
> > wrong thing when ACLs are present. IIRC, there's an LTP test for
> > this CVE now, and it also has a variant which uses ACLs and that
> > fails too....
> 
> Good point.
> I think Christian's vfstests probably tests more cases than what LTP
> does at this point.

I think so, yes. There will also be more tests coming into fstests.

> 
> Christian, Yang,
> 
> It would be nice if you could annotate the relevant fstests with
> _fixed_by_kernel_commit, which will make it easier to find
> all relevant commits to backport when tests are failing on LTS
> kernel.
> 
> >
> > I'm kinda wary about mentioning a security fix and then not
> > backporting the entire set of fixes the CVE requires in the same
> > patchset.  I have no idea what the status of the VFS level fixes
> > that are needed to fix this properly - I thought they were done and
> > reviewed, but they don't appear to be in 5.19 yet.
> >
> 
> No, it looks like tihs is still in review.
> 
> Christoph, Cristian, Yang,
> 
> What do you think is best to do w.r.t this patch?
> 
> Wait for all the current known issues to be fixed in upstream and then
> backport all known fixes?
> 
> Backport whatever fixes are available in upstream now at the same
> backport series?
> 
> Take this now and the rest later?

Imho, backporting this patch is useful. It fixes a basic issue.
What Dave mentioned is that if ACLs/umask are in play things become
order dependent I've pointed out on the patch that aims to fix this: If
no ACLs are supported then umask is stripped in vfs and if they are it's
stripped in the fs. So if umask strips S_IXGRP in the vfs then no setgid
bit is inherited. If it's stripped in the fs post inode_init_owner()
setgid bit is tripped and thus not inherited.. The vfs patch unifies
this behavior.

Christian
