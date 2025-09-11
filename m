Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC9F2E7167
	for <linux-xfs@vger.kernel.org>; Thu, 11 Sep 2025 09:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757582251; cv=none; b=LXuI5dUEVC5nLo0N6jQGxR9Oj1LBUOQzq+XdPzaNOP7gplO5Ud5rqnGPRqH//rCdHJ/nSbLjpwm95IDmgwlLdHESQb1VdQn5CF5G0cxOvn0HhU8gyCj4fKoLQB/bttKo6s3NfmpcsF2FXyfWhlgaSen1UYoQm2t9zvMvXhReg2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757582251; c=relaxed/simple;
	bh=nRopOZdLmoabNyUraQZ8tWhkKnKT00UAZalz8gNlCrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaiLL1/2VEoT3SE1a+n2OUXNGmerOh94UP4eezcEWUna1+B4IgCfM68DcdmQs9RFZB4DStW0ybeBJT5X7iOFPJ00B/K6Q05pcTszAfJYV8HcU3fP8kN4+F5oiDhL+6Iyf8vx/aF8S+4Bkfo253vP0LamD0Z7qombIM3azSklOpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H5wW6v4L; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5wW6v4L"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-323266d6f57so495563a91.0
        for <linux-xfs@vger.kernel.org>; Thu, 11 Sep 2025 02:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757582249; x=1758187049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EbW2IpP4iJhEkSOGqFGCsK7hlxWafH505HiZGCidKuM=;
        b=H5wW6v4Ld7Ynys29TQDzmqVTzS/s/pNEIURnQJHajBOe97UPZ+hHsE17C4QNa2dpid
         QyP2Oa0Oro/rvtZoqTa1KfKlzhvez5Od1gDZzc7lDBUE1/XLQvdJxJ4PiAux1Jid/xpH
         Dca85sF1yEUE8OphXktcpXtDRYUeRfaPK41iNf3ulsl9ivGUHCZtjZxJfrDWeeHT1BxI
         1FGErLGX7fwBmzQ3sFuptl0BPnfJOdcWvnB23puxOmVG7Oo/PUKG5WiBKuBQc2sQ7jrW
         3MXk4EVj5M/LGZsvrW7iiF5/U0O7lAp1cP/gGnLKHHyOWKohL6ligV4vTMk0fIwIpoUb
         wsHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757582249; x=1758187049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EbW2IpP4iJhEkSOGqFGCsK7hlxWafH505HiZGCidKuM=;
        b=ett+yNjhbSxl+vcoWsmrdm3lAYnu4ehn1nBrOaj2ys0BAHplAVywyl8RA6IcSmFVuy
         zxl8D0pNrALJqpbfMAig7Qz1qbNgbmbmM/6ngF9yTVVPwj4FMDcs/7gpizspIQHVPxvS
         JNymhUKruhm5eQYVhU6fGGCv+Nq/kQoQAWSa2gAAjRLTJkVDqWXhzJoz3DlbaMy/BK8X
         xmvuxKqZQgHI1ZqadzO0AdaPuHZb5OwJQJNW0PnXo7vDwkROV7kE1BdjH6TAVwROjZzj
         spCkNb8VfsoJoXOoC/SP3grfjPwxK3GGGXHwga5LOO8jyDTcPy2IaaCaKVrrIqZc86pf
         Tvmg==
X-Forwarded-Encrypted: i=1; AJvYcCXPNj+NzQH1/lfm7216djyOlI1cOSLIzYHmo19qZVtDdr8aNg+3OmxuQLjtNbgWjYOKfoMOX9uSVfM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwtSuN1ACiKi1K5Ur1Oyw4XJb3OytYR6UkgeIhrRZpIqw6l2Up
	tYzXcJ285yvNI/6y/STPppaTjDrcFpgMEcuYKmbhG8bYfn/AEn+adArk
X-Gm-Gg: ASbGncvTlCeapeLRKb3PO1KTiDeMxG7O7ZixQzI+NEjbM52VhuvqYrCSX/pgXs/NmU3
	gYejdNAcGpYBJH/lmUItsxgo2e1N8l3Tq+dn+XDFl0LiusBAZHuvb0r40enh+92oG4wCijEpQIU
	hWfeIKKhoZ71zQctA8BAhroU/VeSfsSKn3tUDUL/LoLkgNwJwMlJZSv3JrQM3vI4xQvjnuAq59+
	kYKMxPpyhXhkZuVT5OLfue7E8RWYK+vI4unhl4BwXxjX4ktcOJnULF1D2ZstWj4dE6yfuzF6t7o
	9y4jg5sjIxTi9LrhZBr0OI9/K2HOZQRP4yqs0tQF7/fL+lh0fS3txL2jVc9gCw1nve95rudHKWq
	0gidD3nrOF+THF39Tr0R4f37jDifKwYD5k+T8kn7Zq4Xg
X-Google-Smtp-Source: AGHT+IGdNYE+dmhUuvc/wFgrZNzzmv3OTe5tjvhzE/L0vEbZy87456Q+ZpSrek0dlXJ+tGug6w7OBg==
X-Received: by 2002:a17:90b:1dc1:b0:32b:5c13:868d with SMTP id 98e67ed59e1d1-32d43ef6d63mr22709012a91.1.1757582248622;
        Thu, 11 Sep 2025 02:17:28 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd632377fsm1942431a91.23.2025.09.11.02.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 02:17:28 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: hch@infradead.org
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	brauner@kernel.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com
Subject: Re: [PATCH v3 0/4] allow partial folio write with iomap_folio_state
Date: Thu, 11 Sep 2025 17:17:26 +0800
Message-ID: <20250911091726.1774681-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <aK20jalLkbKedAz8@infradead.org>
References: <aK20jalLkbKedAz8@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 26 Aug 2025 06:20:13 -0700, Christoph Hellwig wrote:
> On Mon, Aug 26, 2025 at 07:39:21PM +0800, Jinliang Zheng wrote:
> > Actually, I discovered this while reading (and studying) the code for large
> > folios.
> > 
> > Given that short-writes are inherently unusual, I don't think this patchset
> > will significantly improve performance in hot paths. It might help in scenarios
> > with frequent memory hardware errors, but unfortunately, I haven't built a
> > test scenario like that.
> > 
> > I'm posting this patchset just because I think we can do better in exception
> > handling: if we can reduce unnecessary copying, why not?
> 
> I'm always interested in the motivation, especially for something
> adding more code or doing large changes.  If it actually improves
> performance it's much easier to argue for.  If it doesn't that doesn't
> mean the patch is bad, but it needs to have other upsides.  I'll take
> another close look, but please also add your motivation to the cover
> letter and commit log for the next round.

Okay, I'll try my best to clarify the motivation in my future patches.

Also, have you found any issues with this patchset in the past two weeks? If so,
please let me know. And I'd be happy to improve it.

Alternatively, would you mind accepting this patchset? :)

thanks,
Jinliang Zheng. ;)
