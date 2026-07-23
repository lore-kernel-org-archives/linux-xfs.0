Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB0631BCAE
	for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2026 02:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784772388; cv=none; b=c0dGJpyqDXsy/47LUrogMZQNXrtsQyQ3bccnMvvc/q0FW7pJLF/r2OHvx2dKgS4i1Iq869RoPQNlpnvenFYI/X+iUW8Clxry7VcE0QCvm9rJt/d6LY86d6e+yTWs05pAJDDdMyscEdVa18TediaT3VBIo/On5mwORcjUbqHfYx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784772388; c=relaxed/simple;
	bh=o1dAa5dlWYFIUduC4bmxRXL7QQfplW5GTsHpOMWZr+o=;
	h=Message-Id:To:References:In-Reply-To:Content-Type:Date:Cc:Subject:
	 From:Mime-Version; b=qU7DO5qSAaKW6Y3qEeD7NRUKRtvC0IiJUPwsU2LJ3hDlgE5wRge0WpJCigWTyXum6UfHq/nIPtFAfKKE1LoAYJND1ljNwJ2halrcfnFSU+caj0sHNsyDRBvX356hL9bU0QUm4iTxA7RdkhANS1H2j99v4eKUiFf2Z4d9TzXAKVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=DAd5Iky/; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="DAd5Iky/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784772378; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=o1dAa5dlWYFIUduC4bmxRXL7QQfplW5GTsHpOMWZr+o=;
 b=DAd5Iky/aruibefVd1cId2+t+/8dxBy7dlhYAZxh2elmNydYWlRtbZZxYOEGuEBUcZu8HI
 3rfxvwVdVMeALoeUNaHPrHJ29KZpElzoPyoBosOASIJTYTOzKw3kumROd+vwIQkA337n9l
 OwlBgh4aEZ6wOH5TfEVZlS84sW2k0zAhqGyiK8NZxw6YdQMkx1f0bqwEOvtOLOIKAinbQ6
 lYX6FAEF1L1X3LLg9B77ezddKqytDwFhGGfElAGgiTJVALUBa1Q+b/m0l9ShOGkGxvhE2b
 g0erqT99z4+TILamPNePh8cvKpJ3QSJL3lzJcEWVdI+dzQR97v8DuyIMNypdRw==
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.873180e9.9f3e.460d.9186.3caddf216bd7@bytedance.com>
To: "Joanne Koong" <joannelkoong@gmail.com>
References: <20260722124931.3159664-1-hch@lst.de> <20260722124931.3159664-4-hch@lst.de>
	<CAJnrk1Yp_X_qKgBFoQ2JwC8DgECZ09x5xsnj83iAQ8cDeXN2dg@mail.gmail.com>
In-Reply-To: <CAJnrk1Yp_X_qKgBFoQ2JwC8DgECZ09x5xsnj83iAQ8cDeXN2dg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 Jul 2026 10:06:13 +0800
Cc: "Christoph Hellwig" <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
	"Christian Brauner" <brauner@kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, "Carlos Maiolino" <cem@kernel.org>, 
	<linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/3] iomap: use GFP_NOWAIT when application for iomap_dio_simple allocations
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+16a617718+e687c4+vger.kernel.org+changfengnan@bytedance.com>
Content-Transfer-Encoding: quoted-printable


> From: "Joanne Koong"<joannelkoong@gmail.com>
> Date:=C2=A0 Thu, Jul 23, 2026, 05:02
> Subject:=C2=A0 Re: [PATCH 3/3] iomap: use GFP_NOWAIT when application for=
 iomap_dio_simple allocations
> To: "Christoph Hellwig"<hch@lst.de>
> Cc: <changfengnan@bytedance.com>, "Darrick J. Wong"<djwong@kernel.org>, "=
Christian Brauner"<brauner@kernel.org>, "Theodore Ts'o"<tytso@mit.edu>, "Ca=
rlos Maiolino"<cem@kernel.org>, <linux-ext4@vger.kernel.org>, <linux-xfs@vg=
er.kernel.org>, <linux-fsdevel@vger.kernel.org>
> On Wed, Jul 22, 2026 at 5:49=E2=80=AFAM Christoph Hellwig <hch@lst.de> wr=
ote:
> >
> > For non-blocking iocbs we should avoid blocking allocation where
> > possible, so switch to a GFP_NOWAIT allocation here.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>=C2=A0
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>

>=C2=A0
