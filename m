Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793219706;
	b=b9JLCiOGEaSszg0h/x3bNPFsR7ur2SxLgSS3570QVDy+lA1/UzwatostBX2BUZHR02yT
	 XrKC5bHYCiZlLy2hkaFJ89pGJDGigBx86/9LpAMrjLkOMqng0CiHp/FgjbZ50U8P7goPa
	 7NS066AkjEF7ZsXsQtBfAtkjfhYHq+NQx5xQqPlJcMuc1xopJpWSm1GQlrQFP6BQeOvlX
	 lriExYw9YQbFwDzYeoh3hlXFmExLyIo0HIGdhR0oPkBCB/r4yo+8gUi7/4hX2ZXp9M2M3
	 DP/eyNYciXkGoBv2QIXholWFzmHeucgx2otQ7+hdhLin+6L9xf3E2e8d+qhP8x1TwKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793219706;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=bYwUO3QT7Sqe/8/PMdUpBGdMo8Gyco/Lui8myE9jn8I=;
	b=FGbISHIesrHWPSkqvx2lEUksSEU7R9lDJU2/cqmVm9kyVpqTmtVzk3AD8nQqbb1ZtNsE
	 aaBaCAFVj4zL24ub4Y6TNjsZlIe3aiS1o4MXBSBSctZkjQrN5cox06htgSKVoaIatiuj8
	 iwp3fXu+37DjeGgOxjDbWcAImooGekSvHMYAMYxeN7KDudmXTW5ZIp85x947Oq96C+GK9
	 2Cnt1qAfogSkiKerAK+OpZuC/a+kmp0T93caSPoW7Jo7JhfYZZw0xnyu+s0aC/348rcnE
	 OIlGjvv1zrR7uxr58RGdiMdIGFHEA9AFBYJNKEDVWw7W8pQlH9xtCpJm4DgW8E0hQgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=S7LT57Wf;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41E6606A31E;
	Wed, 28 Oct 2026 20:35:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E41E6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=S7LT57Wf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793219703; x=1793824503; i=quwenruo.btrfs@gmx.com;
	bh=bYwUO3QT7Sqe/8/PMdUpBGdMo8Gyco/Lui8myE9jn8I=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=S7LT57Wfpg1Hiuz7IwE/omn3lQwKulHcYQnmSJvwspz2tmG7WMHDhZvjQdH1LIzH
	 /WqQFKxQZv7SRdqIYDtIqm5jcplcoQUsL5z/kCQZv/RTswH2ev3GY6LdaPfQPLoXa
	 C0kRtzKy19DaxQrwEXHnC2JMVPvRplALmSddJQyKE45Aj3L63hVxKY7dXnBmJBJXS
	 F0Ka7Pso09XTip2X39yUu7vojKyle7ry68c1ZM4NsYGHPxQv2y06Fc/gFLDQAQ3lt
	 4TdXhClg3rOAhZmB0K6egFBgShk/DF+icYU2/AVzy2wHXR2pmvwjC4Jktu32lZu8T
	 8WWMBPETZt9q06+51Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MDQeU-1xDwsi0NiY-00FlYm; Wed, 28
 Oct 2026 21:35:02 +0100
Message-ID: <69074a82-05d3-4a51-b266-b74a23b39eb7@gmx.com>
Date: Thu, 29 Oct 2026 07:04:57 +1030
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] iomap: only follow dio alignment requirement if
 specified
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 "Pankaj Raghav(Samsung)" <pankaj.raghav@linux.dev>
References: <1559d839fc32f47db7e8da8c8b2a5ea9b63afb46.1793143679.git.wqu@suse.com>
 <auIUEwEzpgilJn_z@infradead.org>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <auIUEwEzpgilJn_z@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:aQxPirq2yppZqjB/Z449b9hadSGjul9PaAI/25QrQILWcyoDD5e
 jphtBh7p05jxgO7fi6MWQPjnNht8PVVEFwUKrKl3pduXJLvk+kclYQWNnBtlJPRJeYabYQb
 M6MH3tSxub4xSOE1GhnMJAnFfhqnKGtMd9K9ud6Pu8NiuZUTs/zi/LdbmhKoPevqYGQvcek
 uuGTHvIxcQe7B7geshf+g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:NjciPyC/jAA=;umVz1wWrhqaAYIUNoRX01oDF2kS
 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
 PznAXe/V3EtWKX703e9/Q=



=E5=9C=A8 2026/10/29 01:56, Christoph Hellwig =E5=86=99=E9=81=93:
> Can you please write a normal commit log for this?  I.e. explain the
> problem and the highlevel fix in short sentences.  No need for [] tags
> or xfstests output.

I think this is really up to personal tastes.

The xfstests failure output is a good easy way for anyone experiencing=20
the failure to do a simple "git grep" to locate the fix.

And [BUG] [CAUSE] [FIX] are very nature stages when you are fixing a bug.

I understand that too detailed commit message is slowing down the=20
review, but if someone else in the future needs to re-check this commit,=
=20
I guess they would prefer more details than less.

Thanks,
Qu

>=20
> The fix itself looks good.

