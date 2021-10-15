Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582E8C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 20:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3329D611C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 20:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbhJOUeu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Oct 2021 16:34:50 -0400
Received: from sandeen.net ([63.231.237.45]:50178 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232036AbhJOUet (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Oct 2021 16:34:49 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 40A0D4900
        for <linux-xfs@vger.kernel.org>; Fri, 15 Oct 2021 15:31:37 -0500 (CDT)
Message-ID: <d162a7f8-4101-6021-684b-275f894454be@sandeen.net>
Date:   Fri, 15 Oct 2021 15:32:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Content-Language: en-US
From:   Eric Sandeen <sandeen@sandeen.net>
To:     xfs <linux-xfs@vger.kernel.org>
References: <40ae0dd3-aeea-344c-ac6b-e76b42892e86@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next rebased to b4c6731a
In-Reply-To: <40ae0dd3-aeea-344c-ac6b-e76b42892e86@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/15/21 2:42 PM, Eric Sandeen wrote:
> Hi folks,
> 
> The for-next branch of the xfsprogs repository at:
> 
>      git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated.
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
> 
> This is really just the libxfs-5.14 sync (finally!).  Big thanks
> to chandan, djwong, dchinner who all helped significantly with what
> was a much more challenging libxfs sync this time.
> 
> Odds are this will be the bulk of the final 5.14 release. I will just
> add Darrick's deprecation warning, and anything else I get reminded
> of in the next week.  :)

I missed Derrick's "libxfs: fix crash on second attempt to initialize library"
because my old userspace rcu library did not exhibit the problem. :/

Rather than leave a few dozen commits with regressed behavior as a bisect bomb,
I have force-pushed and anybody who pulled in the last hour will need to rebase.
Sorry about that!

Now it's:

New Commits:

Allison Henderson (15):
       [67f397e4] xfs: Reverse apply 72b97ea40d
       [48a540b6] xfs: Add xfs_attr_node_remove_name
       [0469587e] xfs: Refactor xfs_attr_set_shortform
       [473c6b8f] xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
       [f7dcc61f] xfs: Add helper xfs_attr_node_addname_find_attr
       [edd2419e] xfs: Hoist xfs_attr_node_addname
       [1200ab60] xfs: Hoist xfs_attr_leaf_addname
       [7e9eeb93] xfs: Hoist node transaction handling
       [c749b4e1] xfs: Add delay ready attr remove routines
       [d6d6237c] xfs: Add delay ready attr set routines
       [1ad8a3b5] xfs: Remove xfs_attr_rmtval_set
       [38f71479] xfs: Clean up xfs_attr_node_addname_clear_incomplete
       [2c8cf7d9] xfs: Fix default ASSERT in xfs_attr_set_iter
       [f0c4e745] xfs: Make attr name schemes consistent
       [13f632a6] xfs: Initialize error in xfs_attr_remove_iter

Christoph Hellwig (1):
       [8a3be25d] xfs: mark xfs_bmap_set_attrforkoff static

Darrick J. Wong (8):
       [7bf9cd9d] libxfs: fix call_rcu crash when unmounting the fake mount in mkfs
       [c1ab394a] libxfs: fix crash on second attempt to initialize library
       [6d211aaa] xfs: clean up open-coded fs block unit conversions
       [79eb2dcf] xfs: fix radix tree tag signs
       [a789987d] xfs: fix endianness issue in xfs_ag_shrink_space
       [23435e3c] xfs: check for sparse inode clusters that cross new EOAG when shrinking
       [d7de0c3e] xfs: correct the narrative around misaligned rtinherit/extszinherit dirs
       [b4c6731a] xfs_db: convert the agresv command to use for_each_perag

Dave Chinner (28):
       [0bba7995] xfs: use xfs_buf_alloc_pages for uncached buffers
       [f93d2173] xfs: move xfs_perag_get/put to xfs_ag.[ch]
       [4bcd30f6] xfs: move perag structure and setup to libxfs/xfs_ag.[ch]
       [bcac47dc] xfs: make for_each_perag... a first class citizen
       [29d36774] xfs: convert raw ag walks to use for_each_perag
       [b92a329e] xfs: convert xfs_iwalk to use perag references
       [3a0efe08] xfs: convert secondary superblock walk to use perags
       [7635c486] xfs: pass perags through to the busy extent code
       [653f37bc] xfs: push perags through the ag reservation callouts
       [48af87dd] xfs: pass perags around in fsmap data dev functions
       [ca7d293d] xfs: add a perag to the btree cursor
       [195c248c] xfs: convert rmap btree cursor to using a perag
       [971fceb4] xfs: convert refcount btree cursor to use perags
       [ecb44e84] xfs: convert allocbt cursors to use perags
       [a426d0e1] xfs: use perag for ialloc btree cursors
       [a0577dbb] xfs: remove agno from btree cursor
       [3fbe9fa3] xfs: simplify xfs_dialloc_select_ag() return values
       [d38ed6a9] xfs: collapse AG selection for inode allocation
       [51b1e167] xfs: get rid of xfs_dir_ialloc()
       [895ee7c3] xfs: inode allocation can use a single perag instance
       [771d0670] xfs: clean up and simplify xfs_dialloc()
       [b8268cdd] xfs: use perag through unlink processing
       [d2ff101f] xfs: remove xfs_perag_t
       [1dbf114f] xfs: drop the AGI being passed to xfs_check_agi_freecount
       [e86bc63f] xfs: perag may be null in xfs_imap()
       [6d95c77a] xfs: log stripe roundoff is a property of the log
       [08602f16] xfs: xfs_log_force_lsn isn't passed a LSN
       [f682c323] xfs: logging the on disk inode LSN can make it go backwards

Gustavo A. R. Silva (1):
       [8b1a8326] xfs: Fix multiple fall-through warnings for Clang

Jiapeng Chong (1):
       [396a1948] xfs: Remove redundant assignment to busy

Shaokun Zhang (1):
       [398f22e7] xfs: sort variable alphabetically to avoid repeated declaration
