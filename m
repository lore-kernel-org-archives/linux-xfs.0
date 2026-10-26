Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792994164;
	b=LwtXEXQ2Eb7JaOtp2trVCZt0LfyY82Wlzfrg+dPlCFZYPED/EiFmRMjV6FSd9YTzKmg4
	 vGveEP3IRhL+nXWiXLh+wqljWJTZi/Pz3UC6vS/E+60lphhWMU5ZLmt4Rf+Xf3nv+tb9g
	 5QuAJrMrrvjNXx9pI7gKNuFjDour5/Yk0ewdQwq5wJt9MvsqXWvTI9lSDewDphBKZ8ATe
	 UEGosghxcKmHjRC46beC83Wfreo4So7dYnozx74ltsVywdwkBibezlky8R/9GZpaQ4bHC
	 9FUr1SIPPrfwe4TknBa4toQuPrH0orejzmomaAwWKYYY6vqDK8J3dVzKoe6EUuak87w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792994164;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=58nqiRAhd/Np2pvtunfKbU7BbeXCrbpR+ovBdOjzMhw=;
	b=oP/lq6JbHCDjE1KlhC02StE6uMM5EvBrMtjI8CXQm6YVYMYnktsDb8p7FbvkM/aMtEJG
	 Efq19gOe4HbCIrtAjLqB5o5Nt5dkrOgBwOMrkYFc2MmhcpxoxE2kTEyaNBLZaLZkiPIWl
	 dkflRs6DV6kPtk21y5Yzj6GTMdWmJ0fPg1Quigt+IG6+1vrJokW86AUKvTOO1uQA6b90Y
	 nCqiCjLRH5GTahQ3J9bgMxa770tWl64VWVlz46cirCH+NeZRCavg8g8pEoyklmchSJzJC
	 W3CnayzOXBKFKTPN/yIrnsTNm9G3pBGf+cq0ncDGZlCs3fMiBwiZfPoSopxTCtPURBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=VnPTtHjh;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1857606A31A;
	Mon, 26 Oct 2026 05:56:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1857606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=VnPTtHjh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792994155; x=1793598955; i=quwenruo.btrfs@gmx.com;
	bh=58nqiRAhd/Np2pvtunfKbU7BbeXCrbpR+ovBdOjzMhw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VnPTtHjhQe5FHJl992mgzPiQZlv2Xfg+/Bjkkq+82Eub2Ri4R29Cb1tRaTGZYi/c
	 Oqcd0G+jZ51ovINcYTG7HEDps/5sbAWVSB2r2WqTwHXAQjTRvk5N1oYiTsJTkcKKY
	 yMFIgKcX6AnpdZGdXtMtBn2nm4LMcmxPjMtOksGDkSYLyI/qIcISbBEXD+w9CMppN
	 Hv2jTMUV3oMWv0xDhhsit3TSRIQlOiebXO2kvLdKfG2rpqu8kUa0U2H6j7bVABwGh
	 64kDqbdwFzqQGlaklVfQTFtXqN4fqQVy9T/pkU5ddznIypJEd0o+88pPxv92EiDrq
	 ErRxVjFqtk5/dqHWfg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mn2aN-1wtHBN30a7-00gKgI; Mon, 26
 Oct 2026 06:55:55 +0100
Message-ID: <bb5eee0e-26d0-4ebf-9ed6-af01b1093aa4@gmx.com>
Date: Mon, 26 Oct 2026 16:25:43 +1030
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
Subject: Re: [PATCH v4] iomap: follow the alignment requirement for
 iomap_dio_hole_iter()
