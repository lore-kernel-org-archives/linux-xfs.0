Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527E3C00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2413B20692
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 08:57:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qaKEei73"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgAHI5p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 03:57:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58016 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgAHI5p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 03:57:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qYZOX4MN2BVKeqHiH0VTE4qb5nlSzzRTXM4p2InWJLQ=; b=qaKEei73SAog39nzSC3f692iP
        X3ITf8gpehDIqYHYTMC/fLjnUruw1k2otHY9ai2939qu4hKbSu18jUhdPgawodTTBZLDlYwYQIV0D
        VXPqFlbQ+4rem7ZkUfAW1h3IbOUFwC581Bcne2AvyoOVNNxdSo4qJicXzFGsNeN2CJbfy1oEWYiZc
        CiZDza1W2wSCl63/7P35D54MczTsF2KtVr/rZh+9bMEDEpkWpi3CyF1eDIFM9Vf3lvD5Sdo9ILBJI
        7F0/K1XguRgnyb4Rp5NSxUC0tUla9vk8svgVcvM4i/wtPwUsWDO5U7U7roSfzrpy/FmOPXc4nOflN
        QR4Bq0qYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip79r-0002AT-Jc; Wed, 08 Jan 2020 08:57:43 +0000
Date:   Wed, 8 Jan 2020 00:57:43 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xfs: disallow broken ioctls without
 compat-32-bit-time
Message-ID: <20200108085743.GA6971@infradead.org>
References: <20191218163954.296726-1-arnd@arndb.de>
 <20191218163954.296726-2-arnd@arndb.de>
 <20191224084514.GC1739@infradead.org>
 <CAK8P3a2ANKoV1DhJMUuAr0qKW7HgRvz9LM2yLkSVWP9Rn-LUhA@mail.gmail.com>
 <20200102180749.GA1508633@magnolia>
 <20200107141634.GC10628@infradead.org>
 <20200107181614.GA917713@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107181614.GA917713@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 10:16:14AM -0800, Darrick J. Wong wrote:
> Yeah.  Fixing that (and maybe adding an ioctl to set the FS UUID online)
> were on my list for 5.6 but clearly I have to defer everything until 5.7
> because we've just run out of time.
> 
> Uh... I started looking into unifying the ext4 and xfs defrag ioctl, but
> gagged when I realized that the ext4 ioctl also handles the data copy
> inside the kernel.  I think that's the sort of behavior we should /not/
> allow into the new ioctl, though that also means that the required
> changes for ext4/e4defrag will be non-trivial.

Well, we should eventually end up with a common defrag tool (e.g. in
util-linux).  We might as well start of with the xfs_fsr codebase
for that or whatever suits us best.

> The btrfs defrag ioctl also contains thresholding information and
> optional knobs to enable compression, which makes me wonder if we should
> focus narrowly on swapext being "swap these extents but only if the
> source file hasn't changed" and not necessarily defrag?

That sounds like the most useful common API.

> ...in which case I wonder, can people (ab)use this interface for atomic
> file updates?  Create an O_TMPFILE, reflink the source file into the
> temp file, make your updates to the tempfile, and then swapext the
> donor's file data back into the source file, but only if the source file
> hasn't changed?

Sure.
