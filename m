Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9817FC169F9
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 18:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6850A24670
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 18:40:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EYr89rMB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgBSSk0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 13:40:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48068 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBSSkZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 13:40:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TUVBYSnGklAbCqPNef/VRmvWK+JEchnztqIe8WhQfRE=; b=EYr89rMBe/Rg7Hrydlw89DKU6U
        sKhfDOzFM1YdpJVcJJDfTFIwoq9HoGrIGm+XvbaTBlfySpmS12GAFJCZxM74+MV+ZOaxXYTpt/MSK
        AfTIjhuyQxI8XqbHSYYsLwxtd6/ma8OpAaQRmwCiCvfkTVzS3NQXN9QPlNLefCW+sdnFtjS0VI4ZQ
        V0ytU4Frzz3kf3DJ7iJpxdtrzsTlH8tZn6roFL8TO7TDUMB5jagwiBoheIuKj9S1gk2ED3Cu4z1+7
        xzi7qX6VP+UzFL59ihFagLg3+M8xfHiZQ8VPuP9fnjksU0N2opqE0Bd1gxr9xHiQsCg2+88ltskkG
        ENwKI3zQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4UGh-0005s4-HY; Wed, 19 Feb 2020 18:40:19 +0000
Date:   Wed, 19 Feb 2020 10:40:19 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20200219184019.GA10588@infradead.org>
References: <20200214185942.1147742-1-preichl@redhat.com>
 <20200217133521.GD31012@infradead.org>
 <20200219044821.GK9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219044821.GK9506@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 08:48:21PM -0800, Darrick J. Wong wrote:
> > > +static inline bool
> > > +__xfs_rwsem_islocked(
> > > +	struct rw_semaphore	*rwsem,
> > > +	bool			shared,
> > > +	bool			excl)
> > > +{
> > > +	bool locked = false;
> > > +
> > > +	if (!rwsem_is_locked(rwsem))
> > > +		return false;
> > > +
> > > +	if (!debug_locks)
> > > +		return true;
> > > +
> > > +	if (shared)
> > > +		locked = lockdep_is_held_type(rwsem, 0);
> > > +
> > > +	if (excl)
> > > +		locked |= lockdep_is_held_type(rwsem, 1);
> > > +
> > > +	return locked;
> > 
> > This could use some comments explaining the logic, especially why we
> > need the shared and excl flags, which seems very confusing given that
> > a lock can be held either shared or exclusive, but not neither and not
> > both.
> 
> Yes, this predicate should document that callers are allowed to pass in
> shared==true and excl==true when the caller wants to assert that either
> lock type (shared or excl) of a given lock class (e.g. iolock) are held.

Looking at the lockdep_is_held_type implementation, and our existing
code for i_rwsem I really don't see the point of the extra shared
check.  Something like:

static inline bool
__xfs_rwsem_islocked(
	struct rw_semaphore	*rwsem,
	bool			excl)
{
	if (rwsem_is_locked(rwsem)) {
		if (debug_locks && excl)
			return lockdep_is_held_type(rwsem, 1);
		return true;
	}

	return false;
}

should be all that we really need.
