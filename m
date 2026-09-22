Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E10443AB7
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 09:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067633; cv=none; b=OzervWj30N8oNQrZFWvhc/PHmg+rDmGgaqDXD/dwzY0gTPrI0X7kPU9Zt3VjxglQbLVpDOSZ7gz5oIZuWCCaLur0Cq6fQoE9YX3lTujiGzuVdLbejXShsNCkpwYAMd+k8T0E+zMR0pUmVLR8lGl511QPjXgNssMLjSQno8pV8U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067633; c=relaxed/simple;
	bh=HmmHSOBi6Fqj+ayaB0kp+lUWkEfnbaCEl7Q3FaEXEB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F2UcPai4WgSmuksZntUpYX4HO8lJNBtdoaMFfpSMX8d8i9N7coyeAPXrptVpdQIbxH2NvhVGzrfqvoRZ2ctX6Lrm7gF+AhVSHQ0sf4HwPbdCQS06MT8nrDjaUI0ZjPo64/XDsFzp0xkLtiOVo9qH/QYiOIoYtB+h4im4hT94L9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BiKFQ9JE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZypKHgRs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BiKFQ9JE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZypKHgRs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790067630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
	b=BiKFQ9JEMYQnWErHLXjwAi1Hh/82rXt4RcfdK0XVkKU5ecAvudRcBtTvZ3ot2EyIIDVsbw
	9660QAFVowqd88nxp8GkvLeHlXsfNU+NX2ye2bR7diniA7GR0FaonWZ8pOtdp1slg+jM1m
	Y8QFsLGqvfvgXgGMNKAVhVJ0cGuJiLI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-f3RcUgH8OPi8beg-Ci2unw-1; Tue, 22 Sep 2026 05:00:29 -0400
X-MC-Unique: f3RcUgH8OPi8beg-Ci2unw-1
X-Mimecast-MFC-AGG-ID: f3RcUgH8OPi8beg-Ci2unw_1790067628
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c210c66672eso487571066b.2
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 02:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790067628; x=1790672428; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
        b=ZypKHgRstyorMfsTmpy3BZXrQ7fojscv8x71Dn0/9DQft3OrpncnJAG2SXwxPrkvK3
         eOTu2XaRj6JvvfcZgoXM5PLdHNtjWOXDZKMiJ+ACU6D4o335QZIrYCPjCTR3ww0yAmxA
         ycWYotpcec/i161wlDz1QIcvc0k2N8MZ63T6JJqYMLbJdRjAi/5RKO4MtynSE8R4s+MW
         n5bRYbwM1zoyzLjx4vqsHWlA3js6MC7O+BdKgfVjUK7cykFOXBp+rmGQB6UXgFha3++I
         yaAbADzzCT8wVTKvlsaCJAkBsqI4O5uOHHxOHV4/gn45dn8m2WFANUGIdkqbA4ypxyeJ
         PBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790067628; x=1790672428;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
        b=KnKvOgvkYiNEKvl+r6/zqPot3Y99nukaSC1kIxaIP8Ii9b8UeFT5mMqOppeThnbxd3
         eKHCZ3QI9pcMYGJY6bpdpHN38H9XCggSyXkQd0qvdI4MdzC70VrLJuXz7VTxy+ZdTVbX
         bDVTT2SYotJ3ChhbbpPTrQSuqXAp3Xnq4+hVAdZNPoXFUXpo4/O1shJiH+Tcb/J/NV3M
         jrN4dDi8mMViVcXP/CtDDhVx6uq9ZVbuneUM1NN6tea1KBjOjn5QTHDO69zczZnDf8J0
         qu9KWZ9x0EOrPmSuR/zrbSwc2YsZGQwy1+tYX9qPKOhqA+JXflJ/KD62P63+eeHMEHVS
         YGeg==
X-Forwarded-Encrypted: i=1; AKwUvBwOuFQAS/45H5GcbHtzz/i8j/CAgx3X6EJIb41cnP6Cx7T7WB/bsew6mV/M3rktKMQiCQ5CKe9gduw=@vger.kernel.org
X-Gm-Message-State: AFuF++k2y63fnF5XLnhP84XiobWvdmxlnXc/+M1r1QXsN9mrfgj733NO
	tVLxCtP4W77YhcIaIgH7ByUSufKSEUyQSTwVkv7EeJW9fcl9XQjLNkg9cUcPK3EO8jJ+kxW/ygj
	fcks42Utd96SgXHjSh1elglw8ANJmMPIYunQuLCoxbJOizJj1tyTlIcu8BYm5
X-Gm-Gg: AYBFou2ocwnevgq3PlwnzNBf6wSVpVmxKGyThDa6Y+cSww27kcc7D7aa8SnAeo+WN51
	0jxaSCBXu14ANEJf2qil40vp5Fq65rF2M3RoQ7nQ0IbRRg7dL5W+MJ/s4tnWbmoDadiuLxIu77u
	KnMflgQA2DBommefyWdD7bxMmaDsyCvNtA1Fqt0cqzy3LfMoGWlHLyeEfaYhovBob+0srOuaXXa
	1Cya+ZvZpV90SDMnCMzlw0ixQ82QprkJn6pHlGV8xzEEkb620JhEFZc3R7uv+676PLeGBg3VOC7
	JcbHJibGtowZNLc6LfOZpGArKeyru1B1CbfDrdyJhpRJA2JFT2ARSVsia/S0wE1U3SVIv+zDJ6t
	F8yYml/3PuMX89qsA6oexPNi6WKc32xXfTg==
X-Received: by 2002:a17:906:9fc1:b0:c29:4a1f:76be with SMTP id a640c23a62f3a-c2a15703413mr1217329966b.20.1790067627775;
        Tue, 22 Sep 2026 02:00:27 -0700 (PDT)
X-Received: by 2002:a17:906:9fc1:b0:c29:4a1f:76be with SMTP id a640c23a62f3a-c2a15703413mr1217326266b.20.1790067627294;
        Tue, 22 Sep 2026 02:00:27 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a9c4309c7sm51460566b.6.2026.09.22.02.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 02:00:26 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:00:26 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, ebiggers@kernel.org, 
	hch@lst.de, Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <arJC542mXklAeswE@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260922045144.GP2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922045144.GP2705364@frogsfrogsfrogs>

On 2026-09-21 21:51:44, Darrick J. Wong wrote:
> On Fri, Sep 18, 2026 at 01:15:12PM +0200, Andrey Albershteyn wrote:
> > Hi all,
> > 
> > This is next revision of fsverity for XFS.
> > 
> > The main change from v15 is addion of kmem cache
> > xfs_fsverity_ioend_cache instead of adding work_struct to iomap's ioend
> > struct.
> 
> FWIW, Sashiko found at least one or two bugs, but the reports only got
> echoed to the ext4 list.  Perhaps it's time to discuss allowing it to
> email linux-xfs for bugs that it claims to have found in xfs code?

I'm checking its report for fsverity series, but for other patches
not that often. So, maybe it would be useful for "critical" and
"high" priority issues (not sure if it's possible to configure it
that way).

*this time sashiko sent me a bunch of "no regression found" emails
which I think are not necessary

-- 
- Andrey

