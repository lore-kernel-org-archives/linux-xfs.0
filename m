Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6941E9476
	for <linux-xfs@vger.kernel.org>; Tue, 22 Apr 2025 08:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745311450; cv=none; b=kuekW8zyaXTR10tswAa1nQuHprF8EKy4R7CCGppP0hjLjtWAnT6O+uXSQcdiWYlR/21fn6zr7L2913vVJfXsnaLwG4i2SWvmKdw78LRwSCGe0bCC3/FMYECg+Hvhxak8y7CJCOuGtTvPrSLkyJrGoyDstnFTrM1dFyfnRdwqjtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745311450; c=relaxed/simple;
	bh=fuL8axsZwXKR3dyGtDpkJPpNz64sBhUy5WnXsHQb1dA=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=NMfpiCTuNNffNd2/ZHQSSqBIfrn8nsaWdTw5eAmd2gylYN+m5jIXorG0nHwlY3/GHiFCQl0kOulekMrdvg2ohoQbTXhBtXSNBxBS8Ycc8BiZ23YigiOyCUjUI1Sfe2aZyvLEm7/kIsr0W+HEJq2gQQUMx9vinxLsuOfxdYCf/Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=MTTCloIO; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="MTTCloIO"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-736c062b1f5so3782864b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Apr 2025 01:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1745311447; x=1745916247; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:to:from:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WlZlhBTqJqX8VYQTz99s5vLTqhVr1Z5oN80rhzgjGqk=;
        b=MTTCloIOCVP7UPYmYGi2tMtbmsNgo42aXyWsl9NZqwV5U7E6xnX0c8Rb+bwx1C57UX
         AXp73/05/flRdzzT3YYZQOOOgi3ervFZHJPFOx/6n/ogcW9d+MmE7Xp9JG9bOEIPAOhL
         8vrPnqj5HR72+S7+cJZhWvVtPA8NN7SrD4hRZnu8WEzwWIhjtGR3mD6vk/7JPeAreH1r
         SOZ7/mMmPGoP1y2gT+PtKBgOpmajQLOaEyrBGhl55M9Lg4Fq/h1pbLx6HT3iLdm1x/oK
         52SJOnpwnFq0ldgb4YhlL0SwIDZj+DDkigtNCwY6yGdVfYyBFzAFmiScWwWUHXDWwDQj
         PbXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745311447; x=1745916247;
        h=content-transfer-encoding:subject:to:from:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WlZlhBTqJqX8VYQTz99s5vLTqhVr1Z5oN80rhzgjGqk=;
        b=jRH6IS9SK72ouQ47n7DxOZfHZpUXWp9h5YVFx1vYT6kPWMy4zaLAPJ0yScjQG4rI8M
         kOkW6Yq8XmFjNlh1sHjfLhGBOsXmvuVoF7XKbPx3l4kbQJkeioqxXjxPjGmq6l7MJb9O
         +po8A9tBlrDw3y904WaSw6+sIXR9d21RRMgrmmRLX1RyFXiPnuyQNvYk1ho9VVRNi6tk
         OBUxjNrNEtui+vLNP9TpreDg7/Lm3duPa8angd9WVKvWxNtSJFDu5RFQjivTo8ylcr8Z
         uJooGReR1xYtiGepETRL/RAvnk44QInQed6ub1nTXqs/1ltCbo0LBw0FCpoyh3HDSxye
         hB9Q==
X-Forwarded-Encrypted: i=1; AJvYcCV87iCf1ymwE2Rii9cLSjP5wlRwvBl+mNB8l56ucjrM08eUPBpfXyKySlx3NN4Dc5YAcRdUbPLeRZw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXBZEUPZLyc/MPDSS7HJgASGz3pr0Wz5Z+dY42tRKtgQjXNT0s
	F8oJ2PJWiVxJ4rJeo+ZDoOvegxBZmt7FvuhCAxifcVffb1l6Gv6SFHUBjWWrpDc=
X-Gm-Gg: ASbGncs8TTI6mf8XvhTwradED8DK7JlwKV4c2nykNhA+xp7he5bvgWY4UBSXT1DPrRh
	EtqCtrSjndohmm7uErZJ+fAogtqflGrqNcp2cblih7RXPJYFGFSMFiiVkV53JCsCOUDDtCsGMdQ
	Yyr+isLAQZGQzmQRoFg6EGneR41kPPAi55h20+YBcXRou1gGnq92V7TBpl5X8Aoone4Ttuujf/y
	o0AIA64+L6zy+sZn/aDZWPDluLVtUiykooT77Daca5xvbb07vTNsxNsgVfwHDM9a08VrwHgQbFm
	vg0zCIjjycC4EI6bEmXooGM2VOMJi8AdtzpdPh6/MGANjciqezRITA==
X-Google-Smtp-Source: AGHT+IEd/VYO7umxfq1KwDnPN3QBRsvTWavoA8bXpAtiqYJaNRCEBQ1CgjPHr1Mnhxkzokwa0XgZtg==
X-Received: by 2002:a05:6a00:4acc:b0:736:b9f5:47c6 with SMTP id d2e1a72fcca58-73dc1566938mr18307653b3a.16.1745311447476;
        Tue, 22 Apr 2025 01:44:07 -0700 (PDT)
