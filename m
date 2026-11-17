Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794934084;
	b=VqHysAe+afnfca6AaP+KTVXIiyDAVlbUUW7qabaylJYOCzlzul7h2jmnYvgKgrZtVXFt
	 Pm0KR7e/1YOf9ImvpDsGHGieFV1qO1/KhZobFRydEKErH9XzS1LmTJa59T2h8IxL8Zlys
	 GID32ugWxtQSdf1lx/xqpIRbcV/ch6PtCRUusRk2IQzKLHu2M9oFBkGtqJjb7Qu4Q7UTx
	 9Lv/0Flv06fpsfjRBKJ03Z8cmOej2r1+G7wxWuE6RQ7Dv2k8op+BMB+AAzyQZ7BV0zLgv
	 AqtybDwCSCFF+NOEwJ8a8WjH/Yzy2QINGKyOBm9OsQx8SQKfqK/14vjbJ28U9ysLikw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794934084;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ypdQxqNZeuAR8d72dGF4LGjrdC+bZ7mm7BusGxjOzZg=;
	b=213OVpJUSbQrdOyi+60UuarnxuOkiwLjRlV6wKUnhUiwfFkSREDjRiC1iMCEYZEaJQbJ
	 m0RrTA42XzQQTijlvq3IoouO2ydq2eJoVphMWTredzrQKznQt8v8ue4+/9UOyetrPeRPM
	 tu1X/u1tkjRYZ7J4uU8NjHETtL0VIqdzPXergyQFLn/eCW3vgLdF0Mlb/T2pABZ6FtK7F
	 wRqkJQ0uwzS5cGyPPWBf4O3XTzZIU3AYS30hvqAeql6cwL38zSW2H0LZa5x8lMJArg+3j
	 wlbLBOHQ5o9sCpYqyDhyHrzeKS99XyVtmCOBJ420fLwI4JFnuxOmiUTUza4NLN88Ttw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xu3A1GJl;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC0A606A332
	for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 16:48:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BC0A606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xu3A1GJl
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1a2af4c8d00so56727c88.0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 08:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794934083; x=1795538883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ypdQxqNZeuAR8d72dGF4LGjrdC+bZ7mm7BusGxjOzZg=;
        b=Xu3A1GJl8kozVTJFThjjXwIfrGDfI1536lRTU4RwWvLVpDAwzWzTumzfly5npajYci
         Yefv42bXR7jAWZ8Yedn3w12tlImAMsxHOhg+Y1ExRWhF8efD3WpSSKaKFaJqOYc6EMYC
         oYrUTGoHAQFVVO5qOiywoaNvC/yzO5GTjgV+RprLh9QNhShftBK5DowVp5eFI5yn5iL7
         +5qFmff3+LmBHbCqo56u8KWmQNd2RnsrZIFjW1YAdFBKRBEvIwFOUUKKPM8K6Y3FKUD3
         pb9Ya1yn1swzGGnl7hbAntMxpaeGYrrqKbcfFhzAfkGcnUeDJAOMxFFjGyQ3XXpgsrdg
         Vmhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794934083; x=1795538883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ypdQxqNZeuAR8d72dGF4LGjrdC+bZ7mm7BusGxjOzZg=;
        b=uDjw0xKUw2UabO+yrN8SdEWAhlbP+nFsscQj2+5dv0sQjlkT9NbKXJD15N+olQR0bc
         +6lbLq0ZRCGw8M4E9JLd7rDr8oVjuMJ1vvaeY8+vN2jQazlLSxvKXSAMwu8RoUGnPn35
         d2Dl3GSC/5pdZYbSsJAeYE7wY5CW9uz1XUAl2kw0K7x8Vd8TwewgUCQ7ZN1Zj+VOmdeK
         +pWDDFvpqW932Khioc3vD1gijB0C+D0ujL+nJB5/Bf6QY1PP2ymgxqbMbS8OAyPPdPtu
         pDV0kcUBiPqWwiABEVbt3xpviomCR/dswa1ElNtU6D8rNOkUeQ/sX4UKj8GBDbeXnoVo
         C+Aw==
X-Forwarded-Encrypted: i=1; AL+hErE/vhTk34DQ8YXmMet8FT9CwaNl5npRbzWxkwPjcGXEYds0QKhBaA1u87ZhsjopVypM9Ox/qXRYct0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/eng4Mya5pzPN5BrmMDx+ALS1PNoJfk2SZBs/7JtFZ/o2fQgPY
	380esOYT4JmOeEUkhpihs3SHsZTutmm9JfFkwa7s4nuPcCqSdL6or2gh
