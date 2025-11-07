Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300BA28B4FA
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 12:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762517938; cv=none; b=le+QJfL2h5id6c/Z7uHy4RNhWafCOXAwmvfHOHW1Fb2N7r3CMvHX9pZr0q9Db55lGAIafRvU/u/DPxnvitPnYmTdZZFGLP0oWJ4dXtBE53xvfZ5b50pvTOwITleouBx0Ql2Q3vRbBxmU6RhhZQQdKc9V+h8WVif189Coz7HK5pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762517938; c=relaxed/simple;
	bh=MIZZ1vjxEgfdgNAbjdf3zv+1VMrFoFfH9YVC5GD9yew=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=m6tB3Lnfu/59Lpde5UOgciQsVsWKARqdufaIdKlO2s+dEux+yQjy4DdbJqSDilv3yTTswLjYPjUYMd6HNEzYaL6gOEVBxjLndxvOEfYqcnvxgy8KU5r1G3VQYWASkVWt2esVLpquAzp0/wLDBe2bbHH1lWHSzWkfDUw2iUSti9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YKevbrO7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JO1LpfhB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YKevbrO7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JO1LpfhB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762517936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=01xY+v/09JerQqrd2V2gsrRjj7OQNzdoLi62wzBRo2I=;
	b=YKevbrO7zqVsved9OTPt5F8U6fnFw9se0OjRLR57p2Hm7i8V8n9CJNT4XB83QGdkvscase
	SJwiRenwR13EartLw7D73mhN+AbZdLkkjxI+nRjhbKxm5sDmYjS5PN5tID5YmbF28V4YU+
	yzs2X9ftc3jjJhgeP7quQRESyELc7R0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-EcFy-5IqPG6nkiQw9cZasA-1; Fri, 07 Nov 2025 07:18:54 -0500
X-MC-Unique: EcFy-5IqPG6nkiQw9cZasA-1
X-Mimecast-MFC-AGG-ID: EcFy-5IqPG6nkiQw9cZasA_1762517933
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4298da9fc21so302670f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 07 Nov 2025 04:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762517933; x=1763122733; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=01xY+v/09JerQqrd2V2gsrRjj7OQNzdoLi62wzBRo2I=;
        b=JO1LpfhBtTWZDcHHYh/R3qcHlCcfXt2z3dE3hWhHtkyUauvCLLRNzHfHye3tejzjZ5
         OMGK7GW9ICuyny5SIfs+DpfC2rJFdO5k6BhF7THhRQtVwU0VVt19TQyxjsXGjUAMc65V
         5G3pIgM4LPL32s9jJDnQghFLxyDbjXBdQlfWuGApXBVqJENOeP+s/toMIWBjYXA+1zbu
         LjWMG7UxCWAGHB/bCUiQf4ODHjk5yIXPPOuUMrn4mzogFqmG9pXAE+QsQ+Jj0JDZI1+5
         y6oqdRXH5cK+vSpzsYA0rSskFFqI0/WpiU+dIU/oDisjdaxOzgwfJQ20W/lPsqIRmLmp
         r/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762517933; x=1763122733;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=01xY+v/09JerQqrd2V2gsrRjj7OQNzdoLi62wzBRo2I=;
        b=Ox9A7eY48LhFm+/sIeicu+5XS3kQKDCmpAXaMBt9cOMJhm3Rr3suwa8/hD/Vr4QxJa
         cBHFjuIxW0IwxPqaxga4XJIpDkJ2bSdQTq7bhY5WF6YDHhIeDlpvR0YQyt/c/+9Zcu61
         Bwa5ojCjIPIJv6+515qJazb/DDbqcrqcUd7/RiX3xBGGitcuyBaS7DSfp8KpoKvMFwr5
         cWe78ZcSqQMOaTi4JK6jp/BGfr/4LM0kXr6WFYwvPqOCIJakrIOxPedd1tjzOdQxS2wN
         RtI2fY9Lq/NPDbETduPDXhU9vFKTg32sYp9c/5gF1nymnHnC/wf7eXwuXI1ewjxZ48Wg
         m5jQ==
