Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67641862E
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2024 10:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091276; cv=none; b=KAxhLwDr1VKY6XzbQFihiMFNE8n8uH2lTglhJDGJkPyXJBbt4UmUdCC1Ax4Hzww6xJgUXVVgxboS/XMhWMAIDmOtP9o18nKx2Kur25DmkVlsbbKUB2we8yRtTyGHLYtMKG9sM3nwgTPrgjEW+LRxs7svrI31HMWvbXM6gKei8cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091276; c=relaxed/simple;
	bh=NqCAtQKhqezoI667+oF0eVHQWX7zz6BdtrjF+8DRGDw=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:MIME-Version:
	 Content-Type; b=jKoCN45NxfJ9DH5yqU9YIle4cu4NiXL36PO5qCSm9Q4Go3W3NLt8ptfrO7dC0TJp6aUyANzvSaXQxznTzJwFKOtxn5CQCszGup1EoXvnDmSmjFVE5zaSYGlCNL/Lm9j6oqMH5o32DOPWA0J/1a4oy3v+OkeyObD1vhKY4+Ke4zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
User-agent: mu4e 1.10.8; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: carlos@maiolino.me
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 3ec53d438
In-Reply-To: <l6nxtgxvlwmcejoylpuevoyzxxylkcl2vcsw4pwzilos6rph2k@o5ontnahuhz2>
Date: Wed, 24 Jan 2024 10:13:50 +0000
Organization: Gentoo
Message-ID: <87ttn3jawv.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

I think
https://lore.kernel.org/linux-xfs/20240122072351.3036242-1-sam@gentoo.org/
is ready.

See Christoph's comment wrt application order:
https://lore.kernel.org/linux-xfs/Za4Yso9cEs+TzU8w@infradead.org/.

thanks,
sam
