Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3271B3B52E3
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 05:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785217491; cv=pass; b=sQ8kPSDjCig0e66yH19ehO/Zu5Vk5HrktODOZUT/Juo4taojAac/g6MhCk14Nj0GroUDsvTkPYpkT3qWFGdJUMOJDMBxbxSTxML2TWtLJtws4hdrKiAMLnekfvQlsHUrRuzpuxcdzTM6fbD4AEF/RPlaAWileK23NVn+OB7uIQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785217491; c=relaxed/simple;
	bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CioXhClISyEelhB9BMOhMoDr/cHaEnVqI2MAqMlhGUsXaIRVZSrLFsKSC3X0KWwfdGF5XRgIxTJ3ygZM02h9n3lyuBLdSvnimSPEKKiqm3K56Ny1BgfUYmrURlVzfpHuR4CV4UoiSj5Bo6PUvs+mlOQIc5wvgP7L1lGfQPoj4sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fBjaNva3; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fBjaNva3"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so18463215e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 22:44:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785217488; cv=none;
        d=google.com; s=arc-20260327;
        b=GQOBm2a+Fus+LCqX+9w/TmZjg24stPLgOoC6Pn71f79LgPQ+fWSpXBt7heIWg014mo
         exS3k9+CeS5ZE7V1XK/gjs23HmxYkzQqDe5RhI3uqx059k2PSxBZ1jr4NhpT2damPRTT
         e3BAyWULR+FII4Kin+lt9AQhZhkwsz6rIoOjxj2Lsw31IeSdqA2ZUpmvyGYxDOQMldtY
         SvzwsRNtlT/27D2CHzVT82Q6bm8KU7vFZvqKXnhwcRly+28HXt4FZ606uDTswgzvXRsE
         wUfu+96cp/znOrhPvANTAxOOnAq82Fx98HS4OClgtJUtJNyp48mcQhqZuks9eDcD87OV
         SI6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
        fh=f7a+agKwIlzOUzE2vNu0mQkayASWPsjWnadLZ0axtm0=;
        b=lVyKZiQTeT6kHZjO5HD04mwa7V57NqlMHMegzCREZEiy37I/fphheliU7fQ6ljl6oQ
         BudV3lpR254+SOdOpO+Mqi01Sgt8V81N4KMRGMFlaryYbYusJQP6g8tqNt9u/IBy44LA
         2kUTAsOhUM+JcUIBr/z36Xnas8WqBUjUJdWOOUJ1LsOb3FV6+6QAJYE5l4FdAdJ25OrY
         o7HKpCwtMwliZOZ+gCwLAB8pg3VIwHtyxSxiAMYyDU7t3vg6yiEEgGS0pwF1lyPJ7/AJ
         bOUR3e3dvcNbWx0mxGsVhHoyaoid8FdDl5Dc7/mJ1OziC7Od+mHzC/YcP4xpVCMqvHCY
         HmpQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785217488; x=1785822288; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
        b=fBjaNva39tUoIh3WdRtYTNHX6lXws0r73HuX15d2GPSulNVAVJug2chPtRkCxBctrT
         77fgXWVjRq4svwy/4Iy/mHq2Mf7BuTmIUSZgxS+pqU2tddt6Cz1jc+ba+k++HVdERP2u
         YTlyXEcjikO/XsTWJ+Ib7KoTgYlhV9JyoykvLCA+vLYLlDNa66LY8AA6t63oh39o+Lrm
         wDW/eKsE/q4VyshhT2rSJtcOjGvHaxZDnMcjzV0nygT/7ef6EezQbO67EtJgUo6U/DEU
         l2XoUeUA9dAonr3rbYVmbYUzoHKkN9KcrZ6/3wHbCjbDETMdv9MpHyAbC8TRmJQ3hoe9
         bWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785217488; x=1785822288;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
        b=sGRsrnqZHh28AaY9EQKdCsvZrPZS0VwB7boHVOjtA290MvisSJStspYk9VJRq6dK4d
         CQlt0SPOKcPRsxKdbia0mHbzrCBfLuyJDlqG/OhORR57aHT8NOA1zwYF02fgaFewYClI
         QssdZNFCjIu+rKiEhZfDaun6lASiz1XLGTQhu9DDI+LLXU98ZMsDsjZlpHwzy2wqMXyX
         hYoX7C/gaZ8pom9YRWl/is84z96nM610thwDubN6vf5DWEBYYdCMD1NvsavTPqP8cpnz
         OnLv2rDgbyys592pKA3VXWxVpXwWTPYY4w03P8zNgMFfOk/wOnys82tlfaKQtSRXT7Yl
         +HDQ==
