Received: from mail.camora.dev (mail.camora.dev [45.63.89.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4609D3A7826
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 19:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.63.89.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022304; cv=none; b=YQ/qEzdgaRF9Uj8tZMilyLpImQeKRvROug7hQ+54ekxk53PBx5jBU3HeC6h4QQPLua6YPH0Uw9YnuDJnya7JZ30NUrzcdidfzruA0OGzvQM16PVyfzOHYx5hEW5v61KBRbKCJGhKwyaewY4RvDuZK0lvnIY+egfyHQBrtxqsuEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022304; c=relaxed/simple;
	bh=0YOMmggFYIP+r9chG8Cl+5gET+q+L07FhFS2wGYEoho=;
	h=MIME-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Xngjj5cEcTy7KC7a6TdvP4OruKH7rGiakYZdMDdSH/PRNa98zjAX5NEV45hmlCn0T9DA2rGa+7/DXxH+RV4LRyKrxmfVeYvHE9QOV5J5izgwLU+D/0n9YEYtMzR1FF7bJ6dc2MkUc8Ee79mFdScyWWFeDg1DTbZfF5uKaSIcQAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=collar.sh; spf=pass smtp.mailfrom=collar.sh; dkim=pass (2048-bit key) header.d=collar.sh header.i=@collar.sh header.b=eHWJmI69; arc=none smtp.client-ip=45.63.89.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=collar.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collar.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collar.sh header.i=@collar.sh header.b="eHWJmI69"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=collar.sh; s=mail;
	t=1783022295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0YOMmggFYIP+r9chG8Cl+5gET+q+L07FhFS2wGYEoho=;
	b=eHWJmI69CldoZF0zAScgntQxxrEKlu82geT7A+wBpurWgZVc5yFF8yJ0eZjmeB5MIwsVZU
	MaxaGelxc2wrHjF0KeVtj88qcErOcUNxrVkqJJhpgeauFfYFLL2rEP5B/ZBAbFpNolXOg4
	TfAEQEX1ii1lWsc5X1zVcJDDAFdzRKIdInIYSsJfKC5ZyqZR0NYifeQ+v6j7j3afuFCx91
	1ejJQazD+NlDVuYedvcBTzU60+G5yZSsAK+/7HUiNrMxyy1Bv9+4m01SnjbFUyUI6nmI1p
	kom7CXo+X+Uk8Guq8kBkzZL61OS+8iiFdy1EujlqOH87L/bg75lSgGoek1cBHQ==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 02 Jul 2026 12:58:14 -0700
X-MS-Reactions: disallow
Message-Id: <DJOCNHYIYK0G.17Q5FWMGKKXMC@collar.sh>
Cc: "Darrick J. Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
 "Carlos Maiolino" <cem@kernel.org>
Subject: Re: [PATCH] xfsdump: avoid false-positive __strcpy_chk abort on
 long dirent names
From: "Celeste" <celeste@collar.sh>
To: "Andrey Albershteyn" <aalbersh@kernel.org>, "vmfunc" <celeste@collar.sh>
References: <20260625222337.54449-1-celeste@collar.sh>
 <20260625225758.GN6078@frogsfrogsfrogs>
 <178243370553.73182.935356806206037088@collar.sh>
 <aj4z3v6RGnSbxlEI@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
In-Reply-To: <aj4z3v6RGnSbxlEI@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

should we then assume that this is fine to merge?

- vmfunc
