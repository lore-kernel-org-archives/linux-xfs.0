Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B8D22F163
	for <linux-xfs@vger.kernel.org>; Tue, 11 Mar 2025 10:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741690482; cv=none; b=BDMC10eJnQ3icKGaRt7BifKzydoOLBWDP8RDAn890NMxBK70rv7nNjdF8GncufkvFg6Rw/rdQIZk5ctPvilVOgJUHAIbF2CB6oJWI1Y6LUWBMz+l8lEEtt/7LzOMLqpPnWZcPrVTf97+9/9Ac564fCD76r2+3KJhwfsalEAV3tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741690482; c=relaxed/simple;
	bh=gvhZSyAglSVvHGyDfROTjZ1xZULSa8ODCBBM++z31cI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LgeofntwnKd9M2YR3xLG04DsoNJaYUtBPErCF/RjvhWHjAWQEAz0vQTGhpz/Oy9c+132hM1vEjPeO/PFjETNkwZ45j2C9VedAhZ5RzK5w2Kzw5Gj/NIp7yiexseAhg4DZ7XO6SrogYAXYRH9VuYSvy1UTqR0vs+BiqZWDJ1s8fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LwLhSBIp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LwLhSBIp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741690479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=zFuIFXxiIisf3lBsWYo6GAo6nH/mw17G78JRGx4UrZI=;
	b=LwLhSBIpt971EqC1hJ1ypRNfQLs4RCli3GFmkIasdOU3WDGCaQ82hSm17rIQvTtYPZvUZ+
	K3FEgMqDrbGY3GreyKuXPcafBKh+dvJZ5rnWO48lnISksuiqUo5gFMcezH5DaUZYT+yCqm
	9I/kKxV+jY3H2qT7vi5UWyJUr0b+KgY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-Jodsx4knNGu5ZK0Zaje92g-1; Tue, 11 Mar 2025 06:54:38 -0400
X-MC-Unique: Jodsx4knNGu5ZK0Zaje92g-1
X-Mimecast-MFC-AGG-ID: Jodsx4knNGu5ZK0Zaje92g_1741690477
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43935e09897so36733595e9.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Mar 2025 03:54:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741690477; x=1742295277;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zFuIFXxiIisf3lBsWYo6GAo6nH/mw17G78JRGx4UrZI=;
        b=B0kT9UaRcMYgCRTBJ6Cg3NwhRRHk256MJXvVvDk/pmxfuApSiM8y1FS+2iHhfw1BGe
         y/M7tq+R1WwBh69Er8cVV8Y2Iumw9rFKM4fXtrkDu7g0UFCFzHMaEwD4HQcemRhqyeI9
         XHxBjDtE/a3+mz5VOq/Q/F/Kbh5PCRJMT+UioAX2baBTT/KRnq+chcTrE7HBJhFFVzL3
         hCHU2z0nwyHMZz/eNkJCFYp/RdQm2qaPJgUX3+BXlGpq8qxlKOkVYmZXmgFkBYn5x3in
         e9xtulMtrpmN8fc0ciOqohF8/itbOXRMFcWFOfc3Nz6obQ8iyQJSWw7L833FbfiOcFwG
         241w==
X-Gm-Message-State: AOJu0YyvY2Gk87MKV23gY6d9vOY3/Ny6Q/iddUYc3SOjyZDpOb5ZRYlt
	/7htRxQe9RFM+5KmNw+CLaLrP0dT13h9hT26o+nFheFVtSeaZ+6rWbOsT3np8NZp3lUN0sfgT5O
	Dj0kKMg0R19m95V6R4vCwJvyDESJceQQuOOBc/VvJvCQhKqyG3ng0s7BQAkuyLelBUairp+pD2r
	Zz7CcG42aPOI2wsG6HtpjVVJyFng/BFugYobXCMK9P
X-Gm-Gg: ASbGncsp4xPX0ll6ifx4+hJQ0gW1uI/D0/ljYTcmbWSWU9EJzl9pG4L0AIMOIuzHOqV
	3W56q4rFGBomhm9NfPt/56iUIbukAuqlf2q/iOSQ7qvbM37frSNXxLNQQojuvmhf5uZkVyq/zOh
	R1JX9C2svdRElP7xcDZ74GEPa9KXj/Zwc5ih+/c6T/7iYl+x2DdHmPLrjZmZ7tRl2nCD+MXeriz
	BP6J/GRGSSmb7mRnWRsdI6wVNAv6dSPywr7Cu8v7svG7+hc8mGs7iASxDyvHu2hNP+R0g4qXfvi
	/2Z08yfLyikeUfgnM6DhgewzBzONMn6aoIY=
X-Received: by 2002:a05:600c:4446:b0:439:4700:9eb3 with SMTP id 5b1f17b1804b1-43c5a5e4fbamr122253695e9.3.1741690477144;
        Tue, 11 Mar 2025 03:54:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8L+OA2j6IgTKb1CPufIZTfrwA5klwydF+6jLArc5IB/ROPwQMWU7DzXq62BrRKeNy2JOepQ==
X-Received: by 2002:a05:600c:4446:b0:439:4700:9eb3 with SMTP id 5b1f17b1804b1-43c5a5e4fbamr122253415e9.3.1741690476676;
        Tue, 11 Mar 2025 03:54:36 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd4352eccsm205776345e9.27.2025.03.11.03.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 03:54:36 -0700 (PDT)
Date: Tue, 11 Mar 2025 11:54:35 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, bodonnel@redhat.com, cmaiolino@redhat.com, 
	djwong@kernel.org, kjetilho@ifi.uio.no
Subject: [ANNOUNCE] xfsprogs: for-next updated to c34735adb511
Message-ID: <kpeketozzyf2sa4p6naejti3sqqj2vyxwi6bqfd46ztbr42wf5@fbfxbxwopq4n>
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

c34735adb5116b4edae110d788c44d2462017765

New commits:

Andrey Albershteyn (10):
      [b69a2f64abbc] release.sh: add signing and fix outdated commands
      [8efc27559060] release.sh: add --kup to upload release tarball to kernel.org
      [69e03f8ee6c4] release.sh: update version files make commit optional
      [8b5b1002e3db] Add git-contributors script to notify about merges
      [c73d9fb692b5] git-contributors: better handling of hash mark/multiple emails
      [36119c513697] git-contributors: make revspec required and shebang fix
      [8adb8959addc] release.sh: generate ANNOUNCE email
      [54dd2973895a] release.sh: add -f to generate for-next update email
      [f1314f4a59f1] libxfs-apply: drop Cc: to stable release list
      [88940d905da4] gitignore: ignore a few newly generated files

Darrick J. Wong (1):
      [c34735adb511] xfs_{admin,repair},man5: tell the user to mount with nouuid for snapshots

Code Diffstat:

 .gitignore                |   2 +
 db/sb.c                   |   9 ++-
 man/man5/xfs.5            |   5 ++
 release.sh                | 189 +++++++++++++++++++++++++++++++++++++++++++---
 repair/phase2.c           |   9 ++-
 tools/git-contributors.py | 168 +++++++++++++++++++++++++++++++++++++++++
 tools/libxfs-apply        |   1 +
 7 files changed, 363 insertions(+), 20 deletions(-)
 create mode 100755 tools/git-contributors.py

-- 
- Andrey

