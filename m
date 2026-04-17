Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D5625A2A2
	for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2026 16:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776443202; cv=none; b=QRTK6gMZEMc0emHlq9w8dD7nh/6v59JRbB/5NbwNm4lu8RfmGb5hM1YC1adXNtc1+1zq5VTQ4FHTAOOHtkDxwQwKcreIfvEGM3W6yLCgMuEh1ExzSrE8hb/w8N4l2cRs/61PrCt4gMMGUG/t0l7XEcdE3OrCT48/UixbpSZk7Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776443202; c=relaxed/simple;
	bh=AZgGIUTpkW5FbtOGCQl4tYXNPOG/4A/3x/BrNuff6qc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=H8EMWWfHRCEDZID6metyNqZ15MPSjBQWXkFN4j2pdB1p3w588Koq2dSWHsm6EJBvjgIeQ4MXJ+k3bkkvDr1aN65F8BCGK0TzGsWQBTNyVUELsIS+UMkgcXGw4rleyELBEsuhm4BEi5i+rRF/5Jeup+gJWPz1Eb4K3OI5DkW0vK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KJ9Anrxm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FcDLkE9Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KJ9Anrxm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FcDLkE9Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776443200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=FwrUjomicfs1+UCY2Fv1QCqn4wZdEMSTtTjc8sdcSLo=;
	b=KJ9AnrxmGXnZf/QfwNPtDP2tHPNyDV+g53YPXCzUbI34TyNKAeGeQmKDa0jOmd2GetO3U0
	rHqePXK1fd1XTWc7cmAINV8YAIVueIWs2J05zPEoUCp4BxjYDGnDnG3qE4vGt9WzDPBUBi
	Pg6jepUtSkb2VhjUy7dXIisXaYda/2g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-YJEOdqoJPa2X3xvAx83ebw-1; Fri, 17 Apr 2026 12:26:38 -0400
X-MC-Unique: YJEOdqoJPa2X3xvAx83ebw-1
X-Mimecast-MFC-AGG-ID: YJEOdqoJPa2X3xvAx83ebw_1776443198
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43d705eaa64so959819f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2026 09:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776443197; x=1777047997; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FwrUjomicfs1+UCY2Fv1QCqn4wZdEMSTtTjc8sdcSLo=;
        b=FcDLkE9ZqEFgtOZ53zE/74h6ztho/eDsJM9B98wpkjsIgPqCXmoRkB4CB8CF4SG2Qq
         66CrfyQiQ7zMypQuUZVErcG/kASehIM1qY9QHaNEfR0+y5OUipU7YElHnkQfw+pF0Hew
         Mad68GCjSj02T3QSCF/NDsKcjC3evT5oFht76zBUyuCG62I3A4u+W1UHDk02jlRjSn1I
         LlL7l6Sy9jg16sIfHaYrgXnkOa8dvWYXoyWiy63qjPiFln9mvqEE4WT8osRSyqLb/cdO
         irNQNBTUy2zYAoHANuS7ANrAmEr7mq+79bHxvC7pjCbjCGRChvfrwCe4RbSZnzJdKMh+
         Bh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776443197; x=1777047997;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FwrUjomicfs1+UCY2Fv1QCqn4wZdEMSTtTjc8sdcSLo=;
        b=DVN5HxiQRJBkPnxu7tiF2FvvCAP0DYdP3F9DJKOdnYRw7U07YxlMLiSf8wsKL0zmsP
         nfCmohuGbE3YOmTVaIp8Bsnm29FWqMmy2YpbS4Moojt/dlw2Z5sqzlFHUOi2PFEV/xi2
         yjQ6oz270iKT9cgai7Dy/24T8Ry6DM4rYh8etRQHupcsf7cpjlTECgjn9iM6yQN4ejNE
         Ij8fwg+pzYiha+B6iCjwvNqno0a5pI+Rv/U4qNwkoS42zhYuoEVT9PRGHXwkMjnh9SfM
         E6pgaa2RaAe3+LF6JnGcR69r3fE5+sV1gdabn5aEpe1AAhsuO/eLGSabC0uI+SKCssWt
         44Vw==
X-Gm-Message-State: AOJu0Yw+4/gm3BMZtsLUnT+6HfuruOj+BH/6Vm1uZz2OaOQojOoxM4V5
	Gv/jMYXVWVng9H5BRss/IXD+zjDdQLMIrrgT+dtpRJG0A4+qGLs8aAncRwtSazuF3hw2x2NJvA3
	MIU3yUCONnCWkGH6dv/xhEhj2DbM0I7o3XJRSSsMTMv/MKAROPfApWHuQNSKoSkAs0EBT9Hrroh
	kY4QwPy6o9Bd/+sIQyDDn7V7DUdj345YT/SFJfrJY50QgC
X-Gm-Gg: AeBDieuVjo/Eyecm02sKW+JH+U8vlv++XmRl0N+ShsVcmNmYfhfhbEYp2T8oXsFpTKr
	u90HMuYsn1ctyGTBByXku6/zZ6Ez8/DbRfWe8BbinN1YMBU62u2mP83E/gAYxxDpdvPG7Obs4dl
	itODq/qmqVef2Rai8TakH4Afoc0riWwuTTkP1ePSm5SUzI5nwVR8J1D3U2H+4QOhr+yK0V6gBwy
	jbMWveMCurarZjoy4abQlmbRaz4EV5W9+BSv7bCKKcUVrpETg7wcqXkqQ5DXcqeTA9tqD1E6bHI
	aFd0e7yGcAVZonWp465zC0WTeHa86Rua3dLcnxUPM1GXRb89UOVAJnWFvdYpoGp7LEsA3v+GOcK
	aOI1PBSbcZWhp5lM3WfI58A==
X-Received: by 2002:a05:600c:8183:b0:488:b187:3c with SMTP id 5b1f17b1804b1-488fb765ab5mr54676895e9.14.1776443196690;
        Fri, 17 Apr 2026 09:26:36 -0700 (PDT)
X-Received: by 2002:a05:600c:8183:b0:488:b187:3c with SMTP id 5b1f17b1804b1-488fb765ab5mr54676335e9.14.1776443196130;
        Fri, 17 Apr 2026 09:26:36 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1cfbf2sm55824965e9.15.2026.04.17.09.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 09:26:35 -0700 (PDT)
Date: Fri, 17 Apr 2026 18:26:34 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, cmaiolino@redhat.com, djwong@kernel.org, 
	hch@lst.de, ravising@redhat.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to 95329f9fa130
Message-ID: <yuif7zxvzqwp4ko7e3pdny5yrbvzaghd4mqfqccmk34g424lfl@gt2tpexevd2d>
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

95329f9fa13040962c5a2a5e91a29ba215eb341f

New commits:

Darrick J. Wong (3):
      [1a5eeddf738c] xfs_healer: update weakhandle mountpoint when reconnecting
      [1068708f7ada] debian: add version control tags to control
      [95329f9fa130] xfs_scrub: warn about unicode variation selectors in names

Ravi Singh (1):
      [a8eb7b321371] xfs_quota: display default limits for users with zero usage

Code Diffstat:

 debian/control      |  2 ++
 healer/weakhandle.c | 34 +++++++++++++++++++++++++++++++---
 quota/quota.c       |  9 ++++++---
 scrub/unicrash.c    | 25 +++++++++++++++++++++++++
 4 files changed, 64 insertions(+), 6 deletions(-)

-- 
- Andrey

