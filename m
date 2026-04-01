Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE4B392836
	for <linux-xfs@vger.kernel.org>; Wed,  1 Apr 2026 08:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775030406; cv=none; b=kqJVS1dB+yIcA+1KR8fepSNtzfcTHZSNGyzmEbrURjHUFyZavPoiEnhaUuN5EzIi33WVt+3TDWA+Jqwsh8fEJ+yRKYdjsgvneJGZ/lNEO6RyoGzNH1Cvd4Hsrt4Ml2SNyM2PXvUSsmRerHe3kGKwCfPNUQo+ccV5a/UMbfy0FM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775030406; c=relaxed/simple;
	bh=03qSSHuju/lJ4tsTqb7vD701VBGSi9j0XHGFzbRjYdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWe5E6MwX1uUuxG6dGIa1xxGopFFJLqjzqoPBSBpdsfIGCWY9I0oOrZkw0xtTTj1S0zc2okLLNGNdDvK7mx1OB8/d/CGhsoEQ/RcQgn/ncZ1luih7tlWk5B3aJSlXUYPINeCDSicmb48Bm+k9JoMtk9RtddU7p2nRINswR8u2d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M8/XVAH+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YtyHmQa6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M8/XVAH+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YtyHmQa6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775030401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5nKEUQHHyS8kGw3XVEP/5Y00d6pDO4g6gncshQu61RE=;
	b=M8/XVAH+dBZtKZ5o59A9ea9/KWOiQrt5PTo4ZS4no097z+YglkSSlS2lTqH5laTnenk+lH
	atjl8ly7CcYy2fRzucSO7CSc/BoIEi8T92Be6F/kGOabL+J8Fy+yvKc9m9BWDp3bTD+JHM
	pjqeXU+Aura8S7EQIeqf1ON9/vqj2L0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13--KvN3dtMP6GdUhA39Z-Bfw-1; Wed, 01 Apr 2026 03:59:59 -0400
X-MC-Unique: -KvN3dtMP6GdUhA39Z-Bfw-1
X-Mimecast-MFC-AGG-ID: -KvN3dtMP6GdUhA39Z-Bfw_1775030399
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b24cd2e2b3so37517025ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 01 Apr 2026 00:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775030399; x=1775635199; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5nKEUQHHyS8kGw3XVEP/5Y00d6pDO4g6gncshQu61RE=;
        b=YtyHmQa6D1dXAiYQCok0q5fzpBJQKqNp9s24rZqQ1mrIvGwteZogw/FeV5BMFMf5z8
         ElY/UGnP+6dWgH0ekiZNy1s7GcMn39r+7TA5ucwylN/scCfu7z60Cp/8NCLiYvGgaCtU
         A7DqeLlMB3Ad13Rj93Od9ivbjHVAbnJvp+0bNhL0C49bu2Bv3J0AwzlW/R+YpdjYj/oJ
         T7Z/Jw+u/vIcOEr5NfcbDdoWMDk0adXYizNr3/Oh2RaOr19AAP/JMiQGzqEcIL8yFgb0
         o9PzozBoAQO7jRfuQt8+YvsP40iKKEJlutW02dYi33zbN419PrprVQlOdJ1S1TIPRZTN
         dYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775030399; x=1775635199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5nKEUQHHyS8kGw3XVEP/5Y00d6pDO4g6gncshQu61RE=;
        b=m9flov4TK5e69K+fRbXsaYPphG7FCDkuMxsgRIHZgKrV+/ik+ogyrz4TXfRrvS8u4D
         MkaiJto6EazwPrr0LvChOeqaz6PsO0ByzvwF9Ln/775VpKa3GVb7aPWjNRlxjeIocfc+
         ywZRt519+aRIeofQ0HqOnQGb2JBdqoPDke2Zu3MBbSzal0MMl2KaKhion9sj5mppLyq5
         clBgjkRXRgfhtPT8j97sI6sSz/ELO7RWhRQK5qdJoZ/TiCWzNT/iGXCU/XPFlaYaet2j
         UkWdlX1lnA1+4boG5dybYuivlJwsn4upaCOKZ9DPZe3i8AGvDIuXuoWGU81zQm3N5klS
         5MbA==
