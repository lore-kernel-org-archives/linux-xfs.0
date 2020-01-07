Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AC1C33C8C
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 14:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58B3221744
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 14:16:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lcu//VlI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgAGOQg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 09:16:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35640 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgAGOQg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 09:16:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4C+pozSKNrqJiB/AIYEw3/ibuenPIrUJw/8Cd+IjSc0=; b=Lcu//VlIHBDN5lodOHG7JldpV
        Rnhf5GDGoQSrOd9rcoa1HspuBdln1rywSG/Yd+kL1zZp/EDr5TCd3ZilrHnEWcwcPyuxUjlJSeEA2
        5bId7shvaXSjUKSkhoKhy1H+DOuaxhenC+T0oGw20KCFLyUfv0Ym/kZGLwaWoChT+k3/PtZH0iKM6
        DxJWIXUE3Um0KO24RR3tp6Ew2GZde4eZPWHEkUGo6vRBhD9PJz/NMxpVvxdEU/ue8cH0KF2Fb89MC
        hXkDNqvTbO5S2JUayJlWfidr4oinpWN2tfPdGrNHq/SZ+c0iYev2qKP0Haa6Ci9vWF/lRq+QmGZZA
        RZGjN2sqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iopes-0004PX-EL; Tue, 07 Jan 2020 14:16:34 +0000
Date:   Tue, 7 Jan 2020 06:16:34 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xfs: disallow broken ioctls without
 compat-32-bit-time
Message-ID: <20200107141634.GC10628@infradead.org>
References: <20191218163954.296726-1-arnd@arndb.de>
 <20191218163954.296726-2-arnd@arndb.de>
 <20191224084514.GC1739@infradead.org>
 <CAK8P3a2ANKoV1DhJMUuAr0qKW7HgRvz9LM2yLkSVWP9Rn-LUhA@mail.gmail.com>
 <20200102180749.GA1508633@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102180749.GA1508633@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 02, 2020 at 10:07:49AM -0800, Darrick J. Wong wrote:
> > Sorry I missed that comment earlier. I've had a fresh look now, but
> > I think we still need to deprecate XFS_IOC_SWAPEXT and add a
> > v5 version of it, since the comparison will fail as soon as the range
> > of the inode timestamps is extended beyond 2038, otherwise the
> > comparison will always be false, or require comparing the truncated
> > time values which would add yet another representation.
> 
> I prefer we replace the old SWAPEXT with a new version to get rid of
> struct xfs_bstat.  Though a SWAPEXT_V5 probably only needs to contain
> the *stat fields that swapext actually needs to check that the file
> hasn't been changed, which would be ino/gen/btime/ctime.
> 
> (Maybe I'd add an offset/length too...)

And most importantly we need to lift it to the VFS instead of all the
crazy fs specific interfaces at the moment.
