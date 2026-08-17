Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1058322A4E9
	for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2026 03:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786936162; cv=pass; b=MkrnBzDVoTfAIxwSNdjoTfkgWuMLq8D0gZNHAgIupN3LoJa20kAZH/hMYqFO4PHoneTOog/pE0PwJVWSCKLOA6iwy/Nvu5iA2nfb44doM+NIC5wQp2+pmUH+5Tv/zbbUmqb9BJ/1YlT7O0TgkB819TYRkrel4LWLhqFFXAtZFNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786936162; c=relaxed/simple;
	bh=+Eh3ZNEJonDn4FPIn8Zr9U3GpvZdS760QrDM+GW9B+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rxy0Tjin80yXc8S7Q/c7IPDnhrM4EU78JuSPSxBlysbJ2AhbljZrtzLbunAvjLAff6eI9/EsSYruFvt4xNHLptazEARjNYdV2ACnLc9e3EOm4mYbYarMhFIy68poUq94qEOnkYYF2MYhVM7JPjUY6rCyAxoDImjOZGf+POWpPRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MNMKdUeO; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MNMKdUeO"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a378f90555so4627190a12.3
        for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2026 20:09:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786936159; cv=none;
        d=google.com; s=arc-20260327;
        b=W2UkeayUevg3gbl7IEAxnti+0v83yz5DhqMdsTHciuWQdjWZvdn/xuv4u3r/pFNDOb
         5yMH0w2b3iMm1rSyMPoyfGLgfESZzv7tOJFkgIOkzRtHVS68JDpNrFneQaGEdSy1H1EP
         v+Z/x31NiP8zf/8q72FDcUifRxjPsWmmJoS1XGMseSdBFOj2Sa+f6ckX2Qq6LUOZeWSY
         7rZywmq2tQ6kI+VKYowUKPlzvRNpi1yP1L1qNeir4dvIvWw70kyU8eyTIzlvrncNW3S6
         E/U2+o4JzZLLminlb3uJUI+XypSZvGW6zvskOnOFmtNEPap4zo04+JAjX1rpDd2P/Sq2
         Q6+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+Eh3ZNEJonDn4FPIn8Zr9U3GpvZdS760QrDM+GW9B+o=;
        fh=vfIWXsAx13o2iC3/Wv3BShC8COzaERgEHx0lyo+bz8k=;
        b=LCvZA8VrzKG555FDxBnNxPECrQxzC2gIjh65eIjtFY5vqjmnuWOH1yt4stMNHkgOpV
         KMF4abwBVNZKAZ767IhmFkdkbXu7fY5E2qiXaSYylHSFIIiUZpOzsU4FEuAi6Z3BrGeq
         2xu+RRBt5Lr/nrfjn9z4aP7+6mzGoCU/tUEj0s/LnVJ6Q0w+GUM+yTRVhKs8Wcfna1OG
         fFvGFJ7BBlRKQzUie9U82K8SqnRE6aM5jFiqkWqSjP/RsuXKIDp6gGbjLrPdfIlpJ7/a
         DCRjVebwlQEw8wukE+8ClW8fxMxmXfXLs/BgKGo+V/+huvtDH+IVNJKq+uXI65eFqB1q
         oQsg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786936159; x=1787540959; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+Eh3ZNEJonDn4FPIn8Zr9U3GpvZdS760QrDM+GW9B+o=;
        b=MNMKdUeOMtlkjH69MfDl9HcqsSkrL78JgoSiqk3DOEqgDly5C7ESnzetreFLEDFhSA
         7NFXOn1qkd2zanvrerzT1Q5x6VOaTKNCceb1iTpZCQO4uYkNYPzCMxBk5cIPvQ2fDsT7
         NrztQBgjDdWw6ZW0sdIkgMs6XQuOSzYiyQ2mdxD1acmgHJ4N4DabSLfY8Eqi6L4recai
         0J0jbGEO1JnCEBddJUTiWqzZEw+2TqeSquzE41XrF3HTEcPRR1CfQgUCIGbYo5zmrX1L
         L9CsFEkToKl/NYBpHcT65FAqD1GJyEiS63LnGMwwZ45n3uv8yKPF+gcQLQAb8wn6qByu
         8EQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786936159; x=1787540959;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Eh3ZNEJonDn4FPIn8Zr9U3GpvZdS760QrDM+GW9B+o=;
        b=GTWr/0UuA9rF35Irxyv8/sTCIxG7TLKOJnHaa5RigwNUCVfjjf13oW9DS3BqsORgr1
         iRSJkx5Im79+V/YsoBAxh6pUjYkBJi2BCGybb9aA+0ahgM6szdfozpbgvJAGbEYVuAF2
         S40YmDCx7W99ILn16+b01TxUVd/oQDrCmDjJOf1wf1jLxkCkqom4iNWUzjf5nIWewUYZ
         yCmcBQOwFhtRgNdFFaOkhBdB4pwdDy4P/8Bu/IMylYFEtvmDxO99NtfAGh8z3IzD3B4C
         KynIZL4O1abEQWJKvkvTnenS9/fHGgOaY7Vt1bRh5dke+RhXlUQdaZOtGt+i0xfptPHG
         TVWw==
