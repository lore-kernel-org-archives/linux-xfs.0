Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC9F1CABF
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 07:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714636520; cv=none; b=HXGB6SfbdG+4G57lxQxhfCoMP8YI91Gc6PwvvWySaBDmzKFX7SmoJYE/J3YKw2ganZUHod3h28+XT685IrGw1TXwG71nTNdoG5Dd3tZhsOjF2euixtTukPuaQ5JbuuL0OgP83drs92S0y5qZETtCQTEK7vFQpjh40Le0RFCd+OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714636520; c=relaxed/simple;
	bh=bLoi5/9GoirFo4iDtSSbJmVZM11cFd6FewSXQBvcGmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BAPTydwHvNy1g/ED+xUWamoUzMmtgkj45cVL1zkfMIRjOnxsEeyaOdi/1+fgXFoNBy2fVo+jTjyP8ysB4ebkvr+pc7OXKVgDpTT5SfzKyrm7JvfByCN0G1MyB7wT9jVYzVzbI2815HWFHgahYsdUsPVziC1UUJ+H9U+tRbcsDuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=2i70K0El; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="2i70K0El"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e4f341330fso70479295ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 May 2024 00:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714636518; x=1715241318; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vzXgdQNZCTq3zXbY517Bc2QFGyYT+5u0QhtsOjLC20Q=;
        b=2i70K0El84H9xvxag61hqoXw6Qv6Oj6ApVUnB6xSLQhMGgVYRQq3lw9BXo7UOLZAQT
         /JwVAZHF0ZtXWfSjLNjsTd4+zDYW9DhaB7aJ+l5k/esZV9BXspwPowAL5rFQ4iJj0RdX
         cHoRBjp+95TrKCfbAzMzQ2zhhebB8ejcjlXt4fy2RAA+7IKloGdKBwGGX5UmE9OnDuaI
         eUE71B38Z8ck+e55HltnXG50oifwMUEk1upnhvI4HjGig1LbSvGf30CE93A9MaExDfHF
         6Pf2iBubER34xGCzcmTThAOG5nWn1+FLaZOEbGP41yKh/r+07Y5O/Lo9KODXK3DcwcTO
         G+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714636518; x=1715241318;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzXgdQNZCTq3zXbY517Bc2QFGyYT+5u0QhtsOjLC20Q=;
        b=mJIC+PABZxXFbhdme74hCVGl98s/HAhsa9meadYH0kfnAz927oQ1rdWQlSRHUXH8Oc
         9ADtppAxIun5LO3jkso3xsOrZMNp+Gg9/Oj9IQJx5wJMeUPkMt4u+Ic+1PC3ZxcO0SQd
         AOG4zZremlbHFsrUtZ/vAk1uvCC1a9txzcl3dOemrx5kCdXnRWRo3JR7L4DvXL5PvwRs
         dz2rmpzIM+cGtIwZruSStrbQTeW9mVau+v2d44Rzgtr1GXvq3aSeDB4gVl79FGuaGdSE
         dSzh+w7oo/5VrNfpDkDZjJGT33xqlIxxmhjzxEeIWBSmQhpr/pYOXcRCD4E401L2sPwn
         HxHw==
X-Forwarded-Encrypted: i=1; AJvYcCWmFGaZWqlfjCfXhezAmn1F31SBoHGpd4C3ous48++7zOikAJwkNcgF8Kbr+GhjfcM8FqBZvPU/4I7QqXOPld9h4bCYgNmVYppA
X-Gm-Message-State: AOJu0YwvZTKw/rS7cSCDEeFrPZMLElptUCHBnSfDhE3hJfrAzrmx2Rby
	GJa7xovQd0T8yHWXndecx/WoxiV9yqco05asGMEFO/8c78fbcJT5F8RUZ/9j029VMRV2XHvM8rb
	h
X-Google-Smtp-Source: AGHT+IHRZBbQZP0DBHQv6E9P8/zWVJU4aYzgwE2tCeti1wXlJ2Ps+r+uY2RX+iTKk2ZJDng7v+zqLw==
X-Received: by 2002:a17:902:d38d:b0:1e2:9ddc:f72d with SMTP id e13-20020a170902d38d00b001e29ddcf72dmr4764117pld.26.1714636517560;
        Thu, 02 May 2024 00:55:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id p2-20020a1709027ec200b001e3f4f1a2aasm644163plb.23.2024.05.02.00.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 00:55:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s2RHe-000h5q-0n;
	Thu, 02 May 2024 17:55:14 +1000
Date: Thu, 2 May 2024 17:55:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: simplify iext overflow checking and upgrade
Message-ID: <ZjNG4gCLupVAzYo1@dread.disaster.area>
References: <20240502073355.1893587-1-hch@lst.de>
 <20240502073355.1893587-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502073355.1893587-4-hch@lst.de>

On Thu, May 02, 2024 at 09:33:55AM +0200, Christoph Hellwig wrote:
> Currently the calls to xfs_iext_count_may_overflow and
> xfs_iext_count_upgrade are always paired.  Merge them into a single
> function to simplify the callers and the actual check and upgrade
> logic itself.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
