Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077493C0A01;
	Tue, 21 Jul 2026 10:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630699; cv=none; b=Kc/VdI0vaj2s5CrlQ6pbiHS6hT1bM3T/fCK3RUVr8dibk6NY0y/yQuopNbJGWrgTfaP80TX3l7obtJGPSKIX3euPDRE3Ev79fjEBg/8d3zGj0mJwAhPtiY/9wNgx9dghSoe5AGZBueTOS5X9a5XfDY3gEkve7PQ9I2uDThKUre8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630699; c=relaxed/simple;
	bh=Ny8uNafFHLsKzCtHD9aow9Vof8i3NLQ+hSWAzPZ+UIs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CVG+i6BBb/c0yiI6I68pmWlyNReth6yBnZPAFUCTlDGlpgnOdlIVtMFenaHwp8DZAUMzbcQL6A7TDzHsEHVAHr6VjI8r6m2DYSBB6McAivoZw7mbPWd5AjN7DnGbUAg2Pz7OgAVVplAp3qPh4UsG+9ux3UNXa4m9uiR1WmB4c+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNo1IpxL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNo1IpxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B8E1F00A3D;
	Tue, 21 Jul 2026 10:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630680;
	bh=LVwzjmX1KEvtu1uDg6UGyjEKhGemf6vdBii2qShXMb0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TNo1IpxLgZyze3JmroYa1iXIpcERbUbCKq1pQs+IcMHJtjfWJ36KtORSkWqCvxIKT
	 YiBOFlhqRK7RcD1wVxzap5CQX2A5NE8TwPuwsaN+qrYbOJRFeb6uQxIMTMfGg08t8v
	 V/7hVVS742vf8lg98MdvysSeIOUhr2Iv96rIYzDsqWts0lL3oyG3IxtaX03wu9qA65
	 Strar6eVeeiuvtHTeRN98/rXUX5e6IQRDDwKPvfnw4waj7udzwLdBIw8YIf9726rJ9
	 l2xgP+MV8JtZQrA4AT4dZCWYRjill2IF7dZww/ZsR1EyHGqlxa2TeBsMhfFGyupRx7
	 MtmS9C+1ZSiMw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Guanghui Yang <3497809730@qq.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <tencent_542687AA9C474951C4132E84DAED17622105@qq.com>
References: <tencent_542687AA9C474951C4132E84DAED17622105@qq.com>
Subject: Re: [PATCH] xfs: propagate errors from xfs_rtginode_load
Message-Id: <178463067879.324722.682575488251430638.b4-ty@b4>
Date: Tue, 21 Jul 2026 12:44:38 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Sun, 12 Jul 2026 03:42:56 +0000, Guanghui Yang wrote:
> xfs_rtginode_ensure() treats every xfs_rtginode_load() error other than
> -ENOENT as success.  This can leave the realtime group inode unset after an
> I/O, allocation, or corruption error.  Growfs then continues as though the
> inode had been loaded.
> 
> Only -ENOENT means that the inode needs to be created.  Return all other
> errors to the growfs caller.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: propagate errors from xfs_rtginode_load
      commit: b7e53968cb8882c2d276429ea8550848a4940874

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

