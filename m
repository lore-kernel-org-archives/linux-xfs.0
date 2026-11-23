Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795472988;
	b=QHJxMdgEuIcXQE/WpgUJbWcK350XaNEfYuRV1esmjkoAo9kruwtqQiSK4fZ9vuJYiYr0
	 KQDDdknXANjIB+aQCP1xv2UTWOk1GTr7pKKI1mV8aEGt1ySz8oBM4bfbvai05KFIsX16V
	 Ni1L+Z0nrrgfe+N4NrqUO4mex6PG6FSOwQCgJlg8RBa61xiKspcTDe2iKQg2JH4bWNxIT
	 /Q09Pt8R8InGD9iLHY592iQFi70JaRNDTyf+yBiciJoHgojIRJcu5+R8wKNj0P1RWK7Gj
	 9VWs3yEE/8oM3PIdllXQfkLhMSBemLIukMioWmPAfjj3kxewfB5BTNa3LjoT84vOF7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795472988;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:Autocrypt:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=vcuvpU2ZjCticcRCz8mBiVPYz9CrCiT6lwDcRw9mKTQ=;
	b=qXDICE0nI5TAgL+56S7V50W6LKn1WcMl9m38smjQb2ftZcfR5jf/cJuPDsnuoBpBw4fm
	 yG/6qNGjjdH8MJT2AWTZta9Uq5A8T+F9XNbbUkzoc3Z+Aq8c0tFiMZzi+IkuJ/Z2QgqPd
	 WHDFv3bZxmsDLaAkNQeyWywtm4wI5cC1JAZyFFFha3BysvJeVnl94TjgLx0TCLRH6w1Sq
	 pMtmex/VFWUL/LoeYWJPWa1sP2cs4ZIeuAyeX6/Yjwtj7uKeryxMjOQYQNkLohPctCZhA
	 c4G5Zy/gQqWTGaEf34rHnsVP/jthvx8bNHASvEFjY2qZ5YQlNDlYhZvTbJwBQVKVLeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dubeyko.com;
	spf=pass smtp.mailfrom=dubeyko.com;
	dkim=pass header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KtDuIlg7;
	arc=none smtp.remote-ip=74.125.224.52
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF31D606A31E
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 22:29:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF31D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20260707.gappssmtp.com header.i=@dubeyko-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KtDuIlg7
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-67c6a0abc2eso4053888d50.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 14:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20260707.gappssmtp.com; s=20260707; t=1795472987; x=1796077787; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vcuvpU2ZjCticcRCz8mBiVPYz9CrCiT6lwDcRw9mKTQ=;
        b=KtDuIlg7B6694VnHPFw7U/qUJ9VgUogU7LUZZ9brTOJ/Zb3QnI5MjsCqFakjLz7Xei
         Bb1tH+rvHn4qN/u8+sGvH03N3IyDQNnp05tMYh8RfBSuPT6LOioKeYy9jPq0d+3Aaf3i
         j4V6hy4vMlUS5Jx53/6NiyF56H2ho4tb2gX8EwKl2y4veDtFCWi3kV53zA1l7LG1Z0Ws
         n2d5SGshAufJMVDqQinqhmLd3SHlFjYvOKQaWa5FEBIt1mEwtTVUl5R7OA+yhxc2MGlm
         danQUZf22swSh4xHm9s5CfwDQKFp0LhUQwMD9LF70WKfHjTTUw8u0MrH0InLBRZB6y8d
         +N9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795472987; x=1796077787;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vcuvpU2ZjCticcRCz8mBiVPYz9CrCiT6lwDcRw9mKTQ=;
        b=gEp0sWU+HgJg7eiGSYMk/854xuoKdjudgZYfXNatL5L6KxbfOdicQJOAtETJ2+OweT
         eH1Z4Rl5KVaWG+c9afCVU8dMPtSFJ6UM3/0IqZtDzBRvXNqO5QPB5LsDSFNvrb99MCF0
         nEZ5g9Dlz7WRCGfEMm4AwrPwYVIu+RUXYtvCaP5MF7N8m3ju9PVK6DFyEDDJdgjQsaeq
         oMX7PriK88Cg6hQI/fWzmf1Vehewj7PONAjad7enQwFhYSsKF6PzRtTwC0nwtMX4tcdp
         iCQjT20WGC22VJrYiVCwgZXymhb/eFRGnG6N2dDaFU3oU1dkqdlGP93g3r8zkkG+3wgl
         xnog==
