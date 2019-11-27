Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18471C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 12:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3A1B2071E
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 12:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfK0MGn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 07:06:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:47482 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726320AbfK0MGn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Nov 2019 07:06:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7D3FEAE7F;
        Wed, 27 Nov 2019 12:06:41 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2D58D1E0AFA; Wed, 27 Nov 2019 13:06:41 +0100 (CET)
Date:   Wed, 27 Nov 2019 13:06:41 +0100
From:   Jan Kara <jack@suse.cz>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] generic/050: fix xfsquota configuration failures
Message-ID: <20191127120641.GC20979@quack2.suse.cz>
References: <20191127041538.GH6212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127041538.GH6212@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue 26-11-19 20:15:38, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The new 'xfsquota' configuration for generic/050 doesn't filter out
> SCRATCH_MNT properly and seems to be missing an error message in the
> golden output.  Fix both of these problems.
> 
> Fixes: e088479871 ("generic/050: Handle xfs quota special case with different output")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Umm, I can see how I messed up the SCRATCH_MNT filtering and didn't notice
- thanks for fixing that. But the error message should not be there. The
previous mount completely failed so we end up touching file on the parent
filesystem which succeeds (well, unless the parent filesystem is read-only
as well). So to avoid this obscure behavior, we should add something like
(untested):

diff --git a/tests/generic/050 b/tests/generic/050
index cf2b93814267..593e2e69bf9a 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -59,8 +59,10 @@ blockdev --setro $SCRATCH_DEV
 #
 echo "mounting read-only block device:"
 _try_scratch_mount 2>&1 | _filter_ro_mount
-echo "touching file on read-only filesystem (should fail)"
-touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
+if [ "${PIPESTATUS[0]}" -eq 0 ]; then
+       echo "touching file on read-only filesystem (should fail)"
+       touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
+fi

and update xfsquota output accordingly...

								Honza
> @@ -1,8 +1,9 @@
>  QA output created by 050
>  setting device read-only
>  mounting read-only block device:
> -mount: /mnt-scratch: permission denied
> +mount: SCRATCH_MNT: permission denied
>  touching file on read-only filesystem (should fail)
> +touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system
>  unmounting read-only filesystem
>  umount: SCRATCH_DEV: not mounted
>  setting device read-write
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