X-Forwarded-Encrypted: i=1; AHgh+RpU+NT+mr8txrrL6He1zR8tBBOYBloJl5Az3zGPlG/9VFxD2kw5R2UhzGpHgYFtV6I59qT3QlPFDEo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzooxg/2evE1Eo6arVBhTNpLprulxU5ahS2ssBVSWP9AoP4UDNl
	4fq3Th5DisfmjHu6lpXkhA7Se4NjxizEXGt4ZOk1Qql/mCXBp79RHLc6jj41FqKohuIjyUmjofL
	7pY5ipBqLaAJVkOJbDWFK20N0ICYTTi1GnPuirXUhaA==
X-Gm-Gg: AR+sD107xQJaX5VW9tzq9VpBlHPe24/BKknAoNMDP2vFPD+SRMdLSLKLkORFVdxkXkN
	z3vlKd0S/KdzLSZ02500wNX9f7uYfT5LCs8UldUi1gx5I1tDvPSfuzIvIA1hrm1iHCE3BTTZVUw
	kwgNB0fB91gqpIpAUxbZ1cVIR94VirpEwOthh3hRmLP0Yv2H3a3Sgl8Y7NXbIjhoCbXcMldMT7n
	wgdCagLHy3dTv3l99/opbyGTZg40xgUyUi3sqe0+L4DmxpyaZYTanOURV4k4tSWZ+uoT27kZjzG
	uobxy0xjnnWGGA52Mx7ph2RV4iRf+wlKJLVPTOxTlUSPXFwmgAOd68GNqm0=
X-Received: by 2002:a05:600c:a012:b0:496:c18c:f9a2 with SMTP id
 5b1f17b1804b1-496c6586ad0mr8148725e9.34.1785217488357; Mon, 27 Jul 2026
 22:44:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724133328.1837318-1-neelx@suse.com> <amgfuk12imPN2XJe@infradead.org>
In-Reply-To: <amgfuk12imPN2XJe@infradead.org>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 28 Jul 2026 07:44:37 +0200
X-Gm-Features: AUfX_mweqQ4DC10RBxGq9-w14Z5dbzAU5cW-2aUZfLxC0EG3IWa7sp-qvz-yJvY
Message-ID: <CAPjX3Fd1KPswrsNe=BeDpkDwi8CmL9HNKcPScMsgGN16MDyVEQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] fstests: introduce fscrypt support for btrfs
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, djwong@kernel.org, 
	David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Jul 2026 at 05:19, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jul 24, 2026 at 03:33:16PM +0200, Daniel Vacek wrote:
> > This is a rebase and cleanup of older patches [0] from Sweet Tea and Josef
> > fixed to work with the recent kernel and btrfs-progs changes.
>
> I'm not sure if you post this just for reference or what the intent here
> is, especially with a cover letter like this that doesn't have much
> information.
>
> Before we doing anything for the btrfs-specific fscrypt changes in
> xfstests, those changes should be accepted upstream first.
>
> Maybe some thing like splitting tests might make sense without that,
> but then it should be posted separately.

Hi Christoph. Thanks for looking into this.

Yeah, I could have been more verbose, perhaps also using an RFC tag. I
wanted to get feedback and a review from a wider audience to see if
this is a viable direction. This is currently the base for my btrfs
fscrypt development testing.
Especially for upstream fscrypt changes, when sending those patches I
was asked about tests support. I understand to keep fstests OOT as
long as the kernel part is in development. But at the same time I'd
like to make fstests complement the kernel part and ensure they are
ready and available for everyone throughout the process. Kinda to
"bundle" them all the next iteration.

Would you suggest otherwise?

--nX
