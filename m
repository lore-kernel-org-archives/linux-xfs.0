Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54882DCF74
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 09:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767693283; cv=none; b=MwReiKUMfZe+jX2NPzn2FDPIf2TGn9HDF4y3F7vroPjfUh7TbENZALDRdvPyXcnL67PggRF+fd2RXap6zGh8RakE+aTSjxR9R3NEPBuDaoQeBvLFooYpbOufc7wCO15J4F4iXZdlLPwoOkJxSJQnakrnuSsTRJKylqpVIjqUfww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767693283; c=relaxed/simple;
	bh=ZB/iEfpLp8ZVFRtuq1uIBAb/YTSQizffTsiYh4htEnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UEjB82LtynqrdsCAc5R3sM5f8RU+8vAef04KzBg85mRzDlZd6PM30Zda/n41z+Ov5pQqSkoVSsTAWtrrGXIDz9y4OgxMXMWKAVLsltEMbkxMgu6GWDPQef1hdjp2rFUqHoz15VlvoEpjt3dGkMAN6JUhRhjATHAxB/zvjwRxXJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=q+H0LCZK; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="q+H0LCZK"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso7746975ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 06 Jan 2026 01:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1767693281; x=1768298081; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sN1Zgv8ou3ZLBBJ0FQKiRD4/StEaI04wuF3VLVYkoEE=;
        b=q+H0LCZKh3Sg3cMjhlYgssfRXXcZRJ4I4YDAlTIbROAZPhT0AbObk5rewfOyt3Q/4G
         RhsK5EOKPkl7YIavvL/IxQRQ81PZluiumkdxb47tFshxoDWs/EOhVyZ/krPetRy8M+FI
         pAbFFisUA9YmitFDW5gesP68xdHiMvu84JiXzy6gAQdK2P6r/9VDO22yHOKLX1XZTCvE
         Nv1Ku323X3NQ0uF7/pYwn+beQ8+ZtcEe7D8vn092hvGpLLUIpbMXF8RQa39uZG2+EsEy
         30rWslg0RpWMwRXHbJDA/dWc4AD6hIFYxjj56VSXfH7YN2VJYihpqZRIYh8txqog2N4m
         4oiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767693281; x=1768298081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sN1Zgv8ou3ZLBBJ0FQKiRD4/StEaI04wuF3VLVYkoEE=;
        b=dR8kNa9zHR9nnjGRY+cXqK1GHEyCc7u20PLv+Z93GFGriNhLBHGpZgBgXLwLiDJ6F6
         Gyc2PdCqYv5NyPMRzvN6+4PXJhztJFb5DoO2SbgT5Ty0ROfz40mZZO/SYH1sR6h/vRA+
         HFa2eISueM4HCG8M9B7fSO/hgUSPF6W2RAN4/+LxClUYoEzDtfZQR7RdjU/3fIsEajZ+
         kEKuB9OJjx0VeifEGYAvPponIgCjHJRh5kkjQ+PZTwbop8YLha9v6dUdPNJonsSLpNjT
         uof1SrSyIsdCFFqZ0V2jA6gGLDrccsN87+SEaiykzzvSofAYHH/V60rU0n2uRFpujcfW
         zJAw==
X-Forwarded-Encrypted: i=1; AJvYcCWqNj+YmHUYyVtkU1jpAxwW/qJL7kUk9Ul2S8asQo0EDyVouGhdvjB75tT6DoutGT6yRCuoWXZXUik=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLFrhmg/fFXsgnDp0LA92JxoYAzP0XgG1Q/HDjFEkL2Xp/lTD/
	78DM3knVGyXv0znEbSS2emQlp70XDlxrID+rlnpI8ESt4sU7mZsy3OSmDK3iXidGD8E=
X-Gm-Gg: AY/fxX43ssivFSERcmAzFnZ7fh7Jn+/3aCfo+kVLxiTjDRG8iXV4Bb+YNQbADfVdrcP
	46spXS07oA5R8uGY2e+KD4bs18WLpVYsMAkWX3uoixIkVa37etMCT9STel5SwB7v2Ic6h3h7kZy
	oWzqznt8abdqz42z0NoKaSjgzVVKxnNlyCWlnFHLasrb6J6GareQE8i6SpDm2LPF9syRXydZdXO
	24QoXOhjCaA47DOcAqTXPQGLS02kKGYaiwJ/Q3oZG10Qk96NU2aswMq8X9L8UiDLTRlDyxZxjnJ
	z9fMWDEyB7l2jjT7N49XKNKuwQpAd/6gJPnY1IeVCEGP0hhORJy9R6+HO9MjXE10GVVVWvqMqi4
	jMh79fHeSBDagCY/hW3ZbTX6K6QW8V+tZ6IkamsIDykG0Eu/W/gRjoqg8HMzfO/XdmTpIsWG6iF
	U6bnnF12BgXfWys0z1Frr6pgfiaRxpAGHIfUsDIkDS7CoBu9h5bnzuyLL7MF9CJg==
X-Google-Smtp-Source: AGHT+IG8L/8zEiAIVRhPeGtnvkdSqwisIhx0AqA9TkHDeA2TYbYp7bfCjzaH4oXyO21Q7ewjfKRjlw==
X-Received: by 2002:a17:903:1ac3:b0:2a2:dc3f:be4c with SMTP id d9443c01a7336-2a3e2c8ee1fmr22706665ad.10.1767693280967;
        Tue, 06 Jan 2026 01:54:40 -0800 (PST)
Received: from dread.disaster.area (pa49-186-83-206.pa.vic.optusnet.com.au. [49.186.83.206])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c48cc3sm17710005ad.39.2026.01.06.01.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 01:54:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vd3lt-00000006O5r-2vrH;
	Tue, 06 Jan 2026 20:54:37 +1100
Date: Tue, 6 Jan 2026 20:54:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: syzbot <syzbot+c628140f24c07eb768d8@syzkaller.appspotmail.com>,
	cem@kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_ilock (4)
Message-ID: <aVzb3ZHsC6XXUV8i@dread.disaster.area>
References: <695b2495.050a0220.1c9965.0020.GAE@google.com>
 <aVxGFP1GJLPremdy@dread.disaster.area>
 <aVzDj2OEa_R9bJyW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVzDj2OEa_R9bJyW@infradead.org>

On Tue, Jan 06, 2026 at 12:10:55AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 06, 2026 at 10:15:32AM +1100, Dave Chinner wrote:
> > iomap: use mapping_gfp_mask() for iomap_fill_dirty_folios()
> 
> This looks good, but didn't we queue up Brian's fix to remove
> the allocation entirely by now?

No idea - I didn't see a fix in the XFS for-next or the VFS
7.20-iomap branches.  I've been on holidays for the past couple of
weeks so I'd kinda forgotten that we'd been through this a month
ago.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
