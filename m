Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA35F331EAF
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 15:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783007209; cv=pass; b=cMZQxAmxhkIYkMTnjjK1jH7xiWc9pdHU6U6TnXCcuNNdBRAFfjbdF3W0QhbiHu0dTxJQykP4R6nsB9AMkALsvd9lKtFRzS8htsW4uJNbGrJSQyOCvXK8vcJmup4GYx62b4oQyecTkqw1IebvlG2T1nhQQ5H4onF8Z9ftkeikGQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783007209; c=relaxed/simple;
	bh=b46IvgFklG/Dj+5T4d6yDxQfVAW86jxtJP+qWaWVqbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bjuDDmQ/BhXOxB5PYvVVqNd7xblQ2S8JWtQ5qQy6X7f2Us53y4qeRcjrCcvwt7zYqWVf1He5gjjaQLi/24m5pAP/VxIprJCJ1ysmSlN2mcY2zNRch450W3mV/l60vSEIkgosW02M7oemgAp8uKegPrZG2SO3KmRNBDBUp5Rlkwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RadBpuHt; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RadBpuHt"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-80fe8f03098so19419367b3.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 08:46:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783007207; cv=none;
        d=google.com; s=arc-20260327;
        b=sQG7hVaw1XUG7U48R1C/yEqIs5GfOZG0Uaw59LO0lFL0+r3PzvYsfhMcvz4BrKX/0m
         tYvKkVu4cSHt2w/bQFJXeJwiNPlA3N9dDKRlUzFvkyW3Rmn5Q3nsczmMIAUUtRdL0L79
         L8C/Gomu6LtK0M38QcWjKiM90FAXlJgeNb6qFMZd0Sn55w2Fkqrv+4Vk3pEY1R5slufT
         E6MCAVfa63d3KARyP55hyXwgjL4xfasScx9ay2xbQgbZKPVI6ijTMVxB+gfkJtp9iAXC
         fNg4HVZAszJCwsi707zxWVAwuXZftvw8v1Mcv8ueAFR4qDVxevmOVln2yzsZEJSqp/5p
         g+FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=b46IvgFklG/Dj+5T4d6yDxQfVAW86jxtJP+qWaWVqbA=;
        fh=+zR7+LfMx7z/Z9Spevou1Sjby5kqabZaG16JerdcMY0=;
        b=EQ3P38j7JrBxF1rYsil5lQWJL5bChqgid6cJy2hJtMNKbk8jgAgyjuLCaSpo1waTM7
         4tOS7wRN+dDYeUdyuUE9V5bC1eWbO/gd9Bc4ZdJ7YdqMEyB/GIyZ697rAGLVdYdZ8Cra
         n6dF+KEtJwOpV5beuY6Tdaxo0T3aU5NjwGM7Xs3FdNRH5uK4yP74vK1xLAlroQJb4IFY
         YKhC/ZCNXxvppZt1q4gPOosFcpzUf3jfAIBNHmwKJNZtysXKWafNKas48WhrEQo3zeSo
         xbVUKeAM9cZMmyOcGvhBHSP2u7hGCWYYwqfWSdICXZ0ZoctNBvlcFFOf5KfSBex0sOSU
         gsnw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783007207; x=1783612007; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b46IvgFklG/Dj+5T4d6yDxQfVAW86jxtJP+qWaWVqbA=;
        b=RadBpuHtb9bsGUt1VhIVayCsb/OI/eCil/PAvCOjhGkfPmZZOglq3M6eq5RQiwZKo4
         K2JRI7Af7FU4N5epntdnGWqhRDc5TVUjEf2MpXHCeeiW5D+4BwtPolmvU/6pVixVAirG
         lgZDlmZzDROvaAaOX2YFa/xMds+gorlI9X4TE2pq3f3GWqZOj95pF2OnordznNZzlOuj
         gYFFJkouKaN+N2jTe/78rNCtDgGW6e1qsnXkfzIEG5NdBc2bFsUVRTNKp1hDHvewgPLu
         zU8ViVd98YYCSO/Xb0iJojBHtn5DdgqZjQjJa6ELPHJp6VqeWiroVNugxNOAoPmKlVwg
         4BVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783007207; x=1783612007;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b46IvgFklG/Dj+5T4d6yDxQfVAW86jxtJP+qWaWVqbA=;
        b=aeaonjN3sp8N/BLkHIIK0DTAAND9/qaKLQ6RRGcEYHU019j/d+7rY/91ugyJZY1K+m
         SO0DVvfZvK/QoVC+0UHlFhOOAnSkHLdMX2lH18eEhevjkJPYiy7Q8Ls81PUxWOak9cPy
         FYgz0LsdEpQlE1UeWJrV1yS97J5XM3hXrSIzjB7TXNcpJ/rIlapg4HFqPIRlt31vlbNG
         33O0uFEgaXzn/jj9/KJz4PntcOi1L+mJ2LTFRRSBqaFwOSGP5QltVAbvAVMPbwtXICeF
         JfwYnd8uQ/+Z3I2mvhjvLe928ux+Wpsg3tprXgorBGvY3agT1u0zjWfJ+h/1l+jQNYos
         UXYw==
X-Forwarded-Encrypted: i=1; AHgh+RrX7pSOX9wCHhkaZPj4V2ZgfsJShd1NRG1FQLKN022oLD69QhFDoeNBhheVxoxFsEQQl0dXKNVODZg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeZvpGAqwbs4+q6oJwMAWEcx9tbN//LLQ/5+RJfzfZwprlrAvt
	fIgrcEVnKZFLDcRoRZbaRAOM0Bx+SvZWe1JNbbCE8MrR562EADBVZmAIUBxzoWE9AyuIt27kCsm
	SPwEyCUJcu/qCi7o6040ClnBLLIRFURg=
X-Gm-Gg: AfdE7clRcO94bxfWGf6Bv05ptYY9DsSVapFGzonTDdHUtuJnRtQiUFreDAWvajZeEnF
	sk3t2MzY0oOR4Tvimxb06A2ZIAyl8KmuFdvxVsUO4ZiUY4Zs2/09xheKWR+/22pz8bmWFZfPfEI
	nvupC7UCRFOp7/yYL7c8Ey23twpOJAp9EHkkStAhjGCkoXgLmlsQb/HT71Hr8gU3H5kYGgmeoHz
	wjEDjRjtDArrGzMO0roeF48hIeMW+NvVMcWhrwjeCIqSi5WSFcaWbEBk5tDSZ/poZVdaW7R2aw=
X-Received: by 2002:a05:690c:6189:b0:806:e2ad:534d with SMTP id
 00721157ae682-812e8ef3f80mr70063737b3.7.1783007206987; Thu, 02 Jul 2026
 08:46:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702150133.2408523-1-zzzccc427@gmail.com> <20260702153426.GC9392@frogsfrogsfrogs>
In-Reply-To: <20260702153426.GC9392@frogsfrogsfrogs>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Thu, 2 Jul 2026 23:46:35 +0800
X-Gm-Features: AVVi8CdMO9IXkjPOWiE2a2h2Z4Ujh_e4vNgEioJIfVtBuS7AIbYXjxG8NKAvGa0
Message-ID: <CAFRLqsVATEenpZ8FBb1pMTxTay0xwS6GfmMyxZRUUjrNpUPEnQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: serialize zoned sysfs reads against unmount
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>, 
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hi, Darrick
>
> Shouldn't we tear down the sysfs files that access m_zone_info before
> freeing it?
>
> --D

Thanks for the review and suggestion.

I'll check this and follow up with an updated patch if that is the
right approach.

Best regards,
Cen Zhang
