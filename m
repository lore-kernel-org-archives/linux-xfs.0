Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EB841A931
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 21:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784066350; cv=pass; b=Y9TqAmnWgXyEW2DxNR9W5hYtmgsMMsfI37b6tTLRIQGj2eacmbasRk/RfkXCLYTSxK+3cnjKssh+crkkT5u5ZNI2yznCG3HDufxSX68dEJNjWpkWIH7PI0/hgecFscGPIlr3OJvDY1ZwDurUaHC6hJbcgO+vlUtzG4bM4yyfFrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784066350; c=relaxed/simple;
	bh=YGC9dDFhcNE/nH8uF7RQF2fZklwLDMr+vQpMOrHnmr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LTOEiS8DrqknhiY+3jKFWsv8G3CQ7iYHZnG8JAL9Gtw9N/p+kSQb/zZvfMgmchtM9f5jtb8VPvYImRiMBmDuq/bRUT3UPnEDIrLNmL5KMWp29RGhejxdQlKDQNB4ATbYkwBUCkkEOTjyDAHRKtRD9NBfvJVsF0MWB7uzUHMMXos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=Z3q/7ywE; arc=pass smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="Z3q/7ywE"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ceaf8a1265so38882035ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 14:59:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784066349; cv=none;
        d=google.com; s=arc-20260327;
        b=N2HdY6aOILkQLIDkq3NK4Dg4K1iX2yQm0UYstE3iPs0SAETHjpuCKslo9r42iorgAc
         xnuu6bMajF4Um6y4/TZjSuIlazMsowIzaqLCWqvoOes45YleC/7BNsdUr2PsvInzzONt
         XPO4KEWuEHr+ykPzcOKnpguzXWvLuWA5hyyIVDnBNRYomAsn2Tk3Dwbq22pID14EQRGe
         hIpx61YbkwXa5Sx88W4pXzk06VCrVRwYd9rWAreT2sW/S/GdTx0PDrBIrRW74zH8U7r9
         8qL6hjtVtAZeda80YIoR44IDyVGfZPKV6AuGxgxEObPBywRxooa4nNSE6v6lZZwBqD3X
         cRHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YGC9dDFhcNE/nH8uF7RQF2fZklwLDMr+vQpMOrHnmr0=;
        fh=Ly9PwL+RNiMgHg+F2ip9gOa/14AHVmcFEt6JualRs1E=;
        b=Dbi5zi7SjOmncItSuKt/CcKEIrH8ZRmc0vZ4BpL+v5+0oILTfTEiYuDxoJxMgwnJC5
         lDY6x/NoOyJvmtlEZSANwWMgvIksLee94oW1K0fFQPzPC1fQjl42Ql3e/nYih3gUDS8a
         kMZIp2+O48gnay8ZrUjSKIZeUqzWeFwbCVqTiW2hk2lNusWv4CVHuMhPUEPcuQIdSjpt
         rG2951eszTZ+uH3s+A9lZMFD9N23uC/gZ6I9U8Hc6oxQDtTCeYhaeOg2gOV/oWcpfbYp
         tMNIvUMCr5WcXYJbvFdVnGJyuHkIVS4Pb8f9RVQ7ew4/gZlQLb9VQpHN9Hp0gp+jO4fQ
         yDjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1784066349; x=1784671149; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YGC9dDFhcNE/nH8uF7RQF2fZklwLDMr+vQpMOrHnmr0=;
        b=Z3q/7ywECfXtnVrAHDubFcCRDHT+Ujw+9mMWR0y9xVh+HodsZxJDAeIa3NLw41W/Vt
         50snp9FQrSHDIf3oa7iNFnNRt8wfDPi19A5JZo2CHa8Q6GoQ6OyFZA7DMUVrZB+edXs7
         yXbQdDeZ3nzmSqzfVIkNhgzYM9FuACZP5LqY5LovcmQDGGieX5iMBMy/VQ3CFq8kjqq7
         6WbVTGOE7f77Nm0TaZ3VTo1aEGd3c090e33KPUF/4h/JfJfZPheArM6JoRH2bZyNOeGZ
         7KbsON98kg8J//lfpdPnJekr9SytPPz8nVlEg6u4kuyAEU1TrdHnC589pL99mmzId7II
         FVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784066349; x=1784671149;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YGC9dDFhcNE/nH8uF7RQF2fZklwLDMr+vQpMOrHnmr0=;
        b=KbigGFrqXRoA8JN7vVEcb6vZAxEKnvZ/we/DDBtJtB9ultoTErxer0nm2RSMBLBDzG
         afTnHkoE7P51AR3C6PJYcjFZsPoVkxG9XOywmwdDpZI606wkoOL4p7rk4lqmpGRz/cBu
         PzuE534w8qCR1jZe0MnnoLDULr6nUdZRWE9zVlx8+eUe2f7wwjmjBXKxJTBST/wyxAhA
         4RaTP0HAz63mX3cA70mKIFEcu8XDRvsy0rlaJp+QlLiYmzrYJRe1xsg/FXxNWM63stuk
         A99Y9ku/MGiUpCo1x6BOFzcMdK3mSI1M96j7mUNBTwe5+WcanNZyWFnt5468csOTPffJ
         oWIw==
