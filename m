Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51B01DFE1D
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 09:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738056569; cv=none; b=aqPFqX28stfEd7LZZ70U4VbXtrI+6dhDsxlsqEdgQLMyILjnQq42pR9rpIv0flNdp5FO1fqLzM1Gh2eos5uFZJbwKNHqBfEddaZ9in7x3rsBDEgpyvuDFUHIZDSmBBIUAMxMomSpUo0c4TXfzafn0cmW1hwbaYPUzeS2y0QzWeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738056569; c=relaxed/simple;
	bh=fBrgpdkEMU+gT+0d65o0vxt6w3ja6eEceo1TvW1oqs4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=vCMXFv1TxsKZntORk3O+08YqVFmARzXdNmAJp04cjjz5JbM3uQaewkXdaDhMvFnpvly+FBgKbZKFbDD1XpGw7LAqFiCEgmiqNMaCOkmmnHgmhbluj1AqyqZ/azQ3KPM/EBkai8jJ0cnD1/p+BYbF0MALB8JJPosNgX8javBNEOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PFGSbP5E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PFGSbP5E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738056566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fBrgpdkEMU+gT+0d65o0vxt6w3ja6eEceo1TvW1oqs4=;
	b=PFGSbP5EsCM6IVDi5H+UMmlV2TpRNRPzluLn6RBTDn4YkETsJ/FDD6wuHjBwiOoIyulgAO
	jI1sBrxc6b2MWuPLkRkPK0MNk+eXH4ERkWpygPqnaJgQtX3PzNcVm0mbiFGKKHtnwW43iB
	HchOI56h60+pgeURRRCxFfwZG/Ucsug=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-N2E7Cq4lMpid_QiOhTAaCQ-1; Tue, 28 Jan 2025 04:29:25 -0500
X-MC-Unique: N2E7Cq4lMpid_QiOhTAaCQ-1
X-Mimecast-MFC-AGG-ID: N2E7Cq4lMpid_QiOhTAaCQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38a873178f2so3004845f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 01:29:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738056563; x=1738661363;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fBrgpdkEMU+gT+0d65o0vxt6w3ja6eEceo1TvW1oqs4=;
        b=ZW3nz7hIOlCuSm13T9TE9LL8n2D7LCjmlRfjngo6pSAEJwwNruaJpHmi9kr5XcHXzD
         qWdPAFUCVYHPrUBEQEXXzfW+/zfhaRI7diBPemHof5vFPXTxGRMqOgkf5yX1M0SERZOv
         RQiyqKzIUG7hJEXCw5aKhWJDMZ+ruItl7rKHy41ef9Ul5XIUQiudrPPOrBHX7MyY3rNL
         v9OpxfBwfFGoFuizHC8yhC2H8+UPyIMOVkGo5tfdmmOGCDCneoY5ElCIaG3B2/FbDOgA
         +R4OqTpfbuZoSNTqzWpk2qKy7Ssi/M7r040usWKhy3zCA9LENRnJPUAfEu3nh1fSnpIC
         o+yQ==
X-Gm-Message-State: AOJu0YwXYECneh7Z3p2y2i2LH5CF97SNbk7z7JBYahKhAGJY1brgq6Al
	l53Wnf8qWyxG6I4pIjYDU03c0CUR6Ypn4NgxjNcmn0cLWikgFLgOVnoOU9lbfMN467DfSNzVlay
	Fb9PkGJ8EIGbjwmKbp2sTxPbHLUCeTQtpNFl5ET5n47WrY8DxsDs9fUTHmjRS5e0YkA==
X-Gm-Gg: ASbGncuU9SAgAltTECJZYCVul/HecYFlyk9r58VSym/czahsTV3+i4oUJWe0mxBZCrr
	U+h3fBM987ZAwZYU2IcH7o+jJ0ll+nItmFFkLvEsWNcVOnT0T/JFEVcA9rfyFnLnNLlBWLXxBxP
	SCZtnaTLXmEhaatD25+LqJT/2GjwD0/c5H/SZZNHcWnz5G7S46SgmhQ1r5CeHNG+NXnETjextmE
	iwnlma2MNbSfnsT84JJ2q6Y6/actNkPAWSkz4eftfv2ty21y8z7OBnqcQa//dvjMPl9RlsA4BAx
	o+DY7qck9ABD1/bxs1i3VdZYrawag5cNgjr752GS/myaE91f8iXsUA==
X-Received: by 2002:a05:6000:8c:b0:386:3f3e:ab11 with SMTP id ffacd0b85a97d-38bf57a25b1mr28817111f8f.34.1738056563284;
        Tue, 28 Jan 2025 01:29:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZiTmE7dWDRIlyu4cfbtvZHdPYK2FwTmefF9APwoircCagew0rYWHBsvomxcDog+FtmmsKkw==
X-Received: by 2002:a05:6000:8c:b0:386:3f3e:ab11 with SMTP id ffacd0b85a97d-38bf57a25b1mr28817098f8f.34.1738056562935;
        Tue, 28 Jan 2025 01:29:22 -0800 (PST)
Received: from rh (p200300f6af3cbe008169428bb185d3c4.dip0.t-ipconnect.de. [2003:f6:af3c:be00:8169:428b:b185:d3c4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a176519sm13418490f8f.2.2025.01.28.01.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 01:29:22 -0800 (PST)
Date: Tue, 28 Jan 2025 10:29:21 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
    Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: xfs lockup
In-Reply-To: <Z5hmNUbdcmXSCmzc@infradead.org>
Message-ID: <a8774cb1-a3e6-5571-5f10-7a50e6596daa@redhat.com>
References: <9b091e22-3599-973f-d740-c804f43c71ca@redhat.com> <Z5hmNUbdcmXSCmzc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 27 Jan 2025, Christoph Hellwig wrote:
> Hi Sebastian,
>
> this patch:
>
> https://lore.kernel.org/linux-xfs/20250127150539.601009-1-hch@lst.de/
>
> should fix this issue.

Yes, that did the trick!
Thanks!

