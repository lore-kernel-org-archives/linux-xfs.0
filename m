Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C22FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 20:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242208AbiAKUGK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 15:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242072AbiAKUGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 15:06:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C57C06173F
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jan 2022 12:06:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B87DCB81D4D
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jan 2022 20:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A43C36AE9;
        Tue, 11 Jan 2022 20:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641931567;
        bh=Ui1GYZ8/aVDbmrLKkXz8Nkxmt+3zTEQxDFBrQU++mkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P1Z7/nOOmkr73AIraDHMyJK5RBYpXroq/Tlpr+MkHf2cxn5rlgdSFKUPS9uHf0peN
         MQ1+CTRzwb4V7T4WmZecumwVCS/5mUxvxLHSrZREpQoAEQn11gTiY2CjoO1vkjkBag
         Nr4NSVccPu0Z7KT9Gca+6xTFh9QuGvuteTwzzo0y0xah5yCAsp2Hw8H8Yy4RKQtBCS
         RZ7xAlMeTSR/s9mnKDsEF1Sf+9v33eOT3O0QOsmxPHEi4ceJeBRRkMMY+eXssuOjDA
         GJk7SZGsbZ5/pachmYFo45F4yGlLnmjXE92m2gJ90iNBWkAxF/fF/k9Wfbr4g3jCP5
         g1S7ZQWsCGWPg==
Date:   Tue, 11 Jan 2022 12:06:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Kang Chen <void0red@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Why 'fallocate' clear the file's SUID flag?
Message-ID: <20220111200606.GG656707@magnolia>
References: <CANE+tVp9Au=beERRjy9mp90-=5S9ErjEDT=E7i5E3dWvFP928g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANE+tVp9Au=beERRjy9mp90-=5S9ErjEDT=E7i5E3dWvFP928g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 01, 2021 at 06:45:46PM +0800, Kang Chen wrote:
> I found that the 'xfs_update_prealloc_flags' function is called
> during the ‘fallocate’ syscall and the SUID flag is cleared
> when the 'XFS_PREALLOC_INVISIBLE' flag is not set.
> I am a beginner and have some questions about it.
> 
> 1. What does XFS_PREALLOC_INVISIBLE mean and
> why should the SUID flag be cleared
> when XFS_PREALLOC_INVISIBLE is not set?
> 
> 2. The behavior of XFS in handling the fallocate syscall is
> a bit strange and not quite the same as other file systems,
> such as ext4 and btrfs.
> 
> Here is an example:
> foo is a normal file.
> chmod set the SUID and SGID flag.
> The last two parameters of fallocate are irrelevant to this problem.
> After running, ext4 and btrfs set mode o6000, but xfs set mode o2000.
> ```
> int fd = open("foo", 2, 0);
> chmod("foo", o6000);
> fallocate(fd, 3, 6549, 1334);
> fsync(fd);
> ```
> 
> Can you give me some help?

The Open Group spec says (for file writes) that "Upon successful
completion, where nbyte is greater than 0, write() shall mark for update
the last data modification and last file status change timestamps of the
file, and if the file is a regular file, the S_ISUID and S_ISGID bits of
the file mode may be cleared."

https://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html

I think XFS (and ocfs2) interpret fallocate calls as a file write, since
punch/zero/collapse/insert directly change the file contents and
extending the length changes what you get if you read() the entire file.
If nothing else, xfs updates the ctime for any fallocate request.  This
might be overkill for preallocating into the middle of a file, but for
the rest I think it's necessary.

That's the reason I can come up with for why these two filesystems
remove the suid/sgid bits on fallocate.

--D

> Best wishes.
