Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36FC2931CD
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 19:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784056822; cv=none; b=dOsnR69yHkNeX2TannjXsy55KQu0XhcPYQggmHuL61jzVnOHdIQvICpPYCuaxOJA9WNhfJGgz9HsAOdv03DCdTumonFIAo8pdakgA77QQJSg25ygFdUacbMhXV5wSgIB9nNmj/3u+IEIITAENUVLAixz8bOA7DOn+/SQexYWyZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784056822; c=relaxed/simple;
	bh=yqd4MKAtMwnmAxGSUdIx+mohPQm8y+iXnHfZQckwwbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jxmsul5RZepng3i1VM9lsR+dCczLOxsnPltBvnnty0IhV4K1aZTKU9lip2SXno2JclL4t2NhNPpmG6ALEHP8gCkbyDqvYdAp8UcAaz2L2Ay7SWFcYPuEsrTWFTzQI3JWQCsJVTdx2oGzYHSZLRlnfNQOT1Hv9dQdi/tbUsN29Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SWJHQijp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SWJHQijp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784056818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/uKDBVP44I9YE9Zk7Xpf6ZOElFBwIIrrOVbJoZwZECQ=;
	b=SWJHQijpvu+qLoWlzxPj7aQDtb9QTfOowtu5ymLftevVUtUbCuJdftkcb3QZ0xsPaSivpL
	MQr1F3LB8lYMuQfelTLIskqiroPo/fMyCZp9R1Um3dM2ye4ZFCkVQnG05hEfAYfD0huoWZ
	d6bEX/LApUxGwk1TZWRgCF2tdS0Szmo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-IM0-mnCVMgmyM0Z28z-8IQ-1; Tue,
 14 Jul 2026 15:20:15 -0400
X-MC-Unique: IM0-mnCVMgmyM0Z28z-8IQ-1
X-Mimecast-MFC-AGG-ID: IM0-mnCVMgmyM0Z28z-8IQ_1784056814
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB3F5195607C;
	Tue, 14 Jul 2026 19:20:13 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.111])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1B39414;
	Tue, 14 Jul 2026 19:20:12 +0000 (UTC)
Date: Tue, 14 Jul 2026 15:20:08 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ibrahim Hashimov <security@auditcode.ai>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] xfs: bounds-check buffer log item's dirty bitmap
Message-ID: <alaL6C6Gy717Jk2J@bfoster>
References: <20260714172730.73160-1-security@auditcode.ai>
 <20260714175532.74257-1-security@auditcode.ai>
 <20260714180152.GH7398@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714180152.GH7398@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On Tue, Jul 14, 2026 at 11:01:52AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 14, 2026 at 07:55:32PM +0200, Ibrahim Hashimov wrote:
> > xlog_recover_do_reg_buffer() replays each dirty region described by a
> > buffer log item's bitmap into the buffer read for that item:
> > 
> > 	memcpy(xfs_buf_offset(bp, (uint)bit << XFS_BLF_SHIFT),
> > 		item->ri_buf[i].iov_base,
> > 		nbits << XFS_BLF_SHIFT);
> > 
> > The destination offset (bit/nbits, from the logged dirty bitmap) and the
> > buffer size (from the logged blf_len) are both attacker-controlled and
> > otherwise unrelated, yet the only thing bounding the copy is an ASSERT(),
> > which compiles away on production kernels. A crafted image logging a
> > small blf_len together with a bitmap bit past the end of that buffer
> > drives the memcpy() past the buffer's allocation, corrupting adjacent
> > kernel heap during mount-time log recovery. This is reachable by anyone
> > who can get a crafted image mounted -- the malicious-filesystem threat
> > model XFS already guards against elsewhere.
> > 
> > Turn the ASSERT() into a real XFS_IS_CORRUPT() check that aborts recovery
> > of the buffer with -EFSCORRUPTED, consistent with the validate-and-fail
> > idiom already used in xlog_recover_do_inode_buffer() and
> > xfs_dquot_item_recover.c. xlog_recover_do_reg_buffer() therefore becomes
> > STATIC int and its three callers propagate the error.
> > 
> > Found and confirmed with KASAN on a CONFIG_XFS_DEBUG=n build: the crafted
> > image trips a slab-out-of-bounds write before this change and fails
> > recovery cleanly with -EFSCORRUPTED after it.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
> > Assisted-by: AuditCode-AI:2026.07
> 
> Looks fine to me now, thanks for making those edits.
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
> > ---
> > v4: fold xlog_recover_do_dquot_buffer()'s bool return and error
> >     out-parameter into a single int return (1 if dirty, 0 if clean, or a
> >     negative errno on failure), per Darrick's review. No behavioural
> >     change.
> > v3: trim the changelog per Brian Foster's review. Add a Fixes: tag --
> >     the destination-bounds check has been an ASSERT since the initial git
> >     import (2.6.12-rc2), so it predates the git era.
> > v2: resend; v1 went out with an empty Subject line due to a local
> >     git send-email glitch (leading blank line in the patch file).
> > 
> >  fs/xfs/xfs_buf_item_recover.c | 56 ++++++++++++++++++++++++++++-------------
> >  1 file changed, 40 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> > index 02b95b89d1b5..cf2b07ebc6f3 100644
> > --- a/fs/xfs/xfs_buf_item_recover.c
> > +++ b/fs/xfs/xfs_buf_item_recover.c
...
> > @@ -1081,11 +1103,10 @@ xlog_recover_buf_commit_pass2(
> >  			goto out_release;
> >  	} else if (buf_f->blf_flags &
> >  		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
> > -		bool	dirty;
> > -
> > -		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
> > -		if (!dirty)
> > +		error = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
> > +		if (error <= 0)
> >  			goto out_release;

I might suggest something like:

		/* reset error since > 0 means to write the buffer */

... or maybe we can phrase that better. But regardless LGTM now as well,
thanks:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> > +		error = 0;
> >  	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
> >  			xfs_buf_daddr(bp) == 0) {
> >  		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
> > @@ -1105,7 +1126,10 @@ xlog_recover_buf_commit_pass2(
> >  			xfs_buf_relse(rtsb_bp);
> >  		}
> >  	} else {
> > -		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> > +		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
> > +						   current_lsn);
> > +		if (error)
> > +			goto out_release;
> >  	}
> >  
> >  	/*
> > -- 
> > 2.50.1 (Apple Git-155)
> 

