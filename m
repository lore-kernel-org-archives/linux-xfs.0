Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590DC76C8F
	for <linux-xfs@vger.kernel.org>; Fri, 22 Mar 2024 19:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711134148; cv=none; b=GosdFjrMHvGtBn1YuKBSiPjUxDh9uU3Thbmy9VSy7/hPtoc58ragclw/ut6BXBage9s38xqstpLiwjv8HLq97rDoMcv+jBWtZmyH+4QL39stZSgGUwowLzqFqbTrEQxK4QFXt7yUaUBi9tqhXYSXuQgEiT4rrcI0JK5nj5H1H+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711134148; c=relaxed/simple;
	bh=GYEpNvhLStcQP443XLsE579O8tjzBs4neAp+UAc0bfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ak7CdPERTJC2Ow5ixp0byuWPjFfDKJR2DMH/KlH5IwkJ7UlfVEGhCw5g7fU+Dg5/3tLc/XMK7soOQ5J3jgMDtbaR/NQ88E1xIiTTsZte5TtU6opm1KweBs2JbFbhsIY+iL9boCMOGEyTJHHKBeaNC3bkUcIJqlfZzbv2xrzDsSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=ttrfOB1q; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="ttrfOB1q"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id E9CEF1235;
	Fri, 22 Mar 2024 13:56:48 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net E9CEF1235
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1711133809;
	bh=aLS8O8iUWtsqlB7+uIvhyNaa9eWIyrFWUbjCbuyl+Zc=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=ttrfOB1ququb/5oeoH76hPjslB1yjycQSm6ZiAcOQ/VWEOFop1TjWBcFGte4uCi/8
	 dtJJYKLQk5MJ+Q3Mrxwy+BvsHv20zcDfbwVRHsxTUcUpvm7+Qx1VBS87HB65tDDQiA
	 XrO7f4sG6eRQDKiCk/D35zpdl6PVo4xB2IAJPquz0ao0JxQ+yU5k5ttzv8gw8NtMQQ
	 NLSxvozW8XXAn2aWZU9+E0Te9x/wDvHns7DlqZRJ3u1bEwgs/cS97pD2C+1ueA+Wc4
	 NSi09D4NfbMRH8u5/BBNWn4rxPnlY1IMONMd3ZYD9hMtndyl0YJLCQDmzGR30pQpWL
	 XR3QHO/UGWiNA==
Message-ID: <934595be-7768-4193-9137-d00f183ea712@sandeen.net>
Date: Fri, 22 Mar 2024 13:56:46 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: XFS: shrink capability status
Content-Language: en-US
To: SCOTT FIELDS <Scott.Fields@kyndryl.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <CY8PR14MB5931A9E3FFDF1984EC556CE48A322@CY8PR14MB5931.namprd14.prod.outlook.com>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CY8PR14MB5931A9E3FFDF1984EC556CE48A322@CY8PR14MB5931.namprd14.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/24 2:00 PM, SCOTT FIELDS wrote:
> 
> Is there any current line item for working to get XFS filesystem shrink capability implemented?
> 
> With the basis of the Stratus project (Red Hat's solution to ZFS in many ways) depending on XFS, having the ability to shrink a filesystem is more pressing...imo.

It's actually a bit less pressing, because stratis uses thin
provisioning by default, and so actual disk space behind any
given filesystem is fungible.

That said, the beginnings of shrink are actually already upstream,
but there's still quite a lot of work to be done for it to be
generally useful.

-Eric

> Scott Fields
> Kyndryl
> Senior Lead SRE
> 

