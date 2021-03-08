Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB6DC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 03:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 966D264DE5
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 03:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbhCHD4E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 22:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232535AbhCHD4D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Mar 2021 22:56:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3E8264DE5;
        Mon,  8 Mar 2021 03:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615175763;
        bh=+9yd+uVgQXOd0lh8eQNlG7LarQ3BnpuphGFZ2cAZl4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UGyTN1jqYbdVUF9q2WIikgYMnMbmuPG6BbuL+FSrX54IeFtn3w+t2omhrI3mlyLYO
         z0EGwMxwQQiYWm5PiaLMrHc+RFCyNQYRpebeUCtcCelxcth3ScpUMWUXGpYi5EBLdY
         OORX72rIbnq7Um5dZDZj1KtLi5Dw9HpO7SbmnghXn0Lo3hIKOtgYwZWiBe7NyB7hfA
         VeRlckXFQvy/Y8SsMpGc6dHyhcg7cURFDXJjeLCpkVG7Gk2cJjXWaf0Dr16lYdJpay
         qM7BcptitS2PD7jsN7oe29ivLudKbQkWhtDvr8K/eSVYThWI2lEsbMjU0jaS+3qOE0
         bq/OO9ZDW9JCw==
Date:   Sun, 7 Mar 2021 19:56:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v2.1 2/4] xfs: avoid buffer deadlocks when walking fs
 inodes
Message-ID: <20210308035602.GK3419940@magnolia>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
 <161514875165.698643.17020544838073213424.stgit@magnolia>
 <20210307203638.GJ3419940@magnolia>
 <20210307223703.GX4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307223703.GX4662@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 09:37:03AM +1100, Dave Chinner wrote:
> On Sun, Mar 07, 2021 at 12:36:38PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When we're servicing an INUMBERS or BULKSTAT request or running
> > quotacheck, grab an empty transaction so that we can use its inherent
> > recursive buffer locking abilities to detect inode btree cycles without
> > hitting ABBA buffer deadlocks.
> > 
> > Found by fuzzing an inode btree pointer to introduce a cycle into the
> > tree (xfs/365).
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> > v2.1: actually pass tp in the bulkstat_single case
> > ---
> >  fs/xfs/xfs_itable.c |   42 +++++++++++++++++++++++++++++++++++++-----
> >  fs/xfs/xfs_iwalk.c  |   32 +++++++++++++++++++++++++++-----
> >  2 files changed, 64 insertions(+), 10 deletions(-)
> 
> Looks ok, but I can't help but wonder if this case should flag
> corruption if lock recursion does actually occur...

Hm.  Scrub will, since it checks the level and block number of every
pointer it follows.  IIRC the rest of the btree code isn't as paranoid
about things like that.

> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Anyway, thanks for the reviews.

--D

> -- 
> Dave Chinner
> david@fromorbit.com
