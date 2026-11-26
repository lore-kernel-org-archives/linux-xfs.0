Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700959;
	b=kL94EBsZ/50Lu+qKVBABWCiEtKo+i24rEx4TTn1wesCpXDXw8vmgfgbifUDtzAC17AHd
	 9/iO+N4Y36xytRShAFlTwU6xaPVhXnmPWGdwwA9mPPMISO1slqpNl4IZNTuZAjb5mAJ66
	 vQyO7weKUjWFY5eUZf2dQS2krdyV6V9BavjXt+XklZukDHeaRFIXdT5ZdeKUQiCb7boLk
	 axL2ttXESQ5F0qISXGy+T379JOhLjQWc4fFhQ7jSnipzoPcecZRQA8OoLnZjaZ2nemS43
	 aIuFMItn1Rv6MWvy+n10eu0oIaSIr0AoJCYbC8ObJtpf4jyQtvqqZgiQ5pEYMOM33CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700959;
	h=Received:DKIM-Signature:From:To:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=VwYoVpqP2s/F9KnJEpoxU87ilAUxzljI+G4DzwLGCnU=;
	b=UqNYXbO/3KQ8DI3PzS+qih7swEXvK/7dvj8gAHV8EoJ5CsldNYotSit9RGiK8T6J7SsY
	 XVnL9uxAzgbmSOEABJLVJdCb+TFNh7Mug1DHAIE37TLjVxrNG79Dsbb3dPNN8VDOzeQou
	 vQ2WnFCP9My6gkavcbrFQIrqbYNJUmDhG7fxsUlVTYyFQScQS5CMtcw2ZY5WuXKDwhIUO
	 +DHAPWsKYDm68DCeSCf2rDns1frglUCTJMCMUx9cCYT54GzNuLtuIYRoVZNau1X50V0Y2
	 JZy4u8f6U6Z5iPi2N+GDAqe/eZW5JfVCJyntsggrybLTqYRAweWjwcVosM9MUHksX1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jRuRVKiM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA6A606A339;
	Thu, 26 Nov 2026 13:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jRuRVKiM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDCB1F008B2;
	Thu, 26 Nov 2026 13:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700959;
	bh=VwYoVpqP2s/F9KnJEpoxU87ilAUxzljI+G4DzwLGCnU=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=jRuRVKiM2NJ0AasoQ0Awrg1fuqO2GZqNQ7ktwdqGq9+DfsAae22gM5PoLh9a5GsOc
	 3meoy8fIVXtWE4XSNgq5F4uUuJWI2DAzCuIzNomWWvXgn79gjQ/rAjBFPhZFzSb5PM
	 qRtL/chggoza1VeJrSw0yBqkDDtmcAcpP5lA/uf6B6EDl18TdfXKCpP/De9ajETANu
	 oNIHicV/AuNQnjOfjqyE/GqFFONYHK44399oOUsykEVVMBrft6kTBI5OytzqMIWgm5
	 hspH3ot+lo/4Fi8CaRRx/r7TLZd5kM6TVZkPcXltQSsBRgow279+yd5/nw/Mdemr8f
	 yR6I7y3hoAuxw==
From: Carlos Maiolino <cem@kernel.org>
To: tytso@mit.edu, david@fromorbit.com, jack@suse.cz, djwong@kernel.org, 
 josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 tz2294@columbia.edu, brauner@kernel.org, Chris Mason <mason@kernel.org>
In-Reply-To: <20261112214604.67875-6-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-6-mason@kernel.org>
Subject: Re: [PATCH v9 05/14] fs: validate atomic writes after O_APPEND and
 limits
Message-Id: <179570095609.157938.15961057740239692437.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 14:49:16 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 12 Nov 2026 16:46:09 -0500, Chris Mason wrote:
> An RWF_ATOMIC write on XFS with reflink can expose stale disk contents
> if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
> aligned.
> 
> XFS and ext4 call generic_atomic_write_valid() on the range that the
> caller passed. But generic_write_checks() changes the range later:
> O_APPEND moves the position, and RLIMIT_FSIZE cuts the length. XFS can
> then fill only a part of a new block, and still map the whole block into
> the file:
> 
> [...]

Applied to for-next, thanks!

[05/14] fs: validate atomic writes after O_APPEND and limits
        commit: bca5d7312f3772083a84f1fd172d11b7fc893701

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

