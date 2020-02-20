Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B68C11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 16:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 194DE206F4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 16:32:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UQSFBhK0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgBTQcf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 11:32:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60680 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728026AbgBTQcf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 11:32:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wt0oTqrFSsIRExLO8+boEdoW06OO7xm2g+5Tv9jc1uY=; b=UQSFBhK0ZhYgrRRWpoWCNTnI+w
        kQHTIB72F3/P/9xK0cDUjf55ZrvUA/UD5Mzwpo73ciddnY6ktjin5V0GMS4bMaQCDB0JyV7JMHVl+
        SIwCnIO2JsPjUgF9G4x+pQeEVz0Cq8IH3F18Tqw1rN6RvEw6WmPu53JKiqpobeULP0b5Y8VoksktZ
        oZCAsMYjsd4NWdFDYY1ZdzB1Twwo585Uoa1lTf0V2gQZcb9bx2tQhxpyotOWsRLZPh0VhTtfsidFp
        AOmJeqIg+4vnc+dkegaHP5pDPKVvkFFMOHmgfrnfe/99F8++F+b3XdfGGk+3yFCom9lV5T/lgAw/G
        HpE7OBnA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4oka-0001Ma-4P; Thu, 20 Feb 2020 16:32:32 +0000
Date:   Thu, 20 Feb 2020 08:32:32 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20200220163232.GA1651@infradead.org>
References: <20200214185942.1147742-1-preichl@redhat.com>
 <20200217133521.GD31012@infradead.org>
 <20200219044821.GK9506@magnolia>
 <20200219184019.GA10588@infradead.org>
 <b718e9e9-883b-0d72-507b-a47834397c5f@sandeen.net>
 <CAJc7PzU8JXoGDm3baSJo2jghOgzKEAHhAe9XvhLdE07JWe5WjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJc7PzU8JXoGDm3baSJo2jghOgzKEAHhAe9XvhLdE07JWe5WjQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 05:30:35PM +0100, Pavel Reichl wrote:
> OK, thanks for the comments.
> 
> Eric in the following code is WARN_ONCE() used as you suggested or did
> you have something else in mind?
> 
> static inline bool
> __xfs_rwsem_islocked(
>         struct rw_semaphore     *rwsem,
>         bool                    excl)
> {
>         if (!rwsem_is_locked(rwsem)) {
>                 return false;
>         }
> 
>         if (excl) {
>                 if (debug_locks) {
>                         return lockdep_is_held_type(rwsem, 1);
>                 }
>                 WARN_ONCE(1,
>                         "xfs rwsem lock testing coverage has been reduced\n");
>         }

Yikes, hell no.  This means every debug xfs build without lockdep
will be full of warnings all the time.
