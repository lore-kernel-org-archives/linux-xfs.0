Received: from mxout1.mail.janestreet.com (mxout1.mail.janestreet.com [38.105.200.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D233D6CA6
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 17:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=38.105.200.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780939049; cv=fail; b=HC7rMw+yqn7Fgbu3UV5eFyQOY7KDrmgef1vTrfk0702oNSPt1u+ojjwTcK1TNUVe0HW9D6zbI+KEgEdyAQu4245h/ImgQHWlH2TV8TvbtLNv8TeTbI5Spk04TNYkVfc5e84U+9vX+FH4ajYocZJyUnS7zHYP3c5TCA19yje0kVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780939049; c=relaxed/simple;
	bh=nviWi2SVvs6kP8+AcZcCp02bcOI3+H6tiI/C6wy+oDU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O/9vA/zXTGihIJdfOvo7JiJFYWeU/w5SA2mfesijg+1ebBvOYjl9n14Zmb5ZCTSqak81qHPtZEb2xV+82vjgJpwwVVSl+Zubw0ny+I+tzBqOiEKb06L7m9ZmLNXVwslK0rGus8rA8TeVbbyzN+sq2AvvFVKkbrhWl/SpRXSRJwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com; spf=pass smtp.mailfrom=janestreet.com; dkim=pass (1024-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=XXcB22Lt; dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=iEF9RcsS; arc=fail smtp.client-ip=38.105.200.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=janestreet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=janestreet.com header.i=@janestreet.com header.b="XXcB22Lt";
	dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b="iEF9RcsS"
Received: from mail-ej1-f70.google.com ([209.85.218.70])
 	by mxgoog2.mail.janestreet.com with esmtps (TLS1.3:TLS_AES_128_GCM_SHA256:128)
 	(Exim 4.99.4)
 	id 1wWdbG-00000006QtQ-2fws
 	for linux-xfs@vger.kernel.org;
 	Mon, 08 Jun 2026 13:17:22 -0400
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-bebbba3c343so199066666b.0
         for <linux-xfs@vger.kernel.org>; Mon, 08 Jun 2026 10:17:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780939042; cv=none;
         d=google.com; s=arc-20240605;
         b=L7ODs5gBuGJHGCGQnN093vFzGbuMegSRiKiDN3TEE4NTG3jsHgQ/1wEgPEnzB/+lqq
          9haRFtKFsN8zWbglBulyaLo9bZa27cEEwsqRahAksdTNNaqYHnf4FRMWOQx2gCvlQqkA
          THKkpXS/f2nn7gm4HhJmKw73yoSTfwUpR3F2AaJCktZ9BaXAGuiAoLs1se289TJAwRh8
          hrzvGIRqi16f0txofhmbUr8Oq6vF6tJx5iD52RCr52R3ivEW0j8gAxn3FxJMijKxOiQl
          pFjBcKJ7LXTH6OkbxNI0Mk/+v8VFWTvHsqw/ojNpjH6A5hITq3uv27Qg6VHeQM7hAgJb
          XYew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:dkim-signature;
         bh=nviWi2SVvs6kP8+AcZcCp02bcOI3+H6tiI/C6wy+oDU=;
         fh=s3vNs09LOaljGQFwq57ac5dJyrRMA8fJSBsriFFJalE=;
         b=GgtrsnfMZhRV2/JJJf2mqYoze4JaX0Hrct0R/WCRNWjLPX5zWdy0B8/1y1W4FZLLni
          u9oOC5apGVa66UFVde00ELjaXXhD/b6G330CPWA9p/mrtLMpBcwuXYAJcB1Jay55BSVz
          31eHuoh4W6sl2Ug9QV/Sw+LxtHQKJmLzQ/g8WRwTM+HYw6VB0LIWr3ifNqR5hLF9ri3O
          NDGrtbjUlBtNHOzzGXRp8tLWTFGQ2vfw1y62a4LMrpr9vMZ1JwXL/9UIccEYjFmqOL3b
          726dLcgSkTUsKBTLou0U/WxbAlOg6EBeBnJcwY90J8X0w1an21vcXERvtuFdNTEB4B+T
          E8sA==;
         darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=janestreet.com; s=google; t=1780939042; x=1781543842; darn=vger.kernel.org;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:from:to:cc:subject:date
          :message-id:reply-to;
         bh=nviWi2SVvs6kP8+AcZcCp02bcOI3+H6tiI/C6wy+oDU=;
         b=XXcB22LtEBzsh1FnSTtwXA4PQX97VVdzgkwsMoenOMe8iiJeoX4Tz9ZqARwvw3ExsE
          x22P18IubQK8L+O6WHC/36u+ayUgmmPluBmeFKmwrwDQE0TPVbMEe+TiHpfANPJTKgSG
          nJT78VuOl+/Ahv4bNHmatz+RdxhySgBInpZwM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1780939042;
  bh=nviWi2SVvs6kP8+AcZcCp02bcOI3+H6tiI/C6wy+oDU=;
  h=References:In-Reply-To:From:Date:Subject:To:Cc;
  b=iEF9RcsSVUznVNnTsCCypCI0GGTTr0aqGDIQelANpcqz1YD1dMTzOqyHe8Tc/1SZb
  uuVnGMN6wLAIQAifDYRR7vKISMCtL56XmY+8Zy3q15ursCo+qXSD4WIrn4z2pht1+2
  keSAGpV1H2z7C5233YiaePDrJ0DGUA16NZrlPj8KqQjcjyaCpwVzzSCVkgrR0Qh8qG
  AMzCv0vJ8sBkzyRjAl/1xt1d4XKoyYF5AqISfRz7ma2kkHezI/bOYZs3hSgGCfDoba
  6Bip2Kvp2DZOfFhylOnHdSQ+V8eHfwCpy55DFOe51Ci6aAlghHh6ANWQtX/WiST9vK
  +z3enW0HS6dqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=1e100.net; s=20251104; t=1780939042; x=1781543842;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
          :to:cc:subject:date:message-id:reply-to;
         bh=nviWi2SVvs6kP8+AcZcCp02bcOI3+H6tiI/C6wy+oDU=;
         b=Z64IoZdmrQN0eu7EsKGxasJneU7IRsr/PToDIqOj01H9l9jD7uyq7wc2nbnjSRfYiP
          KTs3KJTL1dhakPmqauwQEXm1lVTc0RVr3JTrD81Z985iGkYhu6Ri/H8LLLIHnk/btT5I
          pN+HUWNLivhP/RhWX3pt5pyvsviDRi2Ta5O+BnvIIEzfIQTrYUfuJ/WbYLWA8RI/oXaT
          IiSNYV4ZggB9hURDJkukMZCI1YhrynBDggD+QvFKEYUM6cNcMOzsb0v0CZ/2npgVcYXs
          iSvwRCb0+XiIbUT5rtJppyzc9alUOZmvi8jBU2cgS8CC0psW2d817a0Nq+Fz6X72NbhK
          TqwA==
X-Forwarded-Encrypted: i=1; AFNElJ8bT9yzrA89MTI97XWjAXXWHwrKPBHVz2GKSDuEkNn+NWQpDe78MrqPRFwsldG9YrM5gal+MLUDsuM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1ZFE9MD/wmeaXtoF7SRuA+UJnBPmSQGWdpH/P81q+zj79xrxA
 	N0ruNa3szDhS5U4Cp+lBqpEXslY4rr0n/MfOFMJ1oFN1o1e9I+mIc66wXYl6KsyfEEBProCvnM6
 	XCKBSqTnPaXytSBshXNWv9AbHpqC7K6snFbUui+lDLe8aECRsW9OYk+rfxs+MIAtIORlv7ucJ+u
 	L1v8XyDkHtVRqpJPGH6d/CETaZLKm389Lrxic=
X-Gm-Gg: Acq92OE0Vlrdk2FhhI7SVFWSUXdZJgfVfi4fBP5o1skbwAGwArXfGwWpiXbDS2EVyZS
 	nqlA69PDaZjdIaGdqVkWtmG9xqAoY6O/9tcE4LYCiqOTGJhVxOJlR/RxcbtZ94vPui/kMibUyaR
 	H+hGSlAGHyOXy/DM1WsPTl4KMkqtqGT7wUB9KbzvbnjdfSbYdaANvlbrvkjhF2Q3amkvYPa2J0e
 	u5ehrHNUlNAhPq4
X-Received: by 2002:a17:907:6d05:b0:bed:afd7:185 with SMTP id a640c23a62f3a-bf3737ed359mr795417466b.43.1780939041658;
         Mon, 08 Jun 2026 10:17:21 -0700 (PDT)
X-Received: by 2002:a17:907:6d05:b0:bed:afd7:185 with SMTP id
  a640c23a62f3a-bf3737ed359mr795415166b.43.1780939041283; Mon, 08 Jun 2026
  10:17:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFN_u7FrgM4Dzie2jjkLwWV8P0dvUG_Wwy3Q9B3-2HnnWiDu8w@mail.gmail.com>
  <aiLxe-9Sub8cI3Py@bfoster> <aibns0xP6IVVNWh3@bfoster>
In-Reply-To: <aibns0xP6IVVNWh3@bfoster>
From: Eric Hagberg <ehagberg@janestreet.com>
Date: Mon, 8 Jun 2026 13:17:10 -0400
X-Gm-Features: AVVi8CcZJIKOxJFnY3us1cFaahXNeQdHGkpT9n3Gwe9O5wCWWT-jbuC6519peWk
Message-ID: <CAAH4uRB+Bh9UEVEW8Sb2yM4YhB-Q5UJ6KJJXari3DDF3n3S+-g@mail.gmail.com>
Subject: Re: [BUG] iomap/io_uring: O_APPEND async buffered write silently
  re-appends a data chunk (corruption) on XFS, 6.1.y/6.12.y
To: Brian Foster <bfoster@redhat.com>
Cc: Gregg Leventhal <gleventhal@janestreet.com>, hch@infradead.org, djwong@kernel.org, 
 	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 12:03=E2=80=AFPM Brian Foster <bfoster@redhat.com> w=
rote:
> Another idea that came to mind is to try and just replace the -EAGAIN
> return sequence from the low level iterator with a flag that triggers
> -EAGAIN from the next iter advance. The idea here is to allow the write
> to return partial completion (i.e. so no iov_iter revert) without having
> to return an error from the lowest level in the stack. I had claude come
> up with a quick patch [1] for reference/experimentation.
>
> This is based on v6.12 stable and compile tested only. It needs more
> review and testing in general but might be worth throwing your
> reproducer at if you can..?

With that patch applied, the reproducer runs clean - no errors - and
gets roughly the same performance (maybe slightly better) as when run
against a 6.18 kernel on the same VM.

Thanks,
-Eric
