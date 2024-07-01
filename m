Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B09443D
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 01:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719797235; cv=none; b=LLc4Ha2NNU2b0DK5lGOyGNhwAEEcGvQRnW3AIPKJoQkFMJFBCbfKyEoHdp3NWI0ar9acDipqj1Wi0l7lLRE7jlni0GqP+O8OPT54NpDCzESZzRiBMFOZdvGhs0HiUaw5AKicR1wRbB3DGcaWBryw3Ja0QL9pJLqteAhj1SJbPK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719797235; c=relaxed/simple;
	bh=4UPsK3W0xg6f7Oqk7KOfwOsBuQ3ospZdG+71kQMoZak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sJUh3PiXtHbP3nT06a7MwfEld37kWb6/+MMuZt5/QTv15KF4knGeZlgPBtrTctz6X47JFlGxkgYZnSzVJSMN68xtswIt6peY6NcP0juKeZ9alQ4AJXTVOIj6tLlrfAbalJ4yTRkVLu21uPG2YQqBrxXX9W4eNAIY859f/jxVBuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mX1Ee0zt; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mX1Ee0zt"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70abb539f41so550157b3a.2
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2024 18:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1719797233; x=1720402033; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q24NLPny9tZ6qSMMbD3A4doZO97oppQ4RDUcUrg8mNc=;
        b=mX1Ee0zt1uJxqpU6NUfOCAoFun5Eeu5kqV530hcBfaFqRrNRztsYR02JPdPRrUR8v0
         STTadjjUvrE2KZ/wjQCbDxHXwcKS4Twzx4C5NBmXTkeAcx7D4rN4gJz5GaJP7ktEbkGj
         KeCE36YAYXJDO1DRQrJt/hDKzv1ZzftmXq6BO+gxJIsddvb02pDZgmqgId8CXQOmCYDs
         iZ/XeuCGUtctvskV2pV109SaYCNiq9/yA+yik4yAVbJLh+JieOfCDUNoOWD5GcN28yjA
         Kf5ij0qGU3PI0sxitNAYzneA3Oh+k/LVWJi3arkKIxuxLGgqTxCNZingeOmzTG8Czgt7
         8fRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719797233; x=1720402033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q24NLPny9tZ6qSMMbD3A4doZO97oppQ4RDUcUrg8mNc=;
        b=itf2J7EEPbm3Lg22uzh73QcS0HnrHfAlZAZahBRmgwzggr36RZdRaN5W6Nj98OfrpK
         NsLeuuq1kLJ2M5tv8Kc8P4qjy8nXGxKSPVC8f0elQQl2FPSaHj5X1pPIyWzssk9YaZMM
         /3TD0kvqoqiIcNhUamThIZ0rPEIfc11qBkV5z2ttD/25j5gaphr2M3hSvVI62jHHfwSm
         Y8R0SgLI4pt+gejZWelZmHI5gdEQXCxIy5NMbkZ5sIQozFDA34TxzqjvlhtCcvC8et4b
         dXKXr3FqLIOOCtOvtYcZ2w+qGS1aZfm5kaik3kKlUdpw0bMx/LhLlyD1smZ2Rrt8gotc
         VlSA==
X-Forwarded-Encrypted: i=1; AJvYcCW2g0gAdfRL9fPqp5OQEXa0PbuheTXeqdL35xi+Kbul1n8mat1ST/yGDiQAwn3fPQNUU6DYQS5C1UfmrmnEf6Z70Rio6kcNZ/qe
X-Gm-Message-State: AOJu0Yx0smaMBppBoJY1vzLIwUOfaoBKii23pkoVnjrhRHwK6qGlyilx
	w/E2PfbBBX/YY2Ie0Df/2MOpoaqBSFTMl1KR0P5rvOqYrG30y94eMfTfrvCVDmI=
X-Google-Smtp-Source: AGHT+IF/v1a2dc0MqjXwbk8N7olkBJSt5jiLDqrI6B/p6VH0v7JJVuukX99qwbHgykGIaFqr7hfq8g==
X-Received: by 2002:a05:6a20:9191:b0:1be:d260:93c1 with SMTP id adf61e73a8af0-1bef60fce2bmr7761659637.9.1719797233046;
        Sun, 30 Jun 2024 18:27:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac1539438sm53635115ad.161.2024.06.30.18.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 18:27:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sO5oz-00HNbl-2N;
	Mon, 01 Jul 2024 11:27:09 +1000
Date: Mon, 1 Jul 2024 11:27:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: honor init_xattrs in xfs_init_new_inode for !attr
 && attr2 fs
Message-ID: <ZoIF7dEBkd4YPlSh@dread.disaster.area>
References: <20240618232112.GF103034@frogsfrogsfrogs>
 <20240619010622.GI103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619010622.GI103034@frogsfrogsfrogs>

On Tue, Jun 18, 2024 at 06:06:22PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 18, 2024 at 04:21:12PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xfs_init_new_inode ignores the init_xattrs parameter for filesystems
> > that have ATTR2 enabled but not ATTR.  As a result, the first file to be
> > created by the kernel will not have an attr fork created to store acls.
> > Storing that first acl will add ATTR to the superblock flags, so chances
> > are nobody has noticed this previously.
> > 
> > However, this is disastrous on a filesystem with parent pointers because
> > it requires that a new linkable file /must/ have a pre-existing attr
> > fork.

How are we creating a parent pointer filesystem that doesn't have
XFS_SB_VERSION_ATTRBIT set in it? I thought that mkfs.xfs was going
to always set this....

> > The preproduction version of mkfs.xfs have always set this, but
> > as xfs_sb.c doesn't validate that pptrs filesystems have ATTR set, we
> > must catch this case.

Which is sounds like it is supposed to - how is parent pointers
getting enabled such that XFS_SB_VERSION_ATTRBIT is not actually
set?

> > Note that the sb verifier /does/ require ATTR2 for V5 filesystems, so we
> > can fix both problems by amending xfs_init_new_inode to set up the attr
> > fork for either ATTR or ATTR2.

True, but it still seems to me like we should be fixing mkfs.xfs and
the superblock verifier to do the right thing given this is all
still experimental and we're allowed to fix on-disk format bugs
like this.

Can we add that to the superblock verifier so that the parent
pointer filesystems will not mount if mkfs is not setting the 
XFS_SB_VERSION_ATTRBIT correctly when the parent pointer feature is
enabled?

Worst case is that early testers will need to use xfs_db to set the
XFS_SB_VERSION_ATTRBIT and then the filesystem will mount again...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
