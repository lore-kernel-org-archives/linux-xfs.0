Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B9620DD3
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 05:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717394305; cv=none; b=PX7ifGCnwJNcNnY9su/FV0oFX+i2xSuemNNAQTVPeFNpT7pZwREuoM5IvypvHE2IPI6zw+0VIQxYl/2jrU1lRUOuIg1g/gl4+51JykEXxVjaTJ33ndo7Tn88YiJBXunkKkCOdG/wPb6IivPUbZlZ0lGxl4klhewT79XI3ECqVTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717394305; c=relaxed/simple;
	bh=4Ra6RxsOrSwPmGiIWAS5TwqYTWhLgiRF5MeJXK5ADRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PG4KAZqtGQVQHiinUAeQ4+oKBnkp39eXllCn1SM/316FYFz4WGSABix4kMFSQuJG1sOI2FOM3V5FnSAiopYbAf4ywLOdnjOi/YeoVy3shiTyAmMF1FVEMuv/gvNQnxnrJu31tHdk9dnMF+de1M6m18IcnGWz0/jzTI9+0ZKh2kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=cBnu3fh8; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="cBnu3fh8"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-6818e31e5baso3160989a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 02 Jun 2024 22:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717394303; x=1717999103; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dV5YAk3OuJ/dDV1tXlQo+ZgRRjdyd5n49Sq2I5KEZHU=;
        b=cBnu3fh8L9dYCkVIjvm+9XGRvSUVm5RVvg+ICctFsjPyysIxkPzOFg/XehKc9zqdMB
         tSp0QMMOzy72jyozw1bLDBvqYoaq5IwkI0gZFO6OkcBP3OBnkRCEZbQTS8CaeoJqTgJL
         GKNk8Zqz6tcE6Y+10sNJd+zSVwGUMig1wn+jrHK1bLlNv9DqrcTbz5A6y6ficKigExP4
         uf6AsBuJt5gnCc8OWX65t+0GzB7gbmzF+8Sb/Ir6p+xFLInOewcOVDro5NkJzfZv/VXb
         ZPPUUGlkUCaquQtO5FabQfDxfu+UYN3krK9bfTJ5LSUC4smDlJQ37TAIToYal95UZFm+
         Zb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717394303; x=1717999103;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dV5YAk3OuJ/dDV1tXlQo+ZgRRjdyd5n49Sq2I5KEZHU=;
        b=YReV/yjOFcvweyAGZyuKC3zbw5WeGPGmwMTz19pg+OPlr8QWPGoH9m685iT6qJXpB4
         fdZQdDLodKkvZ8MPqI+YetG3Z6IGQ2CVBIUc5V2CkPGbSwJQox5pdCpAQAKNkP9dzufO
         RQAg7E2pYC0KaFVxMNbu1z+XLenqGURxS5ft2aa69X15x791J5WmL6MWyGQyU8RUG/Ej
         z8RVWyIjVQE/WHf6RiIj75nSZ4cIdFueMxp2wDAbD+4IQtVtGCeNQmPod3SMCpEmzrKU
         TuHtISpJqyVDRp+4L3eT22h93bhWMgczwEXp7/4bs2HVqylweqgynPiMqy/7M1Ue7hN9
         cgcw==
X-Forwarded-Encrypted: i=1; AJvYcCXgc7eWFXA4rrPuvFzZ5ac+OIA1koQFKmLjdHVxd4DiKFIdRqMsVeYELCPWeO40Ka2nnJ/NXioGSsqXNivqOXuG6DvnCAb/Awxt
X-Gm-Message-State: AOJu0Yx9XpdwmToyEfSNlcXNYgeCLDxgD5yZKSCJ51uPk9MSMOkWPf1r
	mIjhgl3zQLuLFN2hrx6+DfzaiB7hN/4UKheIC+dFSvEbbJviyjAuIiV919tg1LcJbRWMtVm8LGI
	t
X-Google-Smtp-Source: AGHT+IGL9EKw0QkM0DX8sEixtiwvu4DONx4v5JiBJUnkAo0b/QORzqNcWnzCXUwo+ebWqz3zUISmVg==
X-Received: by 2002:a17:90b:4a83:b0:2c2:4106:1a48 with SMTP id 98e67ed59e1d1-2c241063a50mr870291a91.22.1717394302847;
        Sun, 02 Jun 2024 22:58:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1a77baebcsm7542997a91.53.2024.06.02.22.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 22:58:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sE0i2-002XK2-2e;
	Mon, 03 Jun 2024 15:58:18 +1000
Date: Mon, 3 Jun 2024 15:58:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: lei lu <llfamsec@gmail.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: don't walk off the end of a directory data block
Message-ID: <Zl1bequjV5u9QjXD@dread.disaster.area>
References: <20240529225736.21028-1-llfamsec@gmail.com>
 <Zlfmu4/kVJxZ/J7B@dread.disaster.area>
 <CAEBF3_ayLsCJVPdZQCb=gHtiFCNG9C3xcGv4_cnUpmS8TQRdYw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEBF3_ayLsCJVPdZQCb=gHtiFCNG9C3xcGv4_cnUpmS8TQRdYw@mail.gmail.com>

On Thu, May 30, 2024 at 11:10:57AM +0800, lei lu wrote:
> Thanks for your time.
> 
> I just add check for the fixed members because I see after the patch
> code there is some checks for dup and dep. "offset +
> be16_to_cpu(dup->length) > end" for dup and "offset +
> xfs_dir2_data_entsize(mp, dep->namelen) > end" for dep.
> “xfs_dir2_data_entsize(mp, dep->namelen)” ensures the alignment of the
> dep.

Sure, but go back and read what I said.

Detect the actual object corruption, not the downstream symptom.

IOWs, the verifier should be detecting the exact corruption you
induced.

Catching all the object corruptions prevents a buffer overrun.
We abort processing before we move beyond the end of the buffer.

IOWs, we need to:

1. verify dup->length is a multiple of XFS_DIR2_DATA_ALIGN; and
2. verify that if the last object in the buffer is less than
   xfs_dir2_data_entsize(mp, 1) bytes in size it must be a dup
   entry of exactly XFS_DIR2_DATA_ALIGN bytes in length.

If either of these checks fail, then the block is corrupt.
#1 will catch your induced corruption and fail immediately.
#2 will catch the runt entry in the structure without derefencing
past the end of the structure.

Can you now see how properly validating that the objects within the
structure will prevent buffer overruns from occurring without
needing generic buffer overrun checks?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
