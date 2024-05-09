Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519A3130487
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 10:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715251870; cv=none; b=Ij6fHIZ7cWF3HL60+b8XNI6G9b8BHgC/8RCjyFTMPcsdePiZSNOWMaJ7kLdkaO5yKSCnu4qxAMnOXC2OjrM7AbIl+5Mms9BA5c9V8bWGxCZPbxteBGI8UvJ6SYQ3l/foym9UZJoUAsIZZZUJ64cY6u24LOfEjVZL+/e4VhYD+M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715251870; c=relaxed/simple;
	bh=RPgYgOcyR4qNUpaYqcxV35eI22ZcGa00oAAGJ0opUYs=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=bt0/ydFSEdKSNFL+lKZe69ZAfv+uBKwTA8K8TWiflEs2x1hUkib5JmC8vE8T0LtRURU/rzSeWh8izrRYzZnLy/43scYL5cafgCEMSjFKIyjEWmcjWr6NCIX5bjNoGSQEMVbluIkzm4CvXiue5ZEUh6kZ1gaZSWvOEFm9drJb9DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=rVCidKwN; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="rVCidKwN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=RPgYgOcyR4qNUpaYqcxV35eI22ZcGa00oAAGJ0opUYs=; b=rVCidKwNfJS3KjeR2s2UXoRuTr
	wkAdGQl9s5mLYafHM+5YP7QgoZ9rPtCuxuQ4NNwCjS/zgMlrW6JWNDVzEgixpC026QiXhR1Ayrf3j
	qXjrD2JgMcU2UEatdwprCY76RAHWg2qFaiPMbDpfN+EJ0n7uLN6z17SqQm6y07R2YPkpKJYrFP129
	En6HOcs0q9fdH7LUkRj6+Pl6gyLew5Mqc9iLzwxy1E5QtZjnKlcdx0tGZ7yshRcDWYvyO0EH2LyKu
	pkFVHJaj5vvWxj/wI61nHLqHJnk2Y2uj2AaTm5WHX45n9Ll3W4EgeLFmluA8hBA0CvRIkHgQQejLY
	v2zHHw8g==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1s51Md-005ELj-Hx; Thu, 09 May 2024 10:51:03 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From: "Debian Bug Tracking System" <owner@bugs.debian.org>
To: Philip Hands <phil@hands.com>
CC: linux-xfs@vger.kernel.org
Subject: Processed: your mail
Message-ID: <handler.s.C.17152516831244576.transcript@bugs.debian.org>
References: <87jzk3qngi.fsf@hands.com>
X-Debian-PR-Package: xfsprogs-udeb
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Thu, 09 May 2024 10:51:03 +0000

Processing commands for control@bugs.debian.org:

> tags 1070795 + d-i
Bug #1070795 [xfsprogs-udeb] xfsprogs-udeb: the udeb is empty (size 904 byt=
es) so does not contain mkfs.xfs
Added tag(s) d-i.
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
1070795: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1070795
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
