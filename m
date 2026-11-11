Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794396100;
	b=teqQ872DDYFLntsY6yufrz7lFMzIGiyNT6c8aYTnsBtc4is9XHGIoW+N39at8kY4jwm+
	 pChsT+97WYSK1GGNnDrsDMAO/MWVmXNsEQJA5fXMmmbWNSFVNrFnspVQvcb1QWNglYr7K
	 Cz0KwFVQPeubD9hbqTxgvAr4vp7YGuULra4TSsUchs5kmVwi3aDpS/sXCxu23iIw4yhRv
	 cjv6wc6yNSbANobCYLFep4OEc8nuH+FEqv5ZzHI0faBHWsByOmUF/UT8HoqT8aseSQ055
	 4TtdSV2uEDaUCXXSXKFpVyYH3NIrRujmzElAGD0JHbCDlIiZrsRceLAnMfmXqkHJigA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794396100;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Nwk0w3cw4cl11qJakkDZ+TjXZvkQ4TxfC3BEvxKHlbQ=;
	b=j90iQsuZLL9Ef0GtMWgy2ksZVOkQ2qtQhvcoYcY9L8WA6q4LoDFn9tzebpvoqnU5AfyE
	 eL8HxAB44zAm9M93HX7DGMZIDj7qxoqMc7rqatp+hvyyUV83/G05bXLsPNkjFYPKIIl0x
	 owxkFh1EnZBxHI3eDkns4jQMvifVDFg5WAiirRgww7IBnJ7rxxzRGbcRZRvEW8HFrAVWd
	 c1nllzyiZWWhsq311Y0PmO5D05dQzhJcc45tplu33pkQvsHWtID8/3PNVTUd8YkZ7cFvL
	 KaIfcanm8fsRO9sUBoMGISdCLlKt30iqCUDW3RABg3tEigkt74v/9AmgFnxBnY9uzGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nOGz/Vc0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97E2606A324;
	Wed, 11 Nov 2026 11:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nOGz/Vc0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094C61F00A05;
	Wed, 11 Nov 2026 11:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794396100;
	bh=Nwk0w3cw4cl11qJakkDZ+TjXZvkQ4TxfC3BEvxKHlbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nOGz/Vc0jEbILhvWwYAVeBfiditgKT1dD3EfPM6ZAbxXHeC8AaUg0UanoZ/88oXV8
	 mEXcrpuR2/Cp1e/CEnaYV60Ovlpsf8lE/1eCsMStB0oyWWjq8Bwdl/iS9GqerJ+Srs
	 Ul/++BnbUyvUlONhNDK5QHA6DijCTblT6y0AQD+Q6z3oAumIEimgQ5pwUDhCrR5eyX
	 EIQ3YIDt8jJuU13mLFa991/UST8LTiXldAHPGhpTPWiugjy6l4VXWtapvcrcyzszV8
	 FhNHAmz/9509qgrKaujz9abPvHN+tABDOWq03tOSMW5+N0jT5yChywav1ZbTiQO64H
	 0doidrb0f41PQ==
Date: Wed, 11 Nov 2026 12:21:35 +0100
From: Christian Brauner <brauner@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Chris Mason <mason@kernel.org>, tytso@mit.edu, david@fromorbit.com, 
	jack@suse.cz, djwong@kernel.org, josef@toxicpanda.com, hch@lst.de, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 04/10] iomap: don't punch delalloc under a dirty EOF
 block
Message-ID: <20261111-esskultur-nahebringen-beiwerk-4a8a3b77bbf1@brauner>
References: <20261109235111.14129-1-mason@kernel.org>
 <20261109235111.14129-5-mason@kernel.org>
 <avLnAe4A6EB8Whyg@nidhogg.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <avLnAe4A6EB8Whyg@nidhogg.toxiclabs.cc>

On Tue, Nov 10, 2026 at 10:43:37AM +0100, Carlos Maiolino wrote:
> Christian, is it ok with you if I pull this through xfs tree?

Sure,
Acked-by: Christian Brauner <brauner@kernel.org>

-- 
