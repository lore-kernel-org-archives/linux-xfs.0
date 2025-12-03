Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A262D5A16
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 09:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764754316; cv=none; b=AXFAdd3mZ3ukOepbyucE5Yo2zIE3OGUSlY8le504VcSe32e2kDahj5+t5EzoRUWdF9UD/LUxBI2Ms253A2/hLRvJwcMv4/2YKV3me0AZ8uBabP5v6Fz1MbdlesRzeccgMIc5ih5N1U95odYx5LlBmX1y245TeCNhMmUfx6cB5cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764754316; c=relaxed/simple;
	bh=jbaH02c/D3QGSIFZvuui9Ihs2a0MIwS8+FrY/NvMJCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rLfcYKrk+dX6XYGjLezSTasbfMedtvYC5U+5CCF7OLIl4378pUj76YfsgbPptnyE7on4+5+dg2Rrg/EIMPXBqi6UblJzFK/4hAVDmzgPnQR5pw0HG7+jK4TSzs1IsewLWt/rzNpIAPYXsnVXkuogZLhdKoa/08fyPXHHMu+IVGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FpKyjzgO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tm/mqdNy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FpKyjzgO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tm/mqdNy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764754313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0vf9T43HKz5BiDm/5U75zkFto3sLQM1Fb/56uQVaOg8=;
	b=FpKyjzgOEzZvVUvLFhJkYrd7Ijy93jVOg0V7qYdNX+pIB9wIvTfNaqgpQe9SbzL2xG/UUd
	17r9ATg+iP6VBm9ZHCqWPhabOXr/5DlswB8pU9C0ZT2RTKvSXr5LF8aqWyNMRHWhEaL1qj
	YokShKBfxwNtcfWvs+gWcorKD+BEimI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-INxtYllWNJe6jnHDezSyJw-1; Wed, 03 Dec 2025 04:31:51 -0500
X-MC-Unique: INxtYllWNJe6jnHDezSyJw-1
X-Mimecast-MFC-AGG-ID: INxtYllWNJe6jnHDezSyJw_1764754310
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4779da35d27so73779855e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 01:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764754310; x=1765359110; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0vf9T43HKz5BiDm/5U75zkFto3sLQM1Fb/56uQVaOg8=;
        b=Tm/mqdNy4YyiQo3BG4vMNymgF9C6quxSTlDGaldEzcM2tOXNjFnLHYfWKCqTvJUdVx
         5/zTEBVcDLqr5D2VsX/fjwqRyJGG3ak73X5koMGp48C6hx2NqVMlIICylqVoz+fDvxGN
         HRd0KXNhr5SnBLaADeeda7pIse7YmXM2MAJPH8V2msQ5tWpYKzxevJAogZSYCbKqPnqD
         WppuwM8c36myGsLEqn3MwLBBOxEP7NUg/s8XA2d6zy64V8pekeF1tWQpjmZGNR5d5c9a
         /nkY3k021T3Ox/qawrxzdUQOhcV/a9uLshj3QfzJdRqAWm1HQVp4D509UWaaqyDSwK5M
         YXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764754310; x=1765359110;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0vf9T43HKz5BiDm/5U75zkFto3sLQM1Fb/56uQVaOg8=;
        b=jqhn/Oq3qqcHGuqa0nsDgukDpeULn2Pebp9R+ggQ6Q8usopmtXcLeqCHK2U9+YimTp
         dnlg5Bes3fiXTQySoFCpCHxuxcqTGdegrH5pHLwWPTAVdopycWmSiHpRNglE6X57VY9x
         D9Ozs+LNqEaJ35/tfrGRGfeEe9pLe6l+oUpg4z9g3x4Bb5Yb9CT6nkLJSbWyXc3t2jfe
         DFADHpbgG0dTuPUux/bSmxy86b/KBHyzi5dgGEkZT/G2dPfzY23dF4SfJ1GTBfv4DTzq
         1zKXLinWKEbflCDNOvasltQuzQrdB7aeMeMv35iSGKfP9/eo2uXyx0Cy6eYTrrEhRB41
         r7yQ==
