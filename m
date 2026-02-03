Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291213939D3
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 08:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770107336; cv=none; b=NN3UXhv+/H/JigLvqBQI8MRasc/EgKanbjavziL6nDLBonR/VwIv6HZHBQTp9N4jDuTU4AIt6RWpDfl+urP5fuGmUQEpEXoUBUwQWmu0cNN8a8LOzFUtQ+SjXy8d3Np0MTAG8wLxfP7LNL/agTp4E0oy1vF1DMy+6vXz9f65tJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770107336; c=relaxed/simple;
	bh=G1a1r/3AnAo9noTgD6SIMFOaLlYMed6hFH477lU1mJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQKP4fX18c0krzGw1KMASLAbwJBteZYrkj/i9iS75bj6/Py3UqNMoGupFPGef9XP7FZox55Twjcff9f17lGtcDemtNaLAstz27Zg0mQv3GbmBBzfYPCSmSa/UqfpS/x7GnlAp3x+n3pwxUSbVRaYyf88LtVJ+TNl1pjBaQIAB70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FHX6Bi0N; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JNmdRjix; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FHX6Bi0N";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JNmdRjix"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770107331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bnv/JghgVk4idQK/RXe2hT8ls2BeCm0hMOi3sy0UuOo=;
	b=FHX6Bi0NFdH3GNAvr86FrNZBZYdSZniOMYm1OTznGL7TmRK4fa+ItF1Efm3unw1LLjx0cL
	ft3Kvu5ivvREmq0F2kas9Cf+IhvRvmAK7IVv4Wa8FjzHgbK9m2qAydWQLiG/ig48DTyzXG
	9ewYLHH55EwJ+GFe6IKNXT6GaQCE3RA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-BW3A0V0XOsCPhH0bJtCBdA-1; Tue, 03 Feb 2026 03:28:50 -0500
X-MC-Unique: BW3A0V0XOsCPhH0bJtCBdA-1
X-Mimecast-MFC-AGG-ID: BW3A0V0XOsCPhH0bJtCBdA_1770107329
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-352c79abf36so4825166a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 03 Feb 2026 00:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770107329; x=1770712129; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bnv/JghgVk4idQK/RXe2hT8ls2BeCm0hMOi3sy0UuOo=;
        b=JNmdRjixHGI7MR11C8sKOCbLICP8yka5ebPA6fxCobGRTOT2+XKV9qtGH+N/P8/6NT
         UuGN253HetkQNO0MRfx45/hoSHW6qkh4kIh5Hg+VSIjZ/quJEjxWlqnTWSBc5nCoEAww
         KX7+CD5wBI7JD8F9gbiS2QAJsqWsSxExiriNR7mv3W3ZWRpVJ5QcqD1Y4V7d8kOQsulW
         Mjnpq3C/v7u1iXvtrQj4joJtrNbacn+BW26VWp0Mj02cw+prJBHc3wtOkS739o4Hwj2O
         G+h0JOTbnZpgdvW3dao2h+XE/IduelV5kGmkyBMgTIOaLqBoMVuMPQ0qlO8OB1cSa9kk
         BULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770107329; x=1770712129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bnv/JghgVk4idQK/RXe2hT8ls2BeCm0hMOi3sy0UuOo=;
        b=hQ4P48szInb6EJFRQB6QtDg8ht6WiBaXU+kdG4xmPG5af7vHVUniY8TPdyyTyMrehG
         Ck0JUPgV3BrRsa7yo0PT/f4bivHwXP5bXMWHWmFpWLrQgwqJxWr5FpGQdu8LXbSwKg9I
         L6b+raRjen3RF9KZGTcQci5UpEHaUFwN0AKu1ZBSCml+0tWvtecMd5bAzfRqIYzHsa2L
         huBjUpqC6r1wSVPoEFZDrTRfpxwlqBc4MBcpDobk0wZqUEpVWyjL3ldI5ldZ0C5IiqM6
         uPRK+GJHo5E6p+x5ZsdFGgZvyJuNjvxj4G2UQwTdUVhck2MrzW5qs8xuHYqkMJU1O18U
         rXqA==
