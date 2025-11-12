Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDDB53A7
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 05:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762923872; cv=none; b=RUjFniOglKv41iYyrLe+n+NsD4vlQN8ZonyGBMF+3+K2TLcslx2QZuiR95agO86WtZ1WAAyBE4p/yw+TagndXoiGxuGtn2FOyfBqkoM3JmmZ9EqUJ2Zt8Qy0XgyoJQKCqteDA1Dl7d8ciyOniNx+NeTba1ThJYu1VWXPaKOXNi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762923872; c=relaxed/simple;
	bh=vKcEZRh/MQsmg5EVk6wGANf8abfcsTmwU/aVd7hgvuI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=NdWLd7zhJpSfBCTjBF11HQ9eh7jstBKrgTlv0JQRY3o+IAC1KRy/bGZY0hF1kqX1pAqCB+IijuXSbyH8hbjQpJEOdY29TZdTCpKP09Jm0jwFKBYNs0uCDJ3Hh8Fy+lQ5buNN7/f6eFCsy0qF1ABF4gbMbSEjLgql4dSPeBXvAuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jj4uzNBa; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jj4uzNBa"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-343d73d08faso378094a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 21:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762923870; x=1763528670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z4/R3fLbLxjEo6VN61j9lBg4IIwWHBhF/HijvDP7p4E=;
        b=Jj4uzNBacsq+uqrXZKg00Lo1cxdBXFgUdRp1NC3YRL/8i3D2r+tZAo2cq3snYbYeWX
         NGUf/ch9e1GhDuiKmOu8hYYqn9p4HnliImOuPNi9RSSD7cBqb8XR5ciLNqYYAYhtFBY8
         863ExgeVdRLkWt3i8gPwpO4suGEs57eEcJ0OtRqcPZahSXUZWp57NMCIE89CRGCi4RPU
         rH8JVzYoYJCZbwv3J4oWMQRU4fE7CF7G5Q2EM1GLw/O+NR5tSnyEh17QOH+TQ74dMM+d
         GynbzczkvgMK5gLk5JRV1+RkzvKcJLpKTeSWY1BC2zNeo08iIKGWnEKDCUsOlF89l21B
         XFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762923870; x=1763528670;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z4/R3fLbLxjEo6VN61j9lBg4IIwWHBhF/HijvDP7p4E=;
        b=bGvuKSSfiRXWVaJANACUKuKqUvNahzymj0POOhWzMqfPGYT62T/OMd3mv1RRvolQ9n
         LEwLC0IacKIwz4rDSKOFsppMWe0A76zgYm7A/kadP/3dmaTyEFe+VTDB1y6Op/yWwjQO
         QWb6OVIJSs/DMiH8J98kymwP3SEKdbdPg8AGSnT3mntSB0hyX1n92zGv2KrQsPXLo57n
         2jwqwAFr8naHY5U9SJh0wYcDdMWnQ/y+XPh3uRSefAmBn+2HwhxWOHlKI3m9tzoytTD3
         9dN+236lAH/x7w6eRjAXJEPmjApQi6h5SBDqVQPdjTm07iI/Nd75SxTeNy6M56vF8dzv
         mIuA==
X-Forwarded-Encrypted: i=1; AJvYcCUg2AuYE5wZV6lLg+h3Ha1S5FrEhX11mVe0TDh0YXOmvLtzJSH6j59yaTaR6NUS2m/Q+Rqe3mRIGBM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFDQy9qj6t3wi2TMSFVjiJFRTuzfHp+atmW2wuvw41vmfZEHD9
	GC7IoVaMD84vEFrNiIu/aT5Ffm221vrlZ7L6QyicdtSDT9cVdqo8D4zTOPLtKQ==
X-Gm-Gg: ASbGncs47F/t7E/ovK+XPgQTeYgEQq//SC1ixXuM83AUZQCBllGnjF8owdb9ynZqDJc
	r0Dv6jXBp2upffU8avxeE7lyA/zLVPoaJDqUcTX5t9vOEtVm/A1gd8ONfGI9wjOlmgubSn3dVWB
	lXvl6RduumpN7ECvNM1pfLC0ehoKRlcbXtakgWaSOdHBngzMHHQlJO5kdsuAKZ9AQ2emvgyd/qn
	Fd0ni+hTTgkhLyjMduGdoiL0iP/nLbmHrs0181PlYpMHOM3bvjhqde3yjNZnMu6CT3B8KjlcXfx
	NRL+I5MGQH74jaPiYTMm+Lps7RAQe8lwYni7e3PQF6ispJljkmFdtKUhK3QLQTXwYShbuAA4DRP
	mFYfmwKkXABf+AWeTnfLC7wpdYtF3SgPtX93l8z5X99WI4S/JLPOVvqTNuAqlA6CJqQ6n3Kn97L
	yuSEYlNmp8WjPmIU4cTC6o1njfmoesyAHAI38KVYtuwFrVUaVcNu2s4a1xQY2CxFg=
X-Google-Smtp-Source: AGHT+IG1EEvkWbd7NeZir15kFcb0Tvox+iezcJP7N+zp/1TIwGoH2oYa0s3N0ns614CCHg5IKbNFJg==
X-Received: by 2002:a17:90b:350c:b0:343:6431:d7d2 with SMTP id 98e67ed59e1d1-343dde1ceffmr2202021a91.7.1762923870128;
        Tue, 11 Nov 2025 21:04:30 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.203.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343e0794ed1sm962251a91.12.2025.11.11.21.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 21:04:29 -0800 (PST)
Message-ID: <b2f592cc25cbf5815f3fb2be66c059385fdaf4ae.camel@gmail.com>
Subject: Re: [Bug 216031] forced kernel crash soon after startup exposes XFS
 growfs race condition
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: bugzilla-daemon@kernel.org, linux-xfs@vger.kernel.org
Date: Wed, 12 Nov 2025 10:33:29 +0530
In-Reply-To: <bug-216031-201763-4B599n5Z93@https.bugzilla.kernel.org/>
References: <bug-216031-201763@https.bugzilla.kernel.org/>
	 <bug-216031-201763-4B599n5Z93@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-11-12 at 02:32 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216031
> 
> Eric Sandeen (sandeen@sandeen.net) changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |sandeen@sandeen.net
> 
> --- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
> I retested the reproducer on 6.15 and saw no errors.
> I'm not entirely sure when or how this got fixed, but it seems to be fixed now,
> so closing.
Maybe https://lore.kernel.org/all/20241014060516.245606-7-hch@lst.de/?
--NR
> 

