Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ACE39D6D0
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 08:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776848289; cv=none; b=up1xs4FX/qCRNjpYL+jyqOYtvUcGDuJR+9Nqaqed3W+4Cl3jpgM/g0UnOV/Z475l9zCntr4A50o/NB+2t0RJz0j3iB1WT2oqyDa+Nk2YlTVCibsts1BGc8wWX8X5VzlOJOUJgrvWzFKXEzw572QpKMZtISTgj6oTsmZe6T0Kkhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776848289; c=relaxed/simple;
	bh=uF63Ms8AACR/oFWxgd+uFy3hlr2NIcQ7At05T0KyQug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heV/nvxhOnV3aGJjsCbY1vBoeElHrdLC7ZZy45N7XWEDeLFwocyNK/Uz3TflljmXD9yq7ahAy8HVunNEQuw+fttvkXNgLUJ9JOfg2HTDSftlTTLeKQIoFW5CEr7ZJcVj0s5xGVZomPRqYpddyPI0l+t2p40DnxHKc7yQr9KM6Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cHQHEGn4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cxPgpXd1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cHQHEGn4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cxPgpXd1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776848286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFaygBUBXXsgixj3eSOd6CMo0lj7K6zPcakxuhrDzd4=;
	b=cHQHEGn4d65uGcHveSIfcaCYX+F8OuoMacUm1MAOmqirZSK4FaBJJv5JD4WXXd/psgrLV4
	AyeNE1L6dGikldh6xPKHp9tapFPxBEeg5jZczq2A419pFkp0K5EdnG6cEGSDAAe63btKjy
	0tAeHahRUjaQ4pK45Cde+QMyNuzt6lE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-GqHTBplWOZiJSanEUC0L1Q-1; Wed, 22 Apr 2026 04:58:05 -0400
X-MC-Unique: GqHTBplWOZiJSanEUC0L1Q-1
X-Mimecast-MFC-AGG-ID: GqHTBplWOZiJSanEUC0L1Q_1776848284
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4411a2c034fso2142466f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 01:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776848284; x=1777453084; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FFaygBUBXXsgixj3eSOd6CMo0lj7K6zPcakxuhrDzd4=;
        b=cxPgpXd1U2be8oz6XUshGUwOibc9axYIPHrFBQMSuZiwknsMCpp4TPaR8V7HmHlTAY
         /dCsgZVFDwyccB3y60KfRvoGnvNlg2iIqUs25ma3UOS+vz/Zsg2LlbyetF/NjsQvTjys
         aJuVv7sS9y+rpV64vhwHsfrlc4dqmdxrJWV1l4wJrJpAQhYrfJcu/hMHFG5ggFE775LB
         W+UX1yNE383mH/kP7SWPY7TcZmnlXH43S7rc0l7ZvA4bsx2363D3RxTy9WLYClkKW2eM
         LCp79CUbrLb03Zm4ngKEbKKygpkSgf9aAmySoGIq7OXDFIImQGBZnG2jEb8jKTcln3vQ
         Z9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776848284; x=1777453084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FFaygBUBXXsgixj3eSOd6CMo0lj7K6zPcakxuhrDzd4=;
        b=UatoDQ5S8ifheahxj/nrNrBk75XM+YOgeAwPBwXKhKgtbEjmDUdvEQUaX+/IwTcAFr
         LC4XeBnthsXVMVd/6zIWVE2UXtIo1Ix8Ku2MiU/Hzis2h8Ls2rhbbRTdZJQLeDqqA5+s
         LQ+qNlpFcprNgH67g+ozKK9AXAfQxwx73UNm34Q5kWTSL3/AC/F/mj9xBBsXTOtxe7eD
         Fvb73KFUbnelepNv4jv2N2ReIlExuFSf0OtoIwrETiEnHakECanjd4w/5FbaMdnB7m1b
         ORTiDfZLTvLLFg790aj+sC9Ul2gbyBCp/yeBY/JW94d3FXSsAfXBwa7RWq/9Wze8aPyZ
         zqaQ==
X-Forwarded-Encrypted: i=1; AFNElJ9fISHy/C5OYws50nOfbKwVFtnGBLDCGdjZfROO5WJKW5yab+o/PKdVsqW1JjU2trBpFnPOxQ08U7I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye48I2m3yB6QC6LsAbBZ44QcgM+dD8aU1Xeg8lIR0iBHvkq17x
	/6hQKWDJQVLIpHzBBmnZeRz38YbPZ9QseDY9iMSm0S5eyPip/fTNMy/5SifzGr5KLmxbb2qFFtR
	Gb8AvMnIAQa0aCopQc+T8/suRXhb9ktKKJm64sDb7jTvrKJD4L4wMb7rVcB+A
X-Gm-Gg: AeBDievDGS7CaoTL68nSKrSQ0MZS9ZkZlRCMcZa/UtHLs5wfCZuWk7H+l65wueT/I8v
	gamy4oXZ1Sm4fdntBtlsHylaDAZBGUjvTM1mUNPnzLyTRuUcUJtHmMnXw/2t1RO0xl2qA84XXw8
	o06ul7wr5mPz5nqQ6poIWgq2BnBPFpLZZTC2AlDQKKNiZDhw7NMWpdEkA8e+xJOEGlaZryIIUHn
	fk/Hwgh/qFC8xHyKOv6l8ZQvbCsv8BeAiHGOWQ9VGHOWCfmvbKGaSEBy/Fca4YLCttBMOF9/liB
	ikwXfZWKQXSyrAsD19TFPHFTdng3biI4r4dDZZtOlCASuNJYW2Mhv7pBSNd2rjcHpHnPqCyW2U0
	y3MdeHEwwneloeZ+HzX9BdQ==
X-Received: by 2002:a05:6000:4022:b0:441:2439:bef2 with SMTP id ffacd0b85a97d-4412439befdmr4594384f8f.24.1776848283800;
        Wed, 22 Apr 2026 01:58:03 -0700 (PDT)
X-Received: by 2002:a05:6000:4022:b0:441:2439:bef2 with SMTP id ffacd0b85a97d-4412439befdmr4594342f8f.24.1776848283286;
        Wed, 22 Apr 2026 01:58:03 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a341sm47712138f8f.24.2026.04.22.01.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:58:02 -0700 (PDT)
Date: Wed, 22 Apr 2026 10:58:02 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org, 
	david@fromorbit.com
Subject: Re: [PATCH v8 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <iads77qkk2wjkqfezd4vtqsga6btlkqdyephqojyv76herp6by@l24e2hm2ebas>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
 <20260421214316.GB37143@quark>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421214316.GB37143@quark>

On 2026-04-21 14:43:16, Eric Biggers wrote:
> On Mon, Apr 20, 2026 at 01:46:47PM +0200, Andrey Albershteyn wrote:
> > This series based on v7.0 with Christoph's read ioends patchset [1].
> > 
> > kernel:
> > https://git.kernel.org/pub/scm/linux/kernel/git/aalbersh/xfs-linux.git/log/?h=b4/fsverity
> 
> FYI: the git repository doesn't match what was actually sent out.  For
> example the patch "ovl: use core fsverity ensure info interface" is a
> bit different.  The version in git (incorrectly, I think) ignores the
> error code, while the patch returns it.
> 
> - Eric
> 

Thanks, you're right, I forgot to push

-- 
- Andrey

