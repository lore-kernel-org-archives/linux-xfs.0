Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE6C39855
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 18:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718909941; cv=none; b=kw6f8tCpCqkxgO/NoFCgkjF68RmJ6iPkNHLZ/6iIVH5re207JYoavHSZETRKuifg+A0fyxAQBUIweUbaGeoArTTFz1S8nQAKtcmvmzINDXup6O0rMf66RPSLdmcZ7Vlgo8KCZGNTptJ5U7em7FBpLrt4BhRxilF9HbGKwXEiVeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718909941; c=relaxed/simple;
	bh=qbk7oYZyc1nJBU2j1vFktpd4NnvyyvOmTJcKBouuD5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PsjiTixDCtD9xhmkhVfyPqDvmyRn94C+sdWB7papofGCElxQRuxJhx6VT6PjK+MeBDnyhfO/No8OZbbM6uA5LzJl7GR0QQhuRDtQNe9wDd8NvtZdx+pURi2JGpgvoJPTBPvf7oTWHB1fG9WJqhHw1YzZgi9hkkOaPiKMZstbo+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QNFedg79; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QNFedg79"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718909938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jH/1STGevSI3JAsnqyhpNLSvcx5qg0QdYjDNlIqmlUw=;
	b=QNFedg79lacgtjRAvPmY6plbl4R7v7U/a6+Bc4v52hxgsHXt824u2chMGvDey4PJcftyte
	4vuP7F/d1alBT99Bn4oiTE/kcn0MEown1eeoRlRwHJTc3diZWZN6VmhnocAqE5McUHqqm6
	G7ULFeClJRYzLtJWsVzGmOQYsbHX/VE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-hGOzF-zZNMmrPLfR6rQNlQ-1; Thu, 20 Jun 2024 14:58:57 -0400
X-MC-Unique: hGOzF-zZNMmrPLfR6rQNlQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1f66f2e4cc7so18206555ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 11:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718909936; x=1719514736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jH/1STGevSI3JAsnqyhpNLSvcx5qg0QdYjDNlIqmlUw=;
        b=ObPle+SL8WZnCkoDnaFi1ifvdn/zK/qYUs/KthoaKPrxdT8kJ40VbF3JLjgeG+Q/qp
         FuwXoUUA8uPkSrpPQKuSaPqq2uXGOoKBYIyo5xnz76OZSQwQhIxCS/r/9QXixBkxu85W
         IoZojTnBpIde3DwHQ1ICVigNxj0MN1bA/6FXPBXq1CpZ562IsXVq5myp568oK9DzyKxz
         up5aY1LLhobhpKaV9C8Ck/KRNoKd5PXxgQMMlU/xui6RoEsN1hFnQyxais35kYnippym
         yqlqCWyKvq9+aj/EpBbfl8PStcT7Mse/c4D3/19txtlZBhpWqhbOnCta8B/3s3JBOQkC
         brjw==
X-Forwarded-Encrypted: i=1; AJvYcCUtqakjhRsUd6p1lTUL/cg/fyXOq3gv7YaNbN6IdE27G23RCH42NVKTfFSLueChHXRBIMos1IIxtPQFfgX9nD+i/LOOVi9z6/Ok
X-Gm-Message-State: AOJu0YwVf2ueDJ5AiIB3wqE2nr2Ac+Os0OiSLBYRPPrrq6ALdp/QbJVS
	jrmH5FjwuNFCWw0DKqikt2chInyA3Enu7vLLMT36YOGEGv0FJ7ue0gz0p5QF5C+USfQaTgylw42
	5fap9t5Ifwxgv1w72G7R01WYDSyG9qNbwSfR2Q7ryjbVlEEA9FsJ8VMId7g==
X-Received: by 2002:a17:902:f546:b0:1f9:ae6d:5697 with SMTP id d9443c01a7336-1f9ae6d5ac1mr60547255ad.35.1718909935819;
        Thu, 20 Jun 2024 11:58:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUqsYkzeltcUKvcT+Qbx8lhqtSk0mACAOpJV3i8spyZLxlcSTnj4E2BeSlbL9PEJfMkQRRkw==
X-Received: by 2002:a17:902:f546:b0:1f9:ae6d:5697 with SMTP id d9443c01a7336-1f9ae6d5ac1mr60547085ad.35.1718909935351;
        Thu, 20 Jun 2024 11:58:55 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f5c039sm140841785ad.306.2024.06.20.11.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 11:58:55 -0700 (PDT)
Date: Fri, 21 Jun 2024 02:58:51 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	guan@eryu.me, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] generic/717: remove obsolete check
Message-ID: <20240620185851.nchu3nlllehnqvmk@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145359.793463.11533521582429286273.stgit@frogsfrogsfrogs>
 <ZnJ2Ehz8PIcQ5m6R@infradead.org>
 <20240619163148.GN103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619163148.GN103034@frogsfrogsfrogs>

On Wed, Jun 19, 2024 at 09:31:48AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 18, 2024 at 11:09:22PM -0700, Christoph Hellwig wrote:
> > On Mon, Jun 17, 2024 at 05:47:48PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > The latest draft of the EXCHANGERANGE ioctl has dropped the flag that
> > > enforced that the two files being operated upon were exactly the same
> > > length as was specified in the ioctl parameters.  Remove this check
> > > since it's now defunct.
> > 
> > The last draft is what got merged into 6.10-rc as far as I can tell,
> > so maybe update the commit message for that?
> 
> "The final version of the EXCHANGERANGE ioctl..."

Will change "The latest draft" to "The final version" when I merge it.

Thanks,
Zorro

> 
> > Otherwise looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks!
> 
> --D
> 

