Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794842426;
	b=4pP5Yw088wfR56ccaWy3V+1lu7lCTdrfxXhG0onH0dY/z9Qyq/ARTKW7k9Jp6+L5R7+d
	 X2kvaXuC4RqXhqJwo8xpcGGDeNy5Wlk0mhZYP2dfwHiOCtCpYsV84R/+u6cxl+R5XOQNX
	 6XVqSLWlWrT99PD2pDTDMxw/HS20onf/PNc0+2yjkcyga9jaWnieCZq+ckMq9MtxKRtnh
	 0VM+KqWoGuJbvAuKVT7kZpDT9wMwTLOuupCST38cuN6st4IQW6elWmeXGt+Aya1a/Poip
	 spNXWaFMgvNFZJHHTY4VgDiwf2DPezRfHrU1kqyjtQ2FKcD4KHh3qKO2aokTjHMsIZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794842426;
	h=Received:DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=EuwerLpUZyxMTnfmn/efDAw7K6nLMnb7DdMD/Ec2UXs=;
	b=MQAX11NqBl2+rF2+/Cm6By0xbZBZ++Ix9iVMRSiRiQKrhRVKXWbzF12E/zigi2JivRV2
	 oiRIRMLY3wPubX/ocm9k7nwgS2I6kQASJiHYtkvT6qeZ7dnyaMuQI5LxPiy0277AJjRxp
	 awNXsAGV7nZ81cmzeMPpR0iuKGeSn/FhH3EsOZyJVMo6f0cJ4nnULa1qjoiXB/Vh/bWel
	 p+WasxfXebyFOHI1cHUXx3YEx/smBGMnbbSWPYDKuHtp1IG6pFG8biJdoY9tK8NwUrceP
	 lMfDZrx0TQ17uT75JJL/Oz+/MZCG8Rna/45QrFI4/F19mGU+EiqiUV3gwH6dp9jIHew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaxoqFFN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8566606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 15:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaxoqFFN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E382D1F000C4
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 15:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794842426;
	bh=EuwerLpUZyxMTnfmn/efDAw7K6nLMnb7DdMD/Ec2UXs=;
	h=Date:From:To:Subject;
	b=aaxoqFFNTsuqpsJXIexE5w1dklE51XNomTVyxMA7QxnTbdQ47mhV25oeDaXgc4pa+
	 zI9prD+ObTZKt4yMbH9Ss+tmCv5VJRjJ3SaFHIChUd324LUYy0iMdzj5IgrCX9TZMy
	 P/y3/UJFvvI7AYO52GU0AJ18yEMhTq8Akgv4DhGC23I7quwpHyJaDCBUzvjKMG/IqT
	 +5NQ2Q1z+g7Y4GiZ1ANFp+2vDa06VcpP9fz+rjR+X8ldCF6pG7W1xiheU6jeR3o5zS
	 ikT3bjrF1b9R7iJ5Wm8QUJybkboS0g8X7ZgtQAR/2+4EcFg05cPh11gxoH2XVBkK9v
	 SkbhK39Y8284A==
Date: Mon, 16 Nov 2026 16:20:23 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: Subject: [ANNOUNCE] xfs-linux: for-next is now 14ae7b4071ae
Message-ID: <avsecxVFoDKQfexo@nidhogg.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi folks,

The xfs-linux/for-next branch has just been updated.

Patches often get missed, if your outstanding patches have been
reviewed, are not already merged in the mainline and are not
listed below, please give me a heads-up.

Follows the list of staged patches.

----- Fixes for v7.4 -----

Chris Mason (11):
      [8190880c904f] xfs: don't skip the flush before shifting extents
      [d467837a485c] xfs: flush the shifted range before changing the file
      [a38c5aadc06a] xfs: don't change the block map under a dirty folio
      [6fe08320c38c] iomap: don't punch delalloc under a dirty EOF block
      [3b6942b13203] xfs: test for reflink after the dio write checks
      [bdc3ee45df55] xfs: test for always COW after the dio write checks
      [f01f70e00770] xfs: refuse fallocate racing with realtime flag changes
      [230565493938] xfs: take the MMAPLOCK in xfs_fileattr_set()
      [03cbbd80a3e7] xfs: restart faults racing with realtime flag changes
      [44e555acd77a] xfs: don't enable DAX on zoned inodes
      [855abf2cf8cd] xfs: test for realtime and reflink under the pNFS locks

Christoph Hellwig (2):
      [369726f6be71] xfs: always call xfs_update_stable_writes in xfs_ioctl_setattr_xflags
      [7b2438af4d91] xfs: refuse writes to files racing with realtime inode flag changes

Daejun Park (2):
      [0d8026c7ac0c] xfs: break layouts before swapping extents
      [844bc1167f1b] xfs: wait for direct I/O before swapping extents

Eric Sandeen (1):
      [765db499ad58] xfs: properly order xfsstats proc/sysfs init and teardown

Hengyu Liang (1):
      [f0b9e58eee23] xfs: fix f_bfree underflow in statfs()

Rik van Riel (1):
      [f9bfe5af596a] xfs: keep successful near rt allocations

Yiqing Wu (2):
      [56b3c41b05ae] xfs: remove unused variable in xchk_stats_estimate_bufsize()
      [5c7da17f904d] xfs: remove unused variable in xrep_tempfile_copyin()

----- Next Merge-Window (v7.5) -----

Adrián García Casado (1):
      [976d3cd5b0a3] xfs: add __printf attribute to xfs_buf_alert_ratelimited()

Carlos Maiolino (1):
      [e5d3bcc6897a] xfs: remove redundant extra assert from xfs_zone_gc_query

Eric Sandeen (8):
      [20496da47af3] xfs: remove redundant stat checks after xfs_btree_insert()
      [e2293d89c56b] xfs: remove redundant stat checks after xfs_refcount_insert()
      [87f5edcd7190] xfs: remove redundant stat checks after xfs_inobt_insert_rec()
      [cfad3431d3ad] xfs: remove redundant stat check after rcbagbt_insert()
      [25b97ffb8111] xfs: remove status parameter from several btree insert functions
      [c71f58e4fde5] xfs: add stat check to xfs_btree_delete and remove caller checks
      [12be672e210c] xfs: remove redundant stat checks after xfs_refcount_delete()
      [01b68405c7f0] xfs: remove status parameter from two btree delete functions

Siddh Raman Pant (1):
      [13257daacb8f] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
