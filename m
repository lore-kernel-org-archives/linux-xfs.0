Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF1C1CFB6
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711599773; cv=none; b=Gzcew9eR12Pem1U5hudQn7XD2IdmHjVvsLGCahxHeo+LtklXUO6o14noF3/DzZq67rM5DWZO4vHRDCjgoHPdLrcACAU7NI6TJpKZMLjA5yiFhVlqAkQ88HBK9Cp658j4cPJvXCbixo4eKQldO+r4iN0QlbIJOnU7Jv8JLLNEb9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711599773; c=relaxed/simple;
	bh=7WNebMWDw+Qwx39rHFLv7WK/EDFjoOFIvPHKkuArs94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8/Mf7AH4P8oXUkjZWZVH6uPdz5FgM0f6rSKnW6y2b0yv+8vuCdUnZ6Gn6crZ/YJuPFlK052QEvrOEKWEPEDoCfQDlXGvd7e5tBr3SLW2/xISG9Zw/BdEeFjdr6a56OzejEgxXGc2f3D9+AZhWjsil7ETUzqAuMAQtqFLJgQV+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=h6QXlEW0; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="h6QXlEW0"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e6b5432439so533917b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711599771; x=1712204571; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nP8/27fRzreRlK27RLht2PQ7ydQJqVmPY25fh2AGius=;
        b=h6QXlEW071IwYXJriEHYYauXgE276yzuHahE4BZiCC7H80pH9cKwENYvMvduCni37W
         kOER88KsYB3YXFJKak27O+wAYXj0TNKy5eQJO4DWu391oYjRQjp5dPsAQyKGFFLBq8Rz
         L3tdGzB4F5yaCxIxWrlOmbdEK1A86abYeQYQYX/wIfZ86f8DwO7CuhdonOKws3e7vQn/
         6u/VdXiz/BbQ5jS2mr42FEFGomjXB3ZCbzAFjkiLQqYCxel8HOpxZvqvxu6duwUzFiC+
         Zy4O5xFjfoHRhZccV3AHyw20O2yihBjpL2A8P/0pw0gRUUPV4WktiGDelI+Z57aQ/kN5
         E2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711599771; x=1712204571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nP8/27fRzreRlK27RLht2PQ7ydQJqVmPY25fh2AGius=;
        b=h8byOagJosekV8bxKz6OPd7wSe9GPB05xBfZbPaM+Dup7VBy/QcPVsS1Xyjmi3Setl
         UDFmxZbB2gw7MZbvR5fDujbZ2rbM4OKdB4E6HCLWNHJWeHjnTBpIafcuROXVPVaeMj8V
         nLLi3F7PLTUgvGfp8SaJQ1dmNBf0BAnd5y2lfCnh3HPDI4IK0deLShCMFCwkphi67KmX
         KawDOXJDWmfzyj4u7IrEnu7hYlKDxIaCjGxjgaooy8ajDLBqCftWrM8YlEfgGI77iwYC
         3UVLr5mN9GzJ6IvkRQmoYfGkkmEwdNwYc/wl1EF/Ro9cdwzBNecPCtST+hQmGdCEck9T
         2Mfw==
X-Forwarded-Encrypted: i=1; AJvYcCUXET2AdgsjIqrDBOQt2bMYPu2ao135ymGzfQF2SgMGvKs1t4a51apXIezyN4BqNQTRFW66+RfyDKTASXH3GU05ldRExHAhxKam
X-Gm-Message-State: AOJu0YzJ4pBX7FjmKnBj1IlGjOvftVihWJZJUSwEqIRsaUqUlQ2vUx0q
	Qawb/ytkioAK3vFYN2VYHq43tS5m3Ep3BJ8x3HgngucgzkBXst7PjpVzI/Ti2Ds=
X-Google-Smtp-Source: AGHT+IHpqae5N45j9bHzAaG7WsQdcKpIqajRq0rYdCZUql9nKyswNxPHq331U852zqYwPH0xGj16rA==
X-Received: by 2002:a05:6a20:8f05:b0:1a3:c266:e7bd with SMTP id b5-20020a056a208f0500b001a3c266e7bdmr2132099pzk.38.1711599771071;
        Wed, 27 Mar 2024 21:22:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id x7-20020a170902ec8700b001ddddc8c41fsm387057plg.157.2024.03.27.21.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:22:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rphHs-00CgR3-0M;
	Thu, 28 Mar 2024 15:22:48 +1100
Date: Thu, 28 Mar 2024 15:22:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/13] xfs: cleanup fdblock/frextent accounting in
 xfs_bmap_del_extent_delay
Message-ID: <ZgTwmO3xY46oM9BR@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-9-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:13PM +0100, Christoph Hellwig wrote:
> The code to account fdblocks and frextents in xfs_bmap_del_extent_delay
> is a bit weird in that it accounts frextents before the iext tree
> manipulations and fdblocks after it.  Given that the iext tree
> manipulations cannot fail currently that's not really a problem, but
> still odd.  Move the frextent manipulation to the end, and use a
> fdblocks variable to account of the unconditional indirect blocks and
> the data blocks only freed for !RT.  This prepares for following
> updates in the area and already makes the code more readable.
> 
> Also remove the !isrt assert given that this code clearly handles
> rt extents correctly, and we'll soon reinstate delalloc support for
> RT inodes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
