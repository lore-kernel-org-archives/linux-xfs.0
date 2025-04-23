Received: from flow-a5-smtp.messagingengine.com (flow-a5-smtp.messagingengine.com [103.168.172.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4711E47C5;
	Wed, 23 Apr 2025 06:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745391042; cv=none; b=SXG/Tjaw5UR1scL/HcUTgOHjQP3L2X8yJBZ1vQc6mHrwIivQnJoMKk7q2uufhMedHE0hNFTdE17mcg+vqs9vDDr7qB7jIpo66hJer23f8XbmJiZjOxwJUoGEVLJNacFuNTcci5dONZrbpWySVdUDX9KWZ0U5yvvpioMGkp7UQ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745391042; c=relaxed/simple;
	bh=vFQXrEYPQdFElwLcyAIy6puNYn6sfgA9egieiZLW3AA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LCnuTJzQ7oDkvBe0WhmVxjGcZaKW4cvdULZMIe1v/r4UBU6U1Ub2s+yU0mbFs55TpYRqNT+J0Rg0anINgAmc8ssFdMv4hrJCY8sNTb9EMNXPTx0ePL5PoHwYNwoFrfTW/SMrz0vxWU3lJY7Xx36ms08ayrpuJtv4hFZvvEc1WsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=GVQzEAAw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hBq+gXH+; arc=none smtp.client-ip=103.168.172.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="GVQzEAAw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hBq+gXH+"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id C750120083F;
	Wed, 23 Apr 2025 02:50:37 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 23 Apr 2025 02:50:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1745391037; x=1745398237; bh=Mv6JogyihW
	75FJ1Hxa8INduGNMG8XXXEEZ8r4tekflc=; b=GVQzEAAwodrhQaEYYK6kG9v8Ii
	TMVlIAazVnaxB4fMjpSeRh8nuoNCppaayX3mbzieZVPVyBxZUxtfYxusUT8vSQvC
	MvVvXJjOXbggmhOby7NPkihvArJIrJmXqjrwRdvyeVlrCp5wUmnuqaqbNY2HwJZn
	NOxiFnWxPCw1Lq72yariWlf7qHSq1oLI/DCb9hx2tfE73I2Q4NwHQw0zSp43p4Dw
	11LA58cuIEzJP2rXH4H1GQIGaWpfqmX9FkzWsMtjt5ahgvl2d9mxLQz8JtuCo/+g
	IneQm6rP0u3JMiGItaaA8a2VcfOAKZnwc+SPftYJACUN3YJiNKlFY9BbtbJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1745391037; x=1745398237; bh=Mv6JogyihW75FJ1Hxa8INduGNMG8XXXEEZ8
	r4tekflc=; b=hBq+gXH+iKSvkoU7Ujpfm4xdzguimx5HQo6dgu+d3GEjcY+Wg7x
	JqhapXjPQrWu1VJl1x2lwTtlkqbZd9lZ4BjnfwCz/GV1C14/Szl0QzdzDyruoKTO
	1SyjYEqU3z/YaQSABxKLDmreO8P74QoSUYCmc7KXB6F2/RkWw528JkX1VVEZmEbI
	Bk/oZ0cy3D/RoJ80GjeXJS81P9+eB6NYJa3J+VOlwi12QBirNSbI4zcnSzltguhn
	xPFIHQcm47x8Uqm8wEpSiqu6d8J/GtHQdQd0ECcfnzDeiljeOnEP3Dpf3sNYne5t
	/d53PlwMK31Rixsifm8k6yZDMb55QF/24qA==
X-ME-Sender: <xms:vY0IaDfCkgxJtk_A77Q3qMJrHNYp2YWPlMPLgxiEfxnFH9oygGCI6A>
    <xme:vY0IaJM3pDnW4e0qFu2prWomP0r8-FoOQCGxOLgT6hDF7GEUVjwauPog8uXnr8b69
    2llxCRZIiwADQ>
X-ME-Received: <xmr:vY0IaMgTvsFGmfBji_EJg7XvpZb3wd7BQfbKSi4s7o7JwknkoXTJqw_ktG7ElJJ5kR4JMCDHCx2pKOr0to5T4gSkY-K-Z_k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvgeehleefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddt
    vdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecugg
    ftrfgrthhtvghrnhepheegvdevvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeu
    fefhgfehkeetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmpdhnsggprhgtphhtthhopedvvddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepiihhihdrhigrnhhgsegvnhhgrdifihhnughrih
    hvvghrrdgtohhmpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdho
    rhhgpdhrtghpthhtoheplhhlfhgrmhhsvggtsehgmhgrihhlrdgtohhmpdhrtghpthhtoh
    epiihhvgdrhhgvseifihhnughrihhvvghrrdgtohhmpdhrtghpthhtohepgihirghnghih
    uhdrtghhvghnseifihhnughrihhvvghrrdgtohhmpdhrtghpthhtoheprghmihhrjeefih
    hlsehgmhgrihhlrdgtohhmpdhrtghpthhtohepughjfihonhhgsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegutghhihhnnhgvrhesrhgvughhrghtrdgtohhmpdhrtghpthhtoh
    eptghhrghnuggrnhgsrggsuheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:vY0IaE-I9zRuhJbBrtTXrD2UnSAsqmo0BJdPQN10KkHYbo94rFUrlQ>
    <xmx:vY0IaPvH81gSam0SpV5-9bnpdVRldPfhrPGWQOndNr6_cIaiI5pZ4g>
    <xmx:vY0IaDFEwmscmnwT33shTSGIiEW_FgOOklS24T5UR3h8yrMtdxk40g>
    <xmx:vY0IaGOgxDhuD2IISs9Cp-Mrs9KMdQXJLTPFuWd0y6SsiKqEHHVpSw>
    <xmx:vY0IaLTnsDtxALOkv3InCsEe9SCLvX8wFrh40qcLO3w4j6B8EE5LZPSa>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Apr 2025 02:50:36 -0400 (EDT)
Date: Wed, 23 Apr 2025 08:48:58 +0200
From: Greg KH <greg@kroah.com>
To: Zhi Yang <Zhi.Yang@eng.windriver.com>
Cc: stable@vger.kernel.org, llfamsec@gmail.com, zhe.he@windriver.com,
	xiangyu.chen@windriver.com, amir73il@gmail.com, djwong@kernel.org,
	dchinner@redhat.com, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10.y] xfs: add bounds checking to
 xlog_recover_process_data
Message-ID: <2025042340-delicate-stubbed-218e@gregkh>
References: <20250423021325.1718990-1-Zhi.Yang@eng.windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423021325.1718990-1-Zhi.Yang@eng.windriver.com>

On Wed, Apr 23, 2025 at 10:13:25AM +0800, Zhi Yang wrote:
> From: lei lu <llfamsec@gmail.com>
> 
> commit fb63435b7c7dc112b1ae1baea5486e0a6e27b196 upstream.

All xfs stable patches must be acked by the xfs stable maintainer for
inclusion.

thanks,

greg k-h
