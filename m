Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5676522338
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 21:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747172240; cv=none; b=hqpo3D6dIyLkthLFhdfkl4IBP4zlHMYkLRG6KN7JzbKEjGYZjNsbIk8B20+eW4tg/rPtfOO/7jtusT1MKxPalE2ZYhoeQYu6fSV4/oUVedJKlqDvXuz5of3OsDiKvQvDIYy2LvS+x5mSjTfm3Fv6AvB3aEGEjsLuId4Ymn79REo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747172240; c=relaxed/simple;
	bh=kkwLr4+ZKxSyCIrCuA3Ysh2CP1sTrzFvfBv2TuA38Vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxgs8Ny5Npd8vmUhxK90aNmdEteeHULbOJQOZK0sX+XeMWVB6herAPHJsBeF/a99eAetz5nljIgLe5J1oDj5ZvVQI0HnRYRnlU+d81iAkvQ4Jyp6wzU6NE/B21LnOWcIp2ADHtNN/N1p59jNAXAhWMhWMi1+NGcMmcSvwYJVEz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=p5TMdMGW; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="p5TMdMGW"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-af6a315b491so5356100a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 14:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1747172237; x=1747777037; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gfL4aldD/k9cL/F/+Tw+nRa4rFKcv18oFkCPZuBJxtc=;
        b=p5TMdMGW4mIsBPlCraLKRFPEAktrisA4utrx6Fk7bXWPJz5U5uyUGZOv2VafsoH9p1
         lO1/dnO7wONw+/Qsez5iCtomdSLTnwoATN+M7GJosE5f7c8IZ50HJVZCWSb+J4K9xDTm
         RR+dijQs3Flt5kqyscTK/PBpO9w2I4Z7H+kHDAGlWuN1lgq31putB8zvTFyuNy76CSDs
         s0AbkB7kDPTP2FmPUObxdnc5JgOnFS3doPDLLElYP4nB3fVBIiusss3Mu2h8f7umTHtA
         G4DubHVNL+GDM/aCjdOxEg0YCQU33bbsoERk61E5bGLE5p3ZzjvUnYfhHXQFL4lIBTmW
         8HJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747172237; x=1747777037;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gfL4aldD/k9cL/F/+Tw+nRa4rFKcv18oFkCPZuBJxtc=;
        b=lJW0hwS5Vr4NG6BR/o2wlI/zBgaA4DfDFjuLqzdrQiiPfI63LwvdBa3HKheuNWsyeW
         uUZUrBszc8QPOcUXXaJrHzayeBjbZ2DxBbWxeoRXA7TPHTzA/6LS03j4p2b/bz5tW+fy
         GQmwwLIyGoOzatZR4v5icnx0bUNLTQF4DThVorMj3E0FojTlVThG4zgutPmyAdmZw1CP
         iEginUEOQ/JzM8lYASJ0aEu8iJRGPJ2qbe1ZhLqAv76IMl68ZfNlu6pI6IJN2zBU7xVz
         YMC1HLWuNKPI0bAsjgYjbaezDA22Ii1Y+RdSWNkn6y8maGtbBAqJyByXTRRyiBKr7sYq
         ru+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXK5TYxZAm115ee+FNC3SwAdKb4AjNshnBHz98gJ0xRrS5fgbO/QJn7mXICCohFTlwbVg72e0dJPAk=@vger.kernel.org
X-Gm-Message-State: AOJu0YycDrUR6RmpXM7s9OUab5A0augCodrP0H9eVALTxnSQ+so7e2aC
	0d62s1T4SCc4QGrtALV++rmLrUKEAQZo6ZBSIOHW0bEZQXC+fEUTM2PEi4dAdQ0=
X-Gm-Gg: ASbGnct/4FYXBj/qQRWMhfZ5WPIpfMK4dnZbuOVuqRGFUMSd6c57PXaDRRhr+bidVE6
	dYx/L3UtNUHrdyhk77vKX9WDrGcM8Ugf0xwmiVH/DXMrNjjn8g8TKhg25DBtvETexF+MJ1Tkl3C
	ouHqHuQWcOuVPbo5DehOa1O1Fi9ziiXX9/AufDs2nlbvcTnNTwa3k0sRlomd786D2vciqeoemGi
	rNhRMbIR0NWWLpig1eyzL3HjoUHAJiOLDuarFZ6xqUygXcaFveZh6eu/1H/sxMEflA8kUOyjfX0
	aFgwQo9rycPtetl6d5W8dm/zAuuYqk42peIxTg7ZreorKBQHqe0H7jJDK3q7oHqCCOZZ2fnigV4
	Yl1cGWkvRLfW5J/welYi/GQQQ
X-Google-Smtp-Source: AGHT+IFWIJ3Wb7cCrtW1fvZR1IrOX3xnWBLrjcvh6wJX5v7n6dlGHBw1OrJ6xR/g1GILcGayZ10Oqw==
X-Received: by 2002:a17:903:8c3:b0:22e:5882:1812 with SMTP id d9443c01a7336-2319819ec3emr13383095ad.32.1747172237554;
        Tue, 13 May 2025 14:37:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82c3063sm85694995ad.244.2025.05.13.14.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 14:37:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uExJK-000000039bc-1NkR;
	Wed, 14 May 2025 07:37:14 +1000
Date: Wed, 14 May 2025 07:37:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org,
	cen zhang <zzzccc427@gmail.com>
Subject: Re: [PATCH] xfs: mark the i_delayed_blks access in xfs_file_release
 as racy
Message-ID: <aCO7injOF7DFJGY9@dread.disaster.area>
References: <20250513052614.753577-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513052614.753577-1-hch@lst.de>

On Tue, May 13, 2025 at 07:26:14AM +0200, Christoph Hellwig wrote:
> We don't bother with the ILOCK as this is best-effort and thus a racy
> access is ok.  Add a data_race() annotation to make that clear to
> memory model verifiers.

IMO, that's the thin edge of a wedge. There are dozens of places in
XFS where we check variable values without holding the lock needed
to serialise the read against modification.

For example, i_delayed_blks updates are protected by the ILOCK, so
there's a data race if we read it without the ILOCK held.  We do
this in:

	xfs_file_release() - the one this patch addresses
	xfs_getbmap() - unlocked access for data fork
	xfs_can_free_eofblocks() - checked twice without locking
	xfs_inodegc_set_reclaimable() - unlocked, but debug
	xfs_inode_has_filedata() - unlocked via xfs_inactive()
	xfs_vn_getattr() - unlocked
	xfs_qm_dqusage_adjust() - unlocked ASSERT

And that's just this one variable in the inode - there are lots of
others we check without bothering to lock the inode.

e.g. pretty much everythign that xfs_vn_getattr() reads is a data
race because "unlocked racy access" is the way stat is designed to
work on Linux.

Hence my question - are we now going to make it policy that every
possible racy access must be marked with data_race() because there
is some new bot that someone is running that will complain if we
don't?  Are you committing to playing whack-a-mole with the memory
model verifiers to silence all the false positives from these
known-to-be-safe access patterns?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
