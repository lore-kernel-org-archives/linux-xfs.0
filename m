Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2F8456DEB;
	Thu,  3 Sep 2026 18:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788460199; cv=none; b=Fs/8PJCwj0b3QK7FSAIwgX0efDFrtoF0ASlt8V7nIdkbELPgASqkRmXUU7kla79n0LMn+EJLJzycn8duyiGxt58C7Kpp6dgI8rviFaTnZko4FfADWC6zQw5RNnabwP8CQKTh+DHfnx/cRZGoong1+XMnOyyrJVpDBViw7Ki+B/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788460199; c=relaxed/simple;
	bh=1W7kQwDNtrHeaK9OxcA8p3YHzc48GC5xPjvjcaW9Acs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BvRF2SqPk8h2pqPCD8u4KIXnDyXddoZ5fKfujRPcbXVmHq5N2TAMtn5GuzXhmJCmZ6lyIIc/WFb6H2aknmn/937FyC7UFQGRnqq8QJqPqOAafwfd0brI1gBYCUaobKoZ/udShAapG7QAKLh3IjUDz3o9gB/TJaEo7R8ZwUooJ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=CxPtMTTH; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OhhE1bUo; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="CxPtMTTH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OhhE1bUo"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailflow.phl.internal (Postfix) with ESMTP id 15D9E1380124;
	Thu,  3 Sep 2026 14:29:50 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 03 Sep 2026 14:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1788460190; x=1788467390; bh=/fSatvsWZM
	4B4zf1fK77XqXosYANLT56ve8NWTcWTZ8=; b=CxPtMTTH9TkAa4aDnaEhmQJnIK
	efRiwvfMnObkLuGH7iQqwfG1yb9qqYqizLmy0KgQo0q1KhW0t7or1QIOAK7oSMXZ
	JWKzUokFOVxClmmOKUZEi8hMmZPTmif8ArOkwEko2ICIxusw6F9h2JrFdxkxDDLZ
	0/2dZejfo4kuFRzQonWU2C5xdZjEb4EPkr+TQZDb1rAZHnr+ZO9whXAN2XmTSn2R
	PVqDRIggND452Jr4ju6hXShQAR2+rNTPIVMSMOsKEYzliniHgN79qYq2tR2j+ksS
	CXb61vPkO9gq1KNJWXlGRaFC+1RbwcwW2sskmmqxXxNn+kBrrlUjhGJKLNCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788460190; x=1788467390; bh=/fSatvsWZM4B4zf1fK77XqXosYANLT56ve8
	NWTcWTZ8=; b=OhhE1bUoRtN1xxHczEJYxz8pVDzzd2dfvyqTeKV4iRF8ifBvC3M
	8wEVHHHKhN/QNBMwXLMPL1od+mwkljYIbiPX9CW3Il/eMqLqKmUg48x7b++2nLDp
	b91FRn8vFFgHJ7LxfOd8rKTIliSSYTMOL7cvV4OXU64y+iJLLZTF4QWf3neIIRZr
	aCcz5ATg1CTKxgScWSN0Qf/ECLF4lnGNQfvkqLeaGcuKL5sTRiXRWsgI5kXvbHF/
	E6NuAJHTgkfhTF8kPWt84/41TateQXMqT4X2+pHqvm0Ph7IbOE28ygTYLuaLF8gm
	LyGdd/SwXoLiVOAHV1E/Ij6reIB8Oi63J0w==
X-ME-Sender: <xms:nbyZapCYC7gXPp0GMMkMgtXsWAWvZd-zVwEHqMcLjCxAOex-B6GIQA>
    <xme:nbyZaokMcjRmjIg-G1qDOo8hJmQwuI1o3wyYT7qAM_NJj-9PpzeTnx4UvaHY2B3gH
    H53MBDdcKBs-1qYY8g3mtdBTps97sag9vlkOu2RUF4zIhelN2dZBgg>
