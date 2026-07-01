Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD5141167B
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 10:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902210; cv=none; b=G8ACQASFeFG4ULMy9GHzsR6OzjhthRAT0SyG7E2A3nGTQ5a/+Yrg2OgaiGOxZbE5sE2yB5XysnZfwbwzqpxXkr279eHau8iwbKtwlf2OZ5LuCJczjwZDxWawbuG06076FmTRrNpP2bcmgc2nraa/yDB9h4Hgeon2N7Dmo9rPEC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902210; c=relaxed/simple;
	bh=eow0qLO+xRWLorCF0hn66EZCYM3v0buwbmfoj19LepM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MyeBoJlqG4rieRcEAvQP1tUY6vM2tqvz11cH8dBuP3xaZtWMvSoeNTEewS79FUF+8a8PnmQdDHtw6Wk5kQjDQCjTF8NPEVlkDG8snyaQ9R2pH3w16bxmrP3ps084ai2F6yBLWKJ0cPArRx4LRPBhl4QgdiXRVchbrwM21QZwW5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ao/jZII6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rkGwlD8n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ao/jZII6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rkGwlD8n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782902207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LhJfmb7L1mpjtH4m4+FUT+rHS4lvtEnGLKvPvw3hHUM=;
	b=ao/jZII620Rx6QC0+oAoOz9XkmV6XEtrixzEyh3WTnQhgf0WIN8nOq1DhTLwIQobDU+89J
	GA2Gmw4CeGregOKCT4TXgmy4XzR/q9H92LupfRt5XzXCZTB7k5zEctxr7A50gFx+5YT9P9
	AneFd34VR8hOZTpwtioQosdPKjoQsSE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-qbwQBmRnOniNUd2bQ46bYQ-1; Wed, 01 Jul 2026 06:36:44 -0400
X-MC-Unique: qbwQBmRnOniNUd2bQ46bYQ-1
X-Mimecast-MFC-AGG-ID: qbwQBmRnOniNUd2bQ46bYQ_1782902203
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-493c20d0468so5461435e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2026 03:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1782902203; x=1783507003; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LhJfmb7L1mpjtH4m4+FUT+rHS4lvtEnGLKvPvw3hHUM=;
        b=rkGwlD8nQG1iLfBzMrfioEFigZzJHdYnDh7ivMimzP3S6/sq5Sr58V7V7e/YXqQMQa
         WzZRdUPlfkYbN2CT/HGCgBtRoR+iUPqk4xpuOLCiVEuzXE07QumvdJiCK7ZoRC+25ggE
         4GZ9r2gAhwdNM0GZ3Q0b4S/FLCsIRWK5oP4ILE9gfQm6ZCu00IN5/FT1mM70N3/yQFTI
         xiNzRGYx3K9dFicwp8nYnsryFeNFHKvjNCP2AfYoAuoE0oXGyILCqpJU4sIu05d3FdIm
         yefNLUEUBiGlPVI5Jc95/n27cAN4hFgLx5wSesMSQOeFVg22+jlYUS0pKonlAfXHseQ1
         oGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782902203; x=1783507003;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LhJfmb7L1mpjtH4m4+FUT+rHS4lvtEnGLKvPvw3hHUM=;
        b=ZbfDEpVdBvcCzfHmx5+lgkZMeQW5tZIwNXkXGX1yIpuAs8Dl/Bt9jC0bmN48oQPsGh
         5yLwVl8N03MabbYJN21zoElHCqLhdD0BVTfAuOvNUCeeFE5X8pBRUBBAm1mD4xAIehDf
         4nQlH/uuqcUaVKPtTI7wtqocUXxhUz8VnsPj5O54lb5Z9zwMPrCrOPUyh8m/Jmk9t841
         tkkMQ9eDdIiv+mjVMKRIa/cvq+xOLaIHjXo6YFApB0LLZzHhfxz21L5YvT7S+hMyekVs
         oRoizOxZmKqWVFV/y0V6O49Si+PRHRffyJfh+9xL5wjbTGakXxCfGVV6PJd2mYbvTP1I
         8ZAA==
X-Forwarded-Encrypted: i=1; AFNElJ/JuUmZflaI2JY9wSW2jOosEW16nefERv+BKEWNcLIoaUiXaM3WT11601AQYzYf2RgJPzXw8QQgD74=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLxMV9SCSd8CjUKFXDhHSqZ3Ydv7yJe9FsFO3dCuqRUygABO01
	Viw7f8o+vcYdQSBYqUFVeaFfNbXssIqV1I83dcZfY2A0mmAPBfyOjA9dkqqGSetlyFyjT97kcQe
	CY8bXWTKRCSvcotTw1s1A7wkZ9ChxCAOV3vmGMHxcuhwAQlqSdDHgyPGapLx3
X-Gm-Gg: AfdE7cmGR4OuflOTUesjHBoaoYe+ZKjHnznpkba2KmIBtv1ebGkIOAX3AuUc9gyMpOC
	kKII8Nkx7JKNdcGOGxlGmFG4zQ2nPouuLnffD/jWdCcvGgGQEZEwfb5Ow2um7TqrIHk6f51dfJm
	YzUOSJpOwFWMGbnp6+OklFA8qgo7XWkvbY/eMupRkGvGMI76u/GQa3KOjTUpbsQ+D2zodmjcnk4
	ZZCpln2CmNWKxbz/ajsGmMW6toy1MZgnmi4k83xAkHYGNW+yLLWMJWGyPvRFwdtsww26feWRLhy
	wWeTKgqHl5h16zyNBySMw4OhXlGZ7AvFKZfHv6vX5zikvJAyvmXarp7zZTxqhOTqN5Ulmq+MGXE
	0KbKmvTe0b21Y/RRFeBNsPBX0AW9YAPWQzuj5vjGsl9v6Vg==
X-Received: by 2002:a7b:ce84:0:b0:493:ba40:ef39 with SMTP id 5b1f17b1804b1-493c2b505d3mr11719535e9.15.1782902203407;
        Wed, 01 Jul 2026 03:36:43 -0700 (PDT)
X-Received: by 2002:a7b:ce84:0:b0:493:ba40:ef39 with SMTP id 5b1f17b1804b1-493c2b505d3mr11719165e9.15.1782902202965;
        Wed, 01 Jul 2026 03:36:42 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47563d19ba6sm14606062f8f.6.2026.07.01.03.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 03:36:42 -0700 (PDT)
Date: Wed, 1 Jul 2026 12:36:41 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, djwong@kernel.org, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the v2log group
Message-ID: <akTto7Y-r2pJY_ID@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260618134528.237508-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618134528.237508-1-hch@lst.de>

On 2026-06-18 15:45:28, Christoph Hellwig wrote:
> v2log have been the default for more than a decade.  Merge all xfs log
> tests into the log group instead of splitting them up (with a lot of
> overlap).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