X-Gm-Message-State: AOJu0YwToVlHIcLxMKkjNe87UAoWefThCGAgNjuaLxoPq2DT8sOQRyKH
	fdmUTR/fNT5gr/Obk2P8Z5qqCalezi/Yq1CxQS/RjtUokyDBEXXyMXtGXFp439kRNdjPpTNjxzZ
	Vgm6u0l8VqUIUUjl5LlCL9NnCswrkLQ8MFWwIg+MBuRyFP6zFPf2JmJACWhGMZS6l813jIYkdta
	H04Am3hetYIsfR4D2bYBNr8tRiu44I3QeQ7X2t57KwNqRX
X-Gm-Gg: ASbGncs21G9vukIIAfsFzbmmz/uLTtCUTi/0ETp6LgQXvvE1uiLvQAuLICatJd5UB+O
	hBcNOSxR5EGMtWcWRHtAZt7YGx7m5630CELfaipawZ/1m9vWgGTHv/K4+C5sbXBxccVbYZJdFgj
	vbqFMA6YaTT9eFxzq6MMPUogc7WkI/8y9nyw2XkK1x8Q1cUt8M58pfaTAcCH9ymaIQcqN8Smpys
	/FGZ9E4ffAR2jr0kbywfmI7EOzwDCAkbVLDiMNBqI16bzmiplXOU53pPj5CwT/4TaJzg1XIIRzC
	rnIDubwckljmPLa8sv3PmBWrtFGxbePG3aKMyZc5+Nvb3rR9XGeneJOObs1SmtgC
X-Received: by 2002:a05:6000:2284:b0:3ff:d5c5:6b01 with SMTP id ffacd0b85a97d-42ae5880ca1mr2698181f8f.19.1762517932944;
        Fri, 07 Nov 2025 04:18:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiwTPgAIPlLEgk9B0l/T1N0rSSLqjepy8yrK9xbOPnqq1EMRnvY9znYp/nb8o0VsP6msAorA==
X-Received: by 2002:a05:6000:2284:b0:3ff:d5c5:6b01 with SMTP id ffacd0b85a97d-42ae5880ca1mr2698141f8f.19.1762517932308;
        Fri, 07 Nov 2025 04:18:52 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac679c5dcsm5926511f8f.44.2025.11.07.04.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 04:18:51 -0800 (PST)
Date: Fri, 7 Nov 2025 13:18:50 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, chandanbabu@kernel.org, djwong@kernel.org, 
	hch@lst.de, luca.dimaio1@gmail.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to 17aa67421d0e
Message-ID: <qfnc5odmudcyqefr25kkpixtkqddywj7d6lvz5o5s7lsjmku4f@axkq2xtppot2>
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

17aa67421d0efec9e1b965d2e2f7bf4bd541cbbb

New commits:

Chandan Babu R (2):
      [9a79db51caca] libfrog: Prevent unnecessary waking of worker thread when using bounded workqueues
      [17aa67421d0e] repair/prefetch.c: Create one workqueue with multiple workers

Christoph Hellwig (7):
      [a5523d4575bb] xfs_copy: improve the error message when mkfs is in progress
      [74274e6e61a1] mkfs: improve the error message from check_device_type
      [42fffb1475e3] mkfs: improve the error message in adjust_nr_zones
      [586ee95d8098] mkfs: move clearing LIBXFS_DIRECT into check_device_type
      [8d1b3cc5e1c8] libxfs: cleanup get_topology
      [8d8ba5006e3e] mkfs: remove duplicate struct libxfs_init arguments
      [75bbfce9dd3e] mkfs: split zone reset from discard

Luca Di Maio (1):
      [01c46f93ffcd] proto: fix file descriptor leak

Code Diffstat:

 copy/xfs_copy.c     |   2 +-
 libfrog/workqueue.c |   4 --
 libxfs/topology.c   |   9 +--
 libxfs/topology.h   |   7 +-
 mkfs/proto.c        |   1 +
 mkfs/xfs_mkfs.c     | 199 +++++++++++++++++++++++++---------------------------
 repair/prefetch.c   |  10 +--
 repair/sb.c         |   3 +-
 8 files changed, 109 insertions(+), 126 deletions(-)

-- 
- Andrey

