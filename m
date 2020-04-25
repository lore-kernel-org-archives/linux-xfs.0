Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E33C55185
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 07:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E980E20728
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 07:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kkLBUTgl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgDYHQe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 03:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgDYHQe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 03:16:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E46C09B049
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 00:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LUtrVPOpVq0qehw/4H4appjiVEutH+4bdvjFVyj+dEU=; b=kkLBUTglsuSJzEEU21m/MZVe1B
        j/Ql1ZqTGlwKAbwdrtIYtnxTruqcCfS5yIGX4mFwg4T/dCFtJjnym+TUd8ytm0eZXsapd+u58k/Mr
        mnMOsffpFnnv5ekmJT45xqQ0eZy5CHuNxiiYk7ZuZKhJPVqRac89El2NlQxn8FsD8f971AqT+AIx9
        Wj9FzgxAwDv18kn8DS1/X4UVAxe8KGGbAN/C3IOvPMqqJQi36QExL+HcnseduZJZ5uDWo5i1/N7fs
        aKM51rZDEvKxPGZk6tjmdCYDJ1bBvmQRsuKA8S+mAGmg2augsMdaRWs9+oD3jmTmJ2CchP3V0Rx2+
        XZjsU4gw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSF39-0002dx-NR; Sat, 25 Apr 2020 07:16:31 +0000
Date:   Sat, 25 Apr 2020 00:16:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: don't warn about packed members
Message-ID: <20200425071631.GB30673@infradead.org>
References: <20191216215245.13666-1-david@fromorbit.com>
 <20200126110212.GA23829@infradead.org>
 <029fa407-6bf5-c8c0-450a-25bded280fec@sandeen.net>
 <20200312140910.GA11758@infradead.org>
 <b6c1fed7-9e98-7d35-c489-bcdd2a6f9a23@sandeen.net>
 <20200424103323.GA10781@infradead.org>
 <20200424174254.GN6742@magnolia>
 <955e6514-a3f2-0c04-a20f-c35a32390747@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <955e6514-a3f2-0c04-a20f-c35a32390747@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 24, 2020 at 12:52:45PM -0500, Eric Sandeen wrote:
> seems like it's in for-next, no?
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/include/builddefs.in?h=for-next#n16

Indeed it is.  I still saw the warnings, though, but a "make realclean"
fixed that.   Oh the joys of build systems..

Sorry for the noise.
