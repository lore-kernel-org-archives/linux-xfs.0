Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAE717A300
	for <linux-xfs@vger.kernel.org>; Sat, 30 Aug 2025 11:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756553027; cv=none; b=su74uhpYfKuWlhQ4+6y+aZ0Xrjv+Rd2maqDenoA8oDpL2vWOVYHyEkoABIncQKPHZ8FOEb1p0DBic6KxcJu3syCzwYWGW68B2JYpjSgGvvGRB5EjrrPLPvpi2s8qetEPlWzmh7PYFL3XkZyeXf6C/GfNUEopXxiH46fan31tLFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756553027; c=relaxed/simple;
	bh=GNsD/sldOrm/7lP8znq5fG2v3Cf20GyoKMhx7qCACyI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Ug/n6A7rpYewswixGztEvjtL19XCI8+2yFs+szuCWDeplNHsUXROb0JHY/wlPtXQOH9dAfcrBBajd+fRBckztw3liFvh8JShf69i/aTL5Lcp17SiWSm5LuhV5XUEJHaR/HuliyclnyQNwBMrTnqgSYdv8gPTdfD0LH6oNJ6OGn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=adamthiede.com; spf=pass smtp.mailfrom=adamthiede.com; dkim=pass (2048-bit key) header.d=adamthiede.com header.i=@adamthiede.com header.b=HD7hXtPN; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=adamthiede.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=adamthiede.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=adamthiede.com header.i=@adamthiede.com header.b="HD7hXtPN"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cDXnm6Psrz9srd
	for <linux-xfs@vger.kernel.org>; Sat, 30 Aug 2025 13:23:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=adamthiede.com;
	s=MBO0001; t=1756553020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=sif0e7yEsZ/lXBepEYt0VZB1EcPYUHzId1f98whRc0Y=;
	b=HD7hXtPNWSSQFlbvVpQ28DLZSMzLGs6tcDcAyaOD0+8pBi07xk4VgX12OGeETjGEOftWe/
	mdQSCiNjC25e6Xq5swdj5ivkSGjM3CtguQaGbIDGEtkVKvasbkKoCb63giHeg7TcO5lpn5
	bGcaiO154DQnyV5lFGxo94olKqg0fu/4ze3mXIF/r+ncq1QoLQNZRXJGuJfn3LqkaBQngr
	VyQS2xZvPiIi4r9nBKR1KLC2y6n813xLLtsldgnPRUJCkTALHYH/b5WKbKya5tHsSY7FwM
	JNz5lJv6AstOf50hgag8pIaG4J7DdbzATL6Bd//xnFvf/DmGbOcd+bUKIeKfiA==
