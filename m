Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9AB763EE
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 13:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713186353; cv=none; b=m5XPnfdfHBi5D7rV+OElVpeRauGzvSl0Ne2c/6kFMhVYDUip3i6XlkdRizDx7mmlC85gjPLzcHQ76bN5rnzUpNlq0LhTt+k7DREkcH7+eDh1NXLhnbT0PYvaNEuPu5PLCONal/uSoMZRoF9sKpyIa2TMdJybLfnTKcXNjzaVi0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713186353; c=relaxed/simple;
	bh=D5mblietN+qCqDWUH934vjzwMrj57ylQqO2Q7Dr28HI=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=t3cgHp74USzFkUz9xM1H6xIaOVibFUP32ajHE+g6GQAsIIjnr76+5FTZQ17RMsw/4VqchywiDIRE0a1XDSplC6OUb68cbzT4r2CJQQPL7uC73rCRIh53MpWCu/lGwNpkjAF1gcOCveuupMG/iENS2A6HGxsPdKKlNcjKp6x7hO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjTYeOxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjTYeOxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEBFC2BD10;
	Mon, 15 Apr 2024 13:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713186352;
	bh=D5mblietN+qCqDWUH934vjzwMrj57ylQqO2Q7Dr28HI=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=NjTYeOxZyMgHnIGMchjL42j0W8Sg4nSWwTJ8D8SRuXoCAeKZz6jEXGIMH5wgNQkst
	 B4cSZH2+i4NWajEH6YsoBe00Fa3eGPKt2BnXOL5tWryqZ5E+0K2MeYDh19WCa4OijZ
	 M51mzhU6ALoV2QDaXQShfLA87iYFkfCPjwuHNEFpd6MNw6L0TVHCvp4e9HcSGwY9xU
	 W4EDUuk8qdW+UWxQuN1mY4sGpmJXgPsAva1SmXtzz4Dw3395fO/rCgCBbVKBxh6xna
	 EOUVSGkhwPKZiPtQcQYwVBWnWUMphrQDxuVopyM1VRbGsRh0VkrAAYazcI63PLVc5Z
	 obZ9pz7jy/ihQ==
References: <Zgv_B07xhnE-pl6x@infradead.org>
 <877cgz3rmt.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zh0CHF5Fl3mqaSvV@infradead.org>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] bring back RT delalloc support
Date: Mon, 15 Apr 2024 18:34:31 +0530
In-reply-to: <Zh0CHF5Fl3mqaSvV@infradead.org>
Message-ID: <8734rm4vyq.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 03:31:56 AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 15, 2024 at 02:11:16PM +0530, Chandan Babu R wrote:
>> Christoph, The tag "xfs-realtime-delalloc-2024-04-02" is missing your
>> Signed-of-by
>
> Tags aren't suppsoed to have signoffs.
>

That article at https://docs.kernel.org/maintainer/pull-requests.html menti=
ons
that a Signed-off-by is required i.e.

'The tag message format is just like a git commit id. One line at the top f=
or
a =E2=80=9Csummary subject=E2=80=9D and be sure to sign-off at the bottom.'

--=20
Chandan