Received: from [10.54.24.77] ([143.92.118.3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbf90dc88sm8034161b3a.83.2025.04.22.01.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 01:44:07 -0700 (PDT)
Message-ID: <d942be2b-94d2-46b1-8d0f-0d64c96d4cd6@shopee.com>
Date: Tue, 22 Apr 2025 16:44:03 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Haifeng Xu <haifeng.xu@shopee.com>
To: catherine.hoang@oracle.com, akpm@linux-foundation.org,
 =?UTF-8?B?77yM?= <linux-xfs@vger.kernel.org>
Subject: endless loop in truncate_inode_pages_range()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi all,
	I found a task stall in truncate_inode_pages_range() in our production environment. The kernel version is stable 6.6.66.

	It's call trace is here:


	[<0>] find_get_entries+0x74/0x270
	[<0>] truncate_inode_pages_range+0x312/0x550
	[<0>] truncate_pagecache+0x48/0x70
	[<0>] truncate_setsize+0x27/0x60
	[<0>] xfs_setattr_size+0xf5/0x3d0 [xfs]
	[<0>] xfs_vn_setattr_size+0x49/0x90 [xfs]
	[<0>] xfs_vn_setattr+0x7e/0x120 [xfs]
	[<0>] notify_change+0x1ee/0x4d0
	[<0>] do_truncate+0x98/0xf0
	[<0>] do_open+0x329/0x470
	[<0>] path_openat+0x135/0x2d0
	[<0>] do_filp_open+0xaf/0x170
	[<0>] do_sys_openat2+0xb3/0xe0
	[<0>] __x64_sys_openat+0x55/0xa0
	[<0>] x64_sys_call+0x16e4/0x2210
	[<0>] do_syscall_64+0x56/0x90
	[<0>] entry_SYSCALL_64_after_hwframe+0x78/0xe2

	
	
	truncate_inode_pages_range

	...
	index = start;
	while (index < end) {
		cond_resched();
		if (!find_get_entries(mapping, &index, end - 1, &fbatch,
				indices)) {
			/* If all gone from start onwards, we're done */
			if (index == start)
				break;
			/* Otherwise restart to make sure all gone */
			index = start;
			continue;
		}

		for (i = 0; i < folio_batch_count(&fbatch); i++) {
			struct folio *folio = fbatch.folios[i];

			/* We rely upon deletion not changing page->index */

			if (xa_is_value(folio))
				continue;

			folio_lock(folio);
			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
			folio_wait_writeback(folio);
			truncate_inode_folio(mapping, folio);
			folio_unlock(folio);
		}
		truncate_folio_batch_exceptionals(mapping, &fbatch, indices);
		folio_batch_release(&fbatch);
	}
	...

	From the vmcore, we found 64 entries in the mapping which have same folio. And the folio seems invalid.
	Those entries always stay in the mapping. When the index fallback to start, we can find the entry 
	sucessfully. So the task stall in truncate_inode_pages_range().

	Since truncate_inode_pages_range() is executed with holding lock of inode->i_rwsem, any operation related with
	this lock will be blocked.
	
crash> tree -t xarray -r address_space.i_pages 0xffff9e1176d23eb0  -p

fffffa99adef6000
  index: 7467136  position: root/28/31/2/0
fffffa99adef6000
  index: 7467137  position: root/28/31/2/1
fffffa99adef6000
  index: 7467138  position: root/28/31/2/2
fffffa99adef6000
  index: 7467139  position: root/28/31/2/3
fffffa99adef6000
  index: 7467140  position: root/28/31/2/4
fffffa99adef6000
  index: 7467141  position: root/28/31/2/5
fffffa99adef6000

...

fffffa99adef6000
  index: 7467190  position: root/28/31/2/54
fffffa99adef6000
  index: 7467191  position: root/28/31/2/55
fffffa99adef6000
  index: 7467192  position: root/28/31/2/56
fffffa99adef6000
  index: 7467193  position: root/28/31/2/57
fffffa99adef6000
  index: 7467194  position: root/28/31/2/58
fffffa99adef6000
  index: 7467196  position: root/28/31/2/60
fffffa99adef6000
  index: 7467197  position: root/28/31/2/61
fffffa99adef6000
  index: 7467198  position: root/28/31/2/62
fffffa99adef6000
  index: 7467199  position: root/28/31/2/63


struct folio {
  {
    {
      flags = 24769796876798016,
      {
        lru = {
          next = 0xffff9dfa8024cf00,
          prev = 0xfffffa9997482210
        },
        {
          __filler = 0xffff9dfa8024cf00,
          mlock_count = 2538086928
        }
      },
      mapping = 0xfffffa999cf87190,
      index = 18446636480414094976,
      {
        private = 0x2a001e,
        swap = {
          val = 2752542
        }
      },
      _mapcount = {
        counter = -1
      },
      _refcount = {
        counter = 1
      },
      memcg_data = 0
    },
    page = {
      flags = 24769796876798016,
      {
        {
          {
            lru = {
              next = 0xffff9dfa8024cf00,
              prev = 0xfffffa9997482210
            },
            {
              __filler = 0xffff9dfa8024cf00,
              mlock_count = 2538086928
            },
            buddy_list = {
              next = 0xffff9dfa8024cf00,
              prev = 0xfffffa9997482210
            },
            pcp_list = {
              next = 0xffff9dfa8024cf00,
              prev = 0xfffffa9997482210
            }
          },
          mapping = 0xfffffa999cf87190,
          {
            index = 18446636480414094976,
            share = 18446636480414094976
          },
.....


	Any thoughts about this?

Thanks!



