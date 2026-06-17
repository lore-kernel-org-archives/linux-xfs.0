Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD313449ED2
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 10:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781692525; cv=none; b=c8ynFSyV9RJ4ZEUbDO3D0u9OBFedlMcEwTgUG1ivnlMEYfYLjQpBolT89zjIks0w2p/MXiaYadCZv2KQmupBzogg8mwLb7fB6rzYS7I7ttTvULJeUhzq1tWqiYCfBJrNWRjMmJaqk3rbBXhW+QVCuCWWNfk96FaZQ1Xy+7dbnj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781692525; c=relaxed/simple;
	bh=FmQlGJLmm//nhqB/Kt6LEMSuUT+8b6LREUrkc6r1ILU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FXcrVuxab+dmc4GxMwjIPG0gskIGNC2pYzr0ta4I2Et8yT/v8VZr6/HXqVavMkaUd6WvlQqR6EhpJAaSlpyR5t5M6ZOlxvOpwy2qx/+IjZI5AZV4lr/OGllSl94ndKpv2JY0cOhZeQtrCVA3F2y5mo1T75cTx+Wr/c2Q5rsPjwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cf4O/soh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CV9DEorq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cf4O/soh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CV9DEorq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781692523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9J0xLqk1t+8uVjbKc+dF4sWfvCu+Au8IQV6DAcVqykA=;
	b=cf4O/soh5wAUCKUXEQRgA2MUMrhoukarVk7H8d+tVXIQ2S3seApd/Qo7LvPlZW5HVYNZOF
	XTkQnzE1yU5IXwUOt8DB+IadUMMM96uzhr3BU+jBoquWxJK2o83yhSgN+U0U6z9ViKV4pb
	fNKSqN7xHhNGPh7yFSc1T9YqYmz2Zv8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-OxdCQm5zO_CFsdlrP8Su7A-1; Wed, 17 Jun 2026 06:35:22 -0400
X-MC-Unique: OxdCQm5zO_CFsdlrP8Su7A-1
X-Mimecast-MFC-AGG-ID: OxdCQm5zO_CFsdlrP8Su7A_1781692521
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49221de4ed4so28538095e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 03:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781692521; x=1782297321; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9J0xLqk1t+8uVjbKc+dF4sWfvCu+Au8IQV6DAcVqykA=;
        b=CV9DEorqwwxq0kD/uUVPIgTerrf/q1NAzsTIRU0IdBWK7EnPCWXy+pLV/14UrfuT5B
         8qL9yIxWIaudRove/JBTR5UEQGR0A3etPoBK0cM2lKCI7ToJdcjOXvdZfhkBJ9SiFOnA
         8PyOqdCXC5N//McwaN11g4JOHB46fe0eUqt/9veIhWoc7KGj9XdrSZ2weZAEMiU6wEtA
         zx5xHTtTc/YRaByR0Z8UTC0tPfX0nbniu6lIRUhgQznBrSUGdy+aD5Wf0Nxe/CoRYztZ
         +z1gBV9SoM/PBS2V2V+om24c1RTWoHuDN1jYhuUuleq9hybdv7HSH+fCcCn/QVeWddZ8
         ymwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781692521; x=1782297321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9J0xLqk1t+8uVjbKc+dF4sWfvCu+Au8IQV6DAcVqykA=;
        b=b2XEG9FVWXv9ktuZCRC4SdP4u1ZQz6Rotv4iJt/qqHkrcR3tLuRVr+FGmcU8/E+tjD
         XRMAJVDtR18+w96oKRtv8z6yYPi6CMOCKYwjzBGaD1wBWbSUxxz9/Jdj0M8iEkgn6O8+
         LvPjP+k80HEUfc5JQi3ItkDfdVVf0OBInkJmkjvImVH/Dam0cenvg+sdh9wLu+UnCM40
         wfyAsM+TL/MU50Dn0hD+mBXVY7nhLQjY40vYUsboByYPtoR7egRiUIyi7zU+LDeVh6xL
         xtg1dgGaP1x0WloUACerwSm/jCkLJElm9otEuOopfchPYQD23hMXSMKKAGCvaDvcWOgt
         aC5Q==
X-Forwarded-Encrypted: i=1; AFNElJ84nTTvvMzQ+pRnQxWB8ftxDgvW4HW8f/CXqrBLohmZFdJnepbDv4xHROWqYpL6QAJcPcdzHRopbnU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfRQ4cIFqyLin8VKm2bNExfNYdeo/X03eFK7BQiGR8XSQw2OuS
	dlapKas7d297braokEovUQS9UcjGuVRcIHIMRrmG4BA+eyZeBEQR/sIy0QZKzvZYS10iKKBkJMV
	Q8tdKiYrXnlECCmqLxrYSa5klzIi3rcrRJi4lXVOJWB/u0KHG2m17HU4+LlwG
X-Gm-Gg: Acq92OGHClHG0jFTmOoKuV6VaUq6FL0LfM4Uzf3fveIzlEeXMX/ZDYJEIF6Bccvw2JX
	pvWpHGTs9eofzFxhOmI6saeRDhD+EM5ikqABsCr9bEdo0zg2pnqLNptgxJe+RLKAIR4EqByrwOe
	MA1jCgxvgauKQZGTwuZQacV8qWCvnWQU4N+Fq5Il7cqUslGS/sxJm1nWnU6PHO9xJVexJ62Bwm7
	Up1ZOfSpWfWtCamoEqu6NVeBw3J/41GrpRndDKR3VmLyd/h0IJHgJC2qiPr91ADgXErh5CGgn9y
	CvY7kTOur6c3SErr1zzvQnGUHOpde315yr9usV5X9gOEQ8neVHJncr0lrGSndf8L5FEQoVVK1yW
	8x/BNfzFuLR8W0knWMw2IN3JTvC18Hd7K9LgAI7pfLYbF+g==
X-Received: by 2002:a05:600c:1d06:b0:492:2f5b:7ed4 with SMTP id 5b1f17b1804b1-4923342fef8mr51426055e9.36.1781692521209;
        Wed, 17 Jun 2026 03:35:21 -0700 (PDT)
X-Received: by 2002:a05:600c:1d06:b0:492:2f5b:7ed4 with SMTP id 5b1f17b1804b1-4923342fef8mr51425705e9.36.1781692520790;
        Wed, 17 Jun 2026 03:35:20 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923687d654sm3886885e9.1.2026.06.17.03.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 03:35:20 -0700 (PDT)
Date: Wed, 17 Jun 2026 12:35:20 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/6] libfrog: fix buffer overflow in getparents
 path_to_string
Message-ID: <ajJ4UgeWpj5R1Tkv@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
 <178118661261.728615.14375517216210339386.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178118661261.728615.14375517216210339386.stgit@frogsfrogsfrogs>

On 2026-06-11 07:05:06, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex points out rather indirectly that snprintf returns the number of
> bytes that would be formatted into the buffer excluding the null
> terminator.  However, it won't format more bytes than the size
> parameter, so the proper way to detect overflows is to compare the
> return value against the size parameter.  Fix that.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: 56f6ba21e97756 ("libfrog: add parent pointer support code")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

