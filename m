Received: from gmmr-4.centrum.cz (gmmr-4.centrum.cz [46.255.227.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ADA70837;
	Tue,  5 Nov 2024 08:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.227.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730796364; cv=none; b=Z8BnOop3W7E7D+iLP2CLnU1GJ9hLYMOjneJi1Jf6RLaf8ovjkfXlvSJAXHr1K3Y7uhMhHU1/2tUP4zE+gbSac4dY7utIa5hXmmRLLMl40T6FSlyXhozz3nA/pklYuUxyhJP+TJxAPhBN7qaNo/lT6kTze1GMdaVCVoABeEQkPDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730796364; c=relaxed/simple;
	bh=HXV6RXuocgY3Sd1np3j8RNc2JkPIPIFW+JVPgbhaSzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSCXG+1dR2mbRP2WFY1UNd/9C3wIYva07l234Cf+bMkUuUifX5bHj77C9ud37S9M2c5hADonDHL1zbCmLMgg8SIjnAajqZl5uYIx4zFxYnf/4DRBJk0WNIdTPwxx8MuDbhHkheeKUV9fb1xAuYkeYOFDQVoOsXKYRaMIZhXpXqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atlas.cz; spf=pass smtp.mailfrom=atlas.cz; dkim=pass (1024-bit key) header.d=atlas.cz header.i=@atlas.cz header.b=b3d6WtYb; arc=none smtp.client-ip=46.255.227.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atlas.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atlas.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atlas.cz header.i=@atlas.cz header.b="b3d6WtYb"
Received: from gmmr-4.centrum.cz (localhost [127.0.0.1])
	by gmmr-4.centrum.cz (Postfix) with ESMTP id F229A2C4D3;
	Tue,  5 Nov 2024 09:44:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=atlas.cz; s=mail;
	t=1730796271; bh=RrSttZjrfEWftPgNSYK6pRxpaQb8jleacAJJe/uXiUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b3d6WtYbgbykS2xGzUTsiLY/jfD3kENkoAcU8bMzcL41ZPcFjGzZzbLxIj9l3gSS/
	 Roonq//5rTB091y2PlR6kx/mzAzGoUTYs8EELnt3nkJo+kHWup+QYLzfz0x3Xs2STS
	 0zPl+RGRyFYz/HWoZB3e5iL4iw7+QDTr5Ur4Wibs=
Received: from antispam95.centrum.cz (antispam95.cent [10.30.208.95])
	by gmmr-4.centrum.cz (Postfix) with ESMTP id F00B5200BDC2;
	Tue,  5 Nov 2024 09:44:31 +0100 (CET)
X-CSE-ConnectionGUID: vk+r8Pt7Qu2lsDzroFy7qg==
X-CSE-MsgGUID: /lI+p/sjRim1JauTZT9Eiw==
X-ThreatScanner-Verdict: Negative
X-IPAS-Result: =?us-ascii?q?A2ExAABm2iln/0vj/y5aHQICCRQFBUEJgTYIDAGDQIFkB?=
 =?us-ascii?q?IRSiB2JUQOKI4gHi2uBfg8BAQEBAQEBAQEJOwkEAQEDBDiESAKKNSc0CQ4BA?=
 =?us-ascii?q?gQBAQEBAwIDAQEBAQEBAQEBDQEBBgEBAQEBAQYGAQKBHYU1Rg2CYgGBJIEmA?=
 =?us-ascii?q?QEBAQEBAQEBAQEBHQINfQEBAQECASMPAUYFCwsNCwICJgICVgYTgwEBgi8BE?=
 =?us-ascii?q?SMUBq4EeoEyGgJl3G8CgSNhgSQGgRouAYhLAYVoARuEXEKCDYEVgyo+gQUBg?=
 =?us-ascii?q?nWEI4JpBIJHhQ0SJU2ISJdjUnscA1kgAREBVRMXCwcFgSkkLAOCUn+BOYFRA?=
 =?us-ascii?q?YMfSoM9gV4FNwo/gkppTToCDQI2giR9glCFHYELA4NihGx9HUADC209NRQbB?=
 =?us-ascii?q?p8XR4MkOCk0LCBgRQiBLcV2gxyBCIRNh0mVQzOXaQOSYZh3jAeBeJsjgVAXg?=
 =?us-ascii?q?hYzIjCDIhM/GY5HiHe+dHcCAQE3AgcBCgEBAwmCO40oI4FLAQE?=
IronPort-PHdr: A9a23:7wWXJxRdU+r9+ueo2lEpPtxYwNpsotiZAWYlg6HPa5pwe6iut67vI
 FbYra00ygOSBcOBuq0P0rCM+4nbGkU+or+5+EgYd5JNUxJXwe43pCcHROOjNwjQAcWuURYHG
 t9fXkRu5XCxPBsdMs//Y1rPvi/6tmZKSV3wOgVvO+v6BJPZgdip2OCu4Z3TZBhDiCagbb9oI
 xi7oxndutMIjYZmKKs9xQbFrmVWd+9L2W5mOFWfkgrz6cu34JNt6Tlbteg7985HX6X6fqA4Q
 qJdAT87LW0759DluAfaQweX6XUSSmoZngNWDgbK8R/2Rpj+vDf0uep7wymaINb5TasoVjS47
 qdkUwHnhSEaPDMk6m7Xi8hwjKVGoBK9ohF03oDZbJ2JOPd4Y6jQZs0RS3ZfUclNVixBGoK8Y
 JUJD+odJuZTso3xq0IToReiGQWgAeXiwSJKiHDrx603y+ovHwHY0gE+AtwAs3rUo9rpO6gPX
 u66zrLFzSnAYv5MxTvx9JTEfxInrPqRXbxwa83RyUw3Gg3fkFqQtZblNC6a2esXtWie8elgX
 v+ohmE9sQFxoSKgxsI2hYnTnY8a0EzE9SFjz4YuP9G3VE96bMeiHZBNuC6UK5F4Tdk+Q2F0p
 ik60LsGtIa0ciYFx5oqxADTZv+HfoWM5h/uWvidLDd4in9heL+xiAu+/FSjx+D9WMe531dHo
 yRKn9TQq3wAyx7e58uHR/Zj+EqqxDiB1wfW6u5eIEA0k7LWK50/zb4qkJocr0DDEjXxmEXsg
 6+bcFgv9Ouw6+n/bbjrp4WQO5F0hwz+KKgihNKzDOYiPgUMX2WX4fqw2KDt8EHjXrlGkOE6n
 rPHvJ3VOcgXvKq0Dg5T340+8RiwFS2m384dnXQfKVJFfw+IgJbxNlHVJfD4Ee+/g1OxkDd33
 /zGPqPuApHKLnXbn7fheK9x61VZyAov1dBT+o9YBqsdL/3tXE/xqMbYDgI8MwCu3+nmCc1x1
 oIYWW2RHq+UKKzfvF6S6u4xI+SBZJUZtCjjJ/Un/fLjj380lUcYfaaz3JsXbH64Hu5hI0Wce
 XfjmM0BEWQQsQo7VuPqkkaPXiRPZ3a2Ra08/Ss3B56nDIvbXICinKSB3DunHp1Rfm1HBFGME
 XPsd4SEQPoMaSSSIsF7kjMeSLeuVZUu2gy0uA/90bpnIfLY+jcEupL7yNh1++rTmAk99TxuE
 cud3GKNT2Fvk2MMRj822r1/oENzyleEzKh4heFXGsZP5/NIVQc6M4TQz+tgC9D9Qg7BZMuGS
 E66QtW6BjE8Vs8+zMUQY0Z8BtqvlQrD0DS3DL8VjbOLGIY4/b7b33j0P8p90WrJ1LE9j1k6R
 ctCLWmmhq959wjOCI/FikaZmLiwdaQawiHN8HyOzXSBvE5GSg58S6bFUm4FZkvQs9v54lnOT
 7i0CbQoKgdB09KNKrNWat31ilVLXPPjONXYY2KslGa8HBmJxr2XbIfxZWUd0zvSCFIenwAQ4
 3mGLw4+CTmlo27ECzxuD13vb1vq8eZlsHy7VFM7zxmWb0190Lq44h4YieSBRPMQ37IEvT8sp
 S17ElmzwdzYF8aNqQx5cKpBZNMy+k1H2n7BugJlJ5KuN69s1RYidFFbtl3v211XC4FMnM4gt
 noswEImJauG0V9pbT6U3ZnsfLbQLz+h0gqobvvu103EmOif/AQMoKAxsVbquQizPkM+93x8l
 dJHhSjPrq7WBRYfBMqiGn088AJ38vSDOnFV2g==
IronPort-Data: A9a23:OMsjZqJzIUtF+xLNFE+R+ZQlxSXFcZb7ZxGr2PjKsXjdYENS0zUPz
 mNKC2/TPa2KMWr8ed5zPoq1pkIGsZOHzNJgGQEd+CA2RRqmi+KeXIjEcR2gV8+xBpCZEBg3v
 512hv3odp1coqr0/0/1WlTZhSAhk/zOH/ykVbOs1hlZHWdMUD0mhQ9oh9k3i4tphcnRKw6Ws
 LsemeWGULOe82Ayazt8B56r8ks14K2r4G5A5DTSWNgS1LPgvyhIZH4gDf7pR5fIatE8NvK3Q
 e/F0Ia48gvxlz8xCsmom6rMaUYDRLjfJ2Cm0hK6jID/6vTqjnVaPpcTbJLwW28O49m6t4wZJ
 OF2iHCFYVxB0pvkw71BDkYCQ0mSCoUdkFPPCSDXXcV+VCQqeVO0qxllJBle0YH1Zo+bqIyBn
 BAVAGllU/yNuw656Ky4CfM8vth8FdSxOJgzqGtn4yCGFPlzFPgvQ42SjTNZ9Dg1w9tLAe6HP
 owSZDxzdgnFJRZdUrsVIM5g2r312z+lKWIe9w/9SakfugA/yCR4yrvkNdPPUtWWQcxO2E2Kz
 o7D1zSpX0FAbIbEodaD2jWop6zX2jj5YoMXTZ+x68JYvAy+x3NGXXX6UnP++5FVkHWWRNNbL
 108+ywgt6E++UWnCN7nUHWQr2SJsR0cc95RFfAq5gaQzKbd/weeAC4DVDEpQNAvqs46bSYn2
 l+Ag5XiAjkHmLmUT2+Ns7SZtzW/PQALImIYIywJVw0I55/kuo5bphbOSMtzVb67lfXrFjzqh
 TOHti4zg/MUl8Fj6kmg1QyZxWjx+96TFFFzuVi/sn+Z0z6VrbWNP+SAgWU3J94ZRGpFZjFtZ
 EQ5pvU=
IronPort-HdrOrdr: A9a23:R7gzI6NQ782rKcBcTsyjsMiBIKoaSvp037Dk7S9MoDhuA6mlfq
 eV7ZAmPH7P+VQssR4b8+xoVJPsfZqYz+8T3WBzB8bAYOCFggqVxehZhOOI/9SjIU3DH4Vmu5
 uIHZITNOHN
X-Talos-CUID: 9a23:DVc20W/zNgZ1gQTxz3GVv1AXWdp1SmGC9WqKJ1SUG3xuZqzKUFDFrQ==
X-Talos-MUID: =?us-ascii?q?9a23=3AlQV2cw2skFreZF+Wl0rgWX1BgzUjpKCPS1hKipc?=
 =?us-ascii?q?8uszdFyVtBwWh3Rm2Xdpy?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.11,259,1725314400"; 
   d="scan'208";a="88582023"
Received: from unknown (HELO gm-smtp11.centrum.cz) ([46.255.227.75])
  by antispam95.centrum.cz with ESMTP; 05 Nov 2024 09:44:31 +0100
Received: from arkam (ip-213-220-240-96.bb.vodafone.cz [213.220.240.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gm-smtp11.centrum.cz (Postfix) with ESMTPSA id B05FA1015FCFE;
	Tue,  5 Nov 2024 09:44:30 +0100 (CET)
Date: Tue, 5 Nov 2024 09:44:29 +0100
From: Petr =?utf-8?B?VmFuxJtr?= <arkamar@atlas.cz>
To: David Hildenbrand <david@redhat.com>
Cc: linux-xfs@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>
Subject: Re: xfs: Xen/HPT related regression in v6.6
Message-ID: <202411584429-Zyna7RpVesXAiTBM-arkamar@atlas.cz>
References: <2024114141121-ZyjWCQr5TJE0JoRT-arkamar@atlas.cz>
 <63b7f241-3340-431b-bf20-1cde551a96b8@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63b7f241-3340-431b-bf20-1cde551a96b8@redhat.com>

On Mon, Nov 04, 2024 at 04:40:58PM +0100, David Hildenbrand wrote:
> On 04.11.24 15:11, Petr Vaněk wrote:
> > I would like to report a regression in XFS introduced in kerenel v6.6 in
> > commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace"). On a
> > system running under Xen, when a process creates a file on an XFS file
> > system and writes exactly 2MB or more in a single write syscall,
> > accessing memory through mmap on that file causes the process to hang,
> > while dmesg is flooded with page fault warnings:
> 
> [...]
> 
> > [   62.406493]  </TASK>
> > 
> > As shown in the log above, the issue persists in kernel 6.6.59. However,
> > it was recently resolved in commit 2b0f922323cc ("mm: don't install PMD
> > mappings when THPs are disabled by the hw/process/vma"). The fix was
> > backported to 6.11. Would it make sense to backport it to 6.6 as well?
> 
> I was speculating about this in the patch description:
> 
> "Is it also a problem when the HW disabled THP using 
> TRANSPARENT_HUGEPAGE_UNSUPPORTED?  At least on x86 this would be the 
> case without X86_FEATURE_PSE."
> 
> I assume we have a HW, where has_transparent_hugepage() == false, so 
> likely x86-64 without X86_FEATURE_PSE.
> 
> QEMU/KVM should be supporting X86_FEATURE_PSE, but maybe XEN does not 
> for its (PC?) guests? If I understood your setup correctly :)
> 
> At least years ago, this feature was not available in XEN PV guests [1].

Yes, as I understand it, the hugepages are not available in my Xen
guest.

> Note that I already sent a backport [2], I should probably ping at this 
> point.

Ah, I haven't noticed this one. It resolves the issue for me in 6.6.y.

> [1] https://lore.kernel.org/all/57188ED802000078000E431C@prv-mh.provo.novell.com/
> [2] https://lkml.kernel.org/r/20241022090952.4101444-1-david@redhat.com

Thanks,
Petr