To: kernel test robot <yi1.lai@intel.com>, Qu Wenruo <wqu@suse.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <202610261048.3dc64aea-lkp@intel.com>
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
In-Reply-To: <202610261048.3dc64aea-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ah905IIpVxMjxcZnKdtLaAKMUP2u2PGF11MEEEqBss8AYWJVPc9
 T9fO+bvgutkKa7Y4l0FuMCvO7E2y9sjGGdUPJpo49lOwOeK/w0pRPhBE80qrcv2Sbj7pT82
 /nQ2LqtHjwmVj2oqG3qJ4bKuKISFOsLwmqOCU/m3DTQVxIrkgg8qClq/tcGwut7HW3057v4
 VLA7jqfYJO9VIXp3kTyig==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:BaLmTVVtRD4=;hogxSvAR1xhFBOBB15nBJ1hTAts
 nPDXQoqusl9vr5CcmRcCFKEYMtocYGw1SpufWaH/56NJBAfla5rPA1W0/248EGWskkZ9gJWy+
 WbYmdj98EJb0d5O+xjDXwC9iG6BZ+lJ0Eyd7twcuO2Q2+qxt8ip4rBMwFfxJUaMM6hyE09NxG
 P24r1GFWjf+ohTo4HGYijNaNhT/bqUhzi42tIVn1T+WY0t1TbFgsWBGb8/EfW87TMQQXaiBQh
 1NdW5QvwUpUEd/djRMdn8FfQZ6+s0+cr4K7cPd5ptGVeptyzWClOKbtXoEssCGAZ7AX3k2gEM
 6ohbzeFOucQV1xEq5zZ4b4yr/AdzQx3B4cS459Wx3dwV0QcKTGYTABlRI1SlwQTtQZ+30Dmg6
 uvRXa7ETUXiER3Hw60oouOHJj02RMxWNmLX2GrmZo1LA+X//NPguw7sgMQitMQFm0nkjM/3g6
 rrUblknPG/0or9FH3ZLdwlAMKfE9Ia8nH68d0BlqzUCAVUZwctmvyhRL4/EpvazZalqIM+OEj
 /iPtbl6e8FyHUbX/Su273Mg5tdV9G6TdOeMEMCnlL1rUuuSszgTpQLk7zwEWORMaFqp+F99Fm
 Mhonduwj+xG8F4eBigEIYGDe1ainyZTFmOkMYuYrJBzAFYbhfmcTP7MS+ZSDymi9cNOvFhnBs
 0xGG6TN0sNi7ma+eKyJLAeUDZ0k/jFmt3Uw3Bmr4M3z1ZiDZj0ShHFKmjOulrd+bFDbl8tqlm
 mUhNoi42EtI2UHIEyA4dRy3Ajl2zn3h9x3hr7CIeyD688zyDsvzn0nKKg+jDBumIDHxBM7nPS
 lPAasDP5sI89NuRM5EzFTa+E6ftHrbEo8AzmNb+278m2CDY6+S80jLrkj0rV8ePWx4iqTR+qT
 UaT+hUx+TyBOLgXP/g+uiyCbGELkDK3InvuoTWI26VxTE+AXeoGqJBYnjDa/W/BuUHV8I8LhF
 VLMW6ROH97hLIZCJ4MFHr1pZvDxWkKj+KYz6omp9Evgl6TzvzDsSSFrCJqEOFX2WxfMGI1cfG
 Kvis7b/otCYt6JhxUMuIeZ55/vQMFbpCJHT3MiHT05boaRpUYAmW2oyONCVo23NHtsPub/ZJb
 jWq0tbbIP/bZXCpE4GJCdcbX5Exz7fxiroWubIB907sqqCZypAVgn2vPQrgN8lV7ftgzEojgY
 n39oLGqiZg2+pK+NNl5+cUcltDCIrEpk/2c7yiwfETLrVWyj9a3lUR9IEQvJjlSVTA5e75KWv
 +ZHqC6gtFjyzEj4v49iK4+L/vE/MwnA4mTU5Kax5GkknWbOW3aw0jwpYryVQpfJWfRUjiTVod
 a15mDcY18qW+OdsqP/Go6j4Fy8r6GXXkHpN1YXx3NmoF5J16ge4fLyaLYjicsKjU015hsJ7yW
 NMYYQ3G+xhhqpVrHWLm2lKVMbQkl5c2IdEE6XvbvI7HGaE7qq9Gn9YYizaEzECilGiYBacIlW
 t2eMcfxVcB3dbzfkrA1TRLsWl8Mx3v/ihARu0DxJgggtndxUQ5wiFYaVOPzkemsuA5mo6l59L
 tQFlGtvXhimA0/0tpwlfHPwVdi5Q5S7DFWqG8u8g2ugh3CaUl8kZgRBrSH4hauijTDNQN8eoU
 cgTwZoWzAgx/rOpNCr7WHWJLfxNNGKGSb0vRj8Xa2F57STEXEpyZlmdZyvvRYFV6AesPobysG
 3nWFedu4Jc/mAh2XLfQGLKN6h6jW3Q6uhN8/5eYd1dsjo00I/v9UkdagfjQ1isnQjopu+a0Y/
 aZiJavqaNJ/r9ION9tWt4aZBaBkRtOtdM4Gis0M1FogmTx+gO/MKx76gR6dwVsTCBMepAVp9W
 wmKgLo3prGeeOp5sTb7AW5irTImV+bILBX6IJwVmDn5gwEdx5rpdqD/JNMq+6eu4eb3Ibo8AV
 WTtTZzTzbWzoonAZJWfs/96YYuK0/fqRRHrUd//iFFCIRQ8YjMoNZg9TMSgs4bcFhyFGPwto/
 qIXMJRMgvWpZHYeFXuYiZd9sMLzGuMk+/hDh7mJ/Wd+l8hwbTNU4/xvjXS1UuNEz6rHg/l7r4
 WPqtCt8zDsE7LsdU0cKxm1rys0S9GouAbsVG50tWhIze0mt/Z3RyqLnsjzfL3sidJr7mY5uej
 kK8yvGIxDtyMLgGbver4+2edkasI6JhdruTEPJw3C2e/c1ejcttoQFGvl7HoGidQhx41qi3jk
 HSxhqAUqBEFdfD6gRjhIhOw972PTJXKXhvzHV02EW5hPIXwgQXwi8WJqnQel7kFKrTb38SgrQ
 W++rJWrhOEeEU4d6p4j3bHnwgFz/85P+7AhGa6uP5+uiMEjSHWH7/LcCmRnfh5cF5KYwJwXii
 FyaU3kDfvlElBk82iciI/DyTPH1efLouaGIIOwoia9q3uGzaEtg8aqHMGqFcUFzMvCiAOyptc
 NhGKGojRZVs27V5Uq09V2U0BiMQcVBdXTDxXm7yGfBd09P9Xr3qrn4Qe1FeUFPz+avQu9SVfQ
 xWGlfs5QZGpoWCBXK0nE2wMVSrc/optKchnJS1n42xTJ782n+IsmiE+YLfVjM/s1DxK8M7tLu
 mcm255k23B7xaaCBa0kM0YHbWBijdOa42aPT7VT9eTKnrEU1CVXoIAfsu1eTZFndtl8HNyFQ6
 7xBTUhlCSq4O0X+yRICprspyicM+Lk0+gVWOiTuEo4cB4IH6fRdXjuhZwchAlw0oNZ9rvYy5w
 6W+NYbNI7RXdA7TSQk8uETRjFXVUjNf2tGjWVLFz+AJTsJimvo5g/qSzg3MiXxs+2TXub9/aJ
 wY+XotvgUWQbgLLFO9ZsguRO45zq+CA9IO4x7E5JOHlrxHURpwQ6bvMOlZ8nAv9/wcUIISXts
 /LiVga+sm1SlDU2maLuxjvlELeROV3MuwvgFyMAcABt+fFuPeNpmvpLVuh0rEBZlXViU2NERl
 N6f8X74tJxPE2TeCNIyQAjZLGphX7DGl0+/Hzlnd6SLodv1bO72EMrMrtVSh4SWA11C3M0g/2
 9BBhWfoTfHPg/W+FMfl0sJvUr7mZm+vWjCS5h/OaA3cFRm4xEFgc1+ETvLIsezzl4BBiTkTPe
 n77623GZomJMb8zMgJIZs07W5tc4d1ELWAK6T7kUYfMMEFAEBpLSPR3IcxeQOYiBR1ZCJMB3o
 y+0eWGJT/ycOku7Khozm+TWUI+mzxbeuj5nB6u1CgtlPtMgDKjbdjMRPEsPfiNZKrTAnhaFjn
 sGuR4i/rWXFq44i8J6Ne35hqgU+LIz6Ev4R+k85Vc8EOHZtLF+NRErfstV+ypaJ2Ia29QeAfK
 g9HoWxsLt+8NqCcgVvA/B/p6yxBLLRgCwFAFqKgjoGDm9WOfJD7xplrs1RG9YKvtp1lbXRncX
 W1WNAza9FbOoR/HNDZF4W4vpe+71T+OfCjLRw59kifgBC4xYxx6naSnMAvvgAeuGcmZNfjcTH
 J0ikhCwvhObvbskNHYv9Hym8tonxYlseIxfqZsJK/K8vnLleIz+bv+aQeoLOFGz0NT+GnPYu1
 ziN2MjjP2V9KzysH7YqeX6YVPfM0THysExtYzuFu1kFvLR4tuM8PyAnx7d88nINK7eA27Fx6H
 adyB5OBZC76xzrvQUA2fSYkpLSaM6znGg/YLOo5JCvf0uWOLkt5YA0vx+oW6W0mTur07FWGrA
 nJ15A6AQhjMjnpAU0GkuuHqE63yq7FdsRX0LV2E2PCjgsiv7IrQAoHKU77w9Zixeyfi0Ku5IC
 1Kwn3pZNxR7Wcxs5xm2ECSMRtQf3qE5QOgjnj3fZ+MopJvRW3rgZYBezQDLGON8884LCuV9f5
 TQCviC8Rla8DJlIsh68uThAQdu+dGvG3XJBXzyMtfmjg2nblI1COntoYRHRivpE0SA9e1b2+3
 5SG4kU5mwlCxE2p5iQKwfEjJpPgTUS72oUlZQHjnUruQ+qmmgoC9Yv/OzRdOS40Y0xjAF8Y2A
 4dPhS3BxjPk+pihW8qHahmD2AV/pvOcxIPrGwd8Sbzw7YTnVXz6VFlmzU7Sy2LDLryzSohgZF
 O4Yw2g31aGgIhsrNCYrHED/oM5GZF/t8D9fG3Vpx27NG6WMbqjZZWSGrwLvsyPfVo030uEU5e
 6Jzv9RySo6uDJP39wRuzafCRy5wLDJ+So1w1YL10Uavy+jNfLdUGSHZoXn7qvVSyfQM1ZmAAh
 850eRSw3uA9xgnmcNJgZ2xSxWYLR5wHaEDgDkCKD+KH6vtlxr3Y7jTPJlbQ2mw2wt67TNWbCq
 zbXKFwN4cTb5s1+B6tuasrtADP3++Ymn93XHaqcOEJAnUZ3HBZwZyRSURhBxMmuWvf8ojIbcD
 wyFFnvsL0IMbUbPpOoTcZFQwY5WP3TbCNIfviO+HusjcAWu13s+M1UZT8lMmtd12W1gz69YB7
 fANCHFYlJLrkpPCdvgkW6ps5gfAZh2ncw6YOAE6XIqEh4ZlLMZ/QnJF3TXOI4CfTF8lT1muTx
 lHfkDY6J4kMhbwqqgXqAEXmICU9D/UNZYw5Jzrel8W3gfwwZ6JbHfIcbiqKNvFz/9ymvep3EP
 n/mWFmavEoXUauXFOIWOYWKPzD3wUD/YZRHwyoZbJv9s/6RR41M5lrZd2m5Ow3jxdATpJL3Yp
 UWtpHp+6fNBj+ZbDmUT4615T2Tr0GIXR6B31BIEM2VD02kw6xse/e43ARdPTNTMcQMYqB3z8c
 efkWyuSI5AfUFeqqxEpKcV4fxKD8U919eBdrgm0MQ3sV1uIfmVh2MFujiaBKUO8TgSLvS1xWB
 iGR49a5FFsfpjsm+pPSxNrEafdICL4HIPkWoB9XrLDtEhra8VddKLeqfHZntUv6CYoQvRCA0p
 QUP39uDovwl07OVgqwVYeUjHNj+mapigkSMLz1OzBW9qoB5u8d+HzmWc9nH+VxZ9aCyPWEhW8
 Pp/IzOOVcqv9h4UZwhHXP+PMGyXRnGlDeAqFi9qqs/qhTjaLoW2PJw27+hHITQ9nHQE5vdWHN
 tTHvNGuK5s8o2Botjj9iWWLo8HrxhWeJkGWeZ46I9SNfiZ+/ytsNs+iq9kFovkG1nwk6tM4FE
 fWPyV6lIhDLP6xfIbhjjB9daOhTvmYrQ/iQCMYe5AX6DfzLR2l8Ct/opGFM2W3LJ/UcWJySKK
 KfihVmsVML7nrduZTWx20brGY60JqjAJ/HtODQLqvUPlDemKmuHTX3KbITVNWgusSAa+xvSop
 G/VDESM6LgSGgvGT3ct/gXdPkUZu/f4drJWAbTzswVLFutdaql5oOGZLsvp0AbjXUgQJpDkze
 ymsl3gL/SflYblMljQ5oWAmq37r08Qf96E/qw0XvLhRmQmVWWBU/8HmUeip9I6AiSsym2pDl5
 8Nr7cy+31uDmWKdVo23tRgoDFUFM1xfu9Al4e4kZl2LXrfKULesT3qhhFRnNzA2TcKdOyjTZZ
 MGxcFhyEN+f8G5yKfx5i8Q+uq3ShHSfaYU4A+eJ2lbe9ZItes77t+LWJ/NADoZdDUWXMgCx1B
 1/zMUNkCOh5DSZqORqrNWTHpcr6/FWLyj47Mi+/LWha4O3qYdihpYaPJTThfLMDSrdTVemnjT
 MDgIY0+By+mfs+OIhpZfrCkG/fz0PQwhUp2vcNzbqfqcXsN9HvCphYKlpNHS6H/QxTo5xBMBr
 H/gMNS4V3dZ3g9UBG6ON+IipOV0MKF1Er69eyNiqzGqztuEVfIpfI8psE9OG8K5YmlgJ2ZfB6
 RDUlAo90h3rQRhYNyEIdEaPSEdrbpDrbnPI8HYQGjG154D9UMG9yucnZBp3Bbynv6HmYgZIvm
 iCkiDLZjnlcf2LeLVmDSjbSIO8QPJRCPyeIKq5E8cZUzKgqDXsp+vLVSg+6qlhE76jatY76MD
 GKAT4OufRKC6GzafWz4hfx11I4QeVmuk7Uo9rphvJyE4FtXyvUsMr29XgnCtwjV/tbtw83K7B
 UqVW7vTdrDCCD4qUOiETCF7fhipbc3vrBQuD5A7zvucO8og9eTKFiZp87eJI0EXkQj2y52aPb
 Qk+e0ZtYjaoo1bV13b0ah5COqJeVnPuFdldrztvU+OSVU/AFdCiiQfx1ZPh99CYOg4oJkH9+S
 l9YhELCmgI8fMYSk5no8aNNJsPeuKGc/jMs7sFGHXErKiQMmykLGnyVugdVgfgIhbGFco8TDX
 rIZH73UfIh2PeaOwT9HVImvagSeODfEnnFekbocskv2GZB2GjLX+hMdIe0n/jQK86eiMrITrI
 OUliy2lDxhihs8Hzh8Fk8EIRILSd7BA4fzk9oOdRI2bH4nVvT6k/6rnQ+fs76ppzkYfLCynkp
 K/1K8sRvdE8BXWy0P+dPDsVk9BxARuX/VBNTY8CVQaLTXiDPDD4Y1TUHtW9A2oGkutpgQQii/
 R+9Izgc2r+MQ0ZNa/RAnU90/U+m+kkkykZzRP1l1iD0zieGivfI+LYqNLOy2Zsh8CVfOXL9Ct
 Moka/06RoY55Oml3V91EqJ1WQWnN0gwFEMPLYNFaa/Y3TcoAsVW4Q6RARkcffKq10qoTY8CCX
 P1qIm0HmfsNqaKSP/8U7w2n11Ao/4oh3Vp/A5fJMzCrxswJilgRVf2C8TLeQUooIRDoqKuTzI
 dEiCcYbr8YKf7/oYcJpur7P26kvDuOFi+/+IiqDrL9Vn5AUNqHda5VOqvEZiqXyK3Y+jqjPCm
 Va+PNTfWrULLLRyPDAfhgtWY7Vj2JoPVKA4A2AiVCLFgOfY7pAc5mhN5mGRWG7yfDDQRSHlBZ
 WtRttlukzCSg73viqJk/2VHULYB9Tx6pKpM0jEzqNONdGbjp4aJnzMX9kWAad7/ZatIZNVTLS
 yjYCSDBH5zn3vlwKaweUeZ3C0MBkdp839QWqz7Gv6HZmo64JRAL9XYazKVu1kx12XwuzC8lxC
 MDh/SczVBThmhMDnWJtImFcQOp6j3zePhVOEYvDRMzI41vW3n52IlcqvKLB94Jh24Mb0yd9uq
 rM3fBuIrCh8NszZkjRBNxhG2a/KBxSqTRSMtjerlXeHyFsCJXUB1y/Emz1ehRHAjL6y4lx6Mj
 QRefOSJO21mBFc2EuQfms+qN+OuNf7miKhW/FSkLMkEnSN3q2PiydhVCozID1hl1gb8T01E/n
 8O7H+9eUFSlxj252DQJDyBQXW3qS3C0wXjBRNhVxQTEDlIwxtLrh0svshz2NnWn8T6RFmYB6R
 kfuvi760/AKkzKr/8XgCOLKGC9KmKOUbSElbeFwz8s3I8lAULPZTAmGBIlKSX6BLDQz/tz1p8
 g0snKPybrqjj9r832MrPsMYJaB8VzteejN6U97QpFkqitBbZE+hbeJbH3qWwAkWlGltNHVtLc
 dL/F9uxTIPrJbOcX3wA7Nt2LkL9WPcErE7Z8Y/Xxp/C6zxgTazqyqrr3wEJZp64xj++/8sHtQ
 1gFwhXUHqiYXrM3hzONKqdWubnBenTqSdNawqAQCf5EUguS/tQrL+XfcnncMzw/EU8YrsSACA
 ljvANYXRI7vpv7kBnhjJXc9U/JIIxbd08kdeOuSQbKya+pfPtHx76BhWjg=



