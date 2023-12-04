Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sl0ngj9n"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9018B92
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 20:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a47UyY9kw364eCyudXvO9xy0gdfgP73k3u0Em9VQHdk=; b=sl0ngj9n8OT5EavQKYscbIrEqQ
	oRxgKbZ5wRe+Xz/jrcoL13X9aUX2YQm2hJDQ6eaikxrnLS0+fmje+Ix4H9MgAhz94xebuGEBtr+Uc
	OWZq7buXBwcdp3ctoqJZsyJXUK+2Ce2xV2NTvC1Z24tCI0xyfOCqPZ7MhVAtOBdqYkz31wzOfnLPB
	iqyUg3kBBQPfsrh55A/MmSARXcdLoNftJTzQ6fmgQNr4HlnfjGzyIePqppar6SjuEwvAdz1PFg4Dx
	0RdMdPXu2mXZ+VuqNTgdqclos3JKqju3L6VoSgI9VuMUuSDZhFgKByyqqB13AApFPF9DwFwQLo708
	u51b3ozw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rA0sW-0030FL-0i;
	Mon, 04 Dec 2023 04:48:20 +0000
Date: Sun, 3 Dec 2023 20:48:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: repair quotas
Message-ID: <ZW1aFIC1OxfApK5z@infradead.org>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
 <170086928871.2771741.2277452744114090363.stgit@frogsfrogsfrogs>
 <ZWgetfZA0JLz94Ld@infradead.org>
 <20231130221015.GR361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130221015.GR361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 30, 2023 at 02:10:15PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 29, 2023 at 09:33:41PM -0800, Christoph Hellwig wrote:
> > > @@ -328,7 +328,6 @@ xchk_quota(
> > >  		if (error)
> > >  			break;
> > >  	}
> > > -	xchk_ilock(sc, XFS_ILOCK_EXCL);
> > >  	if (error == -ECANCELED)
> > >  		error = 0;
> > >  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,
> > 
> > What is the replacement for this lock?  The call in xrep_quota_item?
> 
> The replacement is the conditional re-lock at the start of xrep_quota.

Hmm.  but not all scrub calls do even end up in the repair callbacks,
do they?  Ok, I guess the xchk_iunlock call in xchk_teardown would have
just released it a bit later and we skip the cycle.  Would have been
a lot easier to understand if this was in a well-explained
self-contained patch..

> Not sure what you meant about "we used just lock the exclusive lock
> directly without tracking it" -- both files call xchk_{ilock,iunlock}.
> The telemetry data I've collected shows that quota file checking is
> sorta slow, so perhaps it would be justified to create a special
> no-alloc dqget function where the caller is allowed to pre-acquire the
> ILOCK.

My confusions was more about checking/using sc->ilock_flags in the
callers, while it is maintained by the locking helpers.  Probably not
*THAT* unusual, but I might have simply been too tired to understand it.
