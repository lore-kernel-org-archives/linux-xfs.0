Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725D625B1E0
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 23:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750203625; cv=none; b=Q16SaTPhf6CPt3Ro/L2GPiQ9nBYdJDh3tlMXSy7zwHxZorFV4jL1ihPmV/tjYGNz3klHQwQM/EH2HMBVD06lKgcC0iAQDj8wgN3bHaGXkHzTGsj0HII1LclwSMs8PoL0W0dTpOsIi08+hNnUHopIQLCsiSWDX27t9+rGIVgkXok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750203625; c=relaxed/simple;
	bh=48LEux7d63rbh11z8zfb9D2mpOzvGq+dZrpqd+8DtmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nnOeRT/pMHZHrK/ME73BRhXvnGmSXNLzsUjf4jLUZExLZ2DzTSzdfzyWQWbl2CX3remotOPbjuFpvlU7nD+i7f9/YRhEd2VrVL0GOvS/wFy4oBXILM+AbQMunHc/ZKA/kNRysCilZJ2WAPf0LpKfL/QZuzTDp8Fuc849UY0qSuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Ms99XIyC; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Ms99XIyC"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2350b1b9129so45058015ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 16:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750203623; x=1750808423; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GUK+H6M0RmxUVwmekxtAFH5FdXpqPYlKI9B9Z3e8xPw=;
        b=Ms99XIyCPYsvM4k224RZvQXw9BqyZ7ReRsdB+SsXtqPZcVZL4nbkHYZSx7t1vBuKBq
         A2RKzcDWhD3LahC6JDEimvjp899gE2vUMDXPFJ8NnwKm1/VtYoPUX6xHZh2DsuWsAqLk
         hryIxEWV1R86TT41N7MhmWtJu5R5F5V7kk9bJSMUbMrHSazcBRAOJ6/Ba/qm+ewhRsp7
         3360VrJICeVHkDq4IckfEiSn3ZrLFQ2dahxmFJTlcYa6NOfBBWcAVbhxZhEPgWEk0ILx
         YV8rmpnUiA3fcOE6nSVbe2fKxMlhDm3RJClQitPNCSmNrGwW62TRcxl7/FsTR5AeTgQe
         rPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750203623; x=1750808423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GUK+H6M0RmxUVwmekxtAFH5FdXpqPYlKI9B9Z3e8xPw=;
        b=gO+Reu/T7SdqOlr7RwsPZ2Jzv42sqb0Q71jCo0TG0hmxk9Gslp3l9rRhirp+MON2Ov
         UG8mwdhofKkEHoWfyybhtHdWsYYeJ/m82kyz6A2ErjjiFt30MaP8CSoNQgt2JsCeY/8o
         E6FJq4lS6X7+fYb72YftBFij7HbZ07EtXjOLUaytNzgHy+iSvDyD+fLzT/8pQefnPaqj
         tLyRlM0Ysx/0mUrLLowme4SHwbDBpcyEt+PA2VYQtiyeKTSplu8gjVMjQTTixbt/KRz7
         0+ROAEv12SKqpuh/ub38lor029M3qSg5AkQuU1UXXTqYL9Ftb6fOSKXTYtPWEWKkbZUA
         x5Lw==
X-Forwarded-Encrypted: i=1; AJvYcCVcbvlfHekQFj5GVrK4V/zRf8+QR5eRb11coEojSv1BAMeinrS9gKvoQe943FeVbc9I5yhjfnp+Lhw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8MaXHRd/rtu7tyN4nu/HSIfErLmcgaWjB8WGiOnzl1E6fNml0
	13E/Bm+h6CfhcUydWA+ejImuG7VywA8DwyvG15ihWWo2Kq8uxszNgRlyETEMOkiGW2A=
X-Gm-Gg: ASbGncvOFnJ/R5bzw0nIS8HFIW+0iXwin4wd+cUi6MZ/UmIGYNQ3zE4y/bmRw6gisur
	L8Q+mS2JSEV1MkazVIKYgAbZTumWzB84hcH5kJ4zIOYBQGaNp4vsgRYtYRQTPoiRybLuf2Xo1+E
	hylIVE4tBVzvtdJWbv0ErCG6QIAH7DT/rc5JyUjPn0O0NUHOYiZfILmITxSjJNP+g9B1qI7BuHY
	aHH8oFXJTwWghxRgKDZwRKliPg0GFbrGgqAL3qBtjunDvkx675OeVahg2E4JZ9UY3w+KyRTIcbO
	1WXGIexCRpma0SqCgcUKDyDutW/eLXVnUGNtG7cHpX1/WjkH2N0d9KAVgVPytIqYbDJmH7kXQb7
	K4GwzZRInD2NUSgP7StXqengv+m8Kx+wbEZqaZw==
X-Google-Smtp-Source: AGHT+IGLyRt51NNvwFlbTJGH4WPQVecx0xoEfHR/T/H+2RpeodByCvwUSJeqvS63BxlpSskTNWHrIA==
X-Received: by 2002:a17:903:1c5:b0:235:7c6:ebbf with SMTP id d9443c01a7336-2366b3e34a0mr244989645ad.35.1750203623536;
        Tue, 17 Jun 2025 16:40:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365deb4f85sm86783955ad.183.2025.06.17.16.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 16:40:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uRfue-00000000C8O-2Gnk;
	Wed, 18 Jun 2025 09:40:20 +1000
Date: Wed, 18 Jun 2025 09:40:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: remove the call to bdev_validate_blocksize in
 xfs_configure_buftarg
Message-ID: <aFH85PhSv6NnjWIQ@dread.disaster.area>
References: <20250617105238.3393499-1-hch@lst.de>
 <20250617105238.3393499-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617105238.3393499-4-hch@lst.de>

On Tue, Jun 17, 2025 at 12:52:01PM +0200, Christoph Hellwig wrote:
> All checks the checks done in bdev_validate_blocksize are already
> performed in xfs_readsb and xfs_validate_sb_common.

For the data device, yes. I don't obviously see anywhere else that
we check the fs external log dev or rt device sector size against
the block device sector size, so unless I'm just being blind it
seems to me that this check in xfs_configure_buftarg() is still
necessary for those devices.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