=E5=9C=A8 2026/10/26 13:20, kernel test robot =E5=86=99=E9=81=93:
>=20
> Hello,
>=20
> kernel test robot noticed "xfstests.generic.091.fail" on:
>=20
> commit: 4025185cf953e3f52ab63cf5fec50c1485ee7bb7 ("[PATCH v4] iomap: fol=
low the alignment requirement for iomap_dio_hole_iter()") https://git.kern=
el.org/cgit/linux/kernel/git/torvalds/linux.git master patch link: https:/=
/lore.kernel.org/all/73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.g=
it.wqu@suse.com/
> patch subject: [PATCH v4] iomap: follow the alignment requirement for io=
map_dio_hole_iter()
>=20
> [test failed on linux-next/master 20a33c6b6cbe7e4805dfb6cd68816937443aa1=
48]
>=20
> in testcase: xfstests
> version: xfstests-x86_64-22348afe-1_20261019
> with following parameters:
>=20
> 	disk: 4HDD
> 	fs: ext4
> 	test: generic-group-09
>=20
>=20
> config: x86_64-rhel-9.4-func
> compiler: gcc-14
> test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake=
) with 28G memory
>=20
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>=20
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new ver=
sion of the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <yi1.lai@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202610261048.3dc64aea-lkp@intel=
.com
>=20
>=20
> 2026-10-24 23:20:06 cd /lkp/benchmarks/xfstests
> 2026-10-24 23:20:07 export TEST_DIR=3D/fs/sda1
> 2026-10-24 23:20:07 export TEST_DEV=3D/dev/sda1
> 2026-10-24 23:20:07 export FSTYP=3Dext4
> 2026-10-24 23:20:07 export SCRATCH_MNT=3D/fs/scratch
> 2026-10-24 23:20:07 mkdir /fs/scratch -p
> 2026-10-24 23:20:07 export SCRATCH_DEV=3D/dev/sda4
> 2026-10-24 23:20:07 sed "s:^:generic/:" /lkp/benchmarks/xfstests/tests/g=
eneric-group-09
> 2026-10-24 23:20:07 ./check -E tests/exclude/ext4 generic/091 generic/09=
2 generic/093 generic/094 generic/095 generic/096 generic/097 generic/098
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 lkp-skl-d01 7.3.0-rc2+ #1 SMP PREEMPT Sat =
Oct 24 20:47:23 CST 2026
> MKFS_OPTIONS  -- -F /dev/sda4
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda4 /fs/scratch
>=20
> generic/091        [failed, exit status 1]- output mismatch (see /lkp/be=
nchmarks/xfstests/results//generic/091.out.bad)
>      --- tests/generic/091.out	2026-10-19 16:30:12.000000000 +0000
>      +++ /lkp/benchmarks/xfstests/results//generic/091.out.bad	2026-10-2=
4 23:20:20.173485972 +0000
>      @@ -1,7 +1,25 @@
>       QA output created by 091
>       fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>      -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>      -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -=
W
>      -fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
>      -fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -=
W
>      -fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
>      ...
>      (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/091.out /lkp/b=
enchmarks/xfstests/results//generic/091.out.bad'  to see the entire diff)

Indeed I can reproduce the problem on both ext4 and xfs.

It looks like ext4 and non-COW xfs inodes relies on the unaligned hole=20
iterating behavior.

Considering only btrfs and COW xfs inodes requests FSBLOCK_ALIGNED flag,=
=20
for now I'll fix it by only do the revert if it's requested by the dio fla=
g.

Thanks,
Qu

> generic/092         1s
> generic/093         1s
> generic/094         14s
> generic/095         51s
> generic/096         1s
> generic/097         2s
> generic/098         11s
> Ran: generic/091 generic/092 generic/093 generic/094 generic/095 generic=
/096 generic/097 generic/098
> Failures: generic/091
> Failed 1 of 8 tests
>=20
>=20
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20261026/202610261048.3dc64aea-l=
kp@intel.com
>=20
>=20
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

