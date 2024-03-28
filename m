Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08FB39AF3
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 04:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711599527; cv=none; b=UPE4HoWVk5zzI3bha88BOwNO3ESTauuqB8yFDVG75VVUndPPMW3bbv3L1CG4gsFbTdS3lTn0UG9Mqp2Bz0P2KCFijQQWkmLYVaMwqKt1iX/6xup///qnO8lF0l3DcWsqL7ix8rQ5hCnosuStfL1BPGpuzOn9aVeqFpmlbYv36l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711599527; c=relaxed/simple;
	bh=jOCO6+VozgQlIAjySG6OUoJdHBiKO5JbopFgTqhxKD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwLYVtKkqsYgRAq8HRNWGZqCdr/VpDc8ZA9Bt6AKR3QavV03HpnG+HhUTD9aQgDaPuuYoHTftweaRY4/o3b1MeaGRQtjXWsAUbbOe4xpbsNsgpSoU4pWJUSUQKr1uRCj74g9FN5Xg5ZtkoUso5k6xAsiuK2GNZRB2x0yxMb0aGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=cb+aDehJ; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="cb+aDehJ"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3c3d58cbdbbso334098b6e.2
        for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 21:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711599525; x=1712204325; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ksTUHNzdN2kT29rY6UumH5nXjbNgbqMr13St/50rQNo=;
        b=cb+aDehJEEoYQ+1Z/66AiDrRxucTyWZWLqHu6VB+PTmRHcJLegVFdU/tt8odlBMj4b
         atQgcag4ICzUOrlLlkN3DcUxo9IjERIZDG/0wqFQopHui1eVQwNQ2i3WOR3IrexKfo8v
         GnB09vlAnEai8jW0sj/wTFh5QjDhd3Gfupe7yt1cjRBcW/QyYdQdW9zObIzpSgekR4PV
         EkZ27lYlifm6xkbqYzP6tlK/y1WRvG+HMX+xuxvAYmLdFqHIQHJC889PdOAJkedhiZHX
         5AFNvOt0JKvLs1XB10TLmXvanGdqkMyo+WkGoH5IWUu5obeFHEeIoBE3u72iarE0SDO6
         8gWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711599525; x=1712204325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ksTUHNzdN2kT29rY6UumH5nXjbNgbqMr13St/50rQNo=;
        b=ddmDn2w4Pnqrj2/PQLt7BHzXza1YsCSIuCUoZ/m65WHQFeTaIryzAmhFJ+QoLv+neR
         FuRkdnwRASLI/E/0xfXoUXmgWZaZtFnHpUa4worvmCkcyukijRuTjTOdRyedverSDJf3
         0XexrxOa86nTdLMjVy+jr9XmY7ItjCsPjjvFrLIDVmNVCwuade69b7nz29pJfW6pwae9
         eTo14bVl06UFCVm9exdAligu6Q7z9Z0iglTpTxwQW8sAX4RnRORhVOwEdxBQVBHFch6s
         yZMLie7GbU8ANjdHl6NiWoYkNUdR74sCekqMO/hHdtY2EVkaqgAtLxXzJivlbJ/qpxa3
         Z15A==
X-Forwarded-Encrypted: i=1; AJvYcCVEV5G19JQJewP+pO3XrdnNjG/ZmTht5cX6+hyYa2Q0cxg/4Su1l3hbsOUj8Vl3TyznJs/Gyz6fJGzpeg75HFARyHxS3fHvzz9l
X-Gm-Message-State: AOJu0Yyjy4uGLLvc35d0FqM+vLXao+de7BpETlIAz3uUZHVgJ3xzl14z
	bkPHtwvgYXuhgIMWBukPM8XQWA584Vb7Fh+Y5mf4UlHZJA1BdCECszqfoc6MLWA=
X-Google-Smtp-Source: AGHT+IGABmdgcnicTE0pf8KRlFFkIajEz1wH0IBDYxxmsVzgmH2rlyb0/TWf8AHg6BMDLpRpM8DFtQ==
X-Received: by 2002:a05:6808:3098:b0:3c3:cbf7:a12d with SMTP id bl24-20020a056808309800b003c3cbf7a12dmr1962303oib.47.1711599524578;
        Wed, 27 Mar 2024 21:18:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id lb2-20020a056a004f0200b006eaafcb0ba4sm363631pfb.185.2024.03.27.21.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 21:18:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rphDk-00CgFp-1m;
	Thu, 28 Mar 2024 15:18:32 +1100
Date: Thu, 28 Mar 2024 15:18:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/13] xfs: split xfs_mod_freecounter
Message-ID: <ZgTvmMpM2JHyEHGc@dread.disaster.area>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-7-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:11PM +0100, Christoph Hellwig wrote:
> xfs_mod_freecounter has two entirely separate code paths for adding or
> subtracting from the free counters.  Only the subtract case looks at the
> rsvd flag and can return an error.
> 
> Split xfs_mod_freecounter into separate helpers for subtracting or
> adding the freecounter, and remove all the impossible to reach error
> handling for the addition case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

A nice improvement.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
