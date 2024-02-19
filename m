Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75B44C7B
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 23:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708385410; cv=none; b=pImUbyWtZXrIwSDX89iWkLgiFRE5fWrCdVH5dyQRPQTLDu/MmLmTIrVm9th+dZqmftkh2Fiw6YuWlZVWJHa69TfIYkVFOXTMbJRLAsz4H93fa8m8JJDzSTO3RuRbJKg9rqw3QClCXSa4gaodFPbefPbJ+qUgijMUX8M8flOzKR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708385410; c=relaxed/simple;
	bh=UmFhknTMAqRB8EdBdzNAU4HWGpqvvTzviUCnBoVueVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LnxDci1on2sewK9O5LKcXVnZ5mmqvZyCsaWFCZ0tbq/aMYTXggD3MpXFJtjP/9hZ6mXpfyevF6HHV2cWGk66ov7v/ac3pICHX9oZkQkTjaY2mk561RWyA7NPs7COPDpd2vTRjFoOexOL01J7Z+wxwJeEJFf6081SNUfHGGuCKf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=SN8To6vS; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="SN8To6vS"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e46b5e7c43so607280b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 15:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708385408; x=1708990208; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=enyaFsIC2inlifOk5wZnkb0wtmoJYp1/ydh5DPRe+oI=;
        b=SN8To6vS3Q3KTT+EWO7eu7duuYWhx0y1P++A15fhDIV9bg7+Bo9iELVJJor/IW9kpw
         DY+9AQbrWLSJntbZNa6gE4H/HvHC5hNh0imCSfzHvYm2sb+MRNFvyMJMUVBvcrMcTJnX
         C/e+jMWpk48N1uQoidQ+coCP37/Bhvptity/ht/jYfdCGKv7YzFY48eNtCDU89KuHUQp
         SkKZwp2yvBp2dbTeBp7hruWp9X3MS7a8vsibxBNuAPkIn3dscUfJGK9rnMCkBtMa2JU2
         HIcYXZkliK6atrApsSYEi3OdxKjggiDwBpjr/H/c6fC/uVbGScnZP8eYy3rZwN9eLNep
         pBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708385408; x=1708990208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=enyaFsIC2inlifOk5wZnkb0wtmoJYp1/ydh5DPRe+oI=;
        b=ozcf4/vqjSn/EfvRrTqcX1YXcwbg1CLXZX8THu2WpGp56vDpSsPUNT27yoR8zpckls
         LzD3749ImQvwS5vYe7zVbzYkaNes6edw8/obffkgJBRCSoBfcKSgf823pXzvmKusTPHN
         VvTIgQoVTFR/F9kGu1cgJCdFdMMrSvGt7umQEAwQTCSBUrQcmMq5OEgVjk36651ePEd4
         P1k3st45ej2zKwGW8BOAybTs5h2ASKAx2c4AvBY13n3FyS3AU9iakjbTeLR2N0ZkrwDz
         CzG+Z317cyvDcKZ2BRmOcx/WWKISuLLcbE2ABb0tX9oUc/9YxUqf4BVPUcQWdu1JRfCT
         ew+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVgVtmlVLEhCjw0R0m7keMM6HZixY5Yi+SUocDkcCO7I6TFxT98yUdocVUUlT/zC7y/TG7kb7uvGgoHlACGL+AUeSEkjhqFzE0c
X-Gm-Message-State: AOJu0YwOc86Pfeybj+8dx475rhEewOR5bI5J5jaOmMwvBt6qAB4NQzFa
	tNEbKrhLOBhQ/Ztd/KxXbeohIhUQrdgewQnZmoeCnt+Pv21wPlBV9Wtq9QiqcfI=
X-Google-Smtp-Source: AGHT+IFMRISluJO4QKUvrV3f2YogEHTyXrZ0jzYJRK7SrxZVvDQeZRLNsksrqZo9xh7F4TDTcNnfXQ==
X-Received: by 2002:a62:d41a:0:b0:6e3:dbcd:6d65 with SMTP id a26-20020a62d41a000000b006e3dbcd6d65mr4814782pfh.26.1708385407481;
        Mon, 19 Feb 2024 15:30:07 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id 5-20020a630f45000000b005d30550f954sm5199579pgp.31.2024.02.19.15.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 15:30:07 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rcD5H-008pEw-1P;
	Tue, 20 Feb 2024 10:30:03 +1100
Date: Tue, 20 Feb 2024 10:30:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <ZdPke6g0cp1jcMn4@dread.disaster.area>
References: <20240219063450.3032254-1-hch@lst.de>
 <20240219063450.3032254-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219063450.3032254-7-hch@lst.de>

On Mon, Feb 19, 2024 at 07:34:47AM +0100, Christoph Hellwig wrote:
> To prepare for re-enabling delalloc on RT devices, track the data blocks
> (which use the RT device when the inode sits on it) and the indirect
> blocks (which don't) separately to xfs_mod_delalloc, and add a new
> percpu counter to also track the RT delalloc blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....

> @@ -4938,7 +4938,7 @@ xfs_bmap_del_extent_delay(
>  		fdblocks += del->br_blockcount;
>  
>  	xfs_add_fdblocks(mp, fdblocks);
> -	xfs_mod_delalloc(mp, -(int64_t)fdblocks);
> +	xfs_mod_delalloc(ip, -(long)del->br_blockcount, -da_diff);
>  	return error;

That change of cast type looks wrong.

-- 
Dave Chinner
david@fromorbit.com
