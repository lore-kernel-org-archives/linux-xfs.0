Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1338328260
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 08:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783412867; cv=none; b=S3BBqHNf8IPhHeMMxmOprXBQlrgLfgLHWwXOE1sGUYBSZlsM9UmyEd4AYw6pWsps8Twr2s8UsPxHMQJcR97dr+XYBAymItypW5iunqoDeQ6AfBj3KnwphnACiN75DOZe2ESJ2AcFP9EHpjjENw1Ha+PlmnzkJzzzXYtTkxdvjpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783412867; c=relaxed/simple;
	bh=v0U6DXXas43EyY/8H7DN7zPIlSOjLGo702lwupEc0KI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DwIHoUM1cBM0ESQIg6j0VBWjJirLFGhfqGSFo/KQ0C6uCA4XfB2bMdsqDx/mJNcOeP1Sm3H/RJ04ppM0amQ5ZOH6DxJctyg6SeEbFfWgYyuCiY7Tvad14hcOCsubIVc1ikADAmXanACuMfr2jZDbNzwD5yF0wnqMCcS3jihmSac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DnX+bIPD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=r156/ul2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DnX+bIPD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="r156/ul2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783412864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fOoff4828cS2wMclFc2Xe6/VcHPWYKN0eDc8EyFJTnI=;
	b=DnX+bIPDcWXRxTAUEljgx8aP5vNBZR2202pZsqlyODDzfgipUC/46umhi7J/4VPCzpl/Wq
	dhq7+LwGAnOpOzIKj22W2QRBY39ZjM1XQ3Zhv0Eb0fRHtawA3J/1XZfll2JumhmvZMtcuQ
	NtMLffJysWQMIpU68ov8IgCLgab/JVM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-1thc5cDJNC-Tc2FgfY3S8A-1; Tue, 07 Jul 2026 04:27:41 -0400
X-MC-Unique: 1thc5cDJNC-Tc2FgfY3S8A-1
X-Mimecast-MFC-AGG-ID: 1thc5cDJNC-Tc2FgfY3S8A_1783412860
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-473f4a48e9aso2312430f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 01:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783412860; x=1784017660; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fOoff4828cS2wMclFc2Xe6/VcHPWYKN0eDc8EyFJTnI=;
        b=r156/ul2oMlnZEpQi4ec2WUqoQPcW/EjmGv4d0pEowlwtISeOUu2rpM8ly+pxw4q8j
         4N8c5oIwhvoRV0KZjtASU5mlxYgsedWiwdv3WDyeNV3SE6WkAOAAaSI+OF0qPh7SQY08
         RXDYfUCQNvd3jMSMG4lC/Fgdb+CXgAWmoPWblhASAu82mSLM3y4GCnZzhdw76+45IN8o
         OTvdVt2nD9USLs7kY5ZetSYAeWgVw6e1VSIn/tXXJ4U49rvLbBbjl02wlMr/vUmUGdx9
         g0eNjjk5wCdyqSJP3fOo77M25PMQOvJtBMjD+puZDerdpMNgQrYrrhruKxhJVL3BTtDq
         xd7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783412860; x=1784017660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOoff4828cS2wMclFc2Xe6/VcHPWYKN0eDc8EyFJTnI=;
        b=ILIGqnYJCY1j7rndYpUvBtiFbvd03IUx7ertq8N00bNJr0b0mVtAAHdXXqQb8YqaYx
         iybb4DSA9F15b0Qsmgk1lIFTKE5RfgwZKsv+HqrV5o71m7Brrty0dgevShKl2oug+3ty
         OLOWMnn+HkTxEc6tT4EvUssHKtyL2OdBa5WRHvBtbsqWFBTSJQtcAmsXQyjKFledbOCu
         rYdSSZ9J+HnelXBnQV0pF8sRX21S9PmwvdgAp+hFCSKWjyogC/Iru1syvarugkprYQya
         o5vshYwNcmf6pnqlOcbtJWKnlJ9ZlFckDLHVK8+zVPIeyZTdxtvPyFO0hGNOSwmnlRBO
         Gujg==
X-Forwarded-Encrypted: i=1; AHgh+RoulYs3fze32tQRcVfe73uhtJdrjqw7QPd5QRJGLExPzI2Oc3xcntSiwcHcKm0sKrUn13kk8hx8r50=@vger.kernel.org
X-Gm-Message-State: AOJu0YxORweWEuoaRPhTf8RHt+t7E0FJzdxO1T9FlNQrnUasiirrNDY+
	4GV0Kuw9nD+1qV/EcK06jMFNUcXUe11J7x90fR7By4weGfEZ9nnlB7vKj1za4kUzOZPdeYOXv1k
	bDgVQiDMTtNEJ1A2X8Rvucr6bflP5hxfZ4ecM+G9Io1pjhhwnCmhTNUoowiHA32FLfee8
X-Gm-Gg: AfdE7ckG5woLEkUKpeYp8F+zAT67IJ+5XMgt3fW1Uxks92lE3NEGPH4pNScgaC2bq8J
	jR1Gl+ejUJc43De9ZcXbde/HtdvP3wX8FKpHhqJ28R8ffyC61XJK3JoKfhH+TuO2uNZwGHYO+hi
	jYpYuxjkqcRjoifxn3xSrSVpOaZXybAyCeOpf/uDLUXoiamQIgeA/NKyXOhxE8vfarmyzhJ8X+4
	DUcXTPQ2FoGL/Wi1tcO3QF7sIR37R3DPgWgd9YdePfxGKQQqoCTeTki4DvpdKw4eXBoYodYcLEq
	Li9Klp6GeQtw+uu9OviqHVIbtyPkzL57KITL2JG61WP1NlbaGzqMX8EWSkmk0o/1frOq+bjdJjP
	vlFMNSRVHYKC1TFG8Bo8bjnYLq1oMg+g2rdabHrzhFvCqUw==
X-Received: by 2002:a05:600c:c168:b0:493:a960:a0bf with SMTP id 5b1f17b1804b1-493df064184mr45023195e9.21.1783412858245;
        Tue, 07 Jul 2026 01:27:38 -0700 (PDT)
X-Received: by 2002:a05:600c:c168:b0:493:a960:a0bf with SMTP id 5b1f17b1804b1-493df064184mr45022665e9.21.1783412857625;
        Tue, 07 Jul 2026 01:27:37 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0fc1348sm38192395e9.14.2026.07.07.01.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 01:27:37 -0700 (PDT)
Date: Tue, 7 Jul 2026 10:27:35 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: liuh <liuhuan01@kylinos.cn>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	djwong@kernel.org, hch@lst.de
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 708b369bdf8f
Message-ID: <aky4SXW-YJ_MRdC0@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <akI1Den0ablejlqZ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <fd36dd71-6a06-4d81-9bde-b230e9ef1029@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd36dd71-6a06-4d81-9bde-b230e9ef1029@kylinos.cn>

On 2026-07-03 16:03:48, liuh wrote:
> Hi Andrey,
> 
> Thanks for the update.
> 
> I noticed that my reviewed patch below does not seem to be included in this
> for-next update:
> 
> [PATCH] fsr: preserve xfrog_bulkstat error codes
> 
> Could you please check if it was missed?

Sorry, I missed it, thanks for ping

-- 
- Andrey

