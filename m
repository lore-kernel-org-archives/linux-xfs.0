Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9AA1A6805
	for <linux-xfs@vger.kernel.org>; Tue,  5 May 2026 17:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778001169; cv=none; b=CuGij++ZVqczWEPS5+o3Y2iJZCsYv8Z7dyllh+cXyOQtAoR8ShugyfHtc83lJoO851zWWxm6dlR+uWP93O2LClevGHmdLA146x2eOwDfhfIV4qUiKu4QokNZkR78y82MsxWC8DueysbDbKjgnd9tGjE5/ITbpq3yOOUeFwwquW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778001169; c=relaxed/simple;
	bh=a1z/NZlPGPz0LIcY87SAa6pI93bKQHmt3HQnMQShrCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OM9xO7enXoax/0aafAk6KhuEHJEKV+r1Tjk3ukZUtWkNuJY8l+6oSiAAZ8df5hYX6tojZ1UbxVE5g7692Pd/vJGX2VlUah63ijFS4CKsPz+ORIm3If+a6F7zrUJRAzNWTV0NDE3hcU9nfwldnrRbZ3FXFmFDYNE30Gnr3N2CmXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ri19fZyk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=raR9RdK5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ri19fZyk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="raR9RdK5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778001162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9pP6CmEhCIsO2nQrf4te9scrBlc5AJw7miQRdY5uxiM=;
	b=Ri19fZykMUfVkTYn7QHd2XtrJLURGMQM3Th1uPCrdf7gmaEKUoRiISlguDZpbimWOVb8Cq
	rqEODQWtPGuTu8aoaH+K9wB0DikFwWzTt+WyCBv1K0h6DVvYo9yCX1j+NLpa+WPYXp0FZ9
	hrbQE5yW8HXAcVZvF9piW/4PWSoxXTk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-v_iyS5GiN4CV5XkkYAryWA-1; Tue, 05 May 2026 13:12:41 -0400
X-MC-Unique: v_iyS5GiN4CV5XkkYAryWA-1
X-Mimecast-MFC-AGG-ID: v_iyS5GiN4CV5XkkYAryWA_1778001160
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4836abfc742so48830825e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2026 10:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778001160; x=1778605960; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9pP6CmEhCIsO2nQrf4te9scrBlc5AJw7miQRdY5uxiM=;
        b=raR9RdK5RRq/Vco2czCggKgqG0gJrna5BoGxisnuST098dGEsMQ8QVfpP6r3xkM0kA
         3VrKr8cZoFbjyF9Ln1sjMXVukEDY75Rp/wQ2g6mhMRQuK2fS9FVNLO5W4xrxgZTzcACo
         fFNP3yjZbnmMgEr3JwMsvrY5Mp2KZ55nNR/E1ZiR1vFyQ0FF4iGuJ3AvDzGKuxHGS/vd
         dfTYogxJMhCKepwaohecqhzo0E+/3mMfx2TItLW+4CHJadUD4FhM9W5XVMDL5rWAiJYQ
         KJukqoGjwVCA9AQvAgJadS9PPgPk0lJyM6whdUjBVcNiQCD3DRmcU981v09r/yR3TgPb
         PZ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778001160; x=1778605960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9pP6CmEhCIsO2nQrf4te9scrBlc5AJw7miQRdY5uxiM=;
        b=XuhXrw5gHAviWBJyh2HsiVzUYxPTaMRNlI57+uTRBvTlyaFQdek2tl/4GLGJ+1/lI9
         U/XEiQmoXm1u6EtGEF/RFpV2Q3kDVpCbp2vlBadSFjtBWslm4yGjs7LxX2t7K8X7u78f
         s/ekwaB68rsP3G+UpfzzHeQymVfNFE4vnenKLJx6Y5Ttumw5oWxbqxluuOej83N6eJm2
         K+pGnLHHqVeN/23u9mqIEPg5xaLQyMUjBCmCsJr+qmV2EHTHb5jj0KbbkmrnT93zDbLV
         p2tY1RtTJJaTHTXl6ksf/XLJSzDhxavKQ9xnYXG2pebADrB2RyxaZv4LyCikALePlWU8
         +rew==
X-Forwarded-Encrypted: i=1; AFNElJ/DNtvHYUat/U/3LTKPtJKF3LkDzTcLQ1ugN/gZpFmJPgZ8nHgSOChXyr64BO8Z8tyJL6Z0ROrblYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsG+KThKXj3Gw5hsUGpXTwHEbN5PVUbauC+6dXgbq52SDcHs89
	84B850fAH9D2PJbI91VWYFZFh2VRzmtwJj86QUMfHJRaGV0mj+OpP+sCtC1ghYQs/8RMdrYi6eC
	xHhAhRr2fKBT98MEC6gUMkIhmoyL85P+lkLOaDN5bElaAGGJRQONxFnY3qRfX
X-Gm-Gg: AeBDiet+k4Mqg4KNSG5Wm/QVmbhkFFRCYkN69UfYENAzjBW8gi3+sCllSsxRpfEh7AE
	9OMmniHpUxqjH57kmtBWMas9+3Dde/7WbAT35ukrLVFY58JQOWJfpmWDgs4VhJH4IhpeO0c3xee
	a7WTf78B+bXQQTf4W5JkEdeLFvYlKArPCzGO/cBnieR7OgILAVtoREw2+2CvZ5Pn75QMxFpd7Bt
	vy5WHiB+rh/528DC13XCsUEUIPruRhLFppYMFcRZXA6ACSE8sK3kw7jFZ0t1P3RV/7PETaVOCWh
	ir77gra6iusK02sEwdxp/xjLR1n3B8eGd6iaW2I2WKiWlUptK5vqAoKqmniljJGiGm2T0yNsR0w
	QCBHqMCwPrtTKIDYY7ofBOg==
X-Received: by 2002:a05:600c:3548:b0:488:c40b:c8a4 with SMTP id 5b1f17b1804b1-48e51e097a2mr2197565e9.1.1778001159920;
        Tue, 05 May 2026 10:12:39 -0700 (PDT)
X-Received: by 2002:a05:600c:3548:b0:488:c40b:c8a4 with SMTP id 5b1f17b1804b1-48e51e097a2mr2197135e9.1.1778001159336;
        Tue, 05 May 2026 10:12:39 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-450524831cdsm6543722f8f.5.2026.05.05.10.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 10:12:39 -0700 (PDT)
Date: Tue, 5 May 2026 19:12:38 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test xfsdump subtree restores
Message-ID: <q35bobvlsz66pdqqg5ie6q3xqqflw7kckwvk3hl42hqc5rtcn3@h7kaiwi5vl6l>
References: <20260326025443.1569874-1-ddouwsma@redhat.com>
 <20260326030012.1571545-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326030012.1571545-1-ddouwsma@redhat.com>

On 2026-03-26 14:00:12, Donald Douwsma wrote:
> Regression test for cumulative restores where a directory has been
> renamed outside of the subtree being restored triggering the assert:
> 
>   xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