X-Forwarded-Encrypted: i=1; AHgh+RqQ/G/K/kfjHLyFUI1DEWHbgn0FwhH1iMlNAfcJB9yzqM+Jpu6+DLCjnCJ23KDZfurvYoFCz23SBMU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzorr2a9ai5FIPNBzMy/DbIPBDE4GR9ZTV6bTXid139QUzHBx/R
	cTBW+jIFVNRx5ZOl8N9triUhqIumREgGOQusQO+ORvPN0mxxWLqlDOeef5ufEviTz0Yr5oH2Gf3
	MYvzBB84BdoU30QXqOhWKj/EwB9ktnXiwZP/Q0xiC
X-Gm-Gg: AfdE7cklAOD6mFWtnIcwucS7/b914NrTLLF/dh0TSTy5YkG1LK5gSDdiDGwYqTUxVc0
	oli3sgzDsJSYWg8H0k9v3qQcsFDbLxFWo1L2x1t5xjEitBAiWT811YQGL/2ZSieHTyAcvVXJEqy
	fmgxMrRddJ4t+oOkUB6uloDr7CCWDfKRAuaqzYkvG7XnQO7euvgu0LV5FdnVUEF07qhY5AR3b55
	BXQ98uyTPYbDbgbXSHFkxu8cpPO+DbBZo/EUdLiSlCIR5h+73NcFS+svqVviKXzDiXdRiCff8dt
	tcLaQ3+3SBxk2AoiNJNkzTBTF+Zy6w==
X-Received: by 2002:a17:902:fda8:b0:2ca:4b7a:4a02 with SMTP id
 d9443c01a7336-2cef1370d34mr39057535ad.43.1784066349191; Tue, 14 Jul 2026
 14:59:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712002644.2519804-1-xmei5@asu.edu> <alSPszh1rI0_2m6N@infradead.org>
In-Reply-To: <alSPszh1rI0_2m6N@infradead.org>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 14 Jul 2026 14:58:58 -0700
X-Gm-Features: AUfX_mwwt1zyghLevrgfQEB16fqKZQ8UATMcY5svs1eE5IyZpiTynqe8R-o3l00
Message-ID: <CAPpSM+S7fmPoU3SUZ2HQRZrtA93wbSO26rU1kd1jkH0isPKiTA@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix off-by-one in rtrefcount btree root level validation
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bestswngs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, Christoph and Darrick, for your review and suggestions.

v2 is sent with Darrick's suggestions and both of your Reviewed-by tags:
https://lore.kernel.org/all/20260714215612.1528518-1-xmei5@asu.edu/T/#u

Xiang

On Mon, Jul 13, 2026 at 12:11=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> Looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
