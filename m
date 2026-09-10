Received: from mail-oo2-f43.google.com (mail-oo2-f43.google.com [74.125.231.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D163B71AA
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 20:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789073409; cv=none; b=ZrkD/h2O6fPckHBimxp1O1tJcLyKuSKlhKcckTNaZR1o7lBLJm6F/sUsQgojeTS93npjBSlP24pDdbbqTi/E3zMhGfnLFADGFalIB465Muy7INoAnT/he85PEMgQlwEaz6EE2fuDMF2U6Eo/SoctbiQYnzO5Me9qpRWHr1MowBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789073409; c=relaxed/simple;
	bh=DMskuNQVMj+uoBFxEGvl83x9Kmbf58EB1yX4IXsdyAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i4X+10/VBfIvBhFmmtw7yiFrqfjFJ0ipMFdFLP5fsZCxzOkskwcXXxtGN8hjA6QT5FqNcynBf8+Tim0/A9dGiq+zmIG/JimT0j7TAzXvDvHRdjfU93hniKGYPwZqqmtDRz1f3DVytIcdXZ09M4Pe7CGXt0Cmr0WeUcykvbrZn7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=CpBOYaFI; arc=none smtp.client-ip=74.125.231.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="CpBOYaFI"
Received: by mail-oo2-f43.google.com with SMTP id 46e09a7af769-7fccd4c3f36so174379a34.3
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789073407; x=1789678207; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pZdl25+fTdFEnFxWqmQ6klfnpO36ISnMAYm6McTSM6g=;
        b=CpBOYaFIry/s/eHA4Rq9upG7oOTNN1kuNiXh3xH1pik8JOaDYehMbrbv4fBk9pKaXh
         lBLScF4Eq3/maprx9zN8xTMNaJqQJVSHvMPAgWMRTZEBCjxlujKlWNHdwhCnOSrsidxQ
         tnSHQzcgL/MuuHYeaBSeUj2fus04xjoJh+kdPEQgaq4bAq8B4l4t5yA0eVcg69PaJsZj
         MtClqjmw+jV/QWKkZVTuMF6y0VRd9y9psdlx+0Yrs9n+fjA/pkrmLsEriSyMv+6w0aAa
         egS5mHWNt5H8cj2YYU+tQapufHtp4tXfOxNTYenvQevUu3sdMr89OWFubdNzc3LWaij6
         3TLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789073407; x=1789678207;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pZdl25+fTdFEnFxWqmQ6klfnpO36ISnMAYm6McTSM6g=;
        b=tJEZ5ggOpWiYpbcotr+Q95Imgmiad7iJRUfQk6f2oVUCKm14CimXRcHxEh/jX3rDGv
         3B+fLfPOci4zXUO7XNCpPkNExbqMK2iJD1wRTUaHSQmEIiS22mHdhjhwIo65U6expgj7
         PteqkQvtopwddzUhwI2OAQjyk6MzVbHyBv9tL/rqWZcUpNvBI+mPGw4IYX0BhhNYs8D+
         TcPsfIm8na22pm8hQdC/r4e9SrCaDpgEvZdeKVKzcc9SjojnibukXgBK/WLtDMawVScb
         DRkd0QjJ5Brk2z5uPH+pa8EUc6X+FcP/dXXq7pjjSyrseGS9bf5F6itUWTT/c1cY/xYO
         Jn3A==
X-Forwarded-Encrypted: i=1; AKwUvBwWG1ewX5KtIh/CzYI2xSiJZsC4IBRaiwb5h46VDmEEX31VWbufz7m6Pk1/kjDVBD9AgYpnrRst+YI=@vger.kernel.org
X-Gm-Message-State: AFuF++nVoJyvAe4nUKcA5IYN7nuM5s2bcdSmanOMLl8UyyYepDwxZNoR
	Vvyi/bAJXuLAjkRmF9hOQCtGVb3kubVfXemi2AZeBl6CwlxDbPUw1rcggw0dOli+Irg=
X-Gm-Gg: AYBFou3cN5upAe0Lo/9qN8T2H/q+1J4a/W+3mR4Gyp6mVJpKsCspVJp97Q4P2NscMMo
	LcXQ+AmUETchvKRAx2msuiV+h5LjuoOLAUmW7Xn+yPTA3WfmoWPLRk9TERtaivU6X1u22MmHGCb
	Uu/fGjEeD9YyXq5/jYO0Y5YVOMoNDiDVTcPY/GYEXZnT6Ln/w/PqhnjEJYoAPPvB/UgXdD0rZyb
	ltIFoc1+HVk9kyOwGOuNBKBVIHuCicQstXf3bT3ROxxBzRVWYb9mJyi4WVedTj5Nu1A59/+jK7+
	b6Ymx4hyJr4iuvRgYmQcG1wKTrN/FJVclmYQCN0XXWU/2DrAaQzXI6VkUX6A45PeBD18sU1vOWo
	xoOduZJ/KDxI9sTDDPAgzKOBhxbH3JvcBu5z47yhSTVgXeiDcFL72Cz3sksHbIyUdRGqtOELjue
	B8JPUGxxutW2AdofT08N87aX0iLL3jcweUPfPf4/mJB5qFGP9u7Icb+DuPb0dXvqo5p+a6tECXk
	DotJZkZK1ajf9VGPPlzIKbgGPupU/P/sZ9iT1PWy7y95c/6j121NhWL
X-Received: by 2002:a05:6830:2702:b0:7f4:ea33:8f56 with SMTP id 46e09a7af769-803fec05043mr748651a34.6.1789073406770;
        Thu, 10 Sep 2026 13:50:06 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-803f670d8c4sm611145a34.19.2026.09.10.13.50.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 13:50:05 -0700 (PDT)
Message-ID: <fe537c5f-114d-4d9a-817d-93f359e12924@kernel.dk>
Date: Thu, 10 Sep 2026 14:50:04 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: lazy bounce buffering for checksummed reads v3
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Anuj Gupta <anuj20.g@samsung.com>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260909060924.1102037-1-hch@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260909060924.1102037-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/26 12:08 AM, Christoph Hellwig wrote:
> NOTE/QUESTION TO SUBSYSTEM MAINTAINERS: The patches in this series are
> split over 3 subsystems, and I'd love to hear from the maintainers
> about their preferences for merging this.

It's a little hard to split as you have eg block patches both at the
start and beginning... In the spirit of getting this some runtime, I'm
going to queue it up in a separate branch,
for-7.4/lazy-bounce-buffering for now.

-- 
Jens Axboe
