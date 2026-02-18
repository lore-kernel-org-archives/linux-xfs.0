Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C623244665
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 07:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771401042; cv=none; b=fKyuGbfaEm/k1mv3rFuAiUZIimkX5vCOBdcF3zwnayTax+o2iuqVV/pe80Hc/GnHnUe2J3yr/F6rZYki5emK+7Y1ErsGmJNTSJ65kCDL1J95N8bctW0WVPqyTE49uQ+mMg4tl/KUViJ7aYU2UmCngRYjyNp0rlw+IJlRkx4h2Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771401042; c=relaxed/simple;
	bh=f8v0+zm/5kjR9pQ2BD5n+H4tglM78umXvpUK792yKXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lH8DES6r+lLuSXSyTVpElo4qrMRNZbSOCB+KEhHKJDFlTujT8UItRZTv7uY+8fYN0E7ApQXhHEZbXlFR/6jH27tJETr8qvifgP6AlxZvT46aN8CDv2kRLOYXVc9ZSI4j/OaEQJLe6N9e+9ALuKfhnnvWgcaCvG2AnGlt0+Ol7/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dfajc1oK; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dfajc1oK"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a9296b3926so34576485ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Feb 2026 23:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771401040; x=1772005840; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vyr0zrEvD80BetH81NtDVOd5QJ5GImZ/JX1M2lB/gBU=;
        b=Dfajc1oK/0PCHmUpP+4nIyTjl/L7T2B9kCfiOOHOADVZwO5mv3vT4vmFG4/QnJesnw
         87Tok/yFWRiGSj8c91B4TxI4WxcLySeiX1RktfI46X7h1k78B/f2vaHIm2/Cj/4Tp9PW
         9BDKuaHWcITPgDGiteHAEw5D4I0IhNlQomBKNvGbYUYgkM/jnUw+lMyMgoUco9sQx8wK
         7gztrGV+D4J+/gFd5Tim13/4RV6qq2/+glwxOJpsMqHHd6mwxRG3qfk4vcuMyYGg8UOk
         VOlNaGLq7Ex9XqFxr9RAhhnoFNgmmTO26D91A3U6EA7hEA4yu9JVFE//i6VgRJPEL3og
         s+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771401040; x=1772005840;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vyr0zrEvD80BetH81NtDVOd5QJ5GImZ/JX1M2lB/gBU=;
        b=fsE56HOsG5Of+Wxcl+SCs1neGslChmLHke7N+gX5yzXu7IkA+8fdYFrv2r9PYvX4MV
         E18u9qxkO2/Kr6CCgnwcazfXK6viXZYlrEO9bjKEdWPHLaguSrloqlhCz/85U7+EUEGt
         Lwk0w3qDuGO39/CTnDftq395bd55TU7Z/HkhbtEfo0W04CLeus4H26KP/iLJyWjh8iS8
         U03SUGexbjkV6rzJR1Tfgo9zAD77mIRbWrpvkPfWpA0XUi/sqVKrSVJfFzNTk8So1BRP
         F+BBxyinSBcH2zBGYtBDtn2P/r8VSTdiccmHLdwANOnqEP0wU177iMBjGx6+GpVjN6lG
         VxiA==
X-Forwarded-Encrypted: i=1; AJvYcCWjmxWiSHP5KALE4EmN8gLT0PeSDO/LovE51bFa9Iv6GVUPgHXYvmXIJRxsYjHqH/hj8PtM3gJrdFg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaGs0rUnbjbR01nPB2KGRH7TeKUfRXmH30Xwn42hQDQDhyidlA
	b8e98mKs6Oe6Fz5TDOrxRk/39WP8Bnwi/PL8wiUcqO6QYfTtKADSuZYsEsH9YQ==
X-Gm-Gg: AZuq6aKQvY4ymWenRxIz9+hXIG5B5yZxalXmmTp/HkW8WrPM7EUYOXkNrx+xo34Ey9O
	IDkF5IVb7He8dvEFkBgYFcgMRrOwxyZnaiFH24LtEfMc+Ov9UdG4wiZag3Jeq9GfyEBqaoxjUom
	aQVwjAkUgjmsQbKE1CmZw4eS5YMh3pixNQR4wqJqwHWc/AfKiEro+z6LcuFIUuWZk1s76H6s959
	5QsqJ3PkFhADHJ03x0ev28Qj3bxdx96Xy9p5P6taNYiATYL8DSb/ba0bs65AVynDsLi+O3jceJk
	LSHuMBu0YGD75x+PaArDeo2wYsTUecGMwOkc2f5dWaFmSTmV+8TLJX0kQaWMr+Y3amq1hA0cG1X
	qMIK0Ipt44ZJwhBNYQrJeEbE0354/xt74CHidgjxAOzqPmHlKklRdhDLj5y7b8nru5gGVwN+r2U
	9d5Hc6kxx6dqTbAlQEKpjIzcyUeaTVdTM6V8wENg==
X-Received: by 2002:a17:902:f642:b0:2aa:f7a2:25a5 with SMTP id d9443c01a7336-2ad50ff5b41mr8525565ad.60.1771401040344;
        Tue, 17 Feb 2026 23:50:40 -0800 (PST)
Received: from [192.168.0.120] ([49.207.205.118])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1aaebfd6sm115547375ad.85.2026.02.17.23.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 23:50:39 -0800 (PST)
Message-ID: <dc425988-efef-49e8-9c55-2ea5eeab589c@gmail.com>
Date: Wed, 18 Feb 2026 13:20:35 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/4] xfs: Add some comments in some macros.
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
 <96578ab7bc45eced7c4a3de66c7b81fec2f2095d.1770904484.git.nirjhar.roy.lists@gmail.com>
 <aZVUcgn_8eKw7j2_@infradead.org>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aZVUcgn_8eKw7j2_@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/18/26 11:26, Christoph Hellwig wrote:
> On Thu, Feb 12, 2026 at 07:31:47PM +0530, Nirjhar Roy (IBM) wrote:
>> Some comments on usage of XFS_IS_CORRUPT() and ASSERT.
> "Add comments explaining when to use XFS_IS_CORRUPT() and ASSERT()"
>
> ?

Sure, I will make the change.

--NR

>
> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

