Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FBEC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Apr 2022 15:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbiDQPnQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Apr 2022 11:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiDQPnP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Apr 2022 11:43:15 -0400
Received: from out20-27.mail.aliyun.com (out20-27.mail.aliyun.com [115.124.20.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D59913F6B;
        Sun, 17 Apr 2022 08:40:38 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1002753|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.115828-0.00370883-0.880463;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047212;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.NSNuFHX_1650210033;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.NSNuFHX_1650210033)
          by smtp.aliyun-inc.com(33.40.38.164);
          Sun, 17 Apr 2022 23:40:33 +0800
Date:   Sun, 17 Apr 2022 23:40:32 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 2/4] generic: ensure we drop suid after fallocate
Message-ID: <Ylw08MYz2RgtRRVg@desktop>
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971768254.169983.13280225265874038241.stgit@magnolia>
 <20220412115205.d6jjudlkxs72vezd@zlang-mailbox>
 <CAOQ4uxiDW6=qgWtH8uHkOmAyZBR7vfgwgt-DA_Rn0QVihQZQLw@mail.gmail.com>
 <20220413154401.vun2usvgwlfers2r@zlang-mailbox>
 <20220414155007.GC17014@magnolia>
 <20220414191017.jmv7jmwwhfy2n75z@zlang-mailbox>
 <CAOQ4uxgSmxaOHCj1RdCOX2p1Zmu5enkc4f_fkOLC_muPiMk=PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgSmxaOHCj1RdCOX2p1Zmu5enkc4f_fkOLC_muPiMk=PA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 15, 2022 at 04:42:33PM +0300, Amir Goldstein wrote:
> > Hi Darrick, that's another story, you don't need to worry about that in this case :)
> > I'd like to ack this patch, but hope to move it from generic/ to shared/ . Maybe
> > Eryu can help to move it, or I can do that after I get the push permission.
> >
> > The reason why I intend moving it to shared is:
> > Although we are trying to get rid of tests/shared/, but the tests/shared/ still help to
> > remind us what cases are still not real generic cases. We'll try to help all shared
> > cases to be generic. When the time is ready, I'd like to move this case to generic/
> > and change _supported_fs from "xfs btrfs ext4" to "generic".
> >
> 
> Sorry, but I have to object to this move.
> I do not think that is what tests/shared should be used for.

After reading all the discussions, I prefer option 2 here as well, it's
testing for a security bug, and all affected filesystems should be fixed,
and a new failure will remind people there's something to be fixed.

> 
> My preferences are:
> 1. _suppoted_fs generic && _require_xfs_io_command "finsert"

As btrfs doesn't support "finsert", so the falloc/fpunch tests won't run
on btrfs, and we miss test coverage there.

> 2. _suppoted_fs generic
> 3. _supported_fs xfs btrfs ext4 (without moving to tests/shared)

This is weired. And if we really want to restrict the new behavior
within xfs, btrfs and ext4 for now, then I can live with a whitelist
_require rule, and a good comment on it.

Thanks,
Eryu
