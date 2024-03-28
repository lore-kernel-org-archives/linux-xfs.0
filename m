Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB9638389
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711599353; cv=none; b=Re7hkJw63IYzrfrSfUoworHpMcHbEATRzVTI4JPnftvX3l9ngD0YW8DpWtVPQmQQQXLKtbgwwC7uAF/dVCfFfOE3gFnkdtfKodnDAXbjZh6SbnppSsHBHBw5HIgXC4uMxlY24dw/7geiS6DsOlzylIQfhCRBNwu/NujeNIJgOPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711599353; c=relaxed/simple;
	bh=GNEPjYAF3m54soUrh2Yv6tmegwxywFo1HFKSF1FrTq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qv32f06kwwFWsoeFWijCjiRvAm4OkvuveVzKzJP8P+Y9aUDPulAV6kiDmR+0Vj5Y41m/pu9c0yuZKZKZ5EXuh1diXSFoDJC7qEi60M3DpVHqBV/r9DpnTJFc8J/9pbMzsly5C5mG4ZQB1lYjvlz8Y6mGjpmRNLQPteuhvJhH000=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=UdVwTJeW; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="UdVwTJeW"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e6b729669bso518737b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711599351; x=1712204151; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VfBp3/cbRPs4BVjzV/tfUCrzotCrErCbx6uEJ47NKAo=;
        b=UdVwTJeWUTmfXmJdUMkF+Sd+RmsQA2nXfcOTLtEFuX2TfW2GBYIioY7cphC9wZg2tQ
         Y2BmpoPOWfA77eRfkyPip7Hxom3ZL63Hfexe/Uz9FrER3quSG51+1I3DpWl/dY70ySGN
         b5PKNLco9CyFhud+frg9ThEFcKJef2pbO9I/POWy3IS4y+JHs0wk4EmPjisCO6sybIiB
         nxlhk6ZJSTHO4u/xPKfuvp2rbocGdrZrInKJtH6lD1MwugMv6hshI0X+pm5PQIDtp8N5
         fvpEuRG67n2faH8y2G2lKNxPtniRrZCDl9TfeRSVllhg2MxMqVLFcQnhey/SrrdopGOm
         ztnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711599351; x=1712204151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VfBp3/cbRPs4BVjzV/tfUCrzotCrErCbx6uEJ47NKAo=;
        b=SGDrgELDbSXdajEG/hc3ZqasuHwhlaiNpQ/t593Xa2OcHG6WhS+V3MX03tLyU7m5BC
         fHRhbJ4Pbi1m4jnE4IUU1MfXz5PZBfcEZHsaaohlfw9RM+w+nq2IP+qec8Vgf8/irSKR
         ykZ1LtsrQnf/h51KFlulsCCkOmsfcuPFYvZy9Ckz2ChekTaObwcKwcZsdJ6H8magXfZS
         OWd5h4hlwfVAqDDu513xD0fVVIq7QS+3gVDJ2rXOee3tScstZ2v4W+c8Gc2/DM/2qjf8
         dAhG4sSa7BEOd2HcOVNWFoXhsh5Pc/ppWFpPqLrpxdX9giJrLegNQ+rqnUvBNIXa1H8C
         7SQw==
X-Forwarded-Encrypted: i=1; AJvYcCUk/vB+yReL1vnkCEgBKypmDQjw2uxV2mLatYv3iJ0KcZe95tdeMItj7b7zSarl2jhHNARTOFSIxcw5lQRfYisdp/+LMAd3u8Yh
X-Gm-Message-State: AOJu0YwOTOQpTMxyhGRBP82pbWcvtuBAKfXO356PtSOjBAWN8GwrNjrU
	cLytUhtG9Hlxyyt+peLQNIZydh+GBg6vH7Tdk1XrgY9a0NTXH1fEIYl+4Z21zRoWL91a6e7kvQN
	b
X-Google-Smtp-Source: AGHT+IGJzQDzuIlNdY8Aok4kDmUGK19az23zGOYKE5CArS3eI2avuBhE3D8mjMiX604dMHGKtVIsmA==
X-Received: by 2002:a05:6a00:811:b0:6ea:749c:7849 with SMTP id m17-20020a056a00081100b006ea749c7849mr2444925pfk.13.1711599350617;
        Wed, 27 Mar 2024 21:15:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id w8-20020a056a0014c800b006eac4b45a88sm374418pfu.90.2024.03.27.21.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:15:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rphB5-00Cg8F-34;
	Thu, 28 Mar 2024 15:15:47 +1100
Date: Thu, 28 Mar 2024 15:15:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <ZgTu86veQ1aWuHDS@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-5-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:09PM +0100, Christoph Hellwig wrote:
> __xfs_bunmapi is a bit of an odd place to lock the rtbitmap and rtsummary
> inodes given that it is very high level code.  While this only looks ugly
> right now, it will become a problem when supporting delayed allocations
> for RT inodes as __xfs_bunmapi might end up deleting only delalloc extents
> and thus never unlock the rt inodes.
> 
> Move the locking into xfs_bmap_del_extent_real just before the call to
> xfs_rtfree_blocks instead and use a new flag in the transaction to ensure
> that the locking happens only once.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Not a great fan of using transaction flags for object state, but
I don't have a better way of doing this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