X-ME-Received: <xmr:nbyZanhBpl7Pg_hBzPBTwGHlagURlR6uWONjTBft8212oj3QYkZuY0D_82M>
X-ME-Proxy-Cause: dmFkZTGzhS0EF+xT7L4APxnR4/6WqwEo/DPnzsf1SrAf29Hq8MqzP2TtfK1qR/Svqk+STv
    H4nyfck5vC3zIkbYydfT1Ttl2XZBvWEsTV9U7KUCJvpYiKzH3LLS1TpMk1G8Q3iTlEeqt6
    uCqSQ5F3FzkpEfnpwRBCLOGhNeU0tP6d3OQbhYO3M7PmyvCrhn3qG+OlNDPJKGyZgSthfF
    vI3CoYKv29fWoxbxnpYFUa5xdbF0HB1C9u4CCfeYbHoB3NBJzU8b73sgbQ99wHxzD/oqD9
    nmFhnPrAi7wEECNbyJ9wz2vD++cZExRKpHmU0uZ7vFfONmUZQ/wkCcSDV+9t34/IO9YOpX
    pt+pno6vg2zNg0rB6w6K2L0RQq3qbN6xHrl+RlvfD0EmGDW67TeFKmpYKwvv1xlSl5Kkm0
    SE4iL2xcx9DW6rY5bgR+REp8zE5GL9YG+8NUiCkwx05ewzr6QX8VfNRh6KzIcE5GJ5XTsB
    ZYoViLRJvipGySeYV7w0MxnMC6kyzC2lVOdcVwljW7AhR06y5j6vujQrPsj8SrNAN5eaUm
    77U79F2B3v+mIDhCNPw5iZZgNk5WfrNqorNrSF3AVWPeFfUhlwhd9VKZyAXG2cOtjgfoMo
    d44VAQf4TsN8v+Ebzh3NAJC3CE5akd2vrGCbHdw0KuQ0kRfP1NWLkvVEbD9A
X-ME-Proxy: <xmx:nbyZahf2FWn5k8aa0ijhYFfvDJYQmyhZg7BxSakhXkalyeEk4pH-bw>
    <xmx:nbyZanAt92YMvc_4qWmEMegxLEaqerfxji1JD_BriReXo8ModkjJPw>
    <xmx:nbyZal6RlVehtUw9FikKgP0RrqyDufUaoaVaK5J6tssv14zcvv3K-w>
    <xmx:nbyZakyxtVw9rNEDX2187f1xaiu6W_iG3mnZWnSq_1qMt2o_2pPM_g>
    <xmx:nryZalVKCWmbfmDcii_JrBWGoRPFo6iHGYKV16G-Hpo7yN4I-dl1qQdz>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 14:29:48 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap writes
Date: Thu,  3 Sep 2026 19:29:38 +0100
Message-ID: <20260903182943.662461-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A store through a shared file mapping dirties the whole folio. With large
page cache folios that turns a 4K store into 2M of writeback: one dirty
bit per folio, and writeback has no way to know which part changed.

XFS already knows better. iomap tracks dirty state per block and
iomap_writeback_folio() submits only the dirty ranges, and the buffered
write path sets just the range it copied. Only the mmap path throws that
away, because iomap_dirty_folio() covers the whole folio.

Narrowing the dirtying at page_mkwrite() time does not work on its own:
set_pte_range() batch-maps a whole folio writable on the first shared
write fault, so the stores that follow never fault and never reach the
filesystem.

So harvest the hardware instead. folio_clear_dirty_for_io() already calls
folio_mkclean(), whose rmap walk reads pte_dirty() for every entry of the
folio and throws it away. Those bits are the only record of which parts
of a large folio were written through a mapping. Collect them there and
hand the filesystem the runs that were dirty, through a new
a_ops->dirty_folio_range().

All of this is about PTE-mapped folios. A PMD-mapped folio has a single
dirty bit for the 2M it maps, so there is nothing finer to harvest, and
it keeps writing back whole. Keeping shared write faults off PMDs is a
separate patch and not part of this posting.

On a 512M file in 2M folios on XFS, storing one byte per folio and
calling msync() wrote 512M before and writes 1M after, with identical
minor fault counts.

Not addressed here:

 - Dirty accounting stays folio-granular. A 4K store still counts as 2M
   against dirty_ratio and balance_dirty_pages().
 - iomap_page_mkwrite() still allocates blocks for the whole folio.
 - Filesystems without per-block dirty state see no change.

Kiryl Shutsemau (Meta) (5):
  mm: let folio_mkclean() report which pages had dirty PTEs
  mm: add a_ops->dirty_folio_range() and use the mkclean dirty harvest
  mm: keep the mmap dirty range down to the faulting page
  iomap: narrow page_mkwrite() dirtying to the faulting page
  xfs: track mmap dirty state per block

 fs/iomap/buffered-io.c | 37 +++++++++++++-----
 fs/xfs/xfs_aops.c      |  2 +-
 include/linux/fs.h     |  3 ++
 include/linux/iomap.h  |  2 +
 include/linux/mm.h     |  1 +
 include/linux/rmap.h   |  7 ++++
 mm/memory.c            | 58 ++++++++++++++++++++++++++--
 mm/page-writeback.c    | 87 +++++++++++++++++++++++++++++++++++++++---
 mm/rmap.c              | 56 +++++++++++++++++++++------
 9 files changed, 222 insertions(+), 31 deletions(-)


base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
-- 
2.54.0

