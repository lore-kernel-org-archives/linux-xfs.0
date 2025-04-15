Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE461422AB
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 17:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744737441; cv=none; b=HRuwVT9Lgx1GTSNAMPlSfPIiIzdeEehrvYpF3+S6CWk02edQci18y9RT5oUoJUP23buhonV1SX9Cm/U8JDyhl8OjT+unVaTr3nLFaGYCG2b/JQ59AgQfWxEMlF5khORQRSRSPAd7Fpyx5HM1dCTTuLzvUVLXDGnr3RB18wKULLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744737441; c=relaxed/simple;
	bh=3EYkccdfgYl+iU10TIheBx6fuYcT8neNi+LuXY6CQ0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IDy9+BIKGlt61TgPO6DhcpBDCQDim4NlSwHyKel4H3VkkGOBSeR+FS+l2QYa1NEKeBso/Aazx1ZrUlDN46aKWojvLb68EnOLuztVqLTJNNeUfdeiYkIBvDaSqPhO5r3qnp45PMq4mn2dq/cPFPrQuBkvV347urzusbxuM9VkeVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KT8GZIFb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KT8GZIFb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744737439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Alhme/3JFpzAKHYi9P+WIunz7baPOSHjDh3C0kYh/tk=;
	b=KT8GZIFb8Zwdlds7aWdiI58gxXA/rV8H04kZH/TlyhSQinFz/1mZIkQTDZJtRsKfW8Ojfz
	V/PyKC8sJUtt87brY+KtFMovHBZeabxfoKVk9w6KFCrl7k4R4eL3oJwNPCkCqPk3RazJOB
	lUliTuGkOu3I8j7tLPUukkl0KdVnk2k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-rawq9a-IPmaQgCYFqFzoBA-1; Tue,
 15 Apr 2025 13:17:15 -0400
X-MC-Unique: rawq9a-IPmaQgCYFqFzoBA-1
X-Mimecast-MFC-AGG-ID: rawq9a-IPmaQgCYFqFzoBA_1744737434
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82FED19560A1;
	Tue, 15 Apr 2025 17:17:14 +0000 (UTC)
Received: from redhat.com (unknown [10.22.64.67])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 619EC1955BC0;
	Tue, 15 Apr 2025 17:17:13 +0000 (UTC)
Date: Tue, 15 Apr 2025 12:17:10 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH v2] xfs_repair: fix link counts update following repair
 of a bad block
Message-ID: <kywu54v62mf74gv4egjdx6ptbcpl56llgz7uz6ayq2fkbw5tjf@d7ufqgyyyo4g>
References: <20250415150103.63316-2-bodonnel@redhat.com>
 <20250415170757.GT25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415170757.GT25675@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, Apr 15, 2025 at 10:07:57AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 15, 2025 at 10:01:04AM -0500, bodonnel@redhat.com wrote:
> > From: Bill O'Donnell <bodonnel@redhat.com>
> > 
> > Updating nlinks, following repair of a bad block needs a bit of work.
> > In unique cases, 2 runs of xfs_repair is needed to adjust the count to
> > the proper value. This patch modifies location of longform_dir2_entry_check,
> > moving longform_dir2_entry_check_data to run after the check_dir3_header
> > error check. This results in the hashtab to be correctly filled and those
> > entries don't end up in lost+found, and nlinks is properly adjusted on the
> > first xfs_repair pass.
> > 
> > Suggested-by: Eric Sandeen <sandeen@sandeen.net>
> > 
> > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > ---
> > v2: add logic to cover shortform directory.
> > 
> > 
> >  repair/phase6.c | 20 +++++++++++++++++---
> >  1 file changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/repair/phase6.c b/repair/phase6.c
> > index dbc090a54139..8fc1c3896d2b 100644
> > --- a/repair/phase6.c
> > +++ b/repair/phase6.c
> > @@ -2426,6 +2426,23 @@ longform_dir2_entry_check(
> >  
> >  		/* check v5 metadata */
> >  		if (xfs_has_crc(mp)) {
> > +			longform_dir2_entry_check_data(mp, ip, num_illegal,
> > +				need_dot,
> > +				irec, ino_offset, bp, hashtab,
> > +				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
> > +			error = check_dir3_header(mp, bp, ino);
> > +			if (error) {
> > +				fixit++;
> 
> I think what you're trying to do here is to get
> longform_dir2_entry_check_data to try to find directory entries in the
> directory block (no matter how damaged it is).  Then if the dir3 header
> fields are wrong, we bump fixit so that the directory gets rebuilt from
> the salvaged directory entries.  Right?

Yes.

> 
> So I think you could structure this more like:
> 
> 		/* salvage any dirents that look ok */
> 		longform_dir2_entry_check_data(...);
> 
> 		/* check v5 metadata */
> 		if (xfs_has_crc(mp)) {
> 			error = check_dir3_header(mp, bp, ino);
> 			if (error) {
> 				fixit++;
> 				if (fmt == XFS_DIR2_FMT_BLOCK)
> 					goto out_fix;
> 
> 				libxfs_buf_relse(bp);
> 				bp = NULL;
> 				continue;
> 			}
> 		}
> 
> 		if (fmt == XFS_DIR2_FMT_BLOCK)
> 			break;
> 
> 		libxfs_buf_relse(bp);
> 		bp = NULL;
> 	}

Ah, this makes better sense.

> 
> > +				if (fmt == XFS_DIR2_FMT_BLOCK)
> > +					goto out_fix;
> > +
> > +				libxfs_buf_relse(bp);
> > +				bp = NULL;
> > +				continue;
> > +			}
> > +		}
> > +		else {
> > +			/* No crc. Directory appears to be shortform. */
> >  			error = check_dir3_header(mp, bp, ino);
> 
> dir3 headers (as opposed to dir2 headers) are a crc-only feature, so
> this isn't correct either.

Agree.

> 
> >  			if (error) {
> >  				fixit++;
> > @@ -2438,9 +2455,6 @@ longform_dir2_entry_check(
> >  			}
> >  		}
> >  
> > -		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
> > -				irec, ino_offset, bp, hashtab,
> > -				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
> 
> and removing this call means that we never scan a V4 directory at all.

Doh! I'll fix it up and send a v3. Thanks for your review.

-Bill


> 
> --D
> 
> >  		if (fmt == XFS_DIR2_FMT_BLOCK)
> >  			break;
> >  
> > -- 
> > 2.49.0
> > 
> > 
> 

