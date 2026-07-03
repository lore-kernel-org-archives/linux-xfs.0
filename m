Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816BA378D9B;
	Fri,  3 Jul 2026 09:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783070660; cv=none; b=vD9uptzlEQ8Yf+q6p5Vt7csuWOPLXzXWplEBhsLfr2QQNnXr5QfVi/O9JalLuqpmkYOWteGIOKyO1Git81f545LORgLEVopAI22pkUOOqYOR/zbDpX3HZhWkqmmFwcK2KR3hJNwaeaccNs8nMgQ4LzfWqf+Zm2Ue9vgytqv3cKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783070660; c=relaxed/simple;
	bh=ewGKMwhPAyyeQlJ61ZzGnHwqlkzWv20cII2TM6OZVno=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDxo/B41wQP86fBhlWbJrZTbZJCOfKQ2/FBsk3PHbDb+eUWqf3GwOylkv6Pm1I8ogG3F8feexINF7g7tCNYLCUNq9LWrQGv6rR/Lqqqz1ILG9/1AwfKyIwGkeBl+hmt132YWEoDF1u8lJyPvB3hbKFzATFbMfFnJtqFWPt/Cbmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=UIU6daKJ; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="UIU6daKJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783070612;
	bh=ljK3twhPT2mDzW4Ybw27zHahCubfjEvZ2zbtDTFBNcw=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=UIU6daKJYHAw3iIrjNTFhSZYFT6hpEaPLikvEWutlnGs437ioJTDexESyd9jPzz6W
	 2vT8q8ogBpp6AcBu1hVBbOQeti2W+PRL2jt1AObY20lrs7ryOSS5+ROjnvyN0AttgF
	 hlpMmomRXyEgQe8XvIF0mfEAcRT/SE6/dZ/a4ZCo=
X-QQ-mid: esmtpgz13t1783070603t5028dae8
X-QQ-Originating-IP: kR92vNfWnsjsib/8h4Pnyt8K1OrsbEGkNRVLgtw6PgY=
Received: from localhost.localdomain ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 03 Jul 2026 17:23:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4699686752030843351
EX-QQ-RecipientCnt: 5
From: caina <caina@uniontech.com>
To: hch@infradead.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com
Subject: Re: [PATCH v2] xfs: clean up spelling and grammar errors in comments
Date: Fri,  3 Jul 2026 17:23:21 +0800
Message-Id: <20260703092321.1509-1-caina@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <ajve0YCxD_u62phh@infradead.org>
References: <ajve0YCxD_u62phh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=yes
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MDGUoPnBmw7sLHEnJIKL8OURRVsQOvfcb9lundJGwypxP8FwkcCG4SuR
	p8ax++pFp5Hr51630uxjEFMl5Wtu44cQpGmUzFQOfCH1mqFzya/Gcp4YlX5D9WwqOM/Xqd0
	TqPHXiQEU/gNT/miMkTUa0WVEe9R0GK1BYt+POISXA3VR0/PT2TtXnn9Q58Ac9VIXHT7aYR
	4R31lA6HMxmiLQLwu0ZmrENCp/fWrtVragkZCHnC2bm7/uBqU5mBSDs0aPy9TmTbWacCMwZ
	URZjLcTaxoJu3jexmr1AKG+LVxo0pGHx10nOdDQSHwQ1o/PTsVVq14zDJPGbWZk4kJ94uQs
	qOgZLX9Z/nvENDVvu8r1a6qqOxTw9u852iik/m2sqgrY0pSI5b2UpQpA8uARh3tFMOCJueE
	OmivY2RUFwGUVZoNV6msBMzIhI42tdF2IhwGgQBcVc+jKAQngW5qih8bYuPOU5iHvqib8Du
	cKkkfpvhGd7lqjYxpDa6To1tkRXQ/y3IF21sMHHjN3s8u721kN+VLNTAj5xw5hKqPwcCjIO
	C24r6tFcUPCxugUXMuZxoerIRDSwgJEWbTQ3Cldl0hwg8DXmI1vtIXgdrybga4tdUIejGcm
	igcpa8WK57ZcgkQyOtRGmTwmLVJgHrTXfEGxtaETXquMypx6nqclAHsxafW3e3WrEG1sKC3
	z0U9QfbT4ZUL6LGLbweLZ98IotBdIRr3JuKRMiYH1SdkLJhsZ1qsHydtC3obTRu3BBWTc6T
	LzuDnNaQdfoNSpBWwQW5rEUXUobUlPV6MlFKjrcvKmzY/XvMUvYhocoTnK1kTA83wl0BxRM
	p224MgVOSVn0FuWR1cRV2caboUt760+PfalRrDlN5YOU9tk1WdpaMI064UrAp+fN3z3YgGY
	mH0dtBZ3mWzQWyImmq3Ko5x/gxlf/35jLwO7mi41c1MLVXr9ktJ1ym5GPr+r+IHalpSXrlI
	ge9tY6n9PgWemu6eCaplXMYD5Dx6xOeqchfueHZs0CCoYzLKuOdZcUhhYa/pHV72V3XKnMX
	+XDXk8tYqBH1Y38fz9
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

On Wed, Jun 24, 2026 at 06:42:41AM -0700, Christoph Hellwig wrote:
> On Wed, Jun 17, 2026 at 01:50:52PM +0800, caina wrote:
> >  /*
> >   * Set up an in-memory buffer cache so that we can use the xfbtree.  Allocating
> > - * a shmem file might take loks, so we cannot be in transaction context.  Park
> > + * a shmem file might take looks, so we cannot be in transaction context.  Park
> 
> I think this should be locks, not looks.

Hi Christoph,

Thank you for catching this. You're absolutely right – it should be
"locks" (as in "taking locks"), not "looks". I will fix this in v3.

Thanks,
Caina
