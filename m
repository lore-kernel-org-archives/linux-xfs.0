Received: from gmmr-4.centrum.cz (gmmr-4.centrum.cz [46.255.227.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393371D040B;
	Tue,  5 Nov 2024 09:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.227.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730798860; cv=none; b=oeSVQYf4cbKu/Frp97HUtAOGPwrF/SEKBOMp+tFauT4RHT1HvoruopcFYKuSfE2WM2CCImu9WAlI5neyqi+pLYh26POcOmCQm8Y7R52XRf8WdnZpOngxzmXO3RYVh08PNmhzSyBOje1CxudBwY4m5/A5weGOKMsUfZ8Eg+lv5/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730798860; c=relaxed/simple;
	bh=JSHFHZSGnbrGaCOZClJ9s38M76+XA809XKv7+1kWT8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q5YtbXs1csmNf4bYz4nPDjvJ4uPRU50yd8HpG0pi9cWabBQSWx7LA6m9W+gkV3a9/UHv8nJ2dxK16mM9b3Jgz5KRjj4XItq0WEoqSfgBPResSLjn9iJk9GELfFIAFxnU6wR7/O6+ciHl2gLC64kSJ2a+1b8XiHWJyqUr1Ndx+mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atlas.cz; spf=pass smtp.mailfrom=atlas.cz; dkim=pass (1024-bit key) header.d=atlas.cz header.i=@atlas.cz header.b=cAeumkLW; arc=none smtp.client-ip=46.255.227.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atlas.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atlas.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atlas.cz header.i=@atlas.cz header.b="cAeumkLW"
Received: from gmmr-4.centrum.cz (localhost [127.0.0.1])
	by gmmr-4.centrum.cz (Postfix) with ESMTP id 8906E4B34;
	Tue,  5 Nov 2024 10:27:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=atlas.cz; s=mail;
	t=1730798854; bh=Zh5NaP9DoUAhSs5KOhgU1QXVHVMBkSsfoS+iLptkMUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cAeumkLWJNN2xnyCMI3fuCnZXaw/z+Isi1jdg0vPVh6NkFBF+9mvWJU7bcdfwGoKY
	 panaRAC86pBHp9AZvD9tACbICcBCkUSwagWRqrUqlAcT8jZMWkVOJO8lsjEijMEF1n
	 bBrUTSVbL3C860EcUkHL3PpD5oHecrz/I4g57+3A=
Received: from antispam29.centrum.cz (antispam29.cent [10.30.208.29])
	by gmmr-4.centrum.cz (Postfix) with ESMTP id 79979200D91C;
	Tue,  5 Nov 2024 10:27:34 +0100 (CET)
X-CSE-ConnectionGUID: 9CUH/m/PTzabEO9Low0X8w==
X-CSE-MsgGUID: CPKpUBMGT0Gw1yU3vMcUVA==
X-ThreatScanner-Verdict: Negative
X-IPAS-Result: =?us-ascii?q?A2EVAwB75Cln/0vj/y5aHgEBCxIMQAmBPwuJe5Fxi3WGN?=
 =?us-ascii?q?YEghACGS4F+DwEBAQEBAQEBAQlEBAEBhH0KAoo1JzUIDgECBAEBAQEDAgMBA?=
 =?us-ascii?q?QEBAQEBAQENAQEGAgEBAQEGBgECgR2FNVOCYgGEAAEFIw8BRhALDQsCAiYCA?=
 =?us-ascii?q?lYGgxSCMAE0rxyBMhoCZdxvAoEjYYEqgRouiEwBhWgBhHdCgg2EPz6BBQGHG?=
 =?us-ascii?q?IJpBIJHhR8liRWXY1J7HANZIAERAVUTFwsHBYEpJCwDglJ/gTmBUQGDH0qDP?=
 =?us-ascii?q?YFeBTcKP4JKaU06Ag0CNoIkfYJQhR2BCwODYoRsfR1AAwttPTUUGwajCYN3x?=
 =?us-ascii?q?jODHIEIhE2KH5JtM4NxE5NlA5JhmHepIoFoAYIUMyIwgyNRGY5Hx3SBMgIHA?=
 =?us-ascii?q?QoBAQMJgjuNS4FDCAEB?=
IronPort-PHdr: A9a23:+r+RbhTRI3T7tFeVS5DQsKr7tNpsotCZAWYlg6HPa5pwe6iut67vI
 FbYra00ygOSBcOBuqIP07GempujcFJDyK7JiGoFfp1IWk1NouQttCtkLei7TGbWF7rUVRE8B
 9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUhrwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9I
 Ri4sQndrNcajI9hJ6o+1hfErGZDdvhLy29vOV+ckBHw69uq8pV+6SpQofUh98BBUaX+Yas1S
 KFTASolPW4o+sDlrAHPQwSX6HQTS2kbjBVGDRXd4B71Qpn+vC36tvFg2CaBJs35Uao0WTW54
 Kh1ThLjlToKOCQ48GHTjcxwkb5brRe8rBFx34LYfIeYP+dlc6jDYd0VW3ZOXsdJVyxAHIy8a
 ZcPD/EcNupctoXxukcCoQe7CQSqGejhyCJHhmXu0KM00+ovDx/L0hEjEdIAv3vbsMj6OqgQX
 u2u0KnFzi/OY+9K1Tvh6oXFdA0qr/GWXbJ3dMrc0VMhGB3ZjlWKtIfqMCma1uITtmiY8uFtU
 vigi3Qkqw5rpzig3N0sh5LTiYIJzlDL7z55zJwpKty5UUN2Z8OvH5RMuS+ALYR2Xt8iTH9yu
 CY80rALpZG2cScFxpopwxPSaPyJfoaH7B79VOucLit1iG94dLyxmRu+70itx+ziWsWo0FtHr
 DZJnsXPu30Q1xLe98iJR/1g9UmiwTaCzw/e5+BeLUwqlafWK4QtzqAumpcRq0jOHC/7lF3og
 KOLeEgo4Pak5/r7brn8uJOROJN4hhv6P6kvnMG0HP42PRIUX2eB/OSxzLjj/UrkT7pUlvA2i
 azZsIzCJcQcu665HxdZ0oY95Ba7CDeryNsYnXweIFJefRKHk5DpN0zTLPziEfiwnVKskCtxx
 /DbO73tGInCL3nbnLfge7Zy9VJcxRI8wN1e/Z5YFLEMLfLpVkPvqtDVDAU1Pg60zur/DdVyz
 IIeWWaBAq+DN6PStEeF6fg1I+mPfoAVvSzyK+I+6vH0kX85nUUSfbKz0ZQLaXG0Bu5mLFmBY
 XrwntcBFn8HsRA4TOP3kl2NTzBSa2yuUKI74TE7EJypDZ3NS422nLOB3Tu7HodXZmFJEFyDD
 XDod4CcV/cWdC2SOtNhkiADVbW5RY4h1BWutAv6yrd8L+rU/CMYtYj529do+eLcjww9+SZzD
 8SH3GGBV3t0kX8QRz8qwKB/plRwyliZ0admjPxYFtxT6uhNUgc7M57c0uN7C971WgLceNeGV
 UypQsmnATE2SNI92dgOY1xyG9m6lBDMwzKqA6MJl7yMHJE777jT32bwJ8lg0HvGzrcugEQmQ
 sRVKW2qnLJw9w/WB4LRiUWWi76qdbgA3C7K7GqDyWuOvEdFUA9/SKnFXm4QZlHQrdvn4kPPV
 KGuCbs5PQtb08KCKbVFasfvjVpYQPfvItPeY3i+m2uoHxaH2quMbJb2e2UaxCjdDEkEkwYO/
 XeJLAQ/CSmho3nFATxwGlLgfVns/fN9qHylVE80yR+Fb0l727qy4B4ViuSQS/UI0b0coicut
 y10HEqh39LRE9eNphJtc7hfYdM85VdKzXrXuQNzMZK+M65vmlgQIExLuBbH0RltB5oIus8tt
 H4whF57L66C3UwHfDSfxZ3qYZXcK3Xo/QDpYKnTjALwytGTr58C9O5wlVzlHwLhQkM48Hxi2
 sN92meY746MBxhEAsG5aVo+6xUv/+KSWSI6/Y6BkCQ0acGJ
IronPort-Data: A9a23:byanXK8b1j6pxdWFNzyYDrUDSX+TJUtcMsCJ2f8bNWPcYEJGY0x3m
 mEYWzqGa/reajCkKNp1bIjn808D68CEm4AxGgI+qy9EQiMRo6IpJ/zCdxutYHnCRiHgZB89s
 59OOoGowOQcFCK0SsKFa+C5xZVE/fjVAOe6UaicZ30ZqTZMEE8JkQhkl/MynrlmiN24BxLlk
 d7pqqUzAnf8s9JPGjxSsvvrRC9H5qyo5GpB5gFmP5ingXeH/5UrJMNCTU2OBySgKmVkNrbSb
 /rOyri/4lTY838FYvu5kqz2e1E9WbXbOw6DkBJ+A8BOVTAfzsCa+v9T2Ms0MS+7uR3Q9zxC4
 IklWaiLdOscFvakdNI1CEAETn4kbcWqz5ecSZS3mZT7I0Qr6BIAyd02ZK09FdVwFuqanQiiX
 BHXQdwARknrug64/F60YrhHu+RkKY7TAJEWsFxHnBXeEq4WEY+WFs0m5fcAtNsxrs9LWO3be
 9JAMHxkYRLceQBKfFwFYH48tLv2wCOiLnsC8g3T+vdfD2v7lWSd1JDkKtncf9WQbcxJmk+D4
 GnUl4j8KktEZYXGkGrbohpAgMfkpQDjZag3O4Hg2eEzkWDI2EkYNSM/AA7TTf6RzxTWt8hkA
 0US9jAjsu4580uzQ8Omdxa5vGSFrlgXXN84O/I77AWc4qvS7RyQCmUNQnhGctNOnMAsSDMp1
 neNntX0FTJorbuZQG6c8bHSqim9UQAZJHEDaQceQAcF6sWlq4Y25jrLT9B+AOu2g8fzFDXY3
 T+Htm49iq8VgMpN0L+0lXjDgjSxtt3ZQBUd+AraRCSm4xl/aYrjYJangWU39t4ccsDDEwTH5
 iJb3ZfDhAwTMayweOW2aL1lNNmUCzytbGWB0DaDw7FJG+yRxkOe
IronPort-HdrOrdr: A9a23:R8wVVqNkvOoAssBcTsyjsMiBIKoaSvp037Dk7S9MoDhuA6mlfq
 eV7ZAmPH7P+VQssR4b8+xoVJPsfZqYz+8T3WBzB8bAYOCFggqVxehZhOOI/9SjIU3DH4Vmu5
 uIHZITNOHN
X-Talos-CUID: =?us-ascii?q?9a23=3A+KkLnGtn7iZf0aSUHV1Wo4236It0WUD9i3KXG3O?=
 =?us-ascii?q?qAGxEb+yxTkDIyPN7xp8=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AH2v6dA8g+DOGfu1Hi4xnmpeQf+xQwLyTImUirc0?=
 =?us-ascii?q?ppJCVCHduHjygsh3iFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.11,259,1725314400"; 
   d="scan'208";a="269111868"
Received: from unknown (HELO gm-smtp11.centrum.cz) ([46.255.227.75])
  by antispam29.centrum.cz with ESMTP; 05 Nov 2024 10:16:05 +0100
Received: from arkam (ip-213-220-240-96.bb.vodafone.cz [213.220.240.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gm-smtp11.centrum.cz (Postfix) with ESMTPSA id EB4491015BC69;
	Tue,  5 Nov 2024 10:16:04 +0100 (CET)
Date: Tue, 5 Nov 2024 10:16:03 +0100
From: Petr =?utf-8?B?VmFuxJtr?= <arkamar@atlas.cz>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: david@redhat.com, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	willy@infradead.org
Subject: Re: xfs: Xen/HPT related regression in v6.6
Message-ID: <20241159163-ZyniUyCdoAYdWpG2-arkamar@atlas.cz>
References: <202411584429-Zyna7RpVesXAiTBM-arkamar@atlas.cz>
 <df10f269-0494-46d9-be8f-7e5dc9cd3745@citrix.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df10f269-0494-46d9-be8f-7e5dc9cd3745@citrix.com>

On Tue, Nov 05, 2024 at 08:55:17AM +0000, Andrew Cooper wrote:
> >> At least years ago, this feature was not available in XEN PV guests [1]. 
> > Yes, as I understand it, the hugepages are not available in my Xen
> > guest.
> 
> Xen PV guests are strictly 4k-only.
> 
> Xen HVM guests (using normal VT-x/SVM hardware support) have all page
> sizes available.
> 
> But lucky to find this thread.  We've had several reports and no luck
> isolating what changed.

I am happy to hear that :) It was partially my intention to inform
others because I spent some time isolating it.

Cheers,
Petr

