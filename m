Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A2A268FE3
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 10:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744108247; cv=none; b=K1LKTq6iWLXfavUJQZiRwakSYQVn0Ju/qslqCKIn7QSPR6C6D27ntENBH7teIy5OOn28TcLQQ2P5IdUAxjpjglYic0zvoGJvFgiEY+caD6Jj4ZQp8YLRLwzI6Wd0JObH73g9xMlgvwMr1kPs+Aam9JQvx9mNKxKaqvOw1P/t2Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744108247; c=relaxed/simple;
	bh=yVnJVc2g1r1+sh6TwA2/Y9d9hQTfy5IYRaYytDeQdFk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eA+UUW1TQ3sAjsKCnuVaPbphuufFJSfkQjqbG+pJwLpEegoThqMF3LdT7UN3y1gSTIAAGAgMEVZmAuea/JcyrzrTsKcSEVJZE4ITM+k2MUN0LMV2b/eF4Q4532Y7yt+wCJJ6u5xwgs7mgfstDw7WfOXqd0notftCY7AO72MtirA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YdaxCY9k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YdaxCY9k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744108243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=+M9eNVf+J2MlPvKJ26gDryGWOuzF2U2UkCO1yJuhqlc=;
	b=YdaxCY9ktg5+QY5xcusceEqcDa7ZbtkAdC3IBt2SVU0/vRmqdhE9yVyjAcgyMgp4r3ZSmz
	pmmyJq2fR+U8CmCRTA10PWzVrBMVzqbH+pTTnHeG2HFZlb7SRZVbOATfw8CSEEh7Hr3hii
	P11qf7IESnluqPvAjSA648XAxYJb1cg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-qO8qKTX5Pre1gb9_Ev3AAQ-1; Tue, 08 Apr 2025 06:30:42 -0400
X-MC-Unique: qO8qKTX5Pre1gb9_Ev3AAQ-1
X-Mimecast-MFC-AGG-ID: qO8qKTX5Pre1gb9_Ev3AAQ_1744108241
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d01024089so47260715e9.1
        for <linux-xfs@vger.kernel.org>; Tue, 08 Apr 2025 03:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744108241; x=1744713041;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+M9eNVf+J2MlPvKJ26gDryGWOuzF2U2UkCO1yJuhqlc=;
        b=aYUw2E1NK0+CjUY75QVDJXr23oyYHDBHvcG0VBhmQ9H7V0Sfi/qT+iL8L8tyx09+du
         QNqsdIZjI0CwNVxxu9Ss7dnh4d3+r0en4TP6uho/88cJENGliNGMkwfAzqqH8bH6RywQ
         Mp5smHKWa8e65BoQNN37SDiIC5PGnFo4ewVSrTK820EaFBg1f+QllHO5Qt4MpeZixAVz
         kd/7C7fjWt43JhYEjl5AR+Bq+cQSAlUGX8fgUeEpR8h7Tk4l2NJDbrIW9VyVUiKtYsWQ
         x9CrJ2lcHyQ0FQKLcPuTyNXRa22g2fXq71KkOvEIh/6CynmPU3G8NqtuTZI3s0N6P+MP
         eZYg==
X-Gm-Message-State: AOJu0YzYT0//0HENJnF74yGz2mDcOu6quqvPJgmFYfkfiqusEOZhvQAg
	VWLKZTYyscPuI2i8M48wtJhxNHAzdX5jyN20RUkgB2z0159X/l72x5RhXCp2Q7kdy/wJTbmg439
	feaNP0xziGK8Wch+++hUBx4JhbQHB9aaXloYbl2KXJARZ6RTclMBBcndsU547W6ycOf7v6ReXDi
	GXZtoowo1knPcozZzTbR4n6FXaEVhJNxWDOFSd+iEa
X-Gm-Gg: ASbGncuK/il7lDqz6RuRqQfz+xi/Nr+XzgXTAliDRZRUHHPZpvYCZg1uKi0oVHMjg4P
	7sMwR9mpb9FsPekBqmCBEq6yud2DCGmiFmJfcGRupaglYYWzkL4ND+3p92786Ls81ecN6eJaKwU
	VsGJ6lfWiWpMNaZB0PAj2pwpGq6RSJs1i5b8GL7gqnVxoRfqLtZL/nuykQCcn8lXMgDz6vqPpL1
	29OAFbz6i5dybrIKOVUD+Tnw/wCBay6dsWco3TOnd0f/gfi0nLf/M2NpE9hMmH+TL4ywVzfy7YX
	EJ+WCM7Duti7UzDOcYVHqCY6o0DOCMZ03ZY=
X-Received: by 2002:a05:6000:18ac:b0:39a:c6c4:f877 with SMTP id ffacd0b85a97d-39cba9332c6mr13924232f8f.20.1744108240679;
        Tue, 08 Apr 2025 03:30:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE60f/B2co1nMNTyNLWVsVyhLLR0qxLOipzHhbfimYIB7g23acEcW6WRPvopCxeIZfjM+3bJg==
X-Received: by 2002:a05:6000:18ac:b0:39a:c6c4:f877 with SMTP id ffacd0b85a97d-39cba9332c6mr13924202f8f.20.1744108240211;
        Tue, 08 Apr 2025 03:30:40 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c3020da17sm14617090f8f.64.2025.04.08.03.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 03:30:39 -0700 (PDT)
Date: Tue, 8 Apr 2025 12:30:39 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, bodonnel@redhat.com, djwong@kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 2d5e0a41c199
Message-ID: <zhhpacc7yxc6jbj2tvjb4b4hapmtohvvresbke56jq7dxlf56l@np33ncd7d3kq>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

2d5e0a41c199272ada5d54d51a2a8cbb76da6eee

New commits:

Darrick J. Wong (5):
      [355eb80b188f] xfs_protofile: rename source code to .py.in
      [7a071c8c41a5] xfs_scrub_all: rename source code to .py.in
      [c5913c6f9f0e] Makefile: inject package name/version/bugreport into pot file
      [8a96f3d73d06] xfs_protofile: add messages to localization catalog
      [2d5e0a41c199] xfs_scrub_all: localize the strings in the program

Code Diffstat:

 configure.ac                                    |  3 +-
 include/builddefs.in                            |  1 +
 include/buildrules                              |  9 +++-
 libfrog/Makefile                                | 18 ++++++-
 libfrog/gettext.py.in                           | 12 +++++
 mkfs/Makefile                                   | 11 +++--
 mkfs/{xfs_protofile.in => xfs_protofile.py.in}  | 21 +++++----
 scrub/Makefile                                  | 11 +++--
 scrub/{xfs_scrub_all.in => xfs_scrub_all.py.in} | 62 +++++++++++++++----------
 9 files changed, 103 insertions(+), 45 deletions(-)
 create mode 100644 libfrog/gettext.py.in
 rename mkfs/{xfs_protofile.in => xfs_protofile.py.in} (85%)
 rename scrub/{xfs_scrub_all.in => xfs_scrub_all.py.in} (89%)

-- 
- Andrey

