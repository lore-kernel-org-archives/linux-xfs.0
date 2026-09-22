Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F345489FDA
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 18:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790102622; cv=none; b=vC6Vkq/pG4n05EGWn2G0f5pI2/Nbfh+v19guzvPI+pYHmQv6fyvIetiUu6sn3PkCTrrx8ZaP5flWDPBXnfvNKTvHB5a3bwP1WjEqqDzbVqdlnQCskN2J3gPB3ipT1O1ZO0D5wLVYe9YupUg5XSi2Lv2UDlpwyUi3gSMyUKN+Zmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790102622; c=relaxed/simple;
	bh=Ey1dVK+mA1HsYVtOFCvdCUUmzc/P02m1z+8IiV9BcnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zzy2LDyHwkWtfZxDtnl8myABUQc41hztTPdc2PNw74W9PNZGsoEmjk4gisTi40FZ8409Ip4/4zSbX5M/sK8XvKhKejLRbgkBBEPPreRLVzLYmZLNJBTQjShh7AM8NyWObZiWbB0q86W3zCGbxbJr999YoDiJk25BJEZGk0sglY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WIhY44Gg; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WIhY44Gg"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e4ad9so568725e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 11:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790102619; x=1790707419; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2l4JRHC7Rw+pqUP1HReA75dDASuf5PmXyxwWG+odoY8=;
        b=WIhY44GgUthjJ87mJUagfWsiJbK1+4UPAYPDP5yf/F4dFnzRJR/V4NQZg0m1Kv9kRH
         3Xfw8xRjWa+h2i4KdU71NHILFbpsoYTjo8/995/qPnhLb2utzq6slH2c6sNT12PpgHfA
         QIPtuW8Err3r5fSEDA/uZ6qU+O01wmGmuGu5IKhSXfTbHne9qVX8fQip8FN07atJPfga
         MwkEbNwz1Szq28MumFLMI+AVr3i7n8vLnK4R2onmvxxZBJdD8/X3uf8oLtQSqse3/5Gj
         +gkzGmtG1O8p3GTHf3E+nE5yc/j/1yPV1ZvVuMpzWMLWUT35KN9DBmmEsLAuImAbgBbh
         XKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790102619; x=1790707419;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2l4JRHC7Rw+pqUP1HReA75dDASuf5PmXyxwWG+odoY8=;
        b=P3mNPzxO39QxvLlrMSrQ3zXZd+WrvX+IR/im4BUHcCB966qSmZBhJPkUsMg2kKSOL9
         xsdkoGOWcWPgZJLBvQ0+hwGP/GQsKTGieTCeSL3eM2icZMc1r51XqwbAzUS5WPVfHwQ4
         DZidhDA5sVfJCvjbsusNEp/Yr5j2dW3c9xABqtpiaVdRBW6KSbSwVdKzuNIUULBLNW80
         a/ErnWHAKTGSTzRTijKDbgE4146V4kL6273+ok9F+sBC0y3eUUQiOR78Fzt3x0U5Pwxv
         gi6a2jPOghOLK8t/itp2AgMqwJb+w9LrCw7AzK1IKywZJHtLD+hrJmn9zGwBDvOaVLQ8
         fc6Q==
X-Forwarded-Encrypted: i=1; AKwUvByLkCc7twFqF3OUPqI5HWMDM369n+RBCsH8u0yJ03KZtOqSdfthA0vHtk4lYDVT4nHIG6vluQnvM2I=@vger.kernel.org
X-Gm-Message-State: AFuF++lCj+zF97Oi80fGtY6q3aCgmAcpeu2s9oYJOoyv3hFYEHItT1qi
	PBWqEiD+VbuAmd6OSYXuI6n1Jm254gfhz0+7+O0RUr2hNkIT+bZBk5/r
X-Gm-Gg: AYBFou3NO/gP5VEiTeJXw+SU8Ffj/LMSGuEgGY4OX600OM0uJRiwYCvlhq384xu7+dY
	j3E5284dPJUuZVTtExFGr+5bBU/CnYeB/ZAMO9yqmaxpVZ02v8vtwg+qqJKA0MhVIMVOU2BWJs7
	Hejq//cdTUO6BzVF3dNrE4onZxcbtLj6w5+6YqS6u8Pp/IGt8dzH8Klnn4y+aUJ8TfGjsnwQSc7
	fFb8uII04yS51MNhE/4/leC2otj/DNatCPNWVB0m7hQbFdpBSjd8Lc/wbzRojWAW1404kOWGww3
	rNWA8cn6DWlEEjQ69QI4mjIUWTpmXMvnGs2psnyXvbBrWDXAt4iz2OwfS+w2ZOqyi3PlxlBBkD6
	hCNs6+w4sBBmN9VQ2Kzh9zuu/TmbQ/2BGXYfW/0d1aPBOYffiSlT/18lPaV8WEFwXTdnaij1Bzx
	K+hnjy1CGfP3oBBSQ72ymSXB/bn4VRf9LdYhwrPu4dT56EcEM8DsjKL1pMTHs9v8sda8wgdVEmG
	Geh/3vRdPD9kGBAJp69hBE7qY9OrhVoSIR2ZuZ+PNM3GkI=
X-Received: by 2002:a05:600c:a06:b0:49f:cbf1:e765 with SMTP id 5b1f17b1804b1-49fdec980bamr2359185e9.0.1790102619110;
        Tue, 22 Sep 2026 11:43:39 -0700 (PDT)
Received: from andreayoga.localdomain ([31.189.116.68])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde18093csm13157875e9.3.2026.09.22.11.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 11:43:38 -0700 (PDT)
Date: Tue, 22 Sep 2026 20:43:34 +0200
From: Andrea Parri <parri.andrea@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 3/3] iomap: don't lose a failed direct I/O bio's error
 when zeroing the tail
Message-ID: <arLMVnDWlXPD1iB6@andreayoga.localdomain>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-4-parri.andrea@gmail.com>
 <20260921223432.GO6283@frogsfrogsfrogs>
 <arIT5A3MR7VtCeba@infradead.org>
 <arJF9USiUqIEWB1M@andreayoga.localdomain>
 <arJ0eljPZIuj5PFD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJ0eljPZIuj5PFD@infradead.org>

> Please drop the return value from iomap_dio_zero entirely.

Done locally: iomap_dio_zero() now returns void, and both call sites no
longer capture or check a result.

Thanks!
  Andrea