X-Forwarded-Encrypted: i=1; AJvYcCWlsPKrqCfufko1wV4h2LYqBB30Mn61zv6aizB+qioStwlDJP0fvhnVxsCcGnFSFYhFzM5Q3pmdBr4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2kan3lz8dAp2dlYp46g0lbjx74k+u5T9Jw/5hB9lpcrQ3x3ch
	8q848ao/BE0PzfKSyomBTlb2w9yZUZoi9LRIyVel1LRBwvHrDQSlz7giP9nh1fS7ux2Q0M6WK7x
	5kylbBsHYQ8f7b9+TH0ol1v+cPljEDjHYvMmWdldSAlSFB/hLfqbeHZK6Pv+9HA==
X-Gm-Gg: AZuq6aJ/OfoDtgv9HGxflTClFluEEQEX+N4ajG97BSkHYb43VzZDwQ1ufAvwkHCXphn
	icyx0fqekqRjrkmtJo7jZ2wDG0tP0kBShY1SkMayM5Q0v1o7pL/2BXsqWYQwvt2bzi92CYYOZ9f
	Tq7F/TaoAlpi/w4ASLd1o0ZzwfVR9iUvIfH1htXMEd+rTa5/c3B0C1tBAKENYj6goJd+RG84nf0
	JnHefDnCkMJnhFUyL92Fgs9ksbxHsexsoLAB8SdMP9Z3u3ap9StfOK4Hog66QPgAmWsaI+LsA8M
	8hYLjeDKjTlXbAqfi5uyIK8wyNSgJ3svfYGFxFa1IpuNNu/4XgDky5Pe3knXrnjSFsYyFMiy+Q8
	3/FkSaWy+PzZzlViHOwptxSF3P2fiiFss1OOK3GcDqvB9krtPXQ==
X-Received: by 2002:a17:90b:180f:b0:340:25f0:a9b with SMTP id 98e67ed59e1d1-3543b3d2607mr12497610a91.33.1770107329250;
        Tue, 03 Feb 2026 00:28:49 -0800 (PST)
X-Received: by 2002:a17:90b:180f:b0:340:25f0:a9b with SMTP id 98e67ed59e1d1-3543b3d2607mr12497602a91.33.1770107328829;
        Tue, 03 Feb 2026 00:28:48 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3547afceeb1sm1290786a91.4.2026.02.03.00.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 00:28:48 -0800 (PST)
Date: Tue, 3 Feb 2026 16:28:43 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, djwong@kernel.org, luca.dimaio1@gmail.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/841: create a block device that must exist
Message-ID: <20260203082843.rljncqwo7z4q4zgb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20260202085701.343099-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202085701.343099-1-hch@lst.de>

On Mon, Feb 02, 2026 at 09:57:01AM +0100, Christoph Hellwig wrote:
> This test currently creates a block device node for /dev/ram0,
> which isn't guaranteed to exist, and can thus cause the test to
> fail with:
> 
> mkfs.xfs: cannot open $TEST_DIR/proto/blockdev: No such device or address
> 
> Instead, create a node for the backing device for $TEST_DIR, which must
> exist.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

This patch makes sense to me, thanks.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/841 | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/841 b/tests/xfs/841
> index ee2368d4a746..ddb1b3bea104 100755
> --- a/tests/xfs/841
> +++ b/tests/xfs/841
> @@ -85,9 +85,12 @@ _create_proto_dir()
>  	$here/src/af_unix "$PROTO_DIR/socket" 2> /dev/null || true
>  
>  	# Block device (requires root)
> -	mknod "$PROTO_DIR/blockdev" b 1 0 2> /dev/null || true
> +	# Uses the device for $TEST_DIR to ensure it always exists.
> +	mknod "$PROTO_DIR/blockdev" b $(stat -c '%Hd %Ld' $TEST_DIR) \
> +		2> /dev/null || true
>  
>  	# Character device (requires root)
> +	# Uses /dev/null, which should always exist
>  	mknod "$PROTO_DIR/chardev" c 1 3 2> /dev/null || true
>  }
>  
> -- 
> 2.47.3
> 
> 

