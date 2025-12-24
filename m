Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CA8340D93
	for <linux-xfs@vger.kernel.org>; Wed, 24 Dec 2025 15:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766589401; cv=none; b=XGnDvFdCbtthI81se6Cj1y30bvm2yAPDxponqDkTZEa/J0QtSBKJoz2yqFePR56eTN3s1lq8LVdCr9qzom+msP0scXbkW+CUu9kimfD02D0sJ+1sl66bE6T3ILI49OZbcOFeXwK7pYDcGSTlIhSxj5BHKk9ezBu9FXkRcOXra7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766589401; c=relaxed/simple;
	bh=uOnsWUrYxVkCst/5nq/Nhiz6uqnGuM4W0ppeyUNFdjs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LCwj4FDNdWJZmQJK2zPLzgei5EYfPLJGOq1LBebEdTIHGe9dRc1T/W9XdxJ3d4c9fwKXC4qaLL+h4L/+oBGsg7rORMYzuM4tjDe8j/B8xQ8khRRsqr7NT/59ei0pbdTjyOdpCDPwn01k4GyWUG1tl+Ems+r1a00KXACUz8j642I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VRf9qqJA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sbldBWnf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VRf9qqJA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sbldBWnf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766589397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=C1lJkthoAooSzwBvnedDyZOt6AVbfRteQQ4N8O9IwHQ=;
	b=VRf9qqJArLVoZUwaWWyaYl5qACtrQU+slaDEdso2dbUiIV6+AGVcep1CgM6x72g9yDewEU
	7Ujue3PNsmBHpdGpoPPFFelntrgPSUZ9xFK4QQpW0ZBbG1XY2SQszIzJx38Azc52APPKTo
	YRmQlIsscJDHrjxdQ3x3rbI8axK6z8E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-1o3C8p0eMuyTHkdZ-7rVFA-1; Wed, 24 Dec 2025 10:16:36 -0500
X-MC-Unique: 1o3C8p0eMuyTHkdZ-7rVFA-1
X-Mimecast-MFC-AGG-ID: 1o3C8p0eMuyTHkdZ-7rVFA_1766589395
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4779d8fd4ecso31676785e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 24 Dec 2025 07:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766589394; x=1767194194; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C1lJkthoAooSzwBvnedDyZOt6AVbfRteQQ4N8O9IwHQ=;
        b=sbldBWnfvxKO+8hgg6ECUqrFOcadvuC6I7sxtu0kDeQ0aEactpXscDE4JztTwHaWg8
         ya61AprzJ+RzMDPkrteqXVIbu346chAb16AkWt2yCRUi99efBpabNee8/cDupKpjKjMH
         4N4vo64fhWv9tZSiBtWh4Hg3u0Y+/BLJPYQ/fgmxZAICYMMelZNofeca4zCvfwEDxsE3
         M8cKMCnccJM4CHUdYBmFJGELiRxb/xNtPqvQgbDW7cx/BOQIMjeIc4esPpycKLlFoY5k
         YAl9T5vSLuEtK+yNnonWNLm4f+KT4ZEd/fNjRaeQgFuKaKzTYV0kjzzemk0RjYQxTgWP
         EAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766589394; x=1767194194;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C1lJkthoAooSzwBvnedDyZOt6AVbfRteQQ4N8O9IwHQ=;
        b=EFrrSAMiyGJpY5D3KUa4HklYSwc0GtaDVpvY7ldNcysEKQpsWKuaPlvcZ4FIKRgnGf
         fSqvhbzhrP3Bb4AN7+Y2f8iij9/TMsZ0Kou8OX7q57M7bvwC4k3/OnAPbZqI6TWl663v
         n44FI7eRJlxOHiiEGn66hBM3fjsC5P4QQHfHm7yRLLWRsBhr4yfhq1NTKtkcFGfIWQxn
         HWD3g18l/jAJseHPp4keDls1vUXCrKx4gAOsvpOcXdYkaOKk7aWKKjKnwsC4TMMXfi76
         pk3cNUCzhwHeuuNEMxpQiCwXqw64OkujcHtD2inGv4YU+1ajofhXojFPqtJ+X8w/Ge9J
         XKvQ==
