Return-Path: <SRS0=f2ny=WU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E61AC3A59E
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 16:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16C3A22CE3
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 16:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566664027;
	bh=hcaxNPorSpY124jIa9w8rWIov+dp/m3JU7ie7GcfkCE=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=D1S1WOfeITnOBCNefHPmn1Lpb7uJlDlKrcvl33n8AGOusPjjLj849uPjwSv630VcJ
	 aYKXwZJzzeFpbISxc0d6eQYP3fd6gtKc81hKXbjxs1k8NPo0OW4yQh26DAzv3yRcsQ
	 yx7fmy4FBJgDR3ysDrdJEtwhYHjuB4nH2aat4s2E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfHXQ1G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Aug 2019 12:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbfHXQ1G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 24 Aug 2019 12:27:06 -0400
Received: from localhost (c-67-169-218-210.hsd1.or.comcast.net [67.169.218.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B68562133F;
        Sat, 24 Aug 2019 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566664025;
        bh=hcaxNPorSpY124jIa9w8rWIov+dp/m3JU7ie7GcfkCE=;
        h=Date:From:To:Cc:Subject:From;
        b=r94swXoKa/uz9lHpJMlR+xBqyk/7xwAbnOFs5+EGRgh4C1Kges/VUelKS2x6L9cL8
         IRjvMOiYcOAYXGgEDA9PgodALUR3a01D0wdV1OEbasShQ5qNrbqbYZ2HpdYecBJLpo
         fssndCq7omCzPd8HoQA+2YI8TRoCW2AHSa7oq0+M=
Date:   Sat, 24 Aug 2019 09:27:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Subject: [GIT PULL] xfs: fix for 5.3-rc6
Message-ID: <20190824162705.GM1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this single patch that fixes a xfs lockup problem when a
chown/chgrp operation fails due to running out of quota.  It has
survived the usual xfstests runs and merges cleanly with this morning's
master.  Please let me know if anything strange happens.

--D

The following changes since commit b68271609c4f16a79eae8069933f64345afcf888:

  fs/xfs: Fix return code of xfs_break_leased_layouts() (2019-08-19 18:15:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.3-fixes-6

for you to fetch changes up to 1fb254aa983bf190cfd685d40c64a480a9bafaee:

  xfs: fix missing ILOCK unlock when xfs_setattr_nonsize fails due to EDQUOT (2019-08-22 20:55:54 -0700)

----------------------------------------------------------------
Changes since last time:
- Fix a forgotten inode unlock when chown/chgrp fail due to quota.

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: fix missing ILOCK unlock when xfs_setattr_nonsize fails due to EDQUOT

 fs/xfs/xfs_iops.c | 1 +
 1 file changed, 1 insertion(+)
