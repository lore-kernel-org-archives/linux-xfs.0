Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CDA8286A
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 17:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723052168; cv=none; b=I88MMzP/yPRskXQIvEtyMsIv2heH51tj0doT2Ecnw0rR1YGM1R5nIj3s+yk8nL+TmrqoNYfpplUBwk6vCyPfeVsMW1AllbYFhwXCEp79x1sW+5cGT9c6E437IJECpfPD2TVctnGcst3fNKXcbzemJ9G/ZBqdA3WcSv1Zgoj3lCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723052168; c=relaxed/simple;
	bh=y2Yx6QpyENIwkRZLR+yOAMn3SqWWEgP2+XwuPrYw5yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MvSIC5inHBoCFoMpeJcyWnnpv23pcRNTQ2z9zcPTf8KC8KrnOQXjteV2kuHTZWZM9Fu0e0BOldZ42lAvs4QSYs4mQ3i/keLCsd+ivWIEqku2KCB07Ov/kUgU9MoeO/03CLjOg2znVIEfhxeH8XSefeItKJH8ojZric4S1mEDf4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CnBroLlT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CnBroLlT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723052166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B3B3ADtfIUAOQjxbQ+DdQjL+7JbU2jaOUKwDFuyo590=;
	b=CnBroLlTJ86BFumAHtytNnvSvqs2jd1lAZqVLF5y5Rj8v95/AmJF1tjIO446BHtBFkjAW0
	dpcoj213bFFg/PMQX8nbaC5qvrjMYZGa+paNWastAk9AfUz4cDL4FwzpC2bHIw3a6kl9JL
	YMIt8Lu2B1suIDPvvKeSi7WHrqfiWA4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-TwNzmph6M6Wl2dysBk14vQ-1; Wed,
 07 Aug 2024 13:36:00 -0400
X-MC-Unique: TwNzmph6M6Wl2dysBk14vQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1478F1944D30;
	Wed,  7 Aug 2024 17:35:59 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.103])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F29F01955E8C;
	Wed,  7 Aug 2024 17:35:57 +0000 (UTC)
Date: Wed, 7 Aug 2024 12:35:55 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [PATCH] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <ZrOwe4kzu88wVBrD@redhat.com>
References: <20240802222552.64389-1-bodonnel@redhat.com>
 <20240802232300.GK6374@frogsfrogsfrogs>
 <ZrDkx1gFEGDCvUmS@redhat.com>
 <40fa60fa-b7f0-40c8-87d6-c083b028c6c2@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40fa60fa-b7f0-40c8-87d6-c083b028c6c2@sandeen.net>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Aug 07, 2024 at 12:07:37PM -0500, Eric Sandeen wrote:
> On 8/5/24 9:42 AM, Bill O'Donnell wrote:
> > On Fri, Aug 02, 2024 at 04:23:00PM -0700, Darrick J. Wong wrote:
> >> On Fri, Aug 02, 2024 at 05:25:52PM -0500, Bill O'Donnell wrote:
> >>> Fix potential memory leak in function get_next_unlinked(). Call
> >>> libxfs_irele(ip) before exiting.
> >>>
> >>> Details:
> >>> Error: RESOURCE_LEAK (CWE-772):
> >>> xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
> >>> xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
> >>> xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
> >>> #   74|   	libxfs_buf_relse(ino_bp);
> >>> #   75|
> >>> #   76|-> 	return ret;
> >>> #   77|   bad:
> >>> #   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
> >>>
> >>> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> >>> ---
> >>>  db/iunlink.c | 1 +
> >>>  1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/db/iunlink.c b/db/iunlink.c
> >>> index d87562e3..3b2417c5 100644
> >>> --- a/db/iunlink.c
> >>> +++ b/db/iunlink.c
> >>> @@ -72,6 +72,7 @@ get_next_unlinked(
> >>>  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
> >>>  	ret = be32_to_cpu(dip->di_next_unlinked);
> >>>  	libxfs_buf_relse(ino_bp);
> >>> +	libxfs_irele(ip);
> >>
> >> I think this needs to cover the error return for libxfs_imap_to_bp too,
> >> doesn't it?
> > 
> > I considered that, but there are several places in the code where the
> > error return doesn't release the resource. Not that that's correct, but the
> > scans didn't flag them. For example, in bmap_inflate.c, bmapinflate_f()
> > does not release the resource and scans didn't flag it.
> 
> Upstream coverity scan does flag it, CID 1554242 (that CID actually covers
> both instances of the leak).

Ah, thanks. I'll send a v2.
-Bill


> >>>  
> >>>  	return ret;
> >>>  bad:
> >>> -- 
> >>> 2.45.2
> >>>
> >>
> > 
> > 
> 

