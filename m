Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF56FC433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 864F520672
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nYDjtaSv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgGOSow (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgGOSow (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:44:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D945FC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 11:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=d29s9gv4WU3v4w/AZEK0Yog0DOY7U3/xDvPR8vYIwwE=; b=nYDjtaSv4rv7L8mYMQa7RBIHSF
        UmxvfRbw6O9VydXfCg9KOsP7QimOAmRgiUtz6aFtVTW+wXqHZMt0NiymX4kE8w8oYmeSsoanOTECY
        hUHQCr6YEAMOwhswfNvFVJleMz4qqfq3Y1yOTD3RG4n5xfPRGJhFj0assHONdxj6nyjECDHuTMMDn
        j5lZNnau0vc2Xfl6jthzrVhSodUgT3A7CYU6GZIPdeQhjbsoD0VDrJMIz2NfAinYqlZEWTil20OKU
        kVCA8BETCac28eQraE9yfzDOpo6SZ0+SanWFN3u4On7Kh22yF3hZgIS9qLHFgiFI9UNYhOl41im9f
        h5DeVx+w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvmOf-0006Il-4m; Wed, 15 Jul 2020 18:44:49 +0000
Date:   Wed, 15 Jul 2020 19:44:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_repair: never zero a shortform '..' entry
Message-ID: <20200715184449.GE23618@infradead.org>
References: <159476319690.3156851.8364082533532014066.stgit@magnolia>
 <159476320951.3156851.9608086404704132538.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159476320951.3156851.9608086404704132538.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 02:46:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Repair has this strange behavior during phase 4 where it will zero the
> parent pointer entry of a shortform directory if the pointer is
> obviously invalid.  Unfortunately, this causes the inode fork verifiers
> to fail, so change it to reset bad pointers (ondisk) to the root
> directory.  If repair crashes, a subsequent run will notice the
> incorrect parent pointer and either fix the dir or move it to
> lost+found.
> 
> Note that we maintain the practice of setting the *incore* parent to
> NULLFSINO so that phase 7 knows that it has to fix the directory.

I think we probably want to take Brians series instead, which does
a few more things in the area.
