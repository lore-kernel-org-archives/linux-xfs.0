Received: from smtp-in-1.gedalya.net (mail.gedalya.net [170.39.119.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1879131326C
	for <linux-xfs@vger.kernel.org>; Mon,  4 May 2026 10:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.39.119.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777892197; cv=none; b=aXBD7EJplddpK2hOfm6mgmGxmiUGLmpWPsBxpQC3VsVzYSk1o+NoUPP63UpwwqbLxYPyPAXvt4RnmbMkF1zsBw0bWw/9THiO1R3K/JOX3FwooTxvTBerciM61L4Z1zNuzlaJZdYyn0ONDG0eUc7TAT9/38KJrJ/RacHYbrJ8Zbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777892197; c=relaxed/simple;
	bh=qNEF6v/G+wJxfNuUt+vg9w9qb31a8IEeqtWl4/Ok3KE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=UwlvlOUCml38tVblFTUigLF0IzoPs0NTTzuGJmMNbHVa+v2M2CH5tEbXz3KD44TLsiM6j6QTwaGRG5RNe8CdmsL+Fflm5rj4nqhmH9el2ncneZGwUTrf/dXtypgjbcnmFxE+qKC0+J9DJNldzqjDjq/4Sy9tvVd2iWX2lT0oANY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gedalya.net; spf=pass smtp.mailfrom=gedalya.net; dkim=pass (2048-bit key) header.d=gedalya.net header.i=@gedalya.net header.b=m3KXFN0y; arc=none smtp.client-ip=170.39.119.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gedalya.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gedalya.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gedalya.net header.i=@gedalya.net header.b="m3KXFN0y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=gedalya.net
	; s=rsa1; h=Content-Transfer-Encoding:Content-Type:Subject:From:To:
	MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description; bh=qNEF6v/G+wJxfNuUt+vg9w9qb31a8IEeqtWl4/Ok3KE=; b=m3KXF
	N0yjdxN4/3d4UTDbCBoIF593CTnsDm0obczYvpc2DL6rYD3Wck29A+Ku+F58iWaUIku6QEvfkSF9A
	1CIAo1FKZ/13Hx1czqxV22X93hKLqtXmMyLqvh3unxIR7e38WKc7e3BZUPqUX35z8jypoHl1fkxnb
	LV8t1oH5PgWw560JiEMxmbynf6MSj5+HJC5ZQuSZ+7hNqI1JNDktEToaT8gLs1ZutxMM6usY5ytLf
	7gyaVmyL7yRr0/hb6UGgNyoguyCs26fcxH/I+WjfR0Ogln1NMSGNmtg2dp9dZzxVxFqSuyZnUTa4Y
	+S2NKplLToXNhqUBNhf2i46tv6awA==;
Received: from [192.168.9.10]
	by smtp-in-1.gedalya.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <gedalya@gedalya.net>)
	id 1wJquK-00000004MYB-0QqB
	for linux-xfs@vger.kernel.org;
	Mon, 04 May 2026 10:52:12 +0000
Message-ID: <8961ee4a-3830-498b-a432-5545695db599@gedalya.net>
Date: Mon, 4 May 2026 17:52:09 +0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-xfs@vger.kernel.org
From: Gedalya <gedalya@gedalya.net>
Subject: xfs_scrub: UNICRASH_BIDI_MIXED
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

xfs_scrub looks for file names mixing right-to-left and left-to-right characters. However, it is rather unrealistic for a file name to contain only right-to-left characters.

First, well-known file name extensions are not internationalized. While the file name can be in non-latin letters, the extension will be in latin. Hence you would expect to see file names such as עברית.pdf .

Even if we consider file names without an extension, or if we exclude the extension from the test, a file name can be, for example, a title of an article, as when you save a web page as a PDF file. In non-latin texts, titles, or sentences in general, often contain words in latin script. Technical or scientific terms, or names of published works, and many other things are often written in their original latin script. Whether the file name was suggested by software or manually written, it would often contain an RTL/LTR mix. This is entirely normal and not problematic in any way. To a user of an RTL language, a requirement to avoid any LTR characters seems utterly bizarre.

I don't know what the original motivation for this test was. Perhaps it can be entirely removed. If not, then perhaps it should be possible to disable it, or perhaps it can be disabled by default.

As it stands, a systemd timer is shipped which runs the scrub periodically which should exit cleanly. But I have it reporting useless warnings, and sending an email about that.

Thanks for your consideration.

Gedalya


