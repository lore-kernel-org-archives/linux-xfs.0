Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FD73F5BD8
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 10:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781692447; cv=none; b=VC42TYPk9D2IG6dhbvxOtm9rXld9F7gl207pASqqyWTwj8ubO82RWyBFKh8FfRJPA145TomK8f7p88vxHmchtRHJNxiq/lRux9b+lU9bJMKQthKQgUOG0JCJsbp8Fa0OU/xBcfljsyqtqY3sQHXFaes6R4LMAqab9H9TCFDC4sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781692447; c=relaxed/simple;
	bh=Y6E2YvYO7c/oarGVwuHB+8Fad1WQ1MAjCnShQI524k0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PGYhdItxiLO3hjhbjK8ZO+2o+CNZzcmxV5kW+Rfm6adgbmz7f1B2K9Jn7zC4j2Hl64uBxgci8CC8MBjWsiz/9ex8E6gLL5DCGjXNfDPESU/waHw+DaRZeA6qCOyblScmKIWw4ubDLsaj+m+9tCTFIpTomm9e670f7qlG4LxdKHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=btTpisDD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oVxs9l4G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="btTpisDD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oVxs9l4G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781692445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pvhORpd+2atDYlNPa9GjZO+Z3/OWQm8vbVlnvUzzME0=;
	b=btTpisDDWZI5uwLh7heDEHQGalIb4Pjoxxh1hrCoFa1LH38mFNLo1Ssc+0xlmAOJhPFasv
	LjStisf90LHGRqIvvKjU8IHJ5q2PxdPauWZU0HwH5e+KDZyEwtxMPlx9paSJ73vAyrVkfM
	sdfmgO8/c7jrlLsHPAFAdtXYytf/ziM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-vR69RymFNVe330qJNHCfZg-1; Wed, 17 Jun 2026 06:34:04 -0400
X-MC-Unique: vR69RymFNVe330qJNHCfZg-1
X-Mimecast-MFC-AGG-ID: vR69RymFNVe330qJNHCfZg_1781692443
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490b4d3d3e6so37191315e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 03:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781692443; x=1782297243; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pvhORpd+2atDYlNPa9GjZO+Z3/OWQm8vbVlnvUzzME0=;
        b=oVxs9l4GLDBbNrExdTFYzPfNch/ygWE8sReQsZeta8JqEz7r445pykODD/Mt85Nn25
         37+EKbJvsJG4gyFhG5RNEsyYPiack9cgmcEMbM7cIsN54L1WYDv+kK3Ks0Q81PLiEgEF
         kAXRkiqjXQD2NmreiUJHNC5uHKlQeZcXHPuSesmkkyiIKR5gSZF7qvRt1ysihUf2WUw/
         pzDXdtIlLfNW7EmWjusrfa2tGelNCiRlN2HA1s0Pvswg1faNst2t3w6abd9r2+YyXpYZ
         9DnVWNAN+1uv/7vdhs40YJ3YuNRKpZwKbFuK/s3OGG/8xTwDMYuuspna2zEngeBkkgRj
         eHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781692443; x=1782297243;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pvhORpd+2atDYlNPa9GjZO+Z3/OWQm8vbVlnvUzzME0=;
        b=DwNSOr51BWKkLOxsp/y+QAQf41hduuMsH/2NV7vDHYi51qsKOcClc37d9ilmMyt7jk
         /Tej1nvv5vBMxNizgMR0rHWH9lb3MdyomoiLVuyPlnDbtTA4k28kQx6wlaKOZlaUhw+Y
         GB0X02JiVOk2k0qPV44QmGnrtFt1BX+Nn1a9R26Wic8vxIjvxFRkjm10UUb93+lXj1yj
         6uRwjmDAc6xcDQFpQpSFg9lg+BCic8NY7xZVpgZFeQDDlwytJNFFA+bwVcSIOuqUdfWU
         FQSTbhAzH21Ta3lEYx3wlmFZnUzwuxIv4UAH2pgUENyF7DrjB5xRkrQLb7EOq1qz86j0
         R5+g==
X-Forwarded-Encrypted: i=1; AFNElJ999eTc/DhlFfHbVyquq/bKi8So+qb8Vgr6CvpUqDMgjAQYLpZjvqgYLCW/5S2ZFCfON5kxj7zqah8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyhTP69BUhxO3uZU+PkmGEhHUuulF46vrmt0XXhYlanQ273Kgf
	AbGtBKF6lIzuwbnaRCTi/zCLChrPyBb3VX8Xta9fU9/hAp0UJvagfUTQpICDYF01rIfe3N9UZj+
	9lrprJBiN53nWBVYyVVk9UgY/2V7Mt3PgSAvsrrUnMVMXgB1xdfcg/K6Te3uQJCw2KcuV
X-Gm-Gg: Acq92OF02FxKemJ51vaxSeqxghtzNVq92IBnY9AItDgMnrFbEfiKDgUnNj7APIYPbo0
	gd+BHmVlaFvDncoTx4l5ynZeF+5Ga5OcRfsifoDNmkPD/SfpEa5uA7i4prFRlH/GYCqmDbAou1X
	RCn+c1wxjc5K8B6o3KeGkSJCUFZMEvMgFvkFvWxVntWKl315TVy5kXqYbyKLMURoKziYedRlJKg
	+NRbT0Q/aP+CRCTQeOuRSyTxwgNUuZjM9F3FfB5mCLxVEDTDG+fKYT25GFKQWIWfMeepIDcRL8u
	P1DMGDy4QS0pAdf1gG9Hf0jZ0Dac1vjihqRwtjGWno/JJ+UMC64eh8JnmehC5SI8I6PeDlVbUB0
	0o3R0UhcveHwpqQhjpzbbgxzcLADWptLafk2oG9cYXOd4vA==
X-Received: by 2002:a05:600c:c0c8:b0:490:b446:fb8 with SMTP id 5b1f17b1804b1-492333af102mr44326345e9.11.1781692443162;
        Wed, 17 Jun 2026 03:34:03 -0700 (PDT)
X-Received: by 2002:a05:600c:c0c8:b0:490:b446:fb8 with SMTP id 5b1f17b1804b1-492333af102mr44325715e9.11.1781692442613;
        Wed, 17 Jun 2026 03:34:02 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa510e7sm178380585e9.7.2026.06.17.03.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 03:34:02 -0700 (PDT)
Date: Wed, 17 Jun 2026 12:34:01 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs_healer_start: fix static checking
Message-ID: <ajJ1Qa4CFn3gs0Vb@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
 <178118661316.728615.15344702808600397376.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178118661316.728615.15344702808600397376.stgit@frogsfrogsfrogs>

On 2026-06-11 07:05:52, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix static checking for the startup program's source code.  Alternately,
> we could move it to its own subdirectory.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

