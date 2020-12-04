Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139D6C4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 21:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1AAD22AED
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 21:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgLDVrB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 16:47:01 -0500
Received: from sandeen.net ([63.231.237.45]:43598 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgLDVrA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Dec 2020 16:47:00 -0500
Received: from liberator.sandeen.net (usg [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 726D57906;
        Fri,  4 Dec 2020 15:45:59 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679384513.447856.3675245763779550446.stgit@magnolia>
 <d54542e0-728f-52b4-3762-c9353fcae8de@sandeen.net>
 <20201204211206.GE106271@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/3] xfs: move kernel-specific superblock validation out
 of libxfs
Message-ID: <3123a8c7-9afe-fd73-ae6d-d8c9cd2188ad@sandeen.net>
Date:   Fri, 4 Dec 2020 15:46:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204211206.GE106271@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/4/20 3:12 PM, Darrick J. Wong wrote:
> On Fri, Dec 04, 2020 at 02:35:45PM -0600, Eric Sandeen wrote:
>> On 11/30/20 9:37 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> A couple of the superblock validation checks apply only to the kernel,
>>> so move them to xfs_mount.c before we start changing sb_inprogress.

oh also, you're not changing sb_inprogress anymore, right? ;)

>>> This also reduces the diff between kernel and userspace libxfs.
>>
>> My only complaint is that "xfs_sb_validate_mount" isn't really descriptive
>> at all, and nobody reading the code or comments will know why we've chosen
>> to move just these two checks out of the common validator...
>>
>> What does "compatible with this mount" mean?
> 
> Compatible with this implementation?

Hm.

So most of xfs_validate_sb_common is doing internal consistency checking
that has nothing at all to do with the host's core capabilities or filesystem
"state" (other than version/features I guess).

You've moved out the PAGE_SIZE check, which depends on the host.

You've also moved the inprogress check, which depends on state.
(and that's not really "kernel-specific" is it?)

You'll later move the NEEDSREPAIR check, which I guess is state.

But you haven't moved the fsb_count-vs-host check, which depends on the host.

(and ... I think that one may actually be kernel-specific,
because it depends on pagecache limitations in the kernel, so maybe it
should be moved out as well?)

So maybe the distinction is internal consistency checks, vs
host-compatibility-and-filesystem-state checks.

How about ultimately:

/*
 * Do host compatibility and filesystem state checks here; these are unique
 * to the kernel, and may differ in userspace.
 */
xfs_validate_sb_host(
	struct xfs_mount	*mp,
	struct xfs_buf		*bp,
	struct xfs_sb		*sbp)
{
	/*
	 * Don't touch the filesystem if a user tool thinks it owns the primary
	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
	 * we don't check them at all.
	 */
	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && sbp->sb_inprogress) {
		xfs_warn(mp, "Offline file system operation in progress!");
		return -EFSCORRUPTED;
	}

	/* Filesystem claims it needs repair, so refuse the mount. */
	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
		return -EFSCORRUPTED;
	}

	/*
	 * Until this is fixed only page-sized or smaller data blocks work.
	 */
	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
		xfs_warn(mp,
		"File system with blocksize %d bytes. "
		"Only pagesize (%ld) or less will currently work.",
				sbp->sb_blocksize, PAGE_SIZE);
		return -ENOSYS;
	}

	/* Ensure this filesystem fits in the page cache limits */
        if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
            xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
                xfs_warn(mp,
                "file system too large to be mounted on this system.");
                return -EFBIG;
        }

	return 0;
}

>> Maybe just fess up in the comment, and say "these checks are different 
>> for kernel vs. userspace so we keep them over here" - and as for the
>> function name, *shrug* not sure I have anything better...
> 
> _validate_implementation?  I don't have a better suggestion either.
> 
> --D
> 
>> -Eric
>>
> 
