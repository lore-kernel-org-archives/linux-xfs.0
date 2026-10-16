Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8FF47FB19;
	Fri, 16 Oct 2026 20:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792182080; cv=none; b=LOoEAnXtf28R7WZXOFETevl81PBFxWPEkynPYFmc8xpgpmnqsgvi8gGGCQTCkKjOrALhZysNgoRRWu/RRofykOli/cZ6WC+tYs5pKOvYnuOhIUkybS97HZT0Tc0ZuWIKWn25iShDmhCc/AsZ0LWKw/r9xfyTH+HnxxznaRtd88w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792182080; c=relaxed/simple;
	bh=skN67QCXS84+xQRyX9AQfKbOS/qSOiIPR4g1Hr9c9wY=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=p6hn9fohBwEbbH/q+MTMUM2lDQfcMKlVjSpeM1Av/BCDMWfBtxntAkleC1Nvi2ZCBVZNlMXj3hTYgRgGKxsXaXiFD+yHMYAVXJVKkvPThxJsrMp35zxIFEKwxQ+oAwbpRwe8ZBwnJ45htJJyirv75Ht3GvGyyVSoXSwRLKHdytc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=VqZ9ONVn; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="VqZ9ONVn"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net C056B40A48
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1792182076; bh=fPrejg45z9y8A3ljxgLP55bOX4u1h+H9Nvby0eN/4PY=;
	h=From:To:Subject:In-Reply-To:References:Date:From;
	b=VqZ9ONVnwUYNSl0pgYFwpbK6FRLz0zxJarKaff/GPQ4iMTQhrBKXmoPg+axPCuomz
	 D/TsFjFHCErVjqXrZyjVeN3xPhYvWJw/U10ouP3b9HRQ4YsUxcePQ+VIljbk6pY5A9
	 Y1IHIGZ1y1A8sAjmoZH7lrpb8J8PmycwLnkzlhQiz2I06M1TpW/sUfUJn8iyPKsLeS
	 84HNK+6kG+e7H5U3LxaAmEB8XB/g7z6rhK2IhdLfi7yPKWHfcxs1/QXjBpMs929b4R
	 +ajujzAZAWM18jnFtTqBee24uCPMS5yYUcjrJTaqaHj0h749d6te7s6xIoIpomPLK/
	 cHOnp3Hl0Pa8w==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id C056B40A48;
	Fri, 16 Oct 2026 20:21:15 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: "Darrick J. Wong" <djwong@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
 linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel
 <linux-fsdevel@vger.kernel.org>, fuse-devel <fuse-devel@lists.linux.dev>,
 fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>
References: <20261016160037.GA107919@frogsfrogsfrogs>
Date: Fri, 16 Oct 2026 14:21:15 -0600
Message-ID: <87se25mm6c.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Darrick J. Wong" <djwong@kernel.org> writes:

> Hi everyone,
>
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.

You'll be missed.  I hope the break is refreshing and restorative!

jon