X-Gm-Gg: AYBFou1Qe3j81NfOmthMBJLX7IlKHZ0lIq3LPbh5JvC0umP3a0k7J12hsEg4RBH0uJM
	4ElLd+NjGLNUyqW8hdnYNBSRnswbkG2O+fAJgqNEpWRjV9nNoCnnVWZSIKJzjtpxb49lOuL8fhT
	HXdmdGo+6WZBUlYidYVu388TEI7h+p/pB5s5lDS7qvmZRikATNDqOyZPz7xOfTzdv5DW+FSG8fY
	uoBoIStBdASRjCsgto+a2YTD6F5ZtbMbXg1r0gXq+WasZx+LJr2n2vU4Fg6zCqpS8IPmppcJAUY
	tqFCF5p5Cb296j9nWLnRDq3m81f6NvESkYoaoaA2YPY3/Afwy3oerq4m15cEufwXlk8kXD/9VBi
	/v+eBcCgAQHHXU07ziItsOrdzCIwwKluXmL2f4/zjMtaVbTPTvVJmQqmU2tvmfyaGbAndFizFI2
	z8dCDJ40N4emS2V7zvVfUV8OSStmeistV19cECcEdIcS0Fo6B747eLI7o57Oo1f2cpYpcrloHCJ
	bpxcrjb/E7bfcA6rnzrepIKmN9UUpRdC4t1sp2PqiLfn4tWu3GWWL1QmVjUd/4DhkmpXRr6HHbE
	v2yTjGKhQY9nMZ9Eu2j9iIsYh0DKtEoMwUKYLXjvZgKn0G89W2VBlnPcbYluABu8PLoId3yYaw0
	A2HuFOFkaXbJPSgGy9Wn4PkIGOJD0Lwsqbdl8T11vKyAKuBne9BOnxNIZycHZPrZTdmeFZP6W6n
	EIvhmHdO2naiqtdw4WrlA7cwothRMxrC02FQ/xa9ap+YsS4AwnITRpj3xUiTdB4QWBakoEggZot
	GUfmYJz9+D9XW0=
X-Received: by 2002:a05:7022:294:20b0:1b5:2dce:1b6d with SMTP id a92af1059eb24-1b543cffc70mr134285c88.17.1794934083141;
        Tue, 17 Nov 2026 08:48:03 -0800 (PST)
Received: from FT6N242TWK ([223.181.112.111])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm60883753c88.9.2026.11.17.08.47.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 08:48:02 -0800 (PST)
From: Shashank Mohan Jain <jain.sm@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] iomap: fix offset truncation in iomap_fill_dirty_folios() on 32-bit
Date: Tue, 17 Nov 2026 22:17:56 +0530
Message-ID: <20261117164756.97065-1-jain.sm@gmail.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iomap_fill_dirty_folios() turns the page index at which the dirty
folio lookup ended into the file offset it returns to the caller:

	*start = (pstart << PAGE_SHIFT);

pstart is a pgoff_t. On a 32-bit kernel the shift is done in 32 bits
and the upper bits are lost for every offset at or above 4 GiB.

XFS uses the returned offset in xfs_buffered_write_iomap_begin() to
trim an unwritten mapping to the range covered by the lookup. With the
truncated offset the end of that range is below its start and
xfs_trim_extent() leaves a mapping of zero length. iomap_iter_done()
warns about it,

  WARNING: fs/iomap/iter.c:38 at iomap_iter+0x33c/0x36c
  WARNING: fs/iomap/iter.c:39 at iomap_iter+0x34c/0x36c

and iomap_zero_range() does not terminate: a mapping of zero length is
what the iterator takes for the start of an iteration, so it asks for
the next mapping again and again without checking how much of the
range is left.

On i386 with XFS (4k blocks) this is enough to trigger it:

	fd = open("f", O_RDWR | O_CREAT, 0644);
	fallocate(fd, 0, 5ULL << 30, 1 << 20);
	ftruncate(fd, (5ULL << 30) + 1000);

ftruncate() never returns. The task spins in iomap_zero_range() with
the inode locked and does not react to SIGKILL. A write behind an
unaligned EOF which is in an unwritten block above 4 GiB fails with
EFSCORRUPTED instead, after "XFS (vda): Access to block zero in inode
132 start_block: 0 start_off: 140002 blkcnt: 0 extent-state: 0":

	fallocate(fd, 0, 5ULL << 30, 1000);
	pwrite(fd, buf, 100, (5ULL << 30) + 8192);

The same calls work below 4 GiB, and v6.19 behaves like v7.3-rc6.

Cast the page index to loff_t before the shift.

Tested with an i386 kernel in qemu and XFS on a virtio disk: the two
sequences above hang and fail without this change and succeed with
it.

Fixes: 395ed1ef0012 ("iomap: optional zero range dirty folio processing")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
---
Prepared with Claude Code (Anthropic), model Claude Opus 5.5
(claude-opus-5-5).

First sent privately to security@kernel.org on 11 October; Matthew
Wilcox asked for it to be posted as a normal patch. Sorry for the delay.
The code is unchanged in mainline, so this is the same fix, rebased on
666539eecdf4.

 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6d843b1..846f87a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1735,7 +1735,7 @@ iomap_fill_dirty_folios(
 	}
 
 	count = filemap_get_folios_dirty(mapping, &pstart, pend, iter->fbatch);
-	*start = (pstart << PAGE_SHIFT);
+	*start = (loff_t)pstart << PAGE_SHIFT;
 	*iomap_flags |= IOMAP_F_FOLIO_BATCH;
 	return count;
 }

base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
-- 
2.43.0

