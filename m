Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF094F55BA
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 20:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790369634; cv=none; b=Vv3tokdkOhl0kYYaoLk0w3LMO7sVD3ty1VZbuH26yWCnChWfXD2k27DVuZkQcX7ycXGElH3ixwm/E243YC4T5m8BbKdHAKdE7zhnRJN0rr6ulko2wqUU5mx81iZG74XzP3dp/s3zUd1ct4fXS1XSEUwWk+UbG/ZQNqz3b2L8KzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790369634; c=relaxed/simple;
	bh=ibpzpetqVLvd4uUW6fe3pnDrwVfb6gnY3Ra4TAMnmcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V7kRQwRvy7YkhctWsGMqGTcIsQxcdKtMOhZJXv/vj8iAcL6LluW5IkWSc+OIqye5ubjV1StMRS2nAsMUxuCtWLDO6Ql+L/w2TdTLihNEEsP4XGv7n4PLUGvnslOqlPWXFbi7sVOvqT7cOJ9/4DIr7I0GUODZfKi82JNrJSOTHeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=I16mkd9G; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RCe2ysxD; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="I16mkd9G";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RCe2ysxD"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 7E9471D00066;
	Fri, 25 Sep 2026 16:53:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 25 Sep 2026 16:53:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790369631;
	 x=1790456031; bh=ibpzpetqVLvd4uUW6fe3pnDrwVfb6gnY3Ra4TAMnmcc=; b=
	I16mkd9GPulCxopt2MhL3H4ngmM8gXMuQdMjvKHMJ3566j3oOUBcySY/YBDU02Br
	aqloFDlIWksXimuxAZRks+Mc1LBudf64GnxLtJ6/lgOXfxdmueO4OHOn6F0tE9Sy
	U+ons6H3T2UFuwNplymxuU+tknfWlzTRhaK6g5+fJkpi1I14O4L09dYc84fl2Nn3
	MCOrYVSFfu5tO+MFQ9rCm+1z4J4LIx3Fv3XvYckOCLNCtQX6S9szwVVQjblsQQuC
	o7IQDN8ZPL12MB0QkVA3uhkUyelDswRseIwCz8rHiBLucRw94bW34yQTtRnBlX0t
	aLICH+LQrz29r4/0t8Sk5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790369631; x=
	1790456031; bh=ibpzpetqVLvd4uUW6fe3pnDrwVfb6gnY3Ra4TAMnmcc=; b=R
	Ce2ysxD2iSGjlElDs5n7DTG1v3NOoB6gOq/DHOvkwS3aCqQyDnFuhWhkA6rSK7aW
	UDaP8Ptg/ADkNI+otadRh+vhA0fwMYEaqcR5AQkZzv2iprFW3UGhlN4IO+xIy1qz
	cl3xI3D8emtAMS1JgyxbQHT+cvht+sVFPB/CLYW1dSeWG830bcqawsV2EneP0rZE
	l7HyBwiRTnVlE6CflYf5qfVn8QTHR11MPu6f+UiDtl+A7YL4LMrRMZ94firqe/dq
	LgMx92n4C5yx6W56SKjSpvuLWVqbl1WJ/qg70R1PW4sfYnRTCwVT7/zPKOzTmPwx
	P7Y6MFBWZoN6cVlwnlNDw==
X-ME-Sender: <xms:Xt-2anEqf3rUSWz-Rh62nMFa4_mS7GMyfVgno9GVZHNuWwpOibD80Q>
    <xme:Xt-2aryPRDgqK3IIL99Q9g4cn09izSDEJbrz476jyp8PeD07YErZWi2xDYJk6dQ9q
    MO1Xc1uzd27W2LbZDXwTS6Kgudf5H1fpwFXdWC0GokBvesTvVpujweT>
X-ME-Received: <xmr:Xt-2amgjIkzjZsaAGYIQKuPx0Z3DNXEFxPoGvV1zYCpbEMlmsLKrRMvSFWSp7oAtaH7go_blD427Uc8t8P_TJINhFuwJ2w>
X-ME-Proxy-Cause: dmFkZTGyYeHxwa15ZDiVYeV1E+MVBBSsQuP5dZg6tdxkXuPMU73Xs4u6bLNGs7Osa0ihYi
    XEG62tTa5MI2v49Fd0E7zwXzBKFp1lZe0Mfb9vl8lNAJqwcWq2bRg38Id1HP/x0KY6tUWb
    YXKaCAInj+oXXCN+8yDjuobxXgLeStp7NtH3Usvbq0oj0wO8tkaG+SZYS0Y2z8Xvc572fC
    OFVoaEHTK/MP5POpgCTQf06GTEwSUHQw0+Drxv4g6Op+lhQII0aAXQJg4dBMAtbOLvaAaM
    lHRsnSDTuchkusoM1GoaIZbm6gArQNcJ7fmt3GG7eT+gkIixVfFhcc8kuJoh2x0+wpaRgv
    EaeQVV8d2lRrEyM+mOYkijVtdNXbcLkSAgnReZk2rt0J7dvt03FRQ3cmo3cmdja6hGl9+N
    Tgfn+Hs//WswpRGXxFnDzhdf/3FaZDYgNLEXAt1ZVFTWNYjINU4bmAD/pkX5qD+7w42pAk
    0Ml7TZJOTaL91Rv+errHZEhzpFK3Ntiz45bKZ5g1+BFEk7MWGys5s7QvzO1V5xb4vSoVkG
    MchKg7fgdbgdxrpi4Uv3XvquYzBis+BCQnSMlOibjg9UnbPa0ynZg4rTYyYdoVOf5YMEJh
    xPWCih7Tn1FJCFM9CQlymVqAyB/+PjmG/Oh7X4j8uZftNQ6+4QPnEu8EZOjw
X-ME-Proxy: <xmx:Xt-2auwGA9NXZnJhdqKnbL38UGg78M3yXd-2FY5uZq_yr00jSvNhVg>
    <xmx:Xt-2ahJ2cwRDNOaq3-3KPaZHFGGeVkZyr7PgOmKQV-FAuAn9odSWJQ>
    <xmx:Xt-2atTyZiAPg6JakG_ZutXrV8THDfc9nF5Ckr8D8KACE20Ui_BIqg>
    <xmx:Xt-2ahrmQmtqoId-Wthnhb0AYhXKoMlDq9ZwyXKXRID0SfA1mvlfVg>
    <xmx:X9-2amDILSwTq60T3gbil70KR8C6qNVGr5w50178PF92zE3zFKix-VEw>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Sep 2026 16:53:50 -0400 (EDT)
Message-ID: <3dc56354-728b-451f-9d70-8c135e0b1962@sandeen.net>
Date: Fri, 25 Sep 2026 15:53:50 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/13] libxfs: use xfs_trans.h from the kernel source
To: Christoph Hellwig <hch@lst.de>, Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <20260925152107.3386097-1-hch@lst.de>
 <20260925152107.3386097-13-hch@lst.de>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260925152107.3386097-13-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/25/26 10:20 AM, Christoph Hellwig wrote:
> Replace the the existing xfs_trans.h with a copy of the kernel versions.

after this, inode.c, init.c, and logitem.c all #include "xfs_trans.h" twice?

and trans.c includes xfs_buf_item.h twice.

(perhaps the existing #includes just needed to be moved up?)


Also after this I think we have both libxfs/xfs_trans.h and libxfs/stubs/xfs_trans.h
with the same guard, did you mean to remove the one in stubs/ ?

(ugh, why do I sound like Sashiko LOL)

-Eric
