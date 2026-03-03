Received: from mslow3.mail.gandi.net (mslow3.mail.gandi.net [217.70.178.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF72736074A;
	Tue,  3 Mar 2026 16:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.178.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772554102; cv=none; b=rUE4hMIGqG1ivIuVhhSIzdYVEwrIWnHWDxkEyhZrjv6tqngCW09dPaVAe33i51l7wfKhRJg9WU/qP73fZ1pGIixp9TsQ5ez20CloyGxU7uleYfYzbdiiNLG2Rx4RytsBDAGkcI3KxakGsPoSSW27F4kHAAcqw9QQ5fihuaen9UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772554102; c=relaxed/simple;
	bh=F6SYLE5s6Vuo/tkDR+UcIuu7X0TW/wDC6kBLP7ZGYIY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QlMDD1QdTltXuwtVShrgAFRN3uODSZqT7QxJ8jEuv/pGMKq/BxH0/DRZrsdVOJy8sjTQl7dRmZg+7f0SKeTWhR/0cUmejMMZAlQgPv+UhW4vYeUTl/JbmEyM7hCh16Xyx6Xbt2PXLc7f/tDUB+LD7/tzl/X1T923bG2TC4qh6xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=krisman.be; spf=pass smtp.mailfrom=krisman.be; dkim=pass (2048-bit key) header.d=krisman.be header.i=@krisman.be header.b=VGHXMUv9; arc=none smtp.client-ip=217.70.178.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=krisman.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=krisman.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=krisman.be header.i=@krisman.be header.b="VGHXMUv9"
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by mslow3.mail.gandi.net (Postfix) with ESMTP id E5A705818AB;
	Tue,  3 Mar 2026 16:07:03 +0000 (UTC)
Received: by mail.gandi.net (Postfix) with ESMTPSA id DD54344212;
	Tue,  3 Mar 2026 16:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=krisman.be; s=gm1;
	t=1772554016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5lztja5NAdFE/b8sWmE4dvLme1OLSdhLs+KALNRIMcI=;
	b=VGHXMUv9ehci2l5CrbeLC+iWhgr3FUfZu1W7aNMRDlW7jHcL45aeoPUNYED8mYQnHaMhxy
	JGuDd+UyA2wP/VscuZwKM0JsPqyYq60oLqojE7nTwrqOZoIz7NTob2swRG5UbzU4aSN4oz
	UITK7cXxLLlGY1SaUTX1sVGtX9PDf/S7alEB3UnEReeDvIZIR0fGG98WoLCFsFgTqjXCz5
	eRJMm80RXNsMD0nPcNOxe9bV4N8DfgkWqfv9pbZ6D6FUIqdRL3eIqZ0prxi98bd8PIj6W7
	KmfhcQdeHuJYhzgrBK7QZuMJe8d5BTwujcLPGmk1heqqQIMuDFkAGvn/59WifQ==
From: Gabriel Krisman Bertazi <gabriel@krisman.be>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,  zlang@redhat.com,
  linux-fsdevel@vger.kernel.org,  hch@lst.de,  amir73il@gmail.com,
  jack@suse.cz,  fstests@vger.kernel.org,  linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
In-Reply-To: <aab2JbAZI8RFq_XE@infradead.org> (Christoph Hellwig's message of
	"Tue, 3 Mar 2026 06:54:29 -0800")
References: <177249785452.483405.17984642662799629787.stgit@frogsfrogsfrogs>
	<177249785472.483405.1160086113668716052.stgit@frogsfrogsfrogs>
	<aab2JbAZI8RFq_XE@infradead.org>
Date: Tue, 03 Mar 2026 11:06:52 -0500
Message-ID: <87ldg83nj7.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-GND-Sasl: gabriel@krisman.be
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddviedutddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufgjfhffkfgfgggtsehttdertddtredtnecuhfhrohhmpefirggsrhhivghlucfmrhhishhmrghnuceuvghrthgriihiuceoghgrsghrihgvlheskhhrihhsmhgrnhdrsggvqeenucggtffrrghtthgvrhhnpeffgfevieeuvdfgudeviedvjeevfedvkedvgffhhffhfeethedvveefhfeuudfgteenucfkphepuddtjedrudejuddrudeftddrvdefvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedutdejrddujedurddufedtrddvfedvpdhhvghloheplhhotggrlhhhohhsthdpmhgrihhlfhhrohhmpehgrggsrhhivghlsehkrhhishhmrghnrdgsvgdpqhhiugepffffheegfeeggedvuddvpdhmohguvgepshhmthhpohhuthdpnhgspghrtghpthhtohepledprhgtphhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeiilhgrnhhgsehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohephhgthhesl
 hhsthdruggvpdhrtghpthhtoheprghmihhrjeefihhlsehgmhgrihhlrdgtohhm
X-GND-State: clean

Christoph Hellwig <hch@infradead.org> writes:

>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright 2021, Collabora Ltd.
>> + */
>
> Where is this coming from?

This code is heavily based, if not the same, to what I originally wrote
as a kernel tree "samples/fs-monitor.c" when I was employed by
Collabora.  I appreciate Darrick keeping the note actually.

>
>> +#ifndef __GLIBC__
>> +#include <asm-generic/int-ll64.h>
>> +#endif
>
> And what is this for?  Looks pretty whacky.

Comes from kernel commit 3193e8942fc7 ("samples: fix building fs-monitor
on musl systems") to fix building with musl.  We don't need it here.

-- 
Gabriel Krisman Bertazi