X-Forwarded-Encrypted: i=1; AL+hErG6dFHdyIz/1nZnOYwKPfDKDar6azS47XFJegwObhaF5FcPLDTjRUPqTp+YASXfr7i2QHkRCYeiVGk=@vger.kernel.org
X-Gm-Message-State: APuU4Z/UfrB5MmiyFCnUjCRQqesBMEddA2pcz744XbEH/VIJo9fS+smV
	VPhbyWdkEf7q4/BMlTYzLTCpKcKheASvJuuM+m7+S+slJ5y3ZuZa4RQ4eTNNZN9lixGg1TVQ8dh
	peEGSvDI=
X-Gm-Gg: AZFdTZe5MmCX7ZYqEA7p4lUM34YeBfv48Nt7ILyAXXDfnd2UfcsR/epV3ah+wd1uoZI
	REMrsWenNWlHQlnKvBmZ+XBPFRZ3XhFZ/y1/WHwgAJlTLwZWAD6beIJwHXTwDMq/7/HcSVH7uaS
	GOPtdQE/TLN+7dSDKRo3f5NFkoxQ7oPZREfF5n2verbqaRJt59VMH4SmoVm4avQs+i0vdRcr6nK
	dtS8/ulIdMNUCOx+E1OeowheFY6yY10GImqjMSmz7JzZNGNrJOoyfzZdTxKFokQM9JG6kdoWKDP
	S2ztiaAyOHm8AuRzBGRnr640kJuQiVet1nmZZcOQjenUF/OOnvJwzvFXDkDaK/ts3tm1RvX2nEo
	tgFleLeJKfsw3BeObPygHm+IAFLtJSQstVV+O4ra2dyET5L/Gxxgdx3Ob1N/+kjcWsmtFDB5oG3
	9Tj5A4VgSe7jZnRbBXvk6rMVI9a/hl9Jl67IbDAa9+WATMEoG3VsRZK0XWFZRePy7zYHWOTcnjv
	K5ifPYUJCuq/DgvLxnAyEXkIRUOCi6U/imgnf2B5OfW6ya7NHfFmMsflYhHTV5NdmX8SFmzGXvF
	XEcehbAuNMrETBccHNjqgkngOQ4D+T/RdMLBHgJzR5fkG3NOVXgYiXKLgaSXpiBzahwpkjGa/lc
	+tMyYiKTdsvTxf0RcS4t7t8sive/y1/WG1yBC6mc7sMPCFanILXRPsL90EoAHCtzG7gDvAOKzCb
	1M9HWd5AJW7boF9dJbmkk=
X-Received: by 2002:a05:690c:6a04:b0:8b4:d882:4a1a with SMTP id 00721157ae682-8b52032b647mr40897437b3.9.1795472987061;
        Mon, 23 Nov 2026 14:29:47 -0800 (PST)
Received: from ?IPv6:2600:1700:6476:1430:83a2:1030:d4d1:10b8? ([2600:1700:6476:1430:83a2:1030:d4d1:10b8])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b52030ff10sm50259377b3.33.2026.11.23.14.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 14:29:46 -0800 (PST)
Message-ID: <ae8b60d3c989ded1d02e5fce38d2d99c331e8daf.camel@dubeyko.com>
Subject: Re: [PATCH v5 2/5] hfsplus: move file related operations to file.c
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Christoph Hellwig <hch@lst.de>
Cc: glaubitz@physik.fu-berlin.de, frank.li@vivo.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	vdubeyko@coreweave.com, brauner@kernel.org, linux-xfs@vger.kernel.org,
 "Darrick J. Wong" <djwong@kernel.org>
Date: Mon, 23 Nov 2026 14:29:44 -0800
In-Reply-To: <20261120182228.GB2183@lst.de>
References: <20261118004844.3849979-1-slava@dubeyko.com>
	 <20261118004844.3849979-3-slava@dubeyko.com> <20261120182228.GB2183@lst.de>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=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
 NFdvziOa4FgUBC4X71upsZIoZJeii2V/Jtc3B4g==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-11-20 at 19:22 +0100, Christoph Hellwig wrote:
> On Tue, Nov 17, 2026 at 04:48:41PM -0800, Viacheslav Dubeyko wrote:
> > --- /dev/null
> > +++ b/fs/hfsplus/file.c
> > @@ -0,0 +1,127 @@
> > +// SPDX-License-Identifier: GPL-2.0
>=20
> This loses the copyright information from inode.c

Yeah, you are right. I missed this. Will add it to the next version of
the patch.

Thanks,
Slava.
