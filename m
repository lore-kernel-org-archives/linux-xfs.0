Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A01CC77B73
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 08:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbjFFIhy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 04:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjFFIhx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 04:37:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D32F4
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 01:37:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA16961213
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 08:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA4FC433EF;
        Tue,  6 Jun 2023 08:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686040671;
        bh=h8GnvlnCQ1yoDgdLMSxxrq4NuBdhCyJcWtK7+I8FEMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MCsgSVkUeqBqL/M3kURkeUNO9zdVZn/duoHZ5Uokt2rfKXcMkslnbdKhqGap/iLpP
         gfu00S+VPdPTbuy9yakx05qlgkKMOWqgaNN/FkJ2k7wVzich+w6zuSHm9/6n79Wxym
         +kx+QXUpzLCEIq1FHUezFav2aKzI0K3OT0uB89HzJfyb48pek/3HC0eLzXKR//VvJJ
         Ah5Rs7udYk3pFwyjzHOq3WNEyCloYVjF3TFpmwm1zsxGUr+BtJeEtBaTblCgQdVCRj
         YFr3bKw9fs4Z8RPbwsjm08w7cW/Co+qL1nIV9Nmo0XQHpTjOdcHcn36hmeG2GMet3U
         9yJby1T9rIkOA==
Date:   Tue, 6 Jun 2023 10:37:46 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v24.0 0/3] xfsprogs: fix rmap btree key flag handling
Message-ID: <20230606083746.hy3nsiijduu5e3tx@andromeda>
References: <YHS1lALDDwpemIf-r00UV9mAgTUld-p30D2uZ6UdBvnxE17RtY_YW72pQUcQMKXxYhwCjwfGBTwh9q_eTwhC_g==@protonmail.internalid>
 <168597936664.1225991.1267673489846772229.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168597936664.1225991.1267673489846772229.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 08:36:06AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series fixes numerous flag handling bugs in the rmapbt key code.
> The most serious transgression is that key comparisons completely strip
> out all flag bits from rm_offset, including the ones that participate in
> record lookups.  The second problem is that for years we've been letting
> the unwritten flag (which is an attribute of a specific record and not
> part of the record key) escape from leaf records into key records.
> 
> The solution to the second problem is to filter attribute flags when
> creating keys from records, and the solution to the first problem is to
> preserve *only* the flags used for key lookups.  The ATTR and BMBT flags
> are a part of the lookup key, and the UNWRITTEN flag is a record
> attribute.
> 
> This has worked for years without generating user complaints because
> ATTR and BMBT extents cannot be shared, so key comparisons succeed
> solely on rm_startblock.  Only file data fork extents can be shared, and
> those records never set any of the three flag bits, so comparisons that
> dig into rm_owner and rm_offset work just fine.
> 
> A filesystem written with an unpatched kernel and mounted on a patched
> kernel will work correctly because the ATTR/BMBT flags have been
> conveyed into keys correctly all along, and we still ignore the
> UNWRITTEN flag in any key record.  This was what doomed my previous
> attempt to correct this problem in 2019.
> 
> A filesystem written with a patched kernel and mounted on an unpatched
> kernel will also work correctly because unpatched kernels ignore all
> flags.
> 
> With this patchset applied, the scrub code gains the ability to detect
> rmap btrees with incorrectly set attr and bmbt flags in the key records.
> After three years of testing, I haven't encountered any problems.
> Online scrub is amended to recommend rebuilding of rmap btrees with the
> unwritten flag set in key records.
> 
> The xfsprogs counterpart to this series amends xfs_repair to report key
> records with the unwritten flag bit set, just prior to rebuilding the
> rmapbt.  It also exposes the bit via xfs_db to enable testing back and
> forth.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.

Looks good, will test:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rmap-btree-fix-key-handling
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rmap-btree-fix-key-handling
> ---
>  db/btblock.c  |    4 ++++
>  repair/scan.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 