X-Forwarded-Encrypted: i=1; AHgh+Roow3WTQBUHoasUsVIO5YGpFAQnf3bPoQrl5tJJXSli7tgbli7JXFa/tLmHrOC2qulNhNsHm7r2lZ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEQPwrxi/V3TrSjEOF1VM7XxG2e/5ZB+lAtoESd/R5JS6p8MC/
	vLvomxR/qyE3IECh3Dxg+JPB2awXkPXdTHxO+5i9bWUtobzZMB1LODVziQocc17Ig599miBa2yR
	NgDvbVAnhr5TXJHwldxz6HgOM6TZt36k=
X-Gm-Gg: AR+sD10Du7TiyX6hV/6YnfDtE7ISGmWoBFRCy0acqTik0KPkmRd4FGB6Ut6XE2dyuVR
	PE77pCySyyRB6tD0RsmfYYqgq0ptPnQolr69zJgRb8ydH48OAXpwVMbyxSBWO1E7sIfjEtP7Zzv
	CdfejRiy7hYkX2M4Zsij/bhNVjXpO+ugIytnZ68t6+a2kGk/GWFLV6EVq60nwMTatdg2zYGjRKD
	3MX5hgkS2OdZBb6X70mERMul0r2cps0zHCAXoWY6SDXqN679kQfE3klhXlebNDpIQ9UpzAIhUDU
	zM3AwWSVbKPUjxvOQPY/N4iuBgyE1O0bOoL6MKOHtTHF4jk/+RsNxAcdFh8I5nD4wK7Tbp/Fz8k
	cvQ==
X-Received: by 2002:a17:907:160f:b0:c1f:9c3b:96a7 with SMTP id
 a640c23a62f3a-c212a8d9fbbmr996232866b.17.1786936158919; Sun, 16 Aug 2026
 20:09:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
 <20260616053850.2188-3-aditya.ansh182@gmail.com> <20260624173531.GQ6078@frogsfrogsfrogs>
 <CAK5ssPP6FL+6i8z+0QdE-9DSp0rC_U2S20qdxY7Kmdp7RS0xRw@mail.gmail.com>
 <CAK5ssPMyJhvnEQSRoAwVNnZS-A837OOMewEAvp+ZiuWKD=vUdg@mail.gmail.com>
 <CAK5ssPPC4Ov0KBbRphC_wZBZGu1Rr4-d2At4V+ZECFcuHxbEfg@mail.gmail.com>
 <an7Dk2Tn1ibCRsv2@infradead.org> <an9BQdSqrmzYhB3l@andromeda.toxiclabs.cc>
 <20260814182449.GI3556460@frogsfrogsfrogs> <aoAoLVzAsuM8WLQ0@andromeda.toxiclabs.cc>
In-Reply-To: <aoAoLVzAsuM8WLQ0@andromeda.toxiclabs.cc>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Mon, 17 Aug 2026 08:39:07 +0530
X-Gm-Features: AcwNN1UALbc7EtcnKvUSGIaVRiMYDopfb2EvWraAv4kRkzvIDY4KmTM6fQhcEsI
Message-ID: <CAK5ssPPEq5HDXrq4STV77_9pQYGMapX8SK1qG9hArMj6VrPwVA@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] xfs: prevent close() from hanging on frozen filesystems
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 15, 2026 at 2:39=E2=80=AFPM Carlos Maiolino <cem@kernel.org> wr=
ote:

> Darrick spent his time reviewing your patch. You used a LLM model to
> reply his email which I already find disrespectful enough, and worse,
> you didn't even check the result? Why do you delegate to others your
> responsibility to review your content? If you didn't understand the
> generated content, that would already be a red flag that you shouldn't
> be sending it. If you thought it was right, it means you didn't check it
> carefully enough as you didn't even add any information saying you got
> this from a LLM and wasn't sure how right the information was.
>
> We are all overwhelmed with the inflow of patches now that writing them
> has never been easier.... Yet, we dedicate our time and effort reviewing
> them in an effort to keep the project's quality high. And yet we have
> just so much time in our hands and we would appreciate a little respect
> with at least reviewing the garbage you generated.
>
> You can use whatever tool you want to generate the patches, but Linux
> policy has been that YOU are responsible for whatever you wrote with
> whatever tool you use.
>
> And yet, I can't really emphasize how disrespectful I think such attitude
> is. Somebody's using a LLM to reply to somebody's else emails/messages,
> to say the least, make me believe you think your time is much more valuab=
le
> than ours, giving you didn't even bother to review the email you sent to
> Darrick.
>
> Carlos
>

Darrick, Carlos,

You are completely right, and I apologize.

Because the original patch was carefully crafted came from Christoph's,
suggestion and reviewed thoroughly, I failed to give Darrick=E2=80=99s feed=
back
the careful attention it deserved and sent a reply without verifying the
locking logic against the codebase. That was disrespectful of
your time and effort, even though the intention was never that, but no
amount of reasoning can justify that and I take full responsibility for it.

I will step back, study the locking paths in the codebase properly,
and ensure any future submissions or replies are thoroughly verified.

Thanks,
Aditya
