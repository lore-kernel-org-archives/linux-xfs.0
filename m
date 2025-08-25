Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9682877C7
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 20:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756152101; cv=none; b=MbpuM8dCttfLtlqmlco8LL9d/qwqPb7VPKota4WO9y++Re6V0WQmPZlQJhO6HZQFj9crW2CfaHH5JJVduH3x2PdHiFsyK/V5KpFpDgiePf1PD6droCcbF2hbKPpXJO29nev/M8qNhuJOYACwwMNgwkpjvY4ZD0T3QI2JwghQkW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756152101; c=relaxed/simple;
	bh=+UO3Z8ylt4jmprU+t0yr32BPIeQoRTu3BOgKfEYW8Sk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=MHv4udilBYcePOSwDaFTHk4+YBLmoSueP0xYTFg54K31OyqnB4KOM00SiirO8YHQNQxsgfIo7yOzDG8pJywSi6ysZfjkhuUm1bjQv3/AUAJc9xNsvavhTxWD3aWN8+32MNwD6AKl8hEzO8kD1GI5DdLDPZjRSTY0BHK3+Zu8Zhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GTKqVRH0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GTKqVRH0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756152091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=fpPVCsB0CpPc94HdfL2qFImbg1jkREPaZiikuuRyx2w=;
	b=GTKqVRH0J8vtZMji9gZzXkIM01Q1VMrh0hsgGbQkm+r7rdDKpC/k1oQiTAS406nV+vyOeE
	SL1pmKoIFwKc2uk4Mdq7V4I6hR531nqCpYiwebF29K3K0IuEshs0Daxlab9ccuZ14z712l
	ovswj+9a+yytOp+egtBj7vYraANa+e4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-E1LDJ0k3OHmSOm2bz6jQnw-1; Mon, 25 Aug 2025 16:01:24 -0400
X-MC-Unique: E1LDJ0k3OHmSOm2bz6jQnw-1
X-Mimecast-MFC-AGG-ID: E1LDJ0k3OHmSOm2bz6jQnw_1756152083
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c897f28ab0so1213689f8f.2
        for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 13:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756152083; x=1756756883;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fpPVCsB0CpPc94HdfL2qFImbg1jkREPaZiikuuRyx2w=;
        b=r7ych536h+T+NDyS1xa+k+OqJTK+w6+wivJYNcZMkAc0F1DNB+lhj3NXKX8WMfgZ/a
         oB8UeIVtLA381Mmax3FL2hJB1/T+lvjO51+3SyNoBJgZxpG5mBQ69rQzNiPAnz3zfkZF
         zbCSh5dLcMoy8bLiH5w/beUP9rj8OIhp2uXJ/F3eHVJLhkrA0KKkumHit8LSbdhD8zsW
         ZL13Ep1nUZuKU0VHThSIAfsUXHXuH+nNFJjUIyBCEmh5fQhhBTKWcs3xSS0k1AjlIhV5
         1iQeaqRjdv+RqJCcCzK28iwL+BsCNCb9EReKo7FM3cQhbjnXq1sefjXKV6jk98eHP/ds
         konQ==
X-Gm-Message-State: AOJu0YzTxrfnh+qgUlcTlTIBDk/x4m7btxmRYdhWuIN9w0g44Z287t+J
	XbvLqnjWfS+Ew7aXecg8VLGiYADODZuTdydkhU06kLUUvQBO9MRKuaCXqUeUj8UP7g6VJYg8AT1
	ephiDJMO6zVR50hpSaah71wuVzpg1v6ObTxydleV+4h9Xdzj67hIiv+yBF55OX8il2QptBN2/m4
	oyf3MF9ifnTb6OUMLOzGX1ka38GYEbAgDWUCAdn5VFYS9C
X-Gm-Gg: ASbGnct2Km/xQ1KKBgBh0/EzLfBGp+kVeRd4Mnn5x9YxV60WFbOUNpSxMfL+SzVC1Ra
	N13eeHNVCd8KHh0WvOW1LsXoWkfo+PkGpNv9bx/d+OyetNQlknUTS5nPGrYSjhAg3y+FGeFEuIh
	frJ8LYRR61tTDciY6ziNMRvngKvGuvZ/yJ2esNTNte1t9i6VAPbjNfb9P8pu2DXRiS8iZN7+p0L
	HzvNSxMvCuETXrEjM/lajPuX0Oq0PECyyXN1HwgU3j6d5vV5Nr2KJRyLIksRLRUVS3tSUcGbNeA
	TJGSOymfl7dDgMJMSV20HMNyAtCXFZw=
X-Received: by 2002:a05:6000:2891:b0:3b8:d5cb:ae1c with SMTP id ffacd0b85a97d-3c5db2dce36mr10599947f8f.28.1756152083190;
        Mon, 25 Aug 2025 13:01:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRB9vRw0x5qi9dPvzb4rbjl6QunVaI0GW1j8vL06YmVcRcQO/xn73lw0UftnoWx53QQqWpAQ==
X-Received: by 2002:a05:6000:2891:b0:3b8:d5cb:ae1c with SMTP id ffacd0b85a97d-3c5db2dce36mr10599867f8f.28.1756152080783;
        Mon, 25 Aug 2025 13:01:20 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70ef55aabsm12571967f8f.23.2025.08.25.13.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 13:01:20 -0700 (PDT)
Date: Mon, 25 Aug 2025 22:01:19 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: contact@xavierclaude.be, djwong@kernel.org, hch@lst.de
Subject: [ANNOUNCE] xfsprogs: for-next updated to 9ec44397ea2a
Message-ID: <kmkoyhtz4mjuy5xlucr4noywsgons5n6pn5ti3fjs4uv34fzlx@zsopyugtig6f>
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

9ec44397ea2afd001278c33733433f67394b6c87

New commits:

Christoph Hellwig (2):
      [ea5d15f34e81] move xfs_log_recover.h to libxfs/
      [0c5c99ee8669] libxfs: update xfs_log_recover.h to kernel version as of Linux 6.16

Xavier Claude (1):
      [9ec44397ea2a] Document current limitation of shrinking fs

Code Diffstat:

 include/xfs_log_recover.h |  47 -------------
 libxfs/xfs_log_recover.h  | 174 ++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_growfs.8     |   1 +
 3 files changed, 175 insertions(+), 47 deletions(-)
 delete mode 100644 include/xfs_log_recover.h
 create mode 100644 libxfs/xfs_log_recover.h

-- 
- Andrey

