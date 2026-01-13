Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5882BE65F
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 18:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768329953; cv=none; b=FZ2FW1f/ikioT9Xm5BRf/FlTdakzr9QOjAwyl+av1ljxO0SD73496eYpO3UBNwB+0TlMaqXotZhD5v7Cifq6VrQzygm8SItvSWjGHxID1V0XPe0CjrRiaCbjXpHKeB34pM5PuzQPN3w/MoiGKq56Imgqtb0bgCGdRJAJrA9zUtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768329953; c=relaxed/simple;
	bh=qivh3wagBk/shdLYP6zydPvglQJ+blhVUa56KzR+fL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qV7EjoPm1YzweFURzfayJzEZgbj31VdgKrRS+AV2sDR8hW47oXAbsNT6RkjXODyKiglvqkPs7LuSx9MwWDWL4X4ROUlX8l1YaS0U0/n2gLbfIUIpNG5OJASqoRGXy6GAoadZlA/enBJ5ce5JK3Iiy35e6oiL3uPnBqKBYVWQJi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bUjZxTJn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IvDrwet6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bUjZxTJn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IvDrwet6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768329951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3sW+QU0VGV+EprjAG2KGpy+b5oDyp2QtdQx40jMcQqU=;
	b=bUjZxTJnPLJUjXUnahm4HHzkV+tWasLma2UYV+e4QGwmaxfy8iZCMSKAFR2CN3vKdVAm65
	+7nSJu5QCclvbMm8MBtXlzb6TL5qG47Yjdk7nNElZGSd2eVfIvW0leiS+WMazaeO/459Wr
	QFmcl6jzow1HH5hsNm0mRe1KaCTVrYs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-PwLMsRotNq6uBFWtZlMWGg-1; Tue, 13 Jan 2026 13:45:50 -0500
X-MC-Unique: PwLMsRotNq6uBFWtZlMWGg-1
X-Mimecast-MFC-AGG-ID: PwLMsRotNq6uBFWtZlMWGg_1768329949
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47d17fff653so35052635e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 10:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768329949; x=1768934749; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3sW+QU0VGV+EprjAG2KGpy+b5oDyp2QtdQx40jMcQqU=;
        b=IvDrwet6NG03q4QFgrGqz52A+NhNGONHvpngbXbh8YdpBQtlJXTyBmFsNHY42wHkVy
         vK9DGaE6iDz/S6tv0Ebu6uhi2V2TaPbtgvEeJfDy1Spxz8L3yvUsP289mGz1F5xBsDO1
         KmMYBpOcu5J8COF0vYtEQfBG/f/rUuh+A6Chcg6bclIwSk0F6iSi8g2l1i2PQRrT4WGN
         ZdKwzy0BQjGrbrg/aJz7wzd0LLFv1P1pseABKw7pa9jSzRvLeGaMp9UNlR3BmCBb/d13
         RJpTMh9V8I+TP9ZUQQXG4F6+1aYPDJZm+OIQC2e/uDsSpJkllsYXVkWqwny67YmrEHUC
         9lvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768329949; x=1768934749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3sW+QU0VGV+EprjAG2KGpy+b5oDyp2QtdQx40jMcQqU=;
        b=CzevfJ7VOnmqUTV0obSN1ypcnpuYtvO6wipiFok0XR1pXvN5cWRfwN2h2W4dXld/dg
         Sb8wPVq5+LkJ8DbDem/7ReZ++PMmkJlQ/R/M0U8i0ScDrQ3iuB9p6LzBV0swd4yfUrPG
         bI4jc41P7r358XMv0ezIXUFX8sDw3mmXKFspV7ALlSmoFS6kg9rG8pgvpsYJf5AdIA+4
         W9NX4IobYRMUop8CxjhlSy755hyBbf+fvgYfdp+EiSO91KwGt+OlBUXYjrdlnNW5hFIg
         DHeTHsJdyubI/478nfeNG8+E5SOBYqzO1yz0JmgaSC+3CeVoQtEMxgzl10Q4cY10bJ+T
         ND8g==
X-Forwarded-Encrypted: i=1; AJvYcCUFoxpV4lK3+vtAIhxHBbkgRMUlBBHU0iavFSSQ8dvQYSVd6KeCZxUtMmTdemSHMF9FH+MCsvOiWDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDLbhqaDCkZSuIuMqB2GrlkDCzI1hxgc6/Hlin5TNdL4hwAQr3
	b2K8chQ1jGU1yblW4ueB+M+Dd6KBuxzsZgyGx/j4b/qOz7iFcMsH93TcCDWGusXwam201ljebLd
	a+7KBkumOfzF5avCzvXjb1Bduw1RJY1qLEhtrliXYKh2Qptu0zLiUIdqjhCV8
X-Gm-Gg: AY/fxX7yUxP2Sh1HM4qx6J8Y7Vm92d23Kbib+c28CR1nsFrhlcR8owGI/BB0u8dzuVQ
	b7WrNyCz13pXX68mDGnRoo8RdZCVLrA4xHFfCAO87dbVv9BsFcMHVogLb/b2vP3vxmrnmhq9N55
	gFP056AeWUfzFfvYy4pbNMKvh9xrOR0snR5V63AXM0U+zhSw53Jmu2I/Bs9QMKaLEBMXB6ZCaQa
	sHQMJZkxny/jD3Gcsu4TfL9Q+5fvQXmQyWZGR71vUff/8MrbWib7hx0diKBP+hag9waXAOinm7Y
	qhRpXNyChO/Pa7PdOBOTQfWbwmDsaNnX+W4q7roTWR+n/maVtnSMy5NpYKE3pIohM99TlgieuKA
	=
X-Received: by 2002:a05:600c:470c:b0:47e:e2b0:15ba with SMTP id 5b1f17b1804b1-47ee32e03edmr2480855e9.8.1768329948836;
        Tue, 13 Jan 2026 10:45:48 -0800 (PST)
X-Received: by 2002:a05:600c:470c:b0:47e:e2b0:15ba with SMTP id 5b1f17b1804b1-47ee32e03edmr2480595e9.8.1768329948427;
        Tue, 13 Jan 2026 10:45:48 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8384646fsm384816455e9.15.2026.01.13.10.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 10:45:48 -0800 (PST)
Date: Tue, 13 Jan 2026 19:45:47 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH v2 0/23] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <op5poqkjoachiv2qfwizunoeg7h6w5x2rxdvbs4vhryr3aywbt@cul2yevayijl>
References: <cover.1768229271.patch-series@thinky>
 <aWZ0nJNVTnyuFTmM@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWZ0nJNVTnyuFTmM@casper.infradead.org>

On 2026-01-13 16:36:44, Matthew Wilcox wrote:
> On Mon, Jan 12, 2026 at 03:49:44PM +0100, Andrey Albershteyn wrote:
> > The tree is read by iomap into page cache at offset 1 << 53. This is far
> > enough to handle any supported file size.
> 
> What happens on 32-bit systems?  (I presume you mean "offset" as
> "index", so this is 1 << 65 bytes on machines with a 4KiB page size)
> 
it's in bytes, yeah I missed 32-bit systems, I think I will try to
convert this offset to something lower on 32-bit in iomap, as
Darrick suggested.

-- 
- Andrey

