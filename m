Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562612701A7
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 10:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745405286; cv=none; b=JMqaKa1VYUPBPfNzt8V/4LYM/pf8ArI212MEKef+CuHV1t8gyq0Oo3BI1wJ8HSUEEtMyhD56jtChsY3djF1XbIQfLt5ANEE33QnfGRMioLotdbiL29VK0eaztDRdVpf25VsRRgB4X+Ze1tXuYuFJGPJDyFwLEtXQ2hUWjaBmstw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745405286; c=relaxed/simple;
	bh=rz7+7+Ag4z4hi0Z93p6Mxqgd6qG+AIOJJl9zSYC+4Po=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBpdu6XB0eitkm3iLzYY2XsV+9roKvFJCwskzFDhm/dB2MSwdUX6mDolOdVOyL17iajZIBgCDYR+vTp9Vbjqukrytnc/s32dpQMaOqk0/6PCWBmg6Ao6hVrCBBfGafu8iXHV5oVIS18/HvGNhOW/WTosWlZRJN8FzT4Iwn1cQJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e/rJ2H3P; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e/rJ2H3P"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cf58eea0fso30025265e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 03:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745405283; x=1746010083; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rz7+7+Ag4z4hi0Z93p6Mxqgd6qG+AIOJJl9zSYC+4Po=;
        b=e/rJ2H3PVwJXAVZYJ+9FKzyjSjfnxUMFo+OGPH76hJbafB1/04iYT3v3+/kYYttAA7
         vwik6+vc0ZdqsrKqBbeiWVHcf7jnUwgQ8xFAY7fZKThyl0DBAiqszDBKbeujlDSQkIZj
         yCwKoxKu6EG+l5rDaHTPmRBrb4HhSIxfOl1+MFVXUhaVji1GO6LVADryCulA88LPbZhK
         NBAIZt6YU/7LIbID9uGjh7ZvD1SjPHMCm1hgGZkAPeAPqubpyh3gdcbyovNjNhaDOK70
         4rE5TIwI2h0/q1wWpCLZyzJWkSFP5eWy8/wD1xvjB5ZVh6ghs44PM7AsRmi3FmfBvHxK
         2cMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745405283; x=1746010083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rz7+7+Ag4z4hi0Z93p6Mxqgd6qG+AIOJJl9zSYC+4Po=;
        b=idm+KTw0h1V9dUeVO5zkh9vAIqAExhEUyeGVtCOArMzHjTXiFAUWxSyzPjDrvkAhDu
         WEpk7/xd7CRh2mbwOiVGcxGGNqC/4kzjUto/BKqMcw0pznRaw4PI4xM9g+WHwStWkJmC
         raSproQwsxTbfB8j7PmjW4vPIHfn1X4uZCPjexW8UziQ/+0hOVkAr2sGjN2SYNRHWesc
         QsmG9oF2oQKuwk4QocFDbu68xsbbfhRNSY8Qv6f5RozcoHLEcwry/q9/Q1aJ7sFdQn5b
         y/puS5wBY8S7KV3NU6ysXnIHYIBqruNuX4+sDlr/nbLNGrX1rIWxQYEDt3bOL7LuRT1+
         fFTQ==
X-Gm-Message-State: AOJu0YwakQzkdN2WNw1YqeG7fs+oNLBUfIbz6YPFLCzAxHHjBLX/HvbR
	FdmQmiIUdKbvPm6L8Mob+KNYehxySpCjUvP9P3xX7Jfxeg+5N4tH
X-Gm-Gg: ASbGncu+ObO45zOT7eBrbR4BaOt6llCKYWRq63fvrWLUk/82ODXvCJ4nT3XQgOJSGkD
	3GDZr12cEZXSToMTG2hmMcerB1m4XWy+8EWKTh4isqG8zd2SQ6ds/FguCrGAIHk7mWA9dc8EhIH
	VlPqKaUtzLia8nt5Ov9ZYDyRyojHtYY3Y3lOzLbfQq7YsUFWMPqmDmJ9qSXhN11ybZuXAF75UqD
	nndtp/cjE/FwNNtB+77n6662LsMrFHyhIs5Bfp8zTF+kBSs6gliHGVF6HnA+U/QWMMJoG1LvXjG
	mvGMhw==
X-Google-Smtp-Source: AGHT+IEniH7XPNDFTtk75ggyYwhTCRU63EVgv1p1I7XYdI5cawnrwVP8upXMDAZ+fZ8/2gqn+oOZ1A==
X-Received: by 2002:a05:600c:4706:b0:43c:e9f7:d6a3 with SMTP id 5b1f17b1804b1-4406ab97d53mr164324235e9.13.1745405283449;
        Wed, 23 Apr 2025 03:48:03 -0700 (PDT)
Received: from framework13 ([78.209.88.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-44092d3ed88sm21395675e9.35.2025.04.23.03.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 03:48:03 -0700 (PDT)
Date: Wed, 23 Apr 2025 12:47:59 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, djwong@kernel.org
Subject: Re: [PATCH v4 4/4] populate: add ability to populate a filesystem
 from a directory
Message-ID: <dosg7clmylegjel7ygglstobhmfpbsvymwdq74rrbgtmxclgym@vxep6gcau3gm>
References: <20250423082246.572483-1-luca.dimaio1@gmail.com>
 <20250423082246.572483-5-luca.dimaio1@gmail.com>
 <aAisYB7CiQ6Lyp-J@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAisYB7CiQ6Lyp-J@infradead.org>

Thanks Christoph for the review
I've addressed your suggestions in V5 patch set

L.
