Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80201C7619A
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 15:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbjDEPaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 11:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238601AbjDEPaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 11:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E59159DD
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 08:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AADF6278C
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 15:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D51C433D2;
        Wed,  5 Apr 2023 15:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680708603;
        bh=FOhmsREYCNktqd2PaoNFZdAALKQ0fcfyzPKCI6va6R8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uY/sz19FPtNU+92jHKZ3bs/mUmSrrZD/tQotWMsIt4WjmudAuBxfFJWd2Yt9jIsng
         WaPq8GpDjMZEMkZHM5cu77EBV7tZ7TsQL/SAl5mJBD8+OUGG+008T47BYAnKwKyQ4P
         1yVVu0BeIlFZeZ3FGkpBn7afBqiXvW/0/B6XxWJX7cqhTJMLtc/DutTxt4UvX9xq3U
         G2/ROLCO6qJnFqz6Vfusy5rnATv8WPOCYRZdIJZmsWM4nfBAchzdAp6UX/3Rii5DlE
         Edy+jwzCk4saODiDnn90FcGbCjcVAeRLtSpORCJk+O+bMGtcOEX2+Z0JE9qEYF1yEw
         BE7TYl5MF4sxQ==
Date:   Wed, 5 Apr 2023 08:30:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>, david@fromorbit.com
Cc:     torvalds@linux-foundation.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for
 ascii-ci dir hash computation
Message-ID: <20230405153002.GE303486@frogsfrogsfrogs>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
 <ZC1R4IRx7ZiBeeLJ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC1R4IRx7ZiBeeLJ@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 05, 2023 at 03:48:00AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 04, 2023 at 10:07:06AM -0700, Darrick J. Wong wrote:
> > Which means that the kernel and userspace do not agree on the hash value
> > for a directory filename that contains those higher values.  The hash
> > values are written into the leaf index block of directories that are
> > larger than two blocks in size, which means that xfs_repair will flag
> > these directories as having corrupted hash indexes and rewrite the index
> > with hash values that the kernel now will not recognize.
> > 
> > Because the ascii-ci feature is not frequently enabled and the kernel
> > touches filesystems far more frequently than xfs_repair does, fix this
> > by encoding the kernel's toupper predicate and tolower functions into
> > libxfs.  This makes userspace's behavior consistent with the kernel.
> 
> I agree with making the userspace behavior consistent with the actual
> kernel behavior.  Sadly the documented behavior differs from both
> of them, so I think we need to also document the actual tables used
> in the mkfs.xfs manpage, as it isn't actually just ASCII.

Agreed.  Given that kernel tolower() behavior has been stable since 1996
(and remaps the ISO 8859-1 accented letters), the "ASCII CI" feature
most closely maps to "ISO 8859-1 CI".  But at this point there's not
even a shared understanding (Dave said latin1, you said 7-bit ascii,
IDGAF) so I agree that documenting the exact transformations in the
manpage is the only sane way forward.

I propose the changing the mkfs.xfs manpage wording from:

"The version=ci  option  enables  ASCII  only case-insensitive filename
lookup and version 2 directories. Filenames  are  case-preserving, that
is, the names are stored in directories using  the  case  they  were
created with."

into:

"If the version=ci option is specified, the kernel will transform
certain bytes in filenames before performing lookup-related operations.
The byte sequence given to create a directory entry is persisted without
alterations.  The lookup transformations are defined as follows:

0x41 - 0x5a -> 0x61 - 0x7a
0xc0 - 0xd6 -> 0xe0 - 0xf6
0xd8 - 0xde -> 0xf8 - 0xfe

This transformation roughly corresponds to case insensitivity in ISO
8859-1 and may cause problems with other encodings (e.g. UTF8).  The
feature will be disabled by default in September 2025, and removed from
the kernel in September 2030."

> Does the kernel twolower behavior map to an actual documented charset?
> In that case we can just point to it, which would be way either than
> documenting all the details.

It *seems* to operate on ISO 8859-1 (aka latin1), but Linus implied that
the history of lib/ctype.c is lost to the ages.  Or at least 1996-era
mailing list archives.

--D
