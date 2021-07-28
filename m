Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05076C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D486B60EE6
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhG1TGc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 15:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhG1TGb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 15:06:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5017260EE6;
        Wed, 28 Jul 2021 19:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627499189;
        bh=DyNYWHw2B6UeV+23pscvqwo2ea/bclWx9soXqnfod4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=joPgatv1K1QSZ5sIypVIfQLW+p5Y52nO93pE4n3Df9PgIwWq48f8+InSbnD0dYx5n
         67PkrhP9qh8srrLuVSOZFuqMpYi7DfeNvm6mEkrWbm7P+QN8Mf4aA11W9/FV4wErSi
         uya2qq5MMAYS0TYm8/OkwsIBxkKUzh0TgLslFJSH9pl3HQGOagdJEaPNUMRd+mW9kk
         NUa0QogJLqz4r/DIenGtRo8q3yIMIzYF6xOm4yPEp/TuS3B6LpxFzztZosGksPJ4FK
         KAW4LsM+hPZD3n+LaIMdSy4tSuvC/ZW+nRnTWn/izjB/McBvCbpqUiRw5e11+aaqr0
         rID6wAJKagqxQ==
Date:   Wed, 28 Jul 2021 12:06:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 12/12] xfs: Error tag to test if v5 bulkstat skips
 inodes with large extent count
Message-ID: <20210728190628.GB3601443@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-13-chandanrlinux@gmail.com>
 <20210727231055.GV559212@magnolia>
 <8735ryx5o9.fsf@garuda>
 <87zgu6vqf8.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgu6vqf8.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 28, 2021 at 01:08:35PM +0530, Chandan Babu R wrote:
> On 28 Jul 2021 at 12:53, Chandan Babu R wrote:
> > On 28 Jul 2021 at 04:40, Darrick J. Wong wrote:
> >> On Mon, Jul 26, 2021 at 05:15:41PM +0530, Chandan Babu R wrote:
> >>> This commit adds a new error tag to allow user space tests to check if V5
> >>> bulkstat ioctl skips reporting inodes with large extent count.
> >>>
> >>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> >>
> >> Keep in mind that each of these injection knobs costs us 4 bytes per
> >> mount.  No particular objections, but I don't know how urgently we need
> >> to do that to test a corner case...
> >>
> >
> > How about using the existing error tag XFS_RANDOM_REDUCE_MAX_IEXTENTS instead
> > of creating a new one? XFS_RANDOM_REDUCE_MAX_IEXTENTS conveys the meaning that
> > we use a pseudo max data/attr fork extent count. IMHO this fits into the
> > bulkstat testing use case where we use a pseudo max data fork extent count.
> 
> Sorry, I actually meant to refer to XFS_ERRTAG_REDUCE_MAX_IEXTENTS instead of
> XFS_RANDOM_REDUCE_MAX_IEXTENTS.

Works for me!

--D

> 
> -- 
> chandan
