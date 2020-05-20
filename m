Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E887CC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 14:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C11E8205CB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 14:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgETO14 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 10:27:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:46948 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbgETO1z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 10:27:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E161CAF73;
        Wed, 20 May 2020 14:27:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 4B63B1E126F; Wed, 20 May 2020 16:27:52 +0200 (CEST)
Date:   Wed, 20 May 2020 16:27:52 +0200
From:   Jan Kara <jack@suse.cz>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Petr =?utf-8?B?UMOtc2HFmQ==?= <ppisar@redhat.com>
Subject: Re: [PATCH] quota-tools: Set FS_DQ_TIMER_MASK for individual xfs
 grace times
Message-ID: <20200520142752.GF30597@quack2.suse.cz>
References: <72a454f1-c2ee-b777-90db-6bdfd4a8572c@redhat.com>
 <20200514102036.GC9569@quack2.suse.cz>
 <00c2c5d4-a584-ad7d-c602-e516a8015562@sandeen.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <00c2c5d4-a584-ad7d-c602-e516a8015562@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 19-05-20 12:19:14, Eric Sandeen wrote:
> On 5/14/20 5:20 AM, Jan Kara wrote:
> >> I'm putting together xfstests cases for this, if you want to wait
> >> for those, that's fine.  Thanks!
> > Yeah, that looks like a good thing to do. Also FS_DQ_LIMIT_MASK contains
> > real-time limits bits which quota tools aren't able to manipulate in any
> > way so maybe not setting those bits would be wiser... Will you send a patch
> > or should I just fix it?
> 
> I've sent those tests now, btw.
> 
> I agree that the whole section of flag-setting is a bit odd, I hadn't
> intended to clean it up right now.  I'd be happy to review though if you
> found the time.  :)

Patch attached :)

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--opJtzjQTFsWo+cga
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Fix-limits-setting-on-XFS-filesystem.patch"

From 1814341547753865bcbd92bbe62af51f3e6866dd Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 20 May 2020 16:22:52 +0200
Subject: [PATCH] Fix limits setting on XFS filesystem

xfs_commit_dquot() always set FS_DQ_LIMIT_MASK when calling
Q_XFS_SETQLIM. So far this wasn't a problem since quota tools didn't
support setting of anything else for XFS but now that kernel will start
supporting setting of grace times for XFS, we need to be more careful
and set limits bits only if we really want to update them. Also
FS_DQ_LIMIT_MASK contains real-time limits as well. Quota tools
currently don't support them in any way so avoid telling kernel to set
them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 quotaio_xfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/quotaio_xfs.c b/quotaio_xfs.c
index a4d6f67b0c5a..3333bb1645d9 100644
--- a/quotaio_xfs.c
+++ b/quotaio_xfs.c
@@ -165,7 +165,9 @@ static int xfs_commit_dquot(struct dquot *dquot, int flags)
 		if (flags & COMMIT_USAGE) /* block usage */
 			xdqblk.d_fieldmask |= FS_DQ_BCOUNT;
 	} else {
-		xdqblk.d_fieldmask |= FS_DQ_LIMIT_MASK;
+		if (flags & COMMIT_LIMITS) /* warn/limit */
+			xdqblk.d_fieldmask |= FS_DQ_BSOFT | FS_DQ_BHARD |
+						FS_DQ_ISOFT | FS_DQ_IHARD;
 		if (flags & COMMIT_TIMES) /* indiv grace period */
 			xdqblk.d_fieldmask |= FS_DQ_TIMER_MASK;
 	}
-- 
2.16.4


--opJtzjQTFsWo+cga--
