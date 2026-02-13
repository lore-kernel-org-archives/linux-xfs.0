Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51A8277C96
	for <linux-xfs@vger.kernel.org>; Fri, 13 Feb 2026 10:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770978055; cv=none; b=PA8HGkzToOOCGdpbIg3g4WDiJ12M6wYtXPfgKNufML8WseE7Nl+oWgD1aCIUDNE7d/IODBZFxlyok4iUyhOHNHqPDi4z/MgwbRnrl8+xUXxPaxx5gqhr/xij2Oa7vdGaHNSlOEf29Zav1IJPWG0DR/IGWzorlvc9RcudmrEHXNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770978055; c=relaxed/simple;
	bh=QkuM1KA98AjqJJLyF0SaSqtrBVA9aDzhjYALybpNT0Y=;
	h=Message-ID:Date:MIME-Version:From:Subject:Cc:To:Content-Type; b=IYKkk/4spc8vnVB1KznQl4Xds03LeLheX+2ybaybvGQHTCD4ku4eULTPZuRugSEJtXpUk9O8L067Emws42vt8dGbDdD3nlbiAptRsI58Wo10QDtUtmIIoPB9eC7fpOelHTR3YvqKHkqFtEMJMD0uNIG5WXygDHFJ//dq8sqZwws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S4ZmKQUW; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S4ZmKQUW"
Message-ID: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770978041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zuulf5kC8dVbyvKycXKA+/WFHNP1a1cf2S6fr25OXMk=;
	b=S4ZmKQUWfUTzcb+l80Q3gDvuoftWI4D3rknQ+3HONyVjmERdEHXtzqCTluwLI3lheRxLkB
	BedVdLXVMBk7HVoueNB1Pb9741D6IUfEDuJxSKHD9V+qk48Dxpa5sm7ZmzksF12vhQPDNA
	9IU6Q6YuTOt163xQnbmzPqV5XP0hI7c=
Date: Fri, 13 Feb 2026 11:20:36 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
Subject: [LSF/MM/BPF TOPIC] Buffered atomic writes
Cc: Andres Freund <andres@anarazel.de>, djwong@kernel.org,
 john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, jack@suse.cz, ojaswin@linux.ibm.com,
 Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
 Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
 tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
To: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi all,

Atomic (untorn) writes for Direct I/O have successfully landed in kernel
for ext4 and XFS[1][2]. However, extending this support to Buffered I/O 
remains a contentious topic, with previous discussions often stalling 
due to concerns about complexity versus utility.

I would like to propose a session to discuss the concrete use cases for
buffered atomic writes and if possible, talk about the outstanding
architectural blockers blocking the current RFCs[3][4].

## Use Case:

A recurring objection to buffered atomics is the lack of a convincing 
use case, with the argument that databases should simply migrate to 
direct I/O. We have been working with PostgreSQL developer Andres 
Freund, who has highlighted a specific architectural requirement where 
buffered I/O remains preferable in certain scenarios.

While Postgres recently started to support direct I/O, optimal 
performance requires a large, statically configured user-space buffer 
pool. This becomes problematic when running many Postgres instances on 
the same hardware, a common deployment scenario. Statically partitioning 
RAM for direct I/O caches across many instances is inefficient compared 
to allowing the kernel page cache to dynamically balance memory pressure 
between instances.

The other use case is using postgres as part of a larger workload on one
instance. Using up enough memory for postgres' buffer pool to make DIO 
use viable is often not realistic, because some deployments require a 
lot of memory to cache database IO, while others need a lot of memory 
for non-database caching.

Enabling atomic writes for this buffered workload would allow Postgres 
to disable full-page writes [5]. For direct I/O, this has shown to 
reduce transaction variability; for buffered I/O, we expect similar 
gains, alongside decreased WAL bandwidth and storage costs for WAL 
archival. As a side note, for most workloads full page writes occupy  a 
significant portion of WAL volume.

Andres has agreed to attend LSFMM this year to discuss these requirements.

## Discussion:

We currently have RFCs posted by John Garry and Ojaswin Mujoo, and there
was a previous LSFMM proposal about untorn buffered writes from Ted Tso.
Based on the conversation/blockers we had before, the discussion at 
LSFMM should focus on the following blocking issues:

- Handling Short Writes under Memory Pressure[6]: A buffered atomic
   write might span page boundaries. If memory pressure causes a page
   fault or reclaim mid-copy, the write could be torn inside the page
   cache before it even reaches the filesystem.
     - The current RFC uses a "pinning" approach: pinning user pages and
       creating a BVEC to ensure the full copy can proceed atomically.
       This adds complexity to the write path.
     - Discussion: Is this acceptable? Should we consider alternatives,
       such as requiring userspace to mlock the I/O buffers before
       issuing the write to guarantee atomic copy in the page cache?

- Page Cache Model vs. Filesystem CoW: The current RFC introduces a
   PG_atomic page flag to track dirty pages requiring atomic writeback.
   This faced pushback due to page flags being a scarce resource[7].
   Furthermore, it was argued that atomic model does not fit the buffered
   I/O model because data sitting in the page cache is vulnerable to
   modification before writeback occurs, and writeback does not preserve
   application ordering[8].
     -  Dave Chinner has proposed leveraging the filesystem's CoW path
        where we always allocate new blocks for the atomic write (forced
        CoW). If the hardware supports it (e.g., NVMe atomic limits), the
        filesystem can optimize the writeback to use REQ_ATOMIC in place,
        avoiding the CoW overhead while maintaining the architectural
        separation.
     - Discussion: While the CoW approach fits XFS and other CoW
       filesystems well, it presents challenges for filesystems like ext4
       which lack CoW capabilities for data. Should this be a filesystem
       specific feature?

Comments or Curses, all are welcome.

--
Pankaj

[1] https://lwn.net/Articles/1009298/
[2] https://docs.kernel.org/6.17/filesystems/ext4/atomic_writes.html
[3] 
https://lore.kernel.org/linux-fsdevel/20240422143923.3927601-1-john.g.garry@oracle.com/
[4] https://lore.kernel.org/all/cover.1762945505.git.ojaswin@linux.ibm.com
[5] 
https://www.postgresql.org/docs/16/runtime-config-wal.html#GUC-FULL-PAGE-WRITES
[6] 
https://lore.kernel.org/linux-fsdevel/ZiZ8XGZz46D3PRKr@casper.infradead.org/
[7] 
https://lore.kernel.org/linux-fsdevel/aRSuH82gM-8BzPCU@casper.infradead.org/
[8] 
https://lore.kernel.org/linux-fsdevel/aRmHRk7FGD4nCT0s@dread.disaster.area/

