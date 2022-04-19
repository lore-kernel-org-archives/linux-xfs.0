Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6D5C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 17:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239724AbiDSRVl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 13:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237020AbiDSRVi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 13:21:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FB235DEC;
        Tue, 19 Apr 2022 10:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31A89B816CA;
        Tue, 19 Apr 2022 17:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56E9C385A5;
        Tue, 19 Apr 2022 17:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650388733;
        bh=2KR42tLyCgBZ2hiGu2LTI+NSFF8h/Pce02MbR1QrFjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mKyzInPQTyf6NxhXY6Rddlgs1mNN1bNYP33yfNKKpcyUa5wghYBcu6Tf6zihxUzzv
         To1EgIBN2aaXh23canDS6Cw5iPtSu1MKceHW1wC3oxw80L//wA3Z/WYlFUtzDsqvEr
         paCJPYADduyk5OO4WC1327PJMtooqstDN3bos5l2SfZS1WChtsSAOqCksP6hYMtco3
         EpJ3RbfXnAhRLFsxEovOi4XS0OjMeDgbqPypmj0+6bBXRvVRMo5XLwu7y2YayNgkBL
         A8Uefb2A/OhTbxjD/R4zcKBC9mT0XeTpYMyGqMadO3zUyEvpkoWtHdFEsSrFEp1fRx
         q6tMjCunFcrqA==
Date:   Tue, 19 Apr 2022 10:18:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 2/4] generic: ensure we drop suid after fallocate
Message-ID: <20220419171852.GF17014@magnolia>
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971768254.169983.13280225265874038241.stgit@magnolia>
 <20220412115205.d6jjudlkxs72vezd@zlang-mailbox>
 <CAOQ4uxiDW6=qgWtH8uHkOmAyZBR7vfgwgt-DA_Rn0QVihQZQLw@mail.gmail.com>
 <20220413154401.vun2usvgwlfers2r@zlang-mailbox>
 <20220414155007.GC17014@magnolia>
 <20220414191017.jmv7jmwwhfy2n75z@zlang-mailbox>
 <CAOQ4uxgSmxaOHCj1RdCOX2p1Zmu5enkc4f_fkOLC_muPiMk=PA@mail.gmail.com>
 <Ylw08MYz2RgtRRVg@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ylw08MYz2RgtRRVg@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 17, 2022 at 11:40:32PM +0800, Eryu Guan wrote:
> On Fri, Apr 15, 2022 at 04:42:33PM +0300, Amir Goldstein wrote:
> > > Hi Darrick, that's another story, you don't need to worry about that in this case :)
> > > I'd like to ack this patch, but hope to move it from generic/ to shared/ . Maybe
> > > Eryu can help to move it, or I can do that after I get the push permission.
> > >
> > > The reason why I intend moving it to shared is:
> > > Although we are trying to get rid of tests/shared/, but the tests/shared/ still help to
> > > remind us what cases are still not real generic cases. We'll try to help all shared
> > > cases to be generic. When the time is ready, I'd like to move this case to generic/
> > > and change _supported_fs from "xfs btrfs ext4" to "generic".
> > >
> > 
> > Sorry, but I have to object to this move.
> > I do not think that is what tests/shared should be used for.
> 
> After reading all the discussions, I prefer option 2 here as well, it's
> testing for a security bug, and all affected filesystems should be fixed,
> and a new failure will remind people there's something to be fixed.

Ok.  I'll put it back to _supported_fs generic and leave the tests in
tests/generic/.  Thank you for making a decision. :)

--D

> > 
> > My preferences are:
> > 1. _suppoted_fs generic && _require_xfs_io_command "finsert"
> 
> As btrfs doesn't support "finsert", so the falloc/fpunch tests won't run
> on btrfs, and we miss test coverage there.
> 
> > 2. _suppoted_fs generic
> > 3. _supported_fs xfs btrfs ext4 (without moving to tests/shared)
> 
> This is weired. And if we really want to restrict the new behavior
> within xfs, btrfs and ext4 for now, then I can live with a whitelist
> _require rule, and a good comment on it.
> 
> Thanks,
> Eryu
