Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAD41552EC
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 23:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708473481; cv=none; b=HvsLUV6zIXA6KMppPLbCeQs06cV1T4BWM+cJY3XGIf0bdZ+t3mCZQtP7HPGhXVeN+lHOJmY8Y7PIqUwkH/TB/nuS0O47BjKO1JD16DziirVRQtTnQOoB3AAV5EbXB4tqqT4/eOxFFCb29dDeP6Kpti9aRo1/bl3CdjUeOXgKBv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708473481; c=relaxed/simple;
	bh=Vu0qBGxXYI3e16CamvK0mPBA6ipagKIp5g9nm3mqaT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r72iENbsfiEI+M4EnYn887wyN82eWqaudFrt/9XM8lxGGRcvXSLx10jQORBypQHh1QQaVSdjCgnQoq5PVevXK+Fxz66grMOdGcVa0R4mQ/xGP5eaEzMjy86+xpD5wo+XeHqW21in9UqW1WfNpGhCKox9KiwcXpDjqt8Md0/8Gio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=I2/qame0; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="I2/qame0"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5cedfc32250so15086a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 15:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708473479; x=1709078279; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+HuOeylfhXaySJrII2DZmb9hzOJWICWbUMUmjutfkDI=;
        b=I2/qame0dXCGxH3YmcUNoRvmI5Ph2jWf62zNB5p0MXtUwTfmEWv1grS3HtoBJ+ZSrZ
         wXbopdDQx1jsx+X1oyoiQzjZFXLSwh8uUELKgeCMaExGdooYuuYuOHb+/uuOgwVaZu3h
         ldXRMbaQrhU5m+gfnKdY8xc5LQvMbANQBDhpvyK8aIzfKZQqX3MBuTgOAd/4iQtZ3gyk
         nYmYS/+814IAqXaYVOkAMIyORYmjyox8Aj9Z584O0xisKklm5tJpXD73DXy+1OI/AVoE
         VHJe6jFGgIs6weAlF0CoOMlEvowjWVCsns8pMAgr//lAEp76zW9PhICkvoiYpo4b2i+6
         aAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708473479; x=1709078279;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HuOeylfhXaySJrII2DZmb9hzOJWICWbUMUmjutfkDI=;
        b=qzfzqGM+YGEEdCbvRW/9P9AHUTwskWaiCcwhKKqmrA5Bs5xFXll7YiQkZB0JqyknvS
         pZXUImnDoZ4i5ip+/AHn+XxqREI69zrVrOmB/jKaVti0ZyzXi7xF90RkZDcmin5SwlSE
         5Gkp5p4Egquw2ygnTyluF/1MqbiHUVIdVK+D19jvzpNI7Ad0qj9umswatXAnxGyGTsY9
         aAU+quTOJAuE86ph9yAv1ownXY15OK+8mEhNgApWC3/MW6KvXh9ZwETcPqpH/iaOG+qn
         9WlN3U7CoHY+8wsTIjXa5Kmi9MzvLAtoRcIYFXcMNqwYk9WAp9QkysOlJazKUlPFq/Bx
         e7tw==
X-Forwarded-Encrypted: i=1; AJvYcCWNpTofo26LBmDXULxwgGiT8vYpw6Pl8KEzuiCLe+4KurO722qJ/F4I972O8MxDFohorSvH8ZkZjwZdNoyrmQsWRAD3xIeVtpo0
X-Gm-Message-State: AOJu0YxIWUDUTZ2TYmnejGLjyRbzG3v1O2e7AJBrxEDAo4xKIPVtHgaC
	mHGueqX4jmbJFVlaU4NzKUcXYweyUY2wMGvj2+t9t4roql/z37AW17aM3yv7/Q0=
X-Google-Smtp-Source: AGHT+IGkxpJ6hQXdpszA76x0NvVkFFvn8Lx2eocw7tJ7H2zMFrbWi4m3c+wQjzDg0RzU5k5UgqBGuw==
X-Received: by 2002:a05:6a21:1690:b0:1a0:6856:d128 with SMTP id np16-20020a056a21169000b001a06856d128mr16414653pzb.9.1708473469047;
        Tue, 20 Feb 2024 15:57:49 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id s5-20020aa78d45000000b006e1706f8b00sm7345712pfe.78.2024.02.20.15.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 15:57:48 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rcZze-009HS0-0z;
	Wed, 21 Feb 2024 10:57:46 +1100
Date: Wed, 21 Feb 2024 10:57:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 22/22] xfs: remove xfile_{get,put}_page
Message-ID: <ZdU8elkTrE/t8kkv@dread.disaster.area>
References: <20240219062730.3031391-1-hch@lst.de>
 <20240219062730.3031391-23-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219062730.3031391-23-hch@lst.de>

On Mon, Feb 19, 2024 at 07:27:30AM +0100, Christoph Hellwig wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> These functions aren't used anymore, so get rid of them.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  .../xfs/xfs-online-fsck-design.rst            |   2 +-
>  fs/xfs/scrub/trace.h                          |   2 -
>  fs/xfs/scrub/xfile.c                          | 104 ------------------
>  fs/xfs/scrub/xfile.h                          |  20 ----
>  4 files changed, 1 insertion(+), 127 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
