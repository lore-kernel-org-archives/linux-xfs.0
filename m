Received: from pannekake.samfundet.no (pannekake.samfundet.no [193.35.52.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F081CA84
	for <linux-xfs@vger.kernel.org>; Sun,  2 Mar 2025 08:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.35.52.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740905234; cv=none; b=DDW/ARR79sCQasgANroinjsGSX39m90IL1t2SoL/CXUg4fYiUsq7S+9N8TxmtC/dWiTkNAFsDJhEUSKUqrwDt32OZat3KLEbXk99WFqtcczglhmfIOEdzhllot0vi94+mgbjJRp8nLoi2FK+WsdkXJtNqbm7d78U8pybjxrZcXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740905234; c=relaxed/simple;
	bh=b1RgMhf7CekUaeWLKoP5HHTOJhNlKh18JhOxjLYOcXQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oKmpXtabqpN8hfPcUTUyydd1E6paTUKyxcgZG8mm1JINXR49hhU5qUOVldnbmrlUV+HOZAOyIN2f2l5xqJPknP7F16hDSbX+sgPF+Yk0O6Byh/dWCH25xN+g7AsCj298Skb5+dQYrmdjoUQr83Uet3pXd86osjmf35SEPEB3ItQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no; spf=pass smtp.mailfrom=gunderson.no; dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.b=kfbUACvz; arc=none smtp.client-ip=193.35.52.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gunderson.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.b="kfbUACvz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gunderson.no; s=legacy; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=k5C3xiR6roco6weAKgrELSEsW0SzvT6rYvYVjz8M32M=; b=kfbUACvzTTm5PFHNC8cfENQjK9
	A5cs09MGgcZ8JGOiOmQ3IvPrdNx9yTtokMn6fHdmqZpQVxuevd3fkQUt2SNy2Muabaj7/yjFMdXaU
	5XTo4z6jknml3yVOllncxe7L4coconELPOoTf4OnNYbvM0/Rkxj90eY/F4pakM5x6aYd0YNomou2I
	8ywp7ywjod1HO03WBRNL9YTdtfEomzuIIDgGJ9pG9YBKGqrYscBFuwwHMJK5CzNKkZdlddUFRy1oF
	u4qJsbflusM0bf2OUWKjKI3K9ew8izUbic4zqQHlAzZOSaZdWLQATuY6PRw+mzqLh/cWiEOfvmzU5
	99DB7D4Q==;
Received: from sesse by pannekake.samfundet.no with local (Exim 4.96)
	(envelope-from <steinar+bounces@gunderson.no>)
	id 1toeyc-0042TI-1F
	for linux-xfs@vger.kernel.org;
	Sun, 02 Mar 2025 09:47:10 +0100
Date: Sun, 2 Mar 2025 09:47:10 +0100
From: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To: linux-xfs@vger.kernel.org
Subject: Slow deduplication
Message-ID: <20250302084710.3g5ipnj46xxhd33r@sesse.net>
X-Operating-System: Linux 6.13.0-rc4 on a x86_64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

I'm investigating XFS block-level deduplication via reflink (FIDEDUPERANGE),
and I'm trying to figure out some performance problems I've got. I have a
fresh filesystem of about 4–8 TB (made with mkfs.xfs 6.1.0) that I copied
data into a few days ago, and I'm running 6.13.0-rc4 (since that was the most
recent when I last had the change to boot; I believe I've seen this before
with older kernels, so I don't think this is a regression).

The underlying block device is an LVM volume on top of a RAID-6, and when
I read sequentially from large files, it gives me roughly 1.1 GB/sec
(although not completely evenly). My deduplication code works in mostly
the obvious way, in that it first reads files, hashes blocks from them,
then figures out (through some algorithms that are not important here) what
file ranges should be deduplicated. And the latter part is slow; almost so
slow as to be unusable.

For instance, I have 13 files of about 10 GB each that happen to be identical
save for the first 20 kB. My program has identified this, and calls
ioctl(FIDEDUPERANGE) with one of the files as source and the other 12
as destinations, in consecutive 16 MB chunks (since that's what
ioctl_fideduprange(2) recommends; I also tried simply a single 10 GB call
earlier, but it was no faster and also stopped after the first gigabyte);
strace gives:

  ioctl(637, BTRFS_IOC_FILE_EXTENT_SAME or FIDEDUPERANGE,
  {src_offset=4294971392, src_length=16777216, dest_count=12,
  info=[{dest_fd=638, dest_offset=4294971392},
        {dest_fd=639, dest_offset=4294971392},
	{dest_fd=640, dest_offset=4294971392},
        {dest_fd=641, dest_offset=4294971392},
	{dest_fd=642, dest_offset=4294971392},
	{dest_fd=643, dest_offset=4294971392},
        {dest_fd=644, dest_offset=4294971392},
	{dest_fd=645, dest_offset=4294971392},
	{dest_fd=646, dest_offset=4294971392},
        {dest_fd=647, dest_offset=4294971392},
	{dest_fd=648, dest_offset=4294971392},
	{dest_fd=649, dest_offset=4294971392}]}

This ioctl call successfully deduplicated the data, but it took 71.52 _seconds_.
Deduplicating the entire set is on the order of days. I don't understand why
this would take so much time; I understand that it needs to make a read to
verify that the file ranges are indeed the same (this is the only sane API
design!), but it comes out to something like 2800 kB/sec from an array that
can deliver almost 400 times that. There is no other activity on the file
system in question, so it should not conflict with other activity (locks
etc.), and the process does not appear to be taking significant amounts of
CPU time. iostat shows read activity varying from maybe 300 kB/sec to
12000 kB/sec or so; /proc/<pid>/stack says:

  [<0>] folio_wait_bit_common+0x174/0x220
  [<0>] filemap_read_folio+0x64/0x8b
  [<0>] do_read_cache_folio+0x119/0x164
  [<0>] __generic_remap_file_range_prep+0x372/0x568
  [<0>] generic_remap_file_range_prep+0x7/0xd
  [<0>] xfs_reflink_remap_prep+0xb7/0x223 [xfs]
  [<0>] xfs_file_remap_range+0x94/0x248 [xfs]
  [<0>] vfs_dedupe_file_range_one+0x145/0x181
  [<0>] vfs_dedupe_file_range+0x14d/0x1ca
  [<0>] do_vfs_ioctl+0x483/0x8a4
  [<0>] __do_sys_ioctl+0x51/0x83
  [<0>] do_syscall_64+0x76/0xd8
  [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

Is there anything I can do to speed this up? Is there simply some sort of
bug that causes it to be so slow?

/* Steinar */
-- 
Homepage: https://www.sesse.net/
