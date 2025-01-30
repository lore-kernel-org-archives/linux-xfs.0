Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF1E139B
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jan 2025 09:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230115; cv=none; b=lcJGnPT/V95MXroGdZW+otls6zuaXbM/Yavre+SQRl1egDxZgFtDc9vaOvva0qK2lmUyaNjWIaNA56xY1pAiKAxpRropnCGWyJxZM5Xd5CSVpH0WWFwu0Wf/dgAzMx7pmQASfoGSNc26oONrQbAwXUKcLrkVfY/gzJ9QzMkgwyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230115; c=relaxed/simple;
	bh=GifRgyEjPFTmNN4CKTZOGYRYm5B3lNJDYf1qbqYegtc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Q2V+396YL4XtfejLPUWjZZP1ds0/Slr4jxqRvCxAGmCSn5P27FlZ6usxw8hevucapprP/3F/eOoSdnU4YgCsxf+7cYw0T3jvdpSrz7k6lhmxw6Yc5t0irGv+jD4nlbuFjaeUVWWxYNeDu4mov/wqKrUDT5tpje9IBX+d8vxZUdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L2XAEB31; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L2XAEB31"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738230112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=fqru2r2HtviwaCobeGd7AsiYbjvhjrqb7DdR7DCqE4k=;
	b=L2XAEB31uBQoJZrP0QvJwLb80mO3kJe3nqhOJH0b5Y9EWYAHLNxZJOm7IqfqnTNjO3bioq
	qWDzg6Fkuy8Mj23ztqbf1kCCQ9p9gZ8NSLL6YWGKTwqr94/VjQXdtouOWTagyTXzvplxCM
	fVDBs3Ik8i8QFHWRJEdKiaIJlpzEPfg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-oset3bYpPbqysSDivvrxxw-1; Thu, 30 Jan 2025 04:41:50 -0500
X-MC-Unique: oset3bYpPbqysSDivvrxxw-1
X-Mimecast-MFC-AGG-ID: oset3bYpPbqysSDivvrxxw
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aa68fd5393cso57836966b.0
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jan 2025 01:41:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738230109; x=1738834909;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fqru2r2HtviwaCobeGd7AsiYbjvhjrqb7DdR7DCqE4k=;
        b=kVp9eyI17AoE4YPDhQgIF7MDKpgG0HCuTAqn8IxU8vsaJw55IoDX7p/Uf1s1YHeaLF
         SAx1nnq9IZR6Uccvle4QWRpswy+iinUlb3v8lPrQnCwDFxH039ENnbtvt8I15tODmV5X
         fmdaI8h6BHw4vdsAi+OFoOIxXOkdFZJIjmZtCi9cJATrW2OdJ0rc9l0APz0O7ClA0Lfc
         qMVk4N7+2LYcOdsAZfoeWJLbvYiGGED2LP3LRsAlcw3yX56SX/BntGAFw5ZyAdeEO5OC
         0omA2Kd6zHVaNn7c5QeiaYpPlLunoukp3meAL21v/OBED3UNMH4KF1mjEDlLFHwz+GEK
         Vnvg==
X-Gm-Message-State: AOJu0YwLYR1y1F4tKLJbSyLiZvzYuzwQ+uQzYcxysWpAcCkcpVqR92E6
	d8/r/D32Y/+VB+Nrkymg1hodGuQoqVUn1rpBhTeqmZ/PPEU05cMdNT7rhUdsHsO6iaj8PfQ8pXA
	kf9bEa22hsqU5JAsCMIgxUZDbEoAmvffQgD8w+9eVBORTRBNG6PLJZosAJjlHT1QIxa4lyy9JY8
	wHrxW6X/a9K+PzjnC2iDSwfYbOdsxIz1SGjchb2u7Y
X-Gm-Gg: ASbGncuHw5Noyh0ohAhksYONwr5TUcbCl5uPZzahbhjar2Uv3RAXy81KMwQ6WXeoYbg
	hgvXPplFMZucFAbupcYSYZz0FzA8VIoT0ZmlS+YE0RoKxLIx3LrTsEMUQzadNuFFHJFwqI87REE
	fuYjsmC14DJn8u2wNp2Zv6trDDgkeBIXZ8xExFf6tQ9uN+U6VEKYhHKSzVkydv3RbOoBkigjtPj
	rxUTqJZvzk2RMoV7ReFg5U4VEeUX68zDvDNJo/50UUvMgNXK7Zlk/IiKNhCFoLnw8JNTRwAi6pL
	AF6suJj/co4//4CTKTo2NwRD
X-Received: by 2002:a17:907:3f92:b0:ab6:b9d9:818d with SMTP id a640c23a62f3a-ab6e0a02f84mr303759266b.0.1738230109246;
        Thu, 30 Jan 2025 01:41:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFUXTcesHzgxbOhu1zvztzjJKEwGqwrKAD4yKmnDCPNIKY58JjwHrAfIb1Z/5CyxNcDI1rrUA==
X-Received: by 2002:a17:907:3f92:b0:ab6:b9d9:818d with SMTP id a640c23a62f3a-ab6e0a02f84mr303756866b.0.1738230108847;
        Thu, 30 Jan 2025 01:41:48 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47cf8casm92166166b.59.2025.01.30.01.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2025 01:41:48 -0800 (PST)
Date: Thu, 30 Jan 2025 10:41:46 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: djwong@kernel.org, hch@lst.de
Subject: [ANNOUNCE] xfsprogs: for-next updated to ca10888d51a5
Message-ID: <hyemutprbcw2glr4meibcl2kh32hc7nmvf5od7laedrz6c2yxh@5z2zkufawkxl>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

ca10888d51a51ccb8ef02c9182c554eee4493aac

3 new commits:

Christoph Hellwig (1):
      [c988ff56258a] mkfs: use a default sector size that is also suitable for the rtdev

Darrick J. Wong (2):
      [ff12f3956648] xfs_scrub_all.timer: don't run if /var/lib/xfsprogs is readonly
      [ca10888d51a5] xfs_repair: require zeroed quota/rt inodes in metadir superblocks

Code Diffstat:

 mkfs/xfs_mkfs.c              | 16 +++++++++++++--
 repair/agheader.c            | 49 +++++++++++++++++++++++++++++++++++++++++++-
 scrub/Makefile               |  6 +++++-
 scrub/xfs_scrub_all.timer    | 16 ---------------
 scrub/xfs_scrub_all.timer.in | 23 +++++++++++++++++++++
 5 files changed, 90 insertions(+), 20 deletions(-)
 delete mode 100644 scrub/xfs_scrub_all.timer
 create mode 100644 scrub/xfs_scrub_all.timer.in

-- 
- Andrey

