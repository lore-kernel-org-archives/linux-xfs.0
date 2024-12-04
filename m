Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDD5194AD1
	for <linux-xfs@vger.kernel.org>; Wed,  4 Dec 2024 21:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733349054; cv=none; b=Ytowo+i/hbn3tHa8iWuL6oT+6Szr3bzqnnYzc/EGnIjUgeFY0lAldE+UL/nqSmjRrgc6AvCJkOn/6GfuyqazqpHFiVA/13nJ2cmZD+p4SupkzHG4ohYhGxFVDqcvqtr6aM8GuG94EUYyeTCIElauNWnaerCBApj5aXoKu7fi6f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733349054; c=relaxed/simple;
	bh=LvBBZFBV2tkL0r5lI0qCWkiRpV1sTY6CAWCVG7iy9L0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jhtU+ruHbfVydXxI8jdEeblqevem0VTqX4oeIiteAaGIEpBDv9EnJyJOZmjwxW1IC2+6bkXgBak69uwURFKwxbdQN5aD3ynBIBONRWxwX2g+QRxLo+ddrI4E4WvNyEodYYwisfW5x38CDZ4cj+DeydxQy1919I47WhiXGPr5VKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=IrItn+38; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sgRDbL8i; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="IrItn+38";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sgRDbL8i"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id C555A13806F7;
	Wed,  4 Dec 2024 16:50:51 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 04 Dec 2024 16:50:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1733349051; x=1733435451; bh=thyJvUUMAe
	FE23BnrytLTD3a4GCsP5aJmet0PA+uyYU=; b=IrItn+38eWw5BK0lRT7Z2X3X+H
	+V5HxkTyf7kVner6cmjAUXR5lP7YbxKMluVaKx/3iERAo64VwYFOUKUMOR3hLCDu
	7O0i4PWQ3EIVc9dbH0PMY48E0Xx/o4WIwws9pwf8Ib1M5EEtmqjqpM9NEjrhqJbq
	tlSzVlYxFqTGFKdwXdUaLVxd2RC67NP6XNOlwyJWnggFOYR25umSDhBECQd+EhW7
	XJ/U8W27QrBAdV7RCsdswsYa9Pdg6ckfFQyaM7VsGwEG9TI8wlMXlX18Ld8BW+8G
	lidBdjUdteqROQaTDyVjPOIoFN1BgztE9mNVHyd56w8OCJpwg+R8YmdB5Ydg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1733349051; x=1733435451; bh=thyJvUUMAeFE23BnrytLTD3a4GCsP5aJmet
	0PA+uyYU=; b=sgRDbL8ip2/GuwkyWhT9sv78vNWU/c7PqUKLG8zRJ6F85LCRisu
	cFIXxpFyQeeg7UQkKdoZ1kvQAI1cG4Vu6eaeYgUz8sRZVEOXUM7sHUhfNeQMCPEj
	lM26A0vwFTVKvflau4RtU3v77H4mRNa1bj+DXzwvv5bEBRk3sk2Ma0fjlJ21/90K
	iPYOBO20vpC+SxvI66JEQHfvS7Ulecx+NRh0jFbmfR0sJpsLd61vZZc2wDfTm/l+
	hGLdCPA1EX2uNo2oCF86otFYMHFGepjXxff5F3cTDpaf2uYMkzJukRWaxeakfmGJ
	PPZocZbU6XRCgs+yk0eb8BOuQH/X6omKT3A==
X-ME-Sender: <xms:u85QZxe2OfuEYcztBtgM8uySsfwH6PG6bValIHM-it2v9ILftCksWg>
    <xme:u85QZ_NNVejf0Ed2dsk2ksAavYjdppkBtNaVUc2XA6ty6Sd8QZHqNE6PLEeI43AKU
    LRzLfgacNS--POCnQ>
