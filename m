Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E382289E1F
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 14:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746626518; cv=none; b=Kgk2vtHTEO7TIHz47V+Jn3XNRORfjpMAt0SA8uzZ8OHIltF8k1IVG8euQpK4XCnpdN1zYgEP2Ysr9qq1YzUcIBD8vhxLHihnDfrg0076iP0EiIlrErIvjy0Upa+l8kQSPFhfMr76jx6KNCrkVTMcfEllTNacvFL5otlyPOBLgjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746626518; c=relaxed/simple;
	bh=riUohbe+nhSKSfWHET/Yt5mBIMTKqf2kkbHWdODQalU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ns+2Fa77F6W0X0ISPtujcUlNyX2RRbqARNZ7D1KENwhK70uNyMhNC8VMesNVGEHZerIsmn15w6JiaBt63DcoFJ2Kyxcgv/VKzaeO+OdJFMmBbflVEhpV3jiS5c7zpvCRsBctsyxxzQxbMN/MD4ScG3hq64wIy3TU/4pGLUWlmbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=F5xPJ/Ip; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="F5xPJ/Ip"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d91db4f0c3so38684865ab.3
        for <linux-xfs@vger.kernel.org>; Wed, 07 May 2025 07:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746626515; x=1747231315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=md71yFj7QjYOD6CmfKKjAp0TbUSgcGH/TtN+850EMGU=;
        b=F5xPJ/IpbgIrYmCyxL1ZnXNjxIAq/NJXLETWQ0tRAZhF9QkonvCKWNcxAgQQjfwfgZ
         xMm6Vf/rJcGELq5T0W9kzb8p55lxGhW5frDG45H9pQjUtv7CN3CvxjUcf3HFoZ/cadzU
         vJOxFDXiqvKtr8Nz1k5NJjJClGpbkwpHZYgruWMyUUuZRKBhANyKM0fgYS1FaiSZG1XT
         RQibs2LGpUvxPSPGxVNb6uqdEdE2SUzGvYvDgjLWF60NhTShvumr+ATlvvlCQa/bd7V4
         OUOAkW27boFix23FyJTulJxbi9TkikYZtgr17wtlL5l1pMwFpKjRpgsKiKiU9WLcbWuq
         2DSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746626515; x=1747231315;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=md71yFj7QjYOD6CmfKKjAp0TbUSgcGH/TtN+850EMGU=;
        b=nv6C1CMKHttpLlBicEYVO/cmXJ3Io6YFN+ULDlVVWWOz85nGIeKxa/hqQUZ4ygkhoZ
         hv1OWC3zTfQoMISyXfS5O3WXguUYKxnv5xfvxSjfR99VLkF5X0kfxQa9WjR3fYKpr0ho
         FtoWl/ssoqwCgnQqC/n9MdnmQ8UXZvzsFNjALUO4eZh3jSJYPUBUcvJtCXwPS2H1dawb
         5+afBNxl6XqtrcVVXx55LQE55s+AZ0hLLKrVZb/LjmiGN2eSFalzTRWLK726Dr47byom
         +HGF/g6qax2QoMP+78dEU7zb5f8Yx0TlJ9V6ic7arLRoxJjp6EziDA9X4DrcFhDqaSOB
         A13g==
X-Forwarded-Encrypted: i=1; AJvYcCWWuGQCtdZCeCubmebqMVud/Ja+Nfiyl+rH2VeeKn9R8LMugQvJtFYfS/BIwkXs9WgCqQ7/JA6yXPs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwB6dtVzB5SYbUEsm9Ll9k6+oQEzbI9iwYPOhTMMfLVJEehs//a
	pj7skifwxOd8RkMRt7RMnNzjMfBb3Kl+HAhiOF9ZB5+EdxSuCj/QGx21fMSMztg=
X-Gm-Gg: ASbGnctbMB5XyZHp5fCAB92Ksf1G5mroTHncSXNBQjB+iTAPT3fOfkg6yXoKJ8vf+VU
	qkZmm6R+KIXxiGGI0PJr+laDnld8oPTqwULE7yArpiEG7xjXBEQ8nf1B0hCHs3wHI6l0HwKJRKI
	Bi8fCrWxMTPgBbbX/IGiTBfcRJkgKa0tuqIRzaA9BkGtsguqdgaIVNQJkhqKL5VReZ4MjkgaPYk
	ekfY7L+eUu6KGeaMCBljH0VwZj7gpsd7s53zQTGMDw+ZWCYJqJMkGL+IAi5MkXx2Sm567kbCjvL
	OO9HNOqbeZhz3YZ06faZD9dR5hipbgg91ji0
X-Google-Smtp-Source: AGHT+IEPXkcUdjuoTWJKGESqgsxo1A4ob6I1ttYfFC6JrLgpCILRh6jZ2+LBOAWlTXtq2pbhrFyjbA==
X-Received: by 2002:a05:6e02:1529:b0:3d4:36c3:7fe3 with SMTP id e9e14a558f8ab-3da738e562emr32326165ab.9.1746626515075;
        Wed, 07 May 2025 07:01:55 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975f6dd89sm31362225ab.66.2025.05.07.07.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 07:01:54 -0700 (PDT)
Message-ID: <a789a0bd-3eaf-46de-9349-f19a3712a37c@kernel.dk>
Date: Wed, 7 May 2025 08:01:52 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/19] block: add a bdev_rw_virt helper
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-pm@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250507120451.4000627-1-hch@lst.de>
 <20250507120451.4000627-3-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250507120451.4000627-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/25 6:04 AM, Christoph Hellwig wrote:
> +/**
> + * bdev_rw_virt - synchronously read into / write from kernel mapping
> + * @bdev:	block device to access
> + * @sector:	sector to access
> + * @data:	data to read/write
> + * @len:	length in byte to read/write
> + * @op:		operation (e.g. REQ_OP_READ/REQ_OP_WRITE)
> + *
> + * Performs synchronous I/O to @bdev for @data/@len.  @data must be in
> + * the kernel direct mapping and not a vmalloc address.
> + */
> +int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
> +		size_t len, enum req_op op)

I applied the series, but did notice a lot of these - I know some parts
like to use the 2-tab approach, but I still very much like to line these
up. Just a style note for future patches, let's please have it remain
consistent and not drift towards that.

-- 
Jens Axboe