X-Forwarded-Encrypted: i=1; AJvYcCUku6NCxX9F2qsbLoVxHeH/uDoKw2ylIp1qG2UhHW0r7Xokmm69Z0U7pyYIqKizpuykbY3FP7WtP34=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY7XGZCZwwJoEHaXI50WLuD+C/buXZ1u8w/bSbZejEYzD5RAGW
	Jn3ije28lDxK9X9oKrbjmhnnK7e+uQfmCfCIcUTTi/x/AXmsFRbAKDyYLom2P1ipeToWGy3UnI8
	J8zwg0XkqaWCc1vT0Yu14NqHECny0nPV2HKHxWSsjRgPfArHZRb6uZHMKiWBI
X-Gm-Gg: ASbGncvRw9NkvsuzS8rY38pLpzbALHb+yy36vMfKzevFpZYOyM4GdbpB3pERt0EgBAG
	ctthOruoGgdi3lure4Uyf9oylScKxmTH17ce50rv7fosx9kybxHX0+pJwrWOF5hv+6E4T2TiDfC
	JdueBHeiNJv7Z/B/x1nW/jYjB/mFDwO4BJSSoiroJ9XOcG4VKtJ2/1c6lmuKA6ftOursv8YUhfb
	KJSmFYE4oOL5eBEn5YE7dxWEcigsMy1P5zXCZsMoexX5tRh3yneZkbCrywOUEd7I4B5VAuF8suD
	zcOhqKhLVY2zl9lEW4+ROMTx1gyK3K3w4cN92jPsYTF2DJ+fjjZYh8SrhKrVG17aOSPY2YbC9jE
	=
X-Received: by 2002:a05:600c:c8f:b0:479:1348:c653 with SMTP id 5b1f17b1804b1-4792af333d2mr15766805e9.18.1764754310439;
        Wed, 03 Dec 2025 01:31:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHK3oSU3Q5Qq8/Ff+GOnZBe1upIUTn+V01EGl+dDPcuNru0iKNxeJYKG/JdSv3YehtMmFmDUQ==
X-Received: by 2002:a05:600c:c8f:b0:479:1348:c653 with SMTP id 5b1f17b1804b1-4792af333d2mr15766265e9.18.1764754309830;
        Wed, 03 Dec 2025 01:31:49 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a79ed9asm36785885e9.6.2025.12.03.01.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 01:31:49 -0800 (PST)
Date: Wed, 3 Dec 2025 10:31:18 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>, 
	aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] libfrog: add wrappers for
 file_getattr/file_setattr syscalls
Message-ID: <n3vjxzckyurca7ysssexii3zimnk43frvx7yxxxxqmnogx4y3v@67aipeckchvq>
References: <20250827-xattrat-syscall-v2-0-82a2d2d5865b@kernel.org>
 <20250827-xattrat-syscall-v2-1-82a2d2d5865b@kernel.org>
 <905377ba-b2cb-4ca7-bf41-3d3382b48e1d@maven.pl>
 <aS_XwUDcaQsNl6Iu@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aS_XwUDcaQsNl6Iu@infradead.org>

On 2025-12-02 22:25:05, Christoph Hellwig wrote:
> On Tue, Dec 02, 2025 at 04:37:45PM +0100, Arkadiusz Miśkiewicz wrote:
> > &fsxa should be passed here.
> > 
> > xfsprogs 6.17.0 has broken project quota due to that
> 
> Your fix looks good.  Can you send it out with a proper commit log and
> signoff?
> 
> Andrey: this seems almost worth a 6.17.1 release, unless 6.18 is
> going to happen very soon.
> 

I'm planning on doing one for-next update this week and then 6.18,
so I will probably will add it to 6.18 only 

-- 
- Andrey