X-ME-Received: <xmr:u85QZ6javh0RSva1wH4pQtivLobEv17otdMj91rP4P0a2eWtqTDOryI51N-R90ZUYQUCvItFvodYRs7gZhlQw6OyTFr-BGHIwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieehgddugeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujggfsehttdfstddtreej
    necuhfhrohhmpeflrghnucfrrghluhhsuceojhhprghluhhssehfrghsthhmrghilhdrtg
    homheqnecuggftrfgrthhtvghrnhepveehvdfhkefhueeitddtgffgfeetjefggfetledu
    vdeggffhueehgefhkeekkeffnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjphgrlhhushes
    fhgrshhtmhgrihhlrdgtohhmpdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheprggrlhgsvghrshhhsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:u85QZ691eapWIHXNUUL2A597lSyRjcNgVWIeIyvW91qAFBlLyT26Tw>
    <xmx:u85QZ9sZCjEizqC1EME46LyJFW4BhmJyVjKtvhkEyIV-LCfolcVCow>
    <xmx:u85QZ5FgUjX9hGCYkMsbo6Rqo49w6cWsQ4FtzexjRRrKvJLMWLNUUw>
    <xmx:u85QZ0P1Hu1Beg66S2W01DaE7qopF3V5_tcS-k3-WuW7xT8tjfB8qg>
    <xmx:u85QZ25nzhbtOIw0jKMC0Hbl8TdJCOTdgB1vGJqg3c6fkXrT6oQsNRO7>
Feedback-ID: i01894241:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Dec 2024 16:50:51 -0500 (EST)
Date: Wed, 4 Dec 2024 22:50:49 +0100
From: Jan Palus <jpalus@fastmail.com>
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs v6.12.0 released
Message-ID: <z34jlvpz5wfeejc4ub2ynfcozbhdvzp3ug2eynuepfkqlhlna5@fpuhaexfm24h>
References: <vjjbmzy7uhdxhfejfctdjb4wf5o42wy7qpnbsjucixxwgreb4v@j5ey2vj2fo4o>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <vjjbmzy7uhdxhfejfctdjb4wf5o42wy7qpnbsjucixxwgreb4v@j5ey2vj2fo4o>
User-Agent: NeoMutt/20241114

On 03.12.2024 11:10, Andrey Albershteyn wrote:
> Hi folks,
> 
> The xfsprogs repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated.
> 
> Patches often get missed, so if your outstanding patches are properly reviewed
> on the list and not included in this update, please let me know.
> 
> The for-next branch has also been updated to match the state of master.
> 
> The new head of the master branch is commit:
> 
> 90d6da68ee54e6d4ef99eca4a82cac6036a34b00
> 
> New commits:
> 
> Andrey Albershteyn (1):
>       [90d6da68ee54] xfsprogs: Release v6.12.0
...
>       [bc37fe78843f] man: document file range commit ioctls

Note there is a small issue in this release -- ioctl_xfs_commit_range.2
man page is never installed due to how INSTALL_MAN works:

- for man pages that source other page, like ioctl_xfs_start_commit.2,
  it is copied as is with same filename

- for mans with .SH NAME section, like ioctl_xfs_commit_range.2, it will
  use first symbol that follows this section both for source and
  destination filename, which in case of ioctl_xfs_commit_range.2 is
  ioctl_xfs_start_commit

Effectively ioctl_xfs_start_commit.2 is copied twice and is broken since
it points to non-existent man page. Swapping symbols in .SH NAME section
is one workaround:

@@ -22,8 +22,8 @@
 .\" %%%LICENSE_END
 .TH IOCTL-XFS-COMMIT-RANGE 2  2024-02-18 "XFS"
 .SH NAME
-ioctl_xfs_start_commit \- prepare to exchange the contents of two files
 ioctl_xfs_commit_range \- conditionally exchange the contents of parts of two files
+ioctl_xfs_start_commit \- prepare to exchange the contents of two files
 .SH SYNOPSIS
 .br
 .B #include <sys/ioctl.h>