Message-ID: <ba4261b0-d2a2-4688-933f-359a8cc6b75e@adamthiede.com>
Date: Sat, 30 Aug 2025 06:23:36 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: en-US
To: linux-xfs@vger.kernel.org
From: Adam Thiede <me@adamthiede.com>
Subject: xfsdump musl patch questions
Autocrypt: addr=me@adamthiede.com; keydata=
 xsBNBF+n+90BCAC2ZRLVcvdXDgfY7EppN05eNor3U7/eeiNCCEIWZkYLhikUEP1ReLGBkXpK
 Pc70hfnKAKkCoth3IwhDty9WXMNU+iLNei4ieb2luW+UqluR6xIUIA+txahMU9YcjVaQTKf/
 yZWO4yl6pfBPCxC2UdPZKBAdGoi5NnE0ABFNbhBETQhhBic533lZn33ByupfI3acECnQdjgQ
 llCUpDbw4I+S/N1iFiEHcbMXH7ZB00e3IYNorZ1E9v7p++5rDY1fQ9gXpieg1vFKwSq1NJWo
 9xx336YjaTUbX0EwrdKd9l8AktA3yRjckaK5TAcwSQaDtHvhpbl4ebvPhtwHh699MroXABEB
 AAHNH0FkYW0gVGhpZWRlIDxtZUBhZGFtdGhpZWRlLmNvbT7CwI4EEwEIADgCGwMFCwkIBwIG
 FQoJCAsCBBYCAwECHgECF4AWIQQtG9pGQ7sz3tf8M/kC7fV9o/vRzgUCZL1HxQAKCRAC7fV9
 o/vRzgyRB/wLqRCvvWhQCMgvzeKvru9wcXquhb77K8H/ByLbfiT8YBuP3lZFVh0IQhgO9Ylk
 fIoOJE4V+jjxyOnO2d9xjGbvAmmR6yT0gfLzSVWqrC4k+V9MWLv43nrNzxt41dvo5j824FAl
 X+zaiRZCdO8Jtxg5Elpiop2SKLi1utX1Z8i6YZh+ccJZlchUBAGUTk+D4UjK7vUcjLWT96ya
 CtdtTfXyw36CvGOPEWfc6++Kkl/5sgej1i7biPYzu/r0vssaQYTXKSrv6Cfa3Maa89ASiTtv
 q4qmhLnJeCrPxWlRAf6LEizeBEkOasYni2u8sp4wBezEq45Ozu45sfPkqLpPolG7zsBNBF+n
 +90BCADBRt+vrToRBEG580n77S99qSEkbKD+oJtCVyovnjMNkg0K9UG68LIeCX/ezngiV1M8
 JISvw5iFOuUFqGX/1hLl9wgt/YpuIrgWOp8XxkotavTCloLDvQmufJPO1L8bnnA+WgP2YgVZ
 5MJTj/t4DI+yQgysEjsH8aurHO2uuqgJE+xK+2dy6Cl/wskuGxObksSPmmFH5PH0Joziwrtl
 61ouLE2XwKbkMgIGEKkbFgbfwz3/QuLZGBni+OOtLzXeZ9wNTW/AHUPy6S9U4F+5z6/09fVT
 tTH0cvrgAGjbASlYx2VqGONXAsxCfjulq6ryJBFlPLp949c/JTTgOojukCSbABEBAAHCwHYE
 GAEIACACGwwWIQQtG9pGQ7sz3tf8M/kC7fV9o/vRzgUCZL1H0gAKCRAC7fV9o/vRzlamCACs
 vHw+0heTm+BfC3S8DUST6889gidIIwdqBep1ByzetCph7Bq8Y8BlT5YTX0u/bSKkxCzFgeTm
 vC341Q09ST2XjLAl1ZTdzGhH9gcgYyOw34pr5fPQRJLB392mPzD8YReRzciNbhWzj+DLgeVe
 ouyfGajd6jDjkf4FEq+trQLGZhpfsKn3JnDbzBUs945D50l/vz9q/QN3qZO+H4F6g8ZeMnqo
 FOEFN26xVtdEDr+0DNFsbgKmEzs675kdAY78ZZdbEetX/FSknxJ+FK1ZW3J7Yswwulj34AXP
 LB49Mk8Ot7fo6mdt0DkV11JS9LmKxKvpY+KTlrKG+i7pVCSZvVUx
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello - I'm interested in packaging xfsdump for alpine linux. However, 
alpine uses musl libc and I had to change a lot of things to get xfsdump 
to build. Mostly it was changing types that are specific to glibc (i.e. 
stat64 -> stat). I'm not much of a c programmer myself so I am likely 
misunderstanding some things, but changing these types allows xfsdump to 
compile and function on musl libc. xfsdump still compiles on Debian with 
this patch too.

Would the maintainers of xfsdump be interested in this patch? It's >4000 
lines so I'm not sure of the right way to send it. It's available in the 
following merge request, and linked directly.

https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/88452
https://gitlab.alpinelinux.org/alpine/aports/-/raw/f042233eff197591777663751848ff504210002e/testing/xfsdump/musl.patch

Thanks for your time,

- Adam Thiede
