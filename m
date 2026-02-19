Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F7F30C368
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 14:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771512994; cv=none; b=nSp25VMFz2jT9PPDDEG0ysKS+1D19XmtSV34sSnWgPQbt5D41VsV6a5LTs3KTwOexnMoNqqRDnCdSR9RiAH3WGK4k2F+kjD/1Cs01eTMcmLGwXBsYdAvc0WxSwT5uBYmtUHRzZ4by1Vhi2F20qN8LKx0Sq5K8nLsUeehAN+8cGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771512994; c=relaxed/simple;
	bh=rjZffwu6hdynv2JN23UfzxtD0VnYAIJPc9irgjPZp38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+uU+88OMF9rY1q1lx6bqx7WpckiBz1Ijj+iDm0GZUs56JXRdteXv8l1G8q3CewCkygmWhDH1G4igdefTIpR5qE9zis21p89CdsoJgPwVIZ99jnbeSBATelYQwRGhd1GXzrBIltN351/M6H2XKHBJaW0694vsVKVB+KVZzM9whw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fEJwlyUp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GNo0xuE2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fEJwlyUp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GNo0xuE2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771512992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0KURr9oUxoL2KSC7hNk04GTMfJKM8TJ20DK+6mMaf68=;
	b=fEJwlyUpnXGtgsXA3iMEuT3TT61lVJDP9OrVEX73O1wHJ9XqyWfMZ+prVp7zguMxV+HESH
	y8w+/jZrs8x0kh6ulTF8ej10FMgzCvSPX3aA9nDdHX/eygoFQK/+wB4CLjvi4Zxvwi8rVC
	Oenf2oIrtKgnTVCpE2Syh+akvD2XmrU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-x9bwjNiePD-UDSYw3Sep9g-1; Thu, 19 Feb 2026 09:56:28 -0500
X-MC-Unique: x9bwjNiePD-UDSYw3Sep9g-1
X-Mimecast-MFC-AGG-ID: x9bwjNiePD-UDSYw3Sep9g_1771512987
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4837a718f41so6041225e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771512987; x=1772117787; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0KURr9oUxoL2KSC7hNk04GTMfJKM8TJ20DK+6mMaf68=;
        b=GNo0xuE23lMBFHNDlxsQ++ET/1BKa+n8Dx2BPpvgOfxiUjBb3afpgRYUlFpWBW1hU0
         WaO6+4TahQHUKsba/XmJnXnJfYZ/i8trYKubCZEd4tGUuL4JgqOeRRio4vOwlD0eszt+
         4MtO/ebenZYp/amCiSnmjdvM10t9qnfLlYMb3DPp2wSXMZ3m2gDBsV3oKxH/Ri2bXAh/
         ewulCAjn2xx+DnExqoJmga2D4kdlxIkcQHwCEntacM+HQDIF8J0lBO+dpczekGlFho3p
         xPwZAkWmz9ll5HcQqRNAMrwKxNRPXY9tVYV0+ixnnBaDnWT5hgeS4zc59P+kdHVVE5RG
         yDDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771512987; x=1772117787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0KURr9oUxoL2KSC7hNk04GTMfJKM8TJ20DK+6mMaf68=;
        b=Rvt1YRTweilGIXQpzoLhQOgKyQlXB9deLgiLm0DaYf+1ijvLEIFmxZbpGrnapaxqdn
         1md5NwyV45j9FgqXK+GBbzYK4f6d8ZJMddybW1bLaAhM2t8egbCz5tm9QyZCKbbCoM04
         9Ttkvl3SZn3vAotgjZOokeXTROHQEw3D9Xzx/wDcVSTILgBGnSiyIhSLzo59pcLl650G
         jhneZ6Le96MxYS+/78HNCauF6rGGMsYZN8XkrB/13ar6pLpkiSjDION9Kr4qLTrJuydL
         T/kenArBo7rspgvq3zEmy9oldHmrb5P/EiO/hGFQSVBzANVUpTJ3I3czlG+HWkE+uyo8
         byhg==
X-Forwarded-Encrypted: i=1; AJvYcCXMtUFW1BNKKM/qDJRT8aLKAvZPHe15x3z8ShjYlpjDWY0czVhnT6Jg9NFTXVdx09RPWTPwYwIYXx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDDhpK5tQm6oogoAZfu+dhB5ulMDzexZ+49rQTlmPN8lAtpMlO
	U5w2dUW1+k8TQ9nZtmqISW7cBNcHXkPWSlC551E5DmQltlwg8iXWiEMkwteUp4Nrh/aH3letEVA
	lz1NOc/XRgWVu+8WDFxwzXZaQL7thsTmxK4g2MtuLAboOZZxARA6p0aW+IgsK
X-Gm-Gg: AZuq6aLEqQkkxQonptTXLLJxA9snLnhXR+jcuoDFRyIrSue3EDxXSzrKMAPxkv4LN5l
	pCE4XaFuUDZ987dd6xQ2XUxGSMnRlwOylBTi2lEnytCnIL+gBio3cMpPkQHoMzSTNFso4NoN8Oz
	LcxgWgCokly/G2SuS6ApPhABqKx97gNRdbBtQ1WIK/CZiB9y6MD7uGdgjbS+xAGIyJMU4GaGQNF
	vFfyLOqNhlDxFLs61kq7S/qR1swEMqIVZaplLYj1vYF+nwL3HeT0ck7/n4ajz7XUwQHRib2NRWF
	8WnYBT8vvj9Z378eUFvem1drPVcX4xLhmGot1lbcjxqs064SL1jLd6cO8QLtOYIutkyzBWkU3hJ
	6OPzlnjX2duE=
X-Received: by 2002:a05:600c:6814:b0:47e:e78a:c834 with SMTP id 5b1f17b1804b1-48379bf4788mr307948015e9.34.1771512987381;
        Thu, 19 Feb 2026 06:56:27 -0800 (PST)
X-Received: by 2002:a05:600c:6814:b0:47e:e78a:c834 with SMTP id 5b1f17b1804b1-48379bf4788mr307947515e9.34.1771512986883;
        Thu, 19 Feb 2026 06:56:26 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31ba9easm7852995e9.4.2026.02.19.06.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 06:56:26 -0800 (PST)
Date: Thu, 19 Feb 2026 15:56:25 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>, djwong@kernel.org, 
	hch@infradead.org, david@fromorbit.com, zlang@kernel.org, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com, 
	nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Message-ID: <7pxwnn2gkb7dx46fwzuaubpwcuxvzzy4z6lzivwytypzxfuskl@twake2shwvr2>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>

On 2026-02-19 13:55:51, Carlos Maiolino wrote:
> On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
> > From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> > 
> > This series adds several tests to validate the XFS realtime fs growth and
> > shrink functionality.
> > It begins with the introduction of some preconditions and helper
> > functions, then some tests that validate realtime group growth, followed
> > by realtime group shrink/removal tests and ends with a test that
> > validates both growth and shrink functionality together.
> > Individual patches have the details.
> 
> Please don't send new versions in reply to the old one, it just make
> hard to pull patches from the list. b4 usually doesn't handle it
> gracefully.

b4 has --no-parent argument for am/shazam to break the thread,
pretty handy in such cases :)

	--no-parent           Break thread at the msgid specified and ignore any parent messages

-- 
- Andrey

