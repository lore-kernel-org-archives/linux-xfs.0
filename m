Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C95C22E402
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755018693; cv=none; b=mA1HOIugLwuRp0rDtE65fpAl8D+mCY8S1w/FVNe+HRJoSrZ+yP1ECMHYhvWpDi7KsX7ojhO9uRO5yf9KIKp4JvWH6z4rTkRTw2wAvutLxtUi0+tce81cDwDlax01F3FoZc/kLA2mE4AvE03ADJVorSk10fDOWd3jYp7C7yHudYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755018693; c=relaxed/simple;
	bh=7rbRck077Xr3QB/yKuzHkUIMG+GnCWEWE8m7/2tPOI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VDNQzZvm8Ar/K2l5A27A1k/8xiH2Y1Xr2M6V9t8aQ0RXAP/ez6NeuIYlHG9JcdQwndyGLEhufP1DJqr8SLsC96UfvLYv3A/LBNakCGf9ZuJRHhfhFc3ouoNFMscWgrUW5XSmiSFFFwEsaYmBPo5H42cEK5kWhSmx5U3SUkcvZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iNAJfxP/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iNAJfxP/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755018690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cP2OHHmo9urpEPIW8P+jTI4EpHMpDkapbSQ2TBaCUcc=;
	b=iNAJfxP/T5Tsdvzdt9H0ZAhO0dh0r+AAy5jS+i7a+YXN5ik93Iu7QKjIgA3JGC952LPodh
	LqNmAsJDjnZZ3DO9aCBoTwbR557mBig+5Q15xBdcT8COR2RvxDSxUmbasqxQSDN6QhDpzs
	R1TD4Pkf38ZhRz6oRJpB9z1VWgD22Ac=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-o2VEcCxZOQiqIEKzbROTPQ-1; Tue, 12 Aug 2025 13:11:27 -0400
X-MC-Unique: o2VEcCxZOQiqIEKzbROTPQ-1
X-Mimecast-MFC-AGG-ID: o2VEcCxZOQiqIEKzbROTPQ_1755018686
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b78c983014so3728688f8f.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 10:11:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755018686; x=1755623486;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cP2OHHmo9urpEPIW8P+jTI4EpHMpDkapbSQ2TBaCUcc=;
        b=Kr9voHI39RR1e7eEQLtpXb7XE7Tg9NI/kR7otQ/TelBSyMra7+9uZ+kYgNbvs4yBby
         YQlKAhrx1PQiqKEsc/lpO5eQa6CyRh/bdPXdU+9H5CqC3Xe7gp50YhbqA3X2MGH/5QDN
         Ly5mULJThtywvfuX7vZtuqfVAduVdUy3OZwnUV5X3dlFBRK6K18BV4UEM/YOKqarEQ3w
         TQV6NpUMAxODlaQeRrmxaMz+zowDWThx5Q9WR9bUFtFlUd11edDqcRbOPKUqoj1+RsHK
         Ix2r2tEfUojI6+2W7NVUh5F2sedZiVMZp7gylNRcR1x6xqn8i71/Pcgww35P/Ql3NacW
         Urlw==
X-Forwarded-Encrypted: i=1; AJvYcCWx5ipec1SE5H9kUDyGPjRrp6bYXro96IzWGagqlDvVcIEWt0I/CNEktIq48boTrUPLtJIfYuyI6rY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKbDfAg37dh3Cq2XzCvkcmFi0L0fIS7TDhAwsy+E1I2HzNzjJJ
	bDeHGuJA/VUmO0WPf5TMgIMpFLhK0KcccWdrmxss1AmS0AUFjhWCte/a5oEWYWUyShuuoYVdLDv
	1hYt+pnoBliFHLYCq04Wir8iUCqW+mGprBsCYWfsjhy/gap2yRz6slAJNJmWN
X-Gm-Gg: ASbGncueGEtKyeL32pfhRicv8gb7FDOrzH1Z9XRZBQklHTpiTMx985Vf8v5WwR3pNou
	8/cimNmjUDbhI9M+kCH0JWH9lwqFnEBwFImdKkIFVEoga2ghQcpxqc6yipsRjnSbiBl8d9Ity7g
	g0+rCy/6y9pIn1WQRtgZnyyC3mKlvqzb+BXY8v7mMJoikYwMKBD0MJidlmpBE+gzae0npKAEo50
	ZdbQucyyeGdexHq2z6DOlUtVCZ/xdvj1o/tlxp9M6J9KSzM3XsVLz/LvvRzQgK7LgnMp5fE5Ubr
	7vCrymfyT55Wg3x62WdsqMOabHvNa7IeVOhVaIoSd7Cz/afdWiE84Krc1KI=
X-Received: by 2002:a05:6000:4284:b0:3b7:7898:6df5 with SMTP id ffacd0b85a97d-3b9172842e1mr184458f8f.14.1755018686211;
        Tue, 12 Aug 2025 10:11:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEu8Rkwg6tXk/NOl1brWzbGx1iLmq2u9niyeF3EOyOy1kqum5BGcDYR8r3k+JuJQv8cN6B4Mg==
X-Received: by 2002:a05:6000:4284:b0:3b7:7898:6df5 with SMTP id ffacd0b85a97d-3b9172842e1mr184431f8f.14.1755018685786;
        Tue, 12 Aug 2025 10:11:25 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8e1cb7deesm35097967f8f.2.2025.08.12.10.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 10:11:25 -0700 (PDT)
Date: Tue, 12 Aug 2025 19:11:24 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, ebiggers@kernel.org, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH RFC 14/29] xfs: add attribute type for fs-verity
Message-ID: <radr4lpyokwvxdduurafrfu4l2uwisrbbggdt3m7afcutmezwv@tj334pmh4pgk>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
 <20250728-fsverity-v1-14-9e5443af0e34@kernel.org>
 <20250811115023.GD8969@lst.de>
 <je3ryqpl3dyryplaxt6a5h6vtvsa2tpemfzraofultyfccr4a4@mftein7jfwmt>
 <20250812074415.GD18413@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812074415.GD18413@lst.de>

On 2025-08-12 09:44:15, Christoph Hellwig wrote:
> On Mon, Aug 11, 2025 at 09:00:29PM +0200, Andrey Albershteyn wrote:
> > Mostly because it was already implemented. But looking for benefits,
> > attr can be inode LOCAL so a bit of saved space? Also, seems like a
> > better interface than to look at a magic offset
> 
> Well, can you document the rationale somewhere?
> 

We discussed this a bit with Darrick, and it probably makes more
sense to have descriptor in data fork if fscrypt is added. As
descriptor has root hash of the tree (and on small files this is
just a file hash), and fscrypt expects merkle tree to be encrpyted
as it's hash of plaintext data.

-- 
- Andrey

