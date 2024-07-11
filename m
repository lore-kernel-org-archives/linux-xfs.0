Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AD815531B
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 22:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736848; cv=none; b=bX+Q1VRM7B0mPH4igkpaYyoNVDOA+xZVszBUdU/1x6mFdOEMLJgBQRPOVmuuprDdJoQeJ/b6B30Te2yW3KD1k69kVOg3HNBSrEMkFLETujHyFKEHTMGPI4dHoG4atUbba8fhmLXKjGPePFRh+ZzqrTir03/r6G70LZelh9nbixw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736848; c=relaxed/simple;
	bh=ruEMrtZ43w0PtddQcu/RZD/GlACQGTwlxLorYt05Mm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B1lrIxFschVrspFCDDcHdU48gVQnQnfyors5Lxn9YP8F5sDbOsOvyOFHoOaS4D/TeBq9/zdX3L5yQmrdBn0hoKLJgzAuf9gBxe8sWJyqGnff975xbFvQYDSYURPN+LdjZLfrSJ8M0FK2+8VTK4dvtgar491yERyTv2M42vTHY0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Eh1c/+bu; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Eh1c/+bu"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-70af8128081so1176933b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 15:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720736846; x=1721341646; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qkzk7iO/cCR26Su6zm61bOZOViK3EE9yqYftxgKDkXQ=;
        b=Eh1c/+buqn3f5YM6nvkrsf4VSAwBrbDQNx7TmM9ucjuy0sGbG7VbuCh978fo3P0S7Z
         n4fOecd5lNDBBblFZ3/+asbVHW9gvt1yJ1Nn6WGYVT3HFNriTWMBACl/Vy1vuOzE+l7d
         35SnkG3dDHy0Ag4A89H1/Yx5R54UjgWO+/GRo+t0sOYc1VBrvde7YzGy8560A0TVnF3Y
         PrvjtC7RCmKB2g5RbZW+625Y4Sc8M6GcvJ7/o46fuMja/QiPWveH8sbcnFvuHb9sxOs4
         IPKLbjQA4tDb218+E/lZyEyfAd7CtpCds6aMfWw0YoFZwqqQXwWJLXAU+D0dEKQrtCAD
         d2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720736846; x=1721341646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qkzk7iO/cCR26Su6zm61bOZOViK3EE9yqYftxgKDkXQ=;
        b=aD3lsq/+cTe4KVmJ0PykYIr3OhFjNsuzOv6KsJhaMuEN089Gcjw0WEaFMidWLjBZrW
         rgaPiVNViqiPAxLdPtH+3XDwO/HKyZZcv4+h1gi4akEIYvWzJT0oP4XmkqIA83cc3es8
         oG2YymrPGCWiOVu+PHDyz7U4ZnUXFzXy207n6YPPmxq48TW4UTL6r57HWLZ/JyHGWSNQ
         cP+mGCY0ivrJ7kEdBU+JS4ZQ0BhqZN5ISh4Qs1pVhV8gTLtufWH/H89CzPP+Hmz9lMZA
         bnNGGhZgux7qIvMft50nKkXiYq1p+ChvClAtUkK11DA96jiTzLOKUBbtgVdmSoTdInD7
         eM+A==
X-Forwarded-Encrypted: i=1; AJvYcCUNeEUO1odv2HDXPJZ8ekoGcBemEiVp4GF+Ma2kcqgIT3dAYSO8F0F9XPXW4l9Heptsc9m7vrtQMI2tSBH8dVQEDdKyP4OF78if
X-Gm-Message-State: AOJu0YzJLwibSk774L6CYFVGa8HgFTL6PWqerF1yojmO0Xxh0BZwcofZ
	k16idXyU+OeN3cRz+9+7e8rQXDi5wxiSTqLMg35tXNk71hr/nfE7xgLEsCmh1vcmf5NKQVpQKX4
	6
X-Google-Smtp-Source: AGHT+IGSLCnDSySwqbHOfciXHSGVQMP4G/XOU35cytWLcOyxIIHON0YsNokkIHOocw8kj8Q6erUuJQ==
X-Received: by 2002:a05:6a00:2394:b0:706:742a:1c3b with SMTP id d2e1a72fcca58-70b43545404mr11534000b3a.8.1720736845874;
        Thu, 11 Jul 2024 15:27:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b4389c175sm6400578b3a.12.2024.07.11.15.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 15:27:25 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sS2G3-00CWQn-0y;
	Fri, 12 Jul 2024 08:27:23 +1000
Date: Fri, 12 Jul 2024 08:27:23 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: validate inumber in xfs_iget
Message-ID: <ZpBcS1P2B3Xe1+HH@dread.disaster.area>
References: <20240711054430.GN612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240711054430.GN612460@frogsfrogsfrogs>

On Wed, Jul 10, 2024 at 10:44:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Actually use the inumber validator to check the argument passed in here.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
