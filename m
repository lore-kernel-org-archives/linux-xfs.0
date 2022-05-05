Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A880C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 20:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244042AbiEEUFW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 16:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244961AbiEEUFV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 16:05:21 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF2155EDF0
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 13:01:40 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0DBA54909;
        Thu,  5 May 2022 15:01:06 -0500 (CDT)
Message-ID: <b03a9331-f795-ca8f-d134-ac9912d73372@sandeen.net>
Date:   Thu, 5 May 2022 15:01:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176665416.246985.13192803422215905607.stgit@magnolia>
 <165176665975.246985.16711050246120025448.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] xfs_db: warn about suspicious finobt trees when
 metadumping
In-Reply-To: <165176665975.246985.16711050246120025448.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:04 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We warn about suspicious roots and btree heights before metadumping the
> inode btree, so do the same for the free inode btree.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

LGTM. I wonder if we could do this without quite so much copied code
(like maybe call copy_inodes twice, once for inode tree once for free inode
tree?) but that's a patch for another day.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

===

maybe like this? worth it?

static int
copy_inodes(
        xfs_agnumber_t          agno,
        xfs_agi_t               *agi,
        int                     finobt)
{
        xfs_agblock_t           root;
        int                     levels;
        int                     type;

        if (finobt) {
                type = TYP_FINOBT;
                root = be32_to_cpu(agi->agi_root);
                levels = be32_to_cpu(agi->agi_level);
        } else {
                type = TYP_INOBT;
                root = be32_to_cpu(agi->agi_free_root);
                levels = be32_to_cpu(agi->agi_free_level);
        }

        /* validate root and levels before processing the tree */
        if (root == 0 || root > mp->m_sb.sb_agblocks) {
                if (show_warnings)
                        print_warning("invalid block number (%u) in %s"
                                        "root in agi %u", root,
                                        finobt ? "finobt" : "inobt", agno);
                return 1;
        }
        if (levels > M_IGEO(mp)->inobt_maxlevels) {
                if (show_warnings)
                        print_warning("invalid level (%u) in %s root "
                                        "in agi %u", levels,
                                        finobt ? "finobt" : "inobt", agno);
                return 1;
        }

        if (!scan_btree(agno, root, levels, type, &finobt, scanfunc_ino))
                return 0;

        return 1;
}
