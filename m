Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE86E156661
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 21:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724792983; cv=none; b=KQREexAwySmMrOL5Mp1kY8uUWKKbwjpeelReY9dlCOjNZyfGHqQUakkJ+lwBtQIdUBh4Kz4oGNRbLmRBPrtNI5nY1GnYylUFdxdO7WTW0SBCRxTUHwWka7PQGajIFP8pbVNwDRkN9hXSfG3JhjoNZYppcUsxhqvwM20lVPw30Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724792983; c=relaxed/simple;
	bh=RSmM+xR/rRKXy+5aswUgbWNH411CdYS8oVQJW+2v08g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sn8Cx8ZOsLbFe+5+7L1ML3IHXRkVepS/xlLHR1r+teGRVLfKyovNryO8JxFkwn1mcDqA3uteT6StxchMBZTSpDs3EWUxppF29iuDpnYctIGdnE148UlMDjyMMagHWqJAUf9KKtYogq5LhM7MyaNGInqUrwEBLrFx5N3LICMof44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: xfsprogs-6.10 breaks C++ compilation
Organization: Gentoo
Date: Tue, 27 Aug 2024 22:09:37 +0100
Message-ID: <8734mpd65q.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi!

Forwarding a downstream report from https://bugs.gentoo.org/938569.

xfs_fs.h's xfs_getparents_next_rec relies on an implicit void*-to-T*
cast which is legal in C, but not C++.

It fails like so when a C++ project tries to use the header:
```
/usr/include/xfs/xfs_fs.h: In function 'xfs_getparents_rec* xfs_getparents_next_rec(xfs_getparents*, xfs_getparents_rec*)':
/usr/include/xfs/xfs_fs.h:915:16: error: invalid conversion from 'void*' to 'xfs_getparents_rec*' [-fpermissive]
  915 |         return next;
      |                ^~~~
      |                |
      |                void*

```

It came up when building libktorrent.

thanks,
sam
