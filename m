Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6191217AE11
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 16:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841725; cv=none; b=ITzXUH6CTeszEzFWCl4f5fBw1lKcjZaExA/oJSLnnxRU9a+QvTV3FDVuWccgF9lap1GM64a4cYRcAVuMkVZP9KGkhym/HU7ML0S2dGld0ib7ZWltJ/gh02yvK9K8v09QFNk0lDwV83Y4ZGFCHnIMMYUcIfOQozyQ9MKZ5HrMP8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841725; c=relaxed/simple;
	bh=hSThXL9/o8orNTOUmeOEbhzvn1R/valrG/O+3Z4zdZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=exde90w5CtB24/E3bi7/k7Cy6aBYdp0jWOs3XiK22TYayY4cQ6FLWExD0cEnUkxVlJMAuW4zbIKAmcJ1eHPl6kLXZ2Ap666ZqVnin3Uv1q/YE3NZFGjnLWHkqLEjpCq1FCBcMznKhA0Ffj07E5victxe5HETnfFbAxS2LECYoFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OROFJs2j; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OLSCg7O6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OROFJs2j";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OLSCg7O6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768841723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZW0/pgsrK4DPsXD49ZCnqBR/wZtXnNQHuMugKiZbtIc=;
	b=OROFJs2jxcXlI9s/mmJlN9v9/YUTxoGI9doKotlu1hxRd1vJgoi4KLxHgBmg5lg4naZ1Rw
	5ze/DWdAgzLRIH8eeTb/hRQ7oD+NTigb85tFtYY7mrUZO1qRhCo2BhYHKK0f4KcogU/A4n
	gGXL5Di9jo5U5ZGc1XvISHsY2Q9SsiY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-K7sxaDtpN5G3Twlvwo_Sdg-1; Mon, 19 Jan 2026 11:55:22 -0500
X-MC-Unique: K7sxaDtpN5G3Twlvwo_Sdg-1
X-Mimecast-MFC-AGG-ID: K7sxaDtpN5G3Twlvwo_Sdg_1768841721
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43102ac1da8so3792300f8f.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 08:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768841721; x=1769446521; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZW0/pgsrK4DPsXD49ZCnqBR/wZtXnNQHuMugKiZbtIc=;
        b=OLSCg7O6c2T5+boRjldgGvg6HNcS43pKNLOJzBCziGEgUSokwWY20rA1YMyVolxot6
         6E8e01MLWPPyTWSMpK+UAxEFWawUw1ypGZmznHm/cFRVvCHv+88AhS/BkNCmZRqmtCJN
         hdeuK/0IdJTlxAKdK02+gvufKJ80+CHhMgBBs2lHq5ta9+Cxsdwc2I5B/HLFtZPb15Pt
         2QWBkSDcp94f5uaIB/my0dJMdKdYUF2Up2ZNxdVfXhCJaEVUGqG7+q9z8l6X5h94POKr
         hRHeGk4xMHVL8VNCkAHgK4ja1fB9LWDgyUqRvx/R9FQgOnDVJH5soxjVFGuw6iuuNjXq
         Fv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768841721; x=1769446521;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZW0/pgsrK4DPsXD49ZCnqBR/wZtXnNQHuMugKiZbtIc=;
        b=UpQNOwfPrECF4Ivf7/EShiKNbIhAOWRpalZOUf/8KeJeCT6gBCpdrjiRVTk00qpBMz
         PXDsUjN+mzSviErJ0+iyhffwFbn1QuRO8wF15DV5Z08Xs+LhRNkHHL2fso49sTQ9V3kG
         uGPCfRrqD73O/hAmvK6FfmKWLUPHnkf4wt9TkgFaZeGl0UhsMHof6AzgfYCRSa2C7NGk
         b5FJNxRxuSwGAa0riOET4HOB3SqDhJHdFSm6+RbtEKuFITnzN5U7bTpMdCGLlawhVlZj
         ZaKfUxWrIwFg2ooBEpt560gYuAsRgM1pSlKpN+1uucSHuOZVL1/MfZKNFkI9h/jduHp/
         vDJg==
X-Gm-Message-State: AOJu0YxOhUW1359u1QZDL2HC88INIMU9r889jeim3lWjVjXxunim+kQh
	OtMfIUQhKWkToRsWd85D5QqTtBA7xf8vTQow4q/k2C1b6uMTR0j79oqQpasITFJzriZ5NYPwuoO
	EWrFVOUouXySpjYXK7MTC+ECH8UssRRdTaJ0VX2lLY8ytaxuYbweaxxZNSomZV15jZAcypwcIzh
	x2kMOqeCky3cfz0S7m8CGyy6kng7bwq+JW0pIeX92QddB6
X-Gm-Gg: AZuq6aJEvCtYMmPz5FzDVVaOYpY60SqTubLHn4CFYJnTyXkkU9+JiVfsIRED3qeo0xB
	gkNWh3BKHFqDQF7rHhpnHKH0ic2PeFKsIz+WF7/KNBzytveb6qyYZi+jdLJt/ToLoWnAmmocaD9
	ktr70o98JPuD89M5gNbX2Ss3RFHEeuR00PQ9GqTgefage3JPVxhKhrxzEG3iuz2NOPvWVgMa3HL
	nvIWj6NYC1iaU4ndEMP30aC1LkX+oS+Puh4gIXRFB9q4HfGIIl36yUX2yfv64bI9VtcJ1DZ64Hx
	wPLI6RBR2/EAj+OlEDv/pErcyxzXc3rMhAdh2HoqdPoG5YP2WxLGWdfuHrr00pa1ai7bHVZZCtg
	=
X-Received: by 2002:a05:6000:26d2:b0:42b:4185:e58a with SMTP id ffacd0b85a97d-43569980c3bmr13583796f8f.14.1768841720857;
        Mon, 19 Jan 2026 08:55:20 -0800 (PST)
X-Received: by 2002:a05:6000:26d2:b0:42b:4185:e58a with SMTP id ffacd0b85a97d-43569980c3bmr13583762f8f.14.1768841720387;
        Mon, 19 Jan 2026 08:55:20 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356992c6f2sm23750935f8f.19.2026.01.19.08.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 08:55:20 -0800 (PST)
Date: Mon, 19 Jan 2026 17:55:19 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, 
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>, djwong@kernel.org
Subject: Re: [PATCH v2 0/2] Add traces and file attributes for fs-verity
Message-ID: <wiuypaq453nlrsbmg7fqwi6x4hjdg4dmbz5i4mwuwhgwgzdj37@a2mbukyfpybj>
References: <20260119163222.2937003-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119163222.2937003-2-aalbersh@kernel.org>

ops, wrong email again, will resend

-- 
- Andrey

