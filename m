Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6223C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240643AbjEZAHg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbjEZAHf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:07:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8F3E65
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0B6564B6C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C4CC433A0;
        Fri, 26 May 2023 00:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685059631;
        bh=RFJOqit5S9I9vAP0hYEchl/taP6hXZt1U901r7JxCUM=;
        h=Date:From:To:Cc:Subject:From;
        b=iFuy7r5iNmuvamP96GVICREdT7xQyyLWyNssOxcUd9de+o2rL10TI6ZByN42rQbwv
         FGBwTnJ2L0Xs6/RUOl7dAEpuBhnyIWdGu75AWZMW+n/cpe45EnBaS5eL4p8kI1H9dT
         jwGJ9yfadRSpZ7nRdOT5Qit9nBTMGvWN6ypv13ex9DEFlJe39mdQEfVHUYeIqczeeT
         epYTNfntSfxjfLR4SjyXuigpnovWyvPjq6IKN3Igx3eV+TF/T8oEM+wXMD9kderoso
         Xh+hXPX2/jq+LTdYgRtNHTHMPimpqsBHGBudp39sgHDSnOfmnQUdl62aAM1KuRf5VX
         AfY2R2GBNaa6w==
Date:   Thu, 25 May 2023 17:07:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: [RFC MEGAPATCHSET v12 1/2] xfs: parent pointers and online repair
 part 2
Message-ID: <20230526000710.GG11642@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi everyone,

I am also sending out an RFC for part 2 of online repair.  I've merged
Allison's parent pointers work into djwong-dev and ported the prototype
reconstruction algorithms that I showed off in v11 on top of part 1 of
online repair.  In short, XFS can now rebuild its own directory tree.

Parent pointers now look like this:

	(parent_ino, parent_gen, namehash) -> (name[])

I think this feature is ready to go once we've merged part 1 of the
online repair code.  A full run of the online/offline fsck fuzz testing
show that this code is ready to go, though I have not yet looked deeply
into whether or not things like cycle detection are now easy to
construct.

--D
