Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2523C4338F
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Aug 2021 17:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 781F461220
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Aug 2021 17:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhHVRYD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Aug 2021 13:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhHVRYD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 22 Aug 2021 13:24:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04AA861261;
        Sun, 22 Aug 2021 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629653002;
        bh=qkYaRmTdTGq+8O0P+wz9ZakfjOb2/oaIYm5cKC1CmKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m+NhmpBed2Uz7Hled24LDz1rLnwteQqTt6gtPm0Wsgk+B6RKWqACn+XzT5xLwaNVu
         h1HJ4I34pG4Ap2F+MSwvSsSBXwadGjG8hkLS4LiwltbDMw6S98UA1up3C8bj4A05N2
         6+JIpoKOCnS0H3t4WwIdGOvzm0qAOs53DB4of8ZKQ44lTaM+NN22NQCKqhgBTHE7Vn
         Q0mg9TtY81h7szD0ab5KGU0SMQ2sfMkdliGBCI8IKc1EDAq1I0qnd+egCOSM0z36wy
         8+8Wy60YKlD4PQUmTf25komtE4Y4ZIeBJFD2gCwtl9z7FiysvD4eIt4cLyyr86AGJf
         UR/JE8ergQEaA==
Date:   Sun, 22 Aug 2021 10:23:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] generic: test shutdowns of a nested filesystem
Message-ID: <20210822172321.GA12640@magnolia>
References: <162924439425.779465.16029390956507261795.stgit@magnolia>
 <162924440518.779465.6907507760500586987.stgit@magnolia>
 <YSIymUFbWA9xNcIK@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSIymUFbWA9xNcIK@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 22, 2021 at 07:18:49PM +0800, Eryu Guan wrote:
> On Tue, Aug 17, 2021 at 04:53:25PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > generic/475, but we're running fsstress on a disk image inside the
> > scratch filesystem
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/rc             |   20 +++++++
> >  tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/725.out |    2 +
> >  3 files changed, 158 insertions(+)
> >  create mode 100755 tests/generic/725
> >  create mode 100644 tests/generic/725.out
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 84757fc1..473bfb0a 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -631,6 +631,26 @@ _ext4_metadump()
> >  		$DUMP_COMPRESSOR -f "$dumpfile" &>> "$seqres.full"
> >  }
> >  
> > +# Capture the metadata of a filesystem in a dump file for offline analysis
> > +_metadump_dev() {
> > +	local device="$1"
> > +	local dumpfile="$2"
> > +	local compressopt="$3"
> > +
> > +	case "$FSTYP" in
> > +	ext*)
> > +		_ext4_metadump $device $dumpfile $compressopt
> > +		;;
> > +	xfs)
> > +		_xfs_metadump $dumpfile $device none $compressopt
> > +		;;
> > +	*)
> > +		echo "Don't know how to metadump $FSTYP"
> 
> This breaks tests on filesystems other than ext* and xfs. I think it's
> OK if we only want to use it in failure path, but it's better to
> describe the use case in comments.

Ok, I'll make a note of that in the comment.

"Capture the metadata of a filesystem in a dump file for offline
analysis.  Not all filesystems support this, so this function should
only be used to capture information about a previous test failure."

> And Im' wondering if should honor DUMP_CORRUPT_FS, and only do the dump
> when it's set.

Yes.  Will fix that in the next release.

--D

> Thanks,
> Eryu
