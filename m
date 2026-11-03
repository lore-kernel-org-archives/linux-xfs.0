Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700149;
	b=1F+W4t7kB5GOwCEtSuTKX/hyx1VTK0ktm15f8Mbu8RMPcwb2BlL2ycZ0vsOMJ3tljFys
	 L0ELQ9d2TG8V9w30t/yFXac25nvz2ohJEXIJ0Z8hRTl1BBmipgv06eHn9SyBVh9Vnx4ox
	 MKZJT40Bob5VWiegBNRsUo++x+5I/JlB7PqhA4H5hc8ujFgEG364sJqSrb7ZE9ujWcGoz
	 YFec9HI/JiM9Ver9U0oaqCD+HSW53aUoFZoeMFHid22+wr+CuLcftbM4jIqn+KAFcG/rr
	 UFtBhnaSTDmi2dByu3vHGTyCVKSZgQazdGfb1Kik6m264x3/1op2WS1wbxbunT4kLjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700149;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=SqbYtgRwv8HZ1eJAUuQK7Bk8SUZv++K3V0kRYg9US0c=;
	b=4Y2TheDzh7u15aPrFBqs5iKcKP5WKjCm85b+zl2W0JzqyvI0uaVfAjBbWjKNlk+aID8R
	 n86I2YeLE2HrXmyCZLDlZwILTC5sS8X6vhDuQxZtujQuuvKJigPxRqXJiWUqyEOCzc7AL
	 qpGAQu6+OwBW0FGmaBWpo261PGs+3EQ+lCQNVotYh7Y5CDzw1g0JfDwYc5/j0MhNnFoNL
	 xlmRYiaRLMr8XJwD6scBVw0VgftCyuQ6PY+ElvKVoF0UKg6ckTQM01LDcL06QqPb1vQSj
	 zxNAxsV2UUFelQ/X4xZOSYqkUxYMEgnXnAVnWL6uNRqda7pB8b3lAUmw1fID3tPPagQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lLTVrKrI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C69606A33D;
	Tue,  3 Nov 2026 10:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lLTVrKrI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A878C1F000C1;
	Tue,  3 Nov 2026 10:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700148;
	bh=SqbYtgRwv8HZ1eJAUuQK7Bk8SUZv++K3V0kRYg9US0c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=lLTVrKrIaBH6zUQ7bDKr5TgacOJRuOJZlmYT4d2u9XwfynGPj5m6vY/dw1vsxASJc
	 1XxtplUbtMmzp38uiPm38pM+9ntGvLkwFYfW9AclENHSaZ9jHZupHQQhWYFriAi4h1
	 +z9iA3e9vvd322FcypTX174RiWpzmmOSl5XWeZmrXpM6Iy3zkGyu0OJ7aLgKK/Lkzl
	 0JOvIDeV+5KfkqSZWA7pVGRxaO80q3rWan+3jpMgZlqu0bZk4hyEI53JwHyaZVyuUH
	 jsPxZMk45yZCIVIV2tgUT8Jhi2tiKb/m4Q43SRLIIHPgcmofkZlkg5CRLoxRSjc2JL
	 3rLYjndwtPGHw==
From: Carlos Maiolino <cem@kernel.org>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Dave Chinner <dgc@kernel.org>
In-Reply-To: <20261021063329.2853484-1-ravising@redhat.com>
References: <20261021063329.2853484-1-ravising@redhat.com>
Subject: Re: [PATCH] xfs: mark i_mode=0 and shut down on attr fork
 inactivation failure
Message-Id: <179370014741.413123.16126716252675791304.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 11:02:27 +0100
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

On Wed, 21 Oct 2026 08:33:29 +0200, Ravi Singh wrote:
> xfs_attr_inactive() can fail on an I/O error reading the attribute
> fork's btree blocks, for example from fault injection such as the
> dm-flakey errors used by xfstests generic/475. On failure,
> xfs_ifork_zap_attr() zeros af_nextents without freeing the attribute
> blocks or decrementing i_nblocks, leaving the inode in an
> inconsistent in-memory state.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: mark i_mode=0 and shut down on attr fork inactivation failure
      commit: bde0010631a207511308dc8407f34595dac13ad5

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

