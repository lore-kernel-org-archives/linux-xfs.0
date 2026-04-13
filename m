Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E258345CAA
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 09:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776074205; cv=none; b=NxbEQiemYWPAGhRG/Ic/3Jz1ckhAmzAHRhZFr+NTxjP/BlTa/9a3yoHe0lMVQQwAtCAmw4XZK0B5/uZVud2i4eFPc7u9bym0ZezK4oCDZReHNAtLBUN5pJ5VvP4QG/twvZlX2FECiHkYRyTViTldU/wPMk4hRrOS5GfiePhdE2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776074205; c=relaxed/simple;
	bh=WetT7pJ8mfDZey3pSNLp25h6MEAWzJiY6EtdYyZWZvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pm+swbq+c1qC/tr388FZoJeO1vE6QKPH82pvXH0CQmy0iJ8DTRTlXgb8cz3c9YtUZ5umb1GDMs3fPTAXQYWgr8V99MoQe2/BQ/28nePlXS3uwiHY20eDTowBYmCMpiPnyAgjJpMcXFmeqwcwoRUtSXmE1gAKG8s7a+sjePex6WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UNTiXXiq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GpQn/b+5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UNTiXXiq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GpQn/b+5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776074203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cj2pOKQVciLds6wJAX6eHVlf/G6h6s3xY12nPhj41RQ=;
	b=UNTiXXiq5MWGlMmYFzKVrHl23SxPFcmZPncRTOYtuseIMF8c/8xCmDrgZcvshxD+Teui0I
	gh8M8/Y3cW/0+UzGdjxHxQEJ8whebTvydGjEpdYn7W9nFB9eUAe+1CH4OGHBTO1QVIcfgJ
	223EZrNQvebvVVlDqCevPUYkQ4mB3Uo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-7fW71ljXPbufPpNz66LZ_A-1; Mon, 13 Apr 2026 05:56:42 -0400
X-MC-Unique: 7fW71ljXPbufPpNz66LZ_A-1
X-Mimecast-MFC-AGG-ID: 7fW71ljXPbufPpNz66LZ_A_1776074201
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4836abfc742so30064855e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 02:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776074201; x=1776679001; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cj2pOKQVciLds6wJAX6eHVlf/G6h6s3xY12nPhj41RQ=;
        b=GpQn/b+55+jXZ0lrk2qoDWxv5bAil0JEZno9UGV00GDyiwZ4ff2abCIRuCtcAI90Cj
         TAb9c9hrc09v+fKcE4UBTtZlcL+grqBQxtMDvIec+hd6gF1Ivu17mxUP+xBQ76u1vsUf
         ER4Uso5bG9dQVfMfGppI0XFqJuV8bFAuUkXhmO+WmcuAA3Jvh1vTaDqughUQC3WYD4Re
         3Lo1OgvYpyZ9JgFNAaw18pET9hdDcuzz9HLZbHKoQAffTmHIj9BLbOIXzSgbGss0gfcU
         fIFWKOgBa9QO7Kdqg+NTSCL6Sgh5KaDerz74N4aHTgK7DAtXMPgz1SAocS2+p534Qw43
         shGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776074201; x=1776679001;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cj2pOKQVciLds6wJAX6eHVlf/G6h6s3xY12nPhj41RQ=;
        b=V8IoIscwsZEeb7BsBZNQjjt6jbFqZDCKNFh7bpKHEbmfHb5yEurvUlXe/OzLJ0lCwg
         rWoI0m4drLKuhRbM+DPFAsbhiuKGk3p288IIdQpUb5ovZ/w5+/e52Ighre60D3ylp5k0
         rJc+IuMlUVt5GckXzgvQRlf8Ly7SvFsKoHjVBf5PwOvxfs51og0vyUIQsOPwhjrhWYcL
         WWXFpbOnyFMRittIZu+F9pILIfggClNsOwfN7vsvzeg0dhsDCdJ7UFEG/Zx44oXC+14Q
         XWftGEGEWSaJNrFuU97lBTGR1ikdkQ54dKjuF5jGnwmRNxFgXk/rOyUulQaCh6h6GqHu
         oe5Q==
X-Forwarded-Encrypted: i=1; AFNElJ/6CERk+Grni5xPo0YDcOsCzX31gaPsCQMBfajmuKXoTe8SilYNivEQd7YC6uUbl0knjGLSbf70O2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YySjRiVZH00IHqqclyvzGwbX2JVZ4DVVIFgh2VbdsT6byyi0OkO
	nn5p3XsbvcFFo+5kDnEGsk7Mpd/pXydLJuSVZ9r6hlj5bk401/xGgpfpfln1BKcdUq2rN5Gu2rQ
	ypiTvJU3KznGRmB4TyEZqJMxpVaVYnKJ5EJxgKTA8uPynKHhcXoX7lgSGDIS9M5zirBNw
X-Gm-Gg: AeBDieuQuYF8EBRaPnx5Y3/ewu0ZmA1DKlrTlADqz3g5N4g9FCcYalQxsS4ObMt7AMt
	WbI6mIRBr9EzYWAXdRQMhP6sDM9UmpjNSLQCdh0fwAls1gZr0TbbRS0zgQUisDzLJnerTHoMivA
	1mGoutd8vw4+3NZd+J8YvJTtt1FRl5Q7Ju1iI0rxycCRfEhDwr+O3gTFL0QVZY7L6CXFTrBYIkf
	IPDIsdcEufkwb7PhtCY1lEI3E4x3s67kH1ecBwMHqSPRHp2i7wnnFFgPZzlT4jbs4j8J6yl220U
	Dq1SqFNP7avAYaIIhKf/Iip+OhIgMvIxNhfUjBm2Z1MeI5Yv5444aYshxFvHNFAOlFioyCJGHoh
	NkjB4zDPPc6sKkA==
X-Received: by 2002:a05:600d:2:b0:485:9a50:3370 with SMTP id 5b1f17b1804b1-488d681f36amr129526095e9.8.1776074200908;
        Mon, 13 Apr 2026 02:56:40 -0700 (PDT)
X-Received: by 2002:a05:600d:2:b0:485:9a50:3370 with SMTP id 5b1f17b1804b1-488d681f36amr129525735e9.8.1776074200404;
        Mon, 13 Apr 2026 02:56:40 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d6839981sm92441855e9.21.2026.04.13.02.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 02:56:40 -0700 (PDT)
Date: Mon, 13 Apr 2026 11:56:38 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_healer: update weakhandle mountpoint when
 reconnecting
Message-ID: <5jdzfedf4wfk2mc3z7h2yfgxicvevwzvqfkm4gjmhqktgybvfd@yrxcplk2y2vc>
References: <20260413035650.GG1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413035650.GG1048989@frogsfrogsfrogs>

On 2026-04-12 20:56:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we have to reconnect a weakhandle to a different mount point, we
> should update the internal mountpoint string to that new value so we
> don't have to keep reconnecting it.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