X-Forwarded-Encrypted: i=1; AJvYcCWf4urFRlSh0a9MZIzy1GJXT5XoiaDaDpfd/nAPTK2Slqb0P6nmdEYSbA/GJD8Trx32w5mt8KbHkIw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkblVk7gCPPG0Qn38tSj4ytI2xpNep4A4p1+vhW3O19i6vsB/w
	QMV/br4dOX0zoN9CZMJdHCtJT/87JjJNEeippQKWqxT9aKJXhBC5kns05NAktwizMYPcivkmAMK
	AE6OrTfyhZVGll+6USqvL47345FFsVQB+JNKg99R0AahZc5ni8KQem5+ZV0hG7g==
X-Gm-Gg: ATEYQzw42JhjAgsTZxtipuJJm3CD1Z88aEVR3sRmoqRk1S9DBcYpAeXoWmIHFLC5Cyq
	5r4zYrhElLht6qCOREJruJBbwiOnqluZU5I5RAFArYmCaqkEHeZQBFUW0Uix3/9oTtQR66J3kns
	01nVGQ6YAJeDAs3pVK6ShYQ07ayF3/xmhCfw6EN6bJu2jTsq3NXAundbgbF/PnCUDkCHA6KLAhn
	+WVPoQJRWjvLuD7rHDVKJHQmtYDac+xFBIO3vUTxVGQouSBGIJOqFTPGWR3KQy0P5KpX08uY0la
	qsWWjFTf3n/WmHeSE7UVaL8kuqRuxn7N7HIqrHRyyERqD1vckvS65uck13X9xTo3vC6GWLUvdNn
	fzRzTOrkXUqFRN7Re5g==
X-Received: by 2002:a17:903:b8d:b0:2ae:6092:8d93 with SMTP id d9443c01a7336-2b269c43cf8mr22474365ad.28.1775030398573;
        Wed, 01 Apr 2026 00:59:58 -0700 (PDT)
X-Received: by 2002:a17:903:b8d:b0:2ae:6092:8d93 with SMTP id d9443c01a7336-2b269c43cf8mr22474175ad.28.1775030398065;
        Wed, 01 Apr 2026 00:59:58 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427660c7sm137906715ad.44.2026.04.01.00.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 00:59:57 -0700 (PDT)
Date: Wed, 1 Apr 2026 15:59:52 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, djwong@kernel.org, dlemoal@kernel.org,
	hans.holmberg@wdc.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: add a test for number of open zones on
 conventional devices
Message-ID: <20260401075952.ifuz3kqfq3g7c4gf@doltdoltdolt>
References: <20260331152341.4047725-1-hch@lst.de>
 <20260331211807.gofhlabxlr3mdxnr@doltdoltdolt>
 <20260401061828.GA24293@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401061828.GA24293@lst.de>

On Wed, Apr 01, 2026 at 08:18:28AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 01, 2026 at 05:18:07AM +0800, Zorro Lang wrote:
> > > +
> > > +_scratch_mkfs -b size=${bsize} -r zoned=1,rgsize=${blocks}b \
> > > +	> "$seqres.full" 2>&1
> > 
> > I usually tack on "|| _fail 'mkfs failed'" after _scratch_mount if it's
> > using extra options. That way, we'll know for sure if the mkfs actually
> > failed.
> 
> Yes, that is useful here, especially if we want to support older kernels
> before the zoned device support or !CONFIG_XFS_RT kernels.

Oh, if so, we might need _require_realtime. But that's still not enough to
check mkfs.xfs and mount.xfs on old system (then notrun), we might need
more _require_* helpers for this test. What do you think?

Thanks,
Zorro

> 
> > > +_has_fs_sysfs_attr $SCRATCH_DEV zoned/nr_open_zones || \
> > > +	_notrun "This test requires /sys/fs/${FSTYP}/$SCRATCH_DEV/zoned/nr_open_zones"
> > 
> > Can this be replaced with "_require_fs_sysfs_attr" ? _require_fs_sysfs_attr also can
> > help to get the real path to the sysfs directory for the fs on a device.
> 
> No, this must happen on the scratch file system where we force the
> zoned allocator, as the attribute only exists for those.
> 

