Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A361522170F
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 13:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739453216; cv=none; b=ceyEVwp4OpegTCJCgTIf06yMeLzj8ptd99Vkl9Wtmm0kIooFONVhMdNQYAXPusX0bK0VEvsgdGGoQGH4VFlvsjaplTkIuwwirMzH5RCRN9S2Ab6i+FAIeS680kzhaWcIPaN8Z+5MilGNGmR+b6cpMtWsQCTjrvKfyO0/i17jLV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739453216; c=relaxed/simple;
	bh=f2VrjaaUtOyd2jGHD7nRN294buE1BJdSw6FHDEBRPEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2VitF+D3e8KmZPDTWM6t+xbX7sslWSC5fiBNGWkABHM15Ed1G79BKLmWx71y8mzYK+He8cwTD8EGxyFu8L/nwfmCWyDl0l8vlKpS3I6P2yiwzLyk5CyylB7vcFKjYS/0+W+Q/64RpEK7aH+H3GfnlWThr9HLznHItUUy4jO97I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SbqeVUPN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SbqeVUPN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739453213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JoMxIH9KdGfzSGtAj5uEF3WyB33/9nMeg0uFpV+VG48=;
	b=SbqeVUPNk/t79zzrbY4MQm34QYYjah8lMQecLw5pHtwOZZf0J8+VFM0omvhM5Dq3SPrtOM
	CzjdcrC/52U5WdAFTF3RJJZyWY4PPLHxTEk/T9ltTrFwzciXPGiG+othBFGTlWo5cKG5GA
	dY9I27E7tb7+wUxHJ/q8tJJSFQS2kuo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-l-TzSg8gNO-74klNUP-sWg-1; Thu, 13 Feb 2025 08:26:52 -0500
X-MC-Unique: l-TzSg8gNO-74klNUP-sWg-1
X-Mimecast-MFC-AGG-ID: l-TzSg8gNO-74klNUP-sWg
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38dc709f938so1150006f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 05:26:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739453211; x=1740058011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JoMxIH9KdGfzSGtAj5uEF3WyB33/9nMeg0uFpV+VG48=;
        b=ahYA+0DwqsodkHSOYgHKywwcNkhDaO24McYwOfnyON7G5c+OglXx1xpo/UjtQrVdiq
         IB+c2lweEY1wIdPA5I9UlVhOyBmwq8vozgsHPkyuUkvpKelpNF6CTkmQs4EV1CISi1qn
         orX5Y52NlE7XmJ91U7iMDLEBosHvjX3hFAodr6l29DgWuoWsSUMPixVO0bKDoNw4kOtt
         VlDgw1gPCpOakilbTCfhRj6l/7zSG7jgTfTsfidC8mrM2aKhEsXqgjaGCShW2BQht0gU
         35d0bPm6RoS7ASvLZ70W4652HOE/Y4mlO7hHxMLr+g1QaduiZO7o5fcA5EEQs+wOyBHw
         AZkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVf8OxOogZjUduPPBgbTZDSpH0lusm+lkMyrvMw3cVeYwjg9qIMjZtLdQMb0BRZyrDH6BTxvBd3MaA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb7C+PmfSfTlG6T1VvyFBhEm10IWvSIOZDL90vWUZDN6lAthyD
	gNvK99dq3TXv2/fS79jZ0QqLF1s2+45fbegZHTAV/KIuCGOMalHSvnSlf50aUl5i5GPs9DgvcVq
	hCLFpAS8pRm4GqykkS35i4cenpv/ofyLHHN6ewFz8IV+IYpJpiUfPe2AfnlQU/RdJ
X-Gm-Gg: ASbGncsEc8FaOOEiZvKVZBerkTM3qtDIAlMPdti7mzfa4F8NdbxOcn5RtNa3TeffQD/
	Jw63huPni6ASgOilG3FyjIK70ZfL9HRPQmf1SsrPydUg3YqyGxUlvV0pIJbXa+DA+q60otQ/MzD
	TlWoCQpg31eX242tiVLPXbUyoIubDiFWNHcjewJKsi8WXljeJJUZWcbnmWBJgjjzR3o5/wBAfSM
	gOYwPOGOWAQugU9mdeBg+C0i8oLnenAHiut1rdp2C+9OnXl6DJCNHYI94McLHFVYlDt6pTHmwNG
	T0pWYrlruOsowAxJP5r8ci9m
X-Received: by 2002:a5d:5f4b:0:b0:38d:db2c:26be with SMTP id ffacd0b85a97d-38f24d10863mr3573453f8f.14.1739453211147;
        Thu, 13 Feb 2025 05:26:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF11hPYf6QTnpiVUiAEHbAwOZ19vQnJv6kNaGqV92CB3GqG8EkkiG+wkS+JVKYQc7ZUuw7q4g==
X-Received: by 2002:a5d:5f4b:0:b0:38d:db2c:26be with SMTP id ffacd0b85a97d-38f24d10863mr3573418f8f.14.1739453210817;
        Thu, 13 Feb 2025 05:26:50 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258ccd95sm1893511f8f.25.2025.02.13.05.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 05:26:50 -0800 (PST)
Date: Thu, 13 Feb 2025 14:26:49 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_db: pass const pointers when we're not modifying
 them
Message-ID: <gphbnuur4lz5d4qqucgzbj3g6l6csuwlu47hndujhnutpckpn6@2p4hiu5btpav>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089618.2742734.15049031959195578708.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089618.2742734.15049031959195578708.stgit@frogsfrogsfrogs>

On 2025-02-06 15:02:45, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Pass a const pointer to path_walk since we don't actually modify the
> contents.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

> ---
>  db/namei.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/db/namei.c b/db/namei.c
> index 4eae4e8fd3232c..00610a54af527e 100644
> --- a/db/namei.c
> +++ b/db/namei.c
> @@ -140,10 +140,10 @@ path_navigate(
>  static int
>  path_walk(
>  	xfs_ino_t	rootino,
> -	char		*path)
> +	const char	*path)
>  {
>  	struct dirpath	*dirpath;
> -	char		*p = path;
> +	const char	*p = path;
>  	int		error = 0;
>  
>  	if (*p == '/') {
> 

-- 
- Andrey

