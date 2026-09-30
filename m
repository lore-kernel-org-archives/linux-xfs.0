Received: from mail-pj2-f39.google.com (mail-pj2-f39.google.com [74.125.227.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366493A8755
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 22:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790808073; cv=none; b=gPrar3Jhvz5ggCVWEasCvArexeRQKClgVKA5/qEoD610Q12xF623iG4pgdzeTpkkEXcro8Pta/FsK8aU9AHxzxcS7CU/ACR32ASUYXcKnM8V11IWmVZBmri2Zz4BbZaKY5JWcaLFJSbe+dlKlbilkRjLwyV7+oPrEnUaNMOROfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790808073; c=relaxed/simple;
	bh=eMklWIH8dfFOGxgP33S/sVDH62SwDKkSsYt8Yp2b8eQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=evs/YFzoHwxpsp9fqQyabbR5kJEn60gw92rxYfrnuLDhSPKbKLGCzbGJmfbUhOjTkX63Uyn9/rNSfX+Ml6+YIORUPJZ5GhCii3t/k1pip6PeiQPWhHe3lh+bAkhbPNiUFuerXbLUtWW5AaF/oEyDbuFZHFOTmEtwlK7CiTWUh/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M9JCudyD; arc=none smtp.client-ip=74.125.227.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M9JCudyD"
Received: by mail-pj2-f39.google.com with SMTP id 98e67ed59e1d1-3a498cb99b3so1323923a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 15:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790808070; x=1791412870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eMklWIH8dfFOGxgP33S/sVDH62SwDKkSsYt8Yp2b8eQ=;
        b=M9JCudyDnmNNLgoP8WW4clXWgwbHE3Ew1KFBcISBS678JZql/37JhzPAfWOxOjeHDy
         sxU2iorkxQA7ghN3myY75D6uOxLcseU4eqfXg3kjzoIAWFhn7709BH8vVKmTJteNUJA1
         m/1jEQcUeylm1UHUBMwdfCeT19pfNuvEe5jZSZlBirHHzEERIZdAbxkFXLJ2QhGZK1P+
         ++1kF1/IeKqkMNBkO05+BxTUuOfLCflLa4OWlxCxaGp1JjqAtS7JcW9EO2OKYJ6Ll1y+
         B9+PHNJ50s1LC+IfhXtsxXtvDD8TNvlTPQnh48vGYmrSRf1AqlYjCtwiD/xDZPj/k2lV
         uabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790808070; x=1791412870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eMklWIH8dfFOGxgP33S/sVDH62SwDKkSsYt8Yp2b8eQ=;
        b=W1ViDCEHU+EysItx5+3UnF5Fi2BYr085uf/zN9QbJIjBHAY9+kfKFJHUcNQcDG6fZf
         afmCW78gJfN91PgCYHpVcGutKgHlhEdjk62bjnaLc1HpC82GffA+vgFdpPUo5IRBl4Kt
         t7D5Yzcxywo4iBnCFeHKYsK65H59J/hrYxpa9d8qHf1NRYaN4k61nqfRkKT6S1g4QNqT
         XiyQMb4/ojCv2wYiBg7W0iireN7e3bRjnxdpIYFKcY8jhQIjLhfv57fm62lwx0XHmAut
         4cvzUW+0VIDzp2GACLRGz7GkRu9t5p3BWpQXgCMWS+UoDE3gmttLiHRGzAavgvdfjwRm
         PLEg==
X-Forwarded-Encrypted: i=1; AKwUvBx6xUOVQfFZE6wIYh7GoQf6JsnQ1qxzmm8gx6po1ddHtKElIfPBVT12WWkooNTLEQfmpr4QhamT0d4=@vger.kernel.org
X-Gm-Message-State: AFq9FYLfz8T7eMCnmJ1+9mgN7RmIeJiIZgGGntHbjY78FYW+lYfUVhsZ
	K5LfTMWT7VzLzKDdnPgwecflZ7hib4RkAEx/itBDr/VPFJzEaGo/v2ie
X-Gm-Gg: AYBFou37pH343d9S7FEtoTFfFcim6o+sTP+veyjbQM1ZpKPDo5KeLVmqMP55NbLRF8m
	8kh0sxJPspKpC+dys9bWxyvi9zWXQUXKmr92FrNlcSr2RZr92CcBYYXYLQU9lpDt2xeb1l1PbyA
	WSA7UjGywIar+5yCetKZ03N2Rfc2e0tA0IK9ylBKoZ3BvZuuVONrvSYzhSdAgcDDGI8niMSwIc2
	zLTKF8MkBJtxQzZmngahzyMg524P4XasFaRsfLpE54UnWax2LDsIzqnUB5a3bPndTna0Yf5KDTN
	q4tjseLSnrqyzzNfSEd+6yNBde69GqaXqlDgxWmXgMK7B3tUX9Ef04mCg5qV7LeApOMsAzwDm0E
	IVPnhlwFrcGicEMUDDCciCepLC7pfzJY8veh5TWDkWnfExVl0EDNYccQacI3MKrMM2ewgDX6JE3
	lIF9iWzdB3FyKCgXBvfQGDXJdalPCJZMZXmfVR5FrDSayiVwPVww9dlEsUA62YgS6uW9j7gRVK5
	te8abMrx3xn3qnkhw98KAzLhiyLMG4Cl+FrJpU/2Sh+/nr6rPzN6w==
X-Received: by 2002:a17:90b:4fc1:b0:3a2:b033:4a43 with SMTP id 98e67ed59e1d1-3a4d18f3b7cmr1356754a91.36.1790808070102;
        Wed, 30 Sep 2026 15:41:10 -0700 (PDT)
Received: from lima-xfs.. (174-126-236-85.cpe.sparklight.net. [174.126.236.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f43f832fsm1203863a91.7.2026.09.30.15.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 15:41:09 -0700 (PDT)
From: Eric Peterson <linuxinstalled@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Dave Chinner <dgc@kernel.org>,
	Eric Sandeen <sandeen@sandeen.net>,
	linux-kernel@vger.kernel.org,
	eric.peterson@hpe.com,
	Eric Peterson <linuxinstalled@gmail.com>
Subject: Re: [PATCH v2] xfs: add per-mount read/write I/O completion counters
Date: Wed, 30 Sep 2026 16:40:32 -0600
Message-Id: <20260930224032.1413-1-linuxinstalled@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260902042539.4073566-1-linuxinstalled@gmail.com>
References: <20260828033429.4070267-1-linuxinstalled@gmail.com> <20260902042539.4073566-1-linuxinstalled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Carlos,

I wanted to check in since it has been a few weeks since any response
has been posted.
Is there anything else that you'd like to explore before the changes are
considered for approval or denial?

Thanks,
Eric