X-Gm-Message-State: AOJu0Yw8IPVJCnlqmN5UrLeKfx1hsQGRLzwNUfg2U5tXJjUjCpmIOmaT
	Wk9sJtST6aHOAQd27DZfwc4akeexoPDTolL0krh+c8eS1NFH/fzo4JMZtqVyhD9TgMndAeFt6rL
	k6MhvLNM9bLAF+3DySmgetHAyH33o3t1Vxx92CDOCcOjcma17CHZxZuepkvCHCRv6RP6vWkDMUF
	hs+SDGtLqK7U2y1nDvY9JckO9JPQSa2nY5c+Hs2Yn0OXLx
X-Gm-Gg: AY/fxX6Uh2bsCbhAN95yV5iaR6v1XKbHdvQJolQ0ebuKRWR2PiTVXz6Or/vzFOqHFaD
	t3EuX2SHbOEAoDObGc0q09wIsy67jwcVDuOSNwY0tDflCuXXu5EGrGyQQnl+GOp5EBtHX3Rghi5
	2oTeh52XAjen65votyfeh2pcrLOr1DzWBstcvYQXU+cx0APYfygXbtiXA97IUDvW/JlpgTuvsda
	CMt4vlt9VEoBSpLuLszflPFPJsMiEyKu1mrk440nF2df/zoIsGQDwuZBwHi2RbWLLYQggoBifQt
	qe+ik8TEECoafhGVzsdFGtB0X+dr37NwDGHjT8CY4THmveVRSl1cteBPbHRbeIvnkPP+UuATB8f
	KHw==
X-Received: by 2002:a05:600c:c04b:10b0:47d:333d:99c with SMTP id 5b1f17b1804b1-47d333d09b9mr63772775e9.18.1766589394556;
        Wed, 24 Dec 2025 07:16:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHvGP70oIJ6NxGVVnsJUwYh3C9P1YifOmy8w6rVZn6n/Jwe3ZQcHPIkFbdkEsAbX+vRouB4kA==
X-Received: by 2002:a05:600c:c04b:10b0:47d:333d:99c with SMTP id 5b1f17b1804b1-47d333d09b9mr63772495e9.18.1766589394036;
        Wed, 24 Dec 2025 07:16:34 -0800 (PST)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193cbe58sm299596805e9.9.2025.12.24.07.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 07:16:33 -0800 (PST)
Date: Wed, 24 Dec 2025 16:16:32 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org, cmaiolino@redhat.com, djwong@kernel.org, 
	hch@lst.de, preichl@redhat.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to b5d372d96db1
Message-ID: <2ibkjb3kqbic5blhmojz3mv3ehmdxhdw6fzj6myx5vlivtclwb@r5disaw6rrhc>
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

b5d372d96db1adb316c91a058dddffb38ef6d166

New commits:

Christoph Hellwig (5):
      [0c6d67befe98] repair: add a enum for the XR_INO_* values
      [5d157c568e3d] repair: add canonical names for the XR_INO_ constants
      [a439b4155fd5] repair: factor out a process_dinode_metafile helper
      [f4b5df44edd8] repair: enhance process_dinode_metafile
      [b5d372d96db1] mkfs: adjust_nr_zones for zoned file system on conventional devices

Darrick J. Wong (1):
      [20796eec31f8] xfs_logprint: fix pointer bug

Pavel Reichl (1):
      [98f05de13e78] mdrestore: fix restore_v2() superblock length check

Code Diffstat:

 logprint/log_misc.c       |   2 +-
 mdrestore/xfs_mdrestore.c |   2 +-
 mkfs/xfs_mkfs.c           |   8 +-
 repair/dinode.c           | 300 ++++++++++++++++++++++------------------------
 repair/incore.h           |  19 ---
 5 files changed, 145 insertions(+), 186 deletions(-)

-- 
- Andrey

