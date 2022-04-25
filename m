Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DE8C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 18:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiDYSWn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 14:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244356AbiDYSWl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 14:22:41 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3180D3B29A
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 11:19:37 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5B4FA16C148;
        Mon, 25 Apr 2022 13:19:15 -0500 (CDT)
Message-ID: <43e8df67-5916-5f4a-ce85-8521729acbb2@sandeen.net>
Date:   Mon, 25 Apr 2022 13:19:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Content-Language: en-US
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v1 0/2] xfs: remove quota warning limits
In-Reply-To: <20220421165815.87837-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/21/22 11:58 AM, Catherine Hoang wrote:
> Hi all,
> 
> Based on recent discussion, it seems like there is a consensus that quota
> warning limits should be removed from xfs quota.
> https://lore.kernel.org/linux-xfs/94893219-b969-c7d4-4b4e-0952ef54d575@sandeen.net/
> 
> Warning limits in xfs quota is an unused feature that is currently
> documented as unimplemented. These patches remove the quota warning limits
> and cleans up any related code. 
> 
> Comments and feedback are appreciated!
> 
> Catherine
> 
> Catherine Hoang (2):
>   xfs: remove quota warning limit from struct xfs_quota_limits
>   xfs: don't set warns on the id==0 dquot
> 
>  fs/xfs/xfs_qm.c          |  9 ---------
>  fs/xfs/xfs_qm.h          |  5 -----
>  fs/xfs/xfs_qm_syscalls.c | 19 +++++--------------
>  fs/xfs/xfs_quotaops.c    |  3 ---
>  fs/xfs/xfs_trans_dquot.c |  3 +--
>  5 files changed, 6 insertions(+), 33 deletions(-)

I have a question about the remaining warning counter infrastructure after these
patches are applied.

We still have xfs_dqresv_check() incrementing the warning counter, as was added in
4b8628d5 "xfs: actually bump warning counts when we send warnings"

--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -589,6 +589,7 @@
                        return QUOTA_NL_ISOFTLONGWARN;
                }
 
+               res->warnings++;
                return QUOTA_NL_ISOFTWARN;
        }


That warning counter is written to disk, and read from disk. It can be set from
userspace, and while it could queried from userspace, nothing in xfsprogs seems to
ever actually read or present the value.  It's part of the vfs quota layer, i.e.
d_ino_warns in struct qc_dqblk, but XFS is the only filesystem which updates it.

So what is this thing for?

The structure comments simply say that it counts "# warnings issued"

We /do/ actually issue warnings from quota; we do it via netlink, see
quota_send_warning() in fs/quota/netlink.c, and xfs_quota_warn() which calls
it. We issue warnings when we try to exceed the hard limit (QUOTA_NL_IHARDWARN)
as well as when we have gone past the soft limit (QUOTA_NL_ISOFTWARN) and if
we have exceeded the soft limit grace period (QUOTA_NL_ISOFTLONGWARN), but
we only increment the c/ounter/ in the QUOTA_NL_ISOFTWARN case, if I'm reading
it right - why is that?

So I'm left wondering what this counter is for, and what it's supposed to mean.

tl;dr: it increments only for 1 of 3 warning types, and nobody ever reads it.
What is its purpose?

If we think that maybe some day people will actually care about the number of
warnings issued through netlink for some reason, should we increment it for
every warning type?  Unless it really does have the special meaning about
"warnings related to exceeding the soft quota grace period" but I'm not sure
what that would be used for.

Is it even useful enough to keep?  It /is/ part of an on-disk structure and a
user interface, but it is still, after 20 years, explicitly documented as being
unimplemented.

Personally, I'm inclined to completely deprecate and rip out the counter
altogether, but if there are strong feelings that it should remain in place,
we should at least accurately describe what it's counting, and why the user
or admin might care.

Thanks,
-Eric
