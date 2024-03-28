Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451C517BB9
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 03:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711595332; cv=none; b=rxCnJXdFT2TXKT1JUHN0ps+xpf0i/hzSouYBTByDtRftWacy37nxT3gPxRaBDRpyjQFBZkMGjs92yyrNqVr+KQqbb1isWsi4i8OCDzp6p4FAFG5KIxTYTioI5unLnVahhtLlLa2VQfMSDc57dbpOQ+U8AmW0bQ0aVEXSz1wt8Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711595332; c=relaxed/simple;
	bh=kvRifoDLvUN5T9DevOjToEBwFfqYQjv3IH56lLZ8ypk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P5U2KVcDWdaCBxk7QIjkuZzmlQtjnRdwH1Xfzh/XjL9cXa4szFnaxCi3u77wwTYay48d6/jDHkZ4JOOv1aINBq+k4miJ9vQXigfwnncril0HxKvlZnR1G2eBfzjec+HqxWCIZEePKyosxfuFL/WSXo8entIQzFBzZBxkFYzXd7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kIF04OH/; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kIF04OH/"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1e0d82c529fso4879155ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 20:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711595329; x=1712200129; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xMbWyafQIpTmovJvdaOgZACEtQFwAhR2avUrxGea9Mg=;
        b=kIF04OH/HkOvRbQ3uAnw3+BVmrLlbiL+SleN/4nYY32/qzYjRMbi3x+X8o64F2M0l7
         kDFHlJAWWluj9A1jX2iFeSoZlUCDAQdAXEXMFCnv9hoNYwpM7gT21RYTbEsDbzmrvsTE
         MmiCMweX+HOfd66NEFD9xgBEvpoq8UhRP0EFW1P94j3qJoZTul3nrSDNIGyv+UShmuS8
         Y+ALuQeUsg+ljyWESyLGmDXrCGonw9Y8Tim/Kss0CCLIkH/cQhmMEbMhDN/E3MZurVoM
         ZtQqhhXj5LxGYxdiQ1qDr0Eqbt8JIpj07vOpNj5M8bTPhR6UMRmBYwCwBQ+8Rn/5m8p7
         Pkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711595329; x=1712200129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xMbWyafQIpTmovJvdaOgZACEtQFwAhR2avUrxGea9Mg=;
        b=pLSD0Oog6id//zH0kuy77kwgBYo5wgj9H5G+r108p7wSoxVekSO+VXe1yeN/FWovId
         jr+1KEg27XHltPb5S+PeFsgGOgikTg/NUlWzjs2NjFCymsZOOm53RYiA3+bUoP2I9Dvv
         7CFE2OQ9I39MyCUGk2i+v3EfVYAlXMZK9Xt/jE0jOoWbSU1ORbN8gTBosQ3697IVqs0Z
         Bg9ciqElQUxCgl+/0s19YoLK0/2zziwogf/lm9o3pYuZwFl8u2QGMGxxL0+7MW9EPXsh
         fCuy4tuqiAksAusGVUkETa4q7M9tMpQuJ6opFEBx9SMYlwwZcrzKrjEBMmyU38QK6IDg
         o76A==
X-Forwarded-Encrypted: i=1; AJvYcCVCuGy7VZYvcXl+s0XBaB6CJhIXJEoK9eC5GHhXnQ0Az2zDqijjD4soV3CkNpCBRu0aH5960YXWKtX3baJTKyLClWrzySfXrEhg
X-Gm-Message-State: AOJu0YzpjoRBdQUQoGZocaV6HAfd7gw4OU8eppH6yz5MveW7qwy+EHT0
	PYaI+Rb6Un7615s2zJg+u4q/rXLvWyAB+EV6a2e/cvNn3hRsfV3OnMjxAJ2jCtw=
X-Google-Smtp-Source: AGHT+IHsiDahPG27bCm44IjSM/grKJHxfKIpcvbSEsVZ/DxC+bchVHeYP01IoNL2vlNjQhYpew2Zow==
X-Received: by 2002:a17:903:8cc:b0:1e0:a2cf:62f2 with SMTP id lk12-20020a17090308cc00b001e0a2cf62f2mr1743750plb.23.1711595329392;
        Wed, 27 Mar 2024 20:08:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id im15-20020a170902bb0f00b001da15580ca8sm305832plb.52.2024.03.27.20.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 20:08:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rpg8D-00Ccof-3B;
	Thu, 28 Mar 2024 14:08:46 +1100
Date: Thu, 28 Mar 2024 14:08:45 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/13] xfs: make XFS_TRANS_LOWMODE match the other
 XFS_TRANS_ definitions
Message-ID: <ZgTfPYwjuyvjtjtU@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-2-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:06PM +0100, Christoph Hellwig wrote:
> Commit bb7b1c9c5dd3 ("xfs: tag transactions that contain intent done
> items") switched the XFS_TRANS_ definitions to be bit based, and using
> comments above the definitions.  As XFS_TRANS_LOWMODE was last and has
> a big fat comment it was missed.  Switch it to the same style.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
