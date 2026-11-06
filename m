Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793958608;
	b=YlG1DWKWjlf117/XiliNqlZ3FCrknX/G/nTqAUXLlK9Z37EEKMeEPvssSNmi+w4XDsn3
	 hNjSHqaov6/3UKpmfrzUZXga0YXnGRWNAM4A3Hq/XHbHKnLdVxUuRBUvOIzeIq4HVKNXh
	 9J7G9g9qjglMzgBMuDY2aXx2eblfwvCdAZpPA86Xn5WLVLyrwnDtykF+U23r/CrcXW7B1
	 N9+PNcjUXd9n1YOCU4tp5/NdZfXbiCWxWuV4NjzVcYFOlIHIjzptQ3wc98+KgmZ99JAzx
	 sgjx99aIxtKy8f6bdt6blwSK355drmiAmDWPe/QpudnnKHLKzeFOGwzkt3fna2DSxmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793958608;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kCUnCqn5HTWZnsrPGG7K4yZW4eeu6ReW8XRXv1w/mms=;
	b=feFIPqkU/ZbRrF2zG8s/iiQBrySv21pGPKmn3zzEu/haxqJnyoxSkyhtP3HdIiOQ/tpW
	 M7PL8W5t4j09FYdnyX/DokhMPk7CsPz5C/bYEbSkXWh+/2uBjaDjiDD2LW3vr4GXvxDS3
	 JIcCWjfAKDO8MC0as64OwbFr5oARwt6LtqXZRbBeffvHS18lu9X5ojpSHfeSteuptF2CR
	 nWSYme1NPvaTAm/DExOEW0nWMvm8GalcbJarUp6KDCYXwtISX0vhN8FQOtFItGFlihXyf
	 yNGyWJyCXUNc7HKSEN+36c3UCFQuJmchAHVTJRTe8V9tIzu60NqiVxacovg8+vEoTUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j4YBjvkV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BF6606A326;
	Fri,  6 Nov 2026 09:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j4YBjvkV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CB71F008A2;
	Fri,  6 Nov 2026 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793958608;
	bh=kCUnCqn5HTWZnsrPGG7K4yZW4eeu6ReW8XRXv1w/mms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j4YBjvkVgca9eK11r/pmkpmYVknRXQ1iskoPiA3nVhz6l4PLBxwItQPMezGI9RzXb
	 UPvuwqXnJMsyrsdW8ntFbsn0WdTQ4LaFVeRIXjvHcjcXw+vJXy8u44+zE2b3BTPF9G
	 uohVMaIXn0WeyrDi//pRdllPre2HvwFhzH1usLpvv11hATT0wd/Bghba+XTyDEFB9V
	 TWj+FoknTLGuFwd03RiJDDUr141atCh5r+DxSBjsS5rQofufHTfk6Y3NH4kHMOLI6L
	 K41v3KjaaSJd/H7gbyJO11e3/Wtew1FOv66Is2C+QSRKDeDkCVmY4wRpC4O+qr50E3
	 R5fciyUwDyVzw==
Date: Fri, 6 Nov 2026 10:50:02 +0100
From: Christian Brauner <brauner@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>, 
	Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj1072538@gmail.com>, djwong@kernel.org, cem@kernel.org, 
	axboe@kernel.dk, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, anuj20.g@samsung.com, nj.shetty@samsung.com
Subject: Re: [RFC 0/4] fs: support dma-buf backed direct I/O
Message-ID: <20261106-schalldicht-acker-fiskalisch-d53d55495e5e@brauner>
References: <20261016091919.971295-1-anuj1072538@gmail.com>
 <4649a20f-aba9-418e-987f-66f21ab24410@gmail.com>
 <20261028162900.GA22640@lst.de>
 <69f1290c-1650-4ce4-bc0f-e8a3c03a5d14@gmail.com>
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
In-Reply-To: <69f1290c-1650-4ce4-bc0f-e8a3c03a5d14@gmail.com>

On Thu, Oct 29, 2026 at 11:34:07AM +0000, Pavel Begunkov wrote:
> I didn't check last time but there is space to spare. Maybe I don't
> know about all production enabled options growing mutexes.

Meh, I agree with Christoph. We have rejected similar proposal from
other users in the past that just needed a little bit of that spare
space.

The  bytes that are left in the last cacheline are for things that are
useful for every file and not for a rather nieche feature.

> Filesystems should set it to a super block or something similar.
> It's "unsigned long" for that exact reason. Shouldn't be a problem
> for md either.

I don't think any of this needs to be in struct file. There are creative
ways to work around this. We draw a hard line when bloating struct file.
Sorry.
