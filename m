Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792564440;
	b=f4wOLGz+/HrqGoNa9Ll3yaJlcrMBvSBFDJEoxMe4/IxmQ3e7qQ7b2hONHwCMx/CKKKKG
	 T2XkM4oI48ULzBhrRxuX0jmbAmAYRonP1odxGkZpXATBAkaK0mrK/8sbPRF7qOHJodvKs
	 B7P5syUlx+RUxC/kNF3NClwP4SjtcBjU8v7QZlaqI5bP+COhWl1hrhzwE9mSiFib+WHL1
	 8/zZan7KLBxxB6AthIlOCjK92IWzpf/8wwrlS5d0Wq/Ty1vsLUqwX+c4fCEx7T+1PDZ+r
	 6tkFxyerhRjm2GCxEzxXwdieDNOZ+Lr8hF+edBtB2DDW2r1LNcnptXSoMM97Hsk/IBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792564440;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Vaam/ALx4CdqVcSAP/pijmolIFXuCMaRyfcRj58bxsA=;
	b=AjDuy1m5KiLts76WlQn5hFytA43+doUFwkGuJEG6BkmVOT+rmMBowP8ynywaJLRoZFWZ
	 ObNQlAI4Qiz7cOnS9j5c8HiRI+92Yt9iHI/gHI3d0PUCz9BInfi/DBcFz7NFwckQdoNlu
	 GS0dF2L1T3sUD6JBSWefxo9L4wKY/uX+n6hbMOj81DFtrGclyvciHyhbOOOKc+HItlTAt
	 oe9gG28yhwDSPzKdwVSOc83IGq4VJF0VtLe4YMwY3InTBepgbTl1HKsfQMVCP3REsyBxB
	 AYE7TpNCsv6wNGgRhVLv82ldskDw8o+HFolzf+qKhQcv1SeyoMxRqMzc6Is9TYDvFtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WHUEiMkr;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=aJ0zqFiM;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E3E606A33E
	for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 06:33:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96E3E606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WHUEiMkr;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=aJ0zqFiM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792564438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Vaam/ALx4CdqVcSAP/pijmolIFXuCMaRyfcRj58bxsA=;
	b=WHUEiMkrikxf7r8GwYEUUCe53OxvcHlrpDPMKiSimk+XivWk0PEP2y03Xh+6OLkJ3Z/hIg
	IBB+YR+w+nWV4Zs0kbgbbO0cqHHeM8uGlmD2vh1rs3N5oQ0QMSHkN/PvJwhheS0/5QgSIS
	cx4ET0GNMaPtQDJTBNPWlTQ8jqJ27dI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-W7ka3dgNP1CqkLfNB6rfKQ-1; Wed, 21 Oct 2026 02:33:57 -0400
X-MC-Unique: W7ka3dgNP1CqkLfNB6rfKQ-1
X-Mimecast-MFC-AGG-ID: W7ka3dgNP1CqkLfNB6rfKQ_1792564436
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48e0ef019a4so304137f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Oct 2026 23:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792564436; x=1793169236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vaam/ALx4CdqVcSAP/pijmolIFXuCMaRyfcRj58bxsA=;
        b=aJ0zqFiMkIqsi+s+g+eDk5wM1BLioqIhlBb8eyhsSxr+VR+Te2CIv+Haq0mmTc7npE
         oj8r1t2PvTnyGeoIi58ZtzsuByYHW6EJjjOuCLqwBXNKVdjP5rThHm+iizZB6mNdHUkf
         NGNF7MmlxiScK82FRX5SSLYd17qObtxxp0POVxW+HtUSdL77DIecOvYVuIkT/Ji2u6Y6
         A04AKutUmnwtG0vDvJgJGW6BzbN9VQGZO5/xUVnjwB9lr87I/ezw0BZVqcIKSoubKWJi
         fjhbVZksmMmrHouIjL+wOARmVrU2Y/y97HwxzfQhH+xldso+GTDJmspqqjFwaIrAAeGg
         CYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792564436; x=1793169236;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vaam/ALx4CdqVcSAP/pijmolIFXuCMaRyfcRj58bxsA=;
        b=OmI6k7zMHuN2ouaG0iYOlREtAVGlMqJo8rMrCI0bVYx4RlNRcFTAdt1lxbFg68zlBa
         jvuBgh3ZujWwv7nciyu60lLFD6acTbluXjmpLZK100f5WRxauqGGLWtG23OnL/Ty4Zrd
         8K9cF9dM6VjyDM2UPgiMdcVFymKXyL1fT6nGbUgRPoZ+5mzfkf12bVzvvTuLjSoNh1kN
         yhQZkt9vBFmbfEtDJMd9BPazVWrxqwkkfF9MoPiyAuNWfyLV/REycXkKam3qzZLhFIAm
         nMVpmQizF0r8Z8eioeZSyg6tkAvRUcW8uqjVaa+HE50EX8VuqAYgABLw1U6Via4FCHsV
         BSwA==
X-Gm-Message-State: AFq9FYKrdUACYtLkietPwUv2qrNewT7vtlg44UygZixZ6m7Fo6ZgJqXC
	j7tl0drpdcS2c8EfaHLcUE4HWNNMgr8/QoePzdxiD6KZNnshaKZh3ZPFVWjcEigxLcpu8Ekkyax
	i0VgJhqQxbam/rTUMUHLUCx8mQFZ1qZ9HiSb+z64vh2EO5MF7AxYCfgBrG9DgTg==
X-Gm-Gg: AYBFou1TfFj7OrdhT54+8AeKbF0sqgpkfWLO6ch7FqXoigzf5jH6FVd1SQJeSJQGH2X
	K08lLF4O1nZk01PbnL/NXOaeMfjai0fGWd7HbQ1SPZIYs2PRPGcdGO8Uk5P/lYjBvOw6Euzw60D
	11qAE3rHTywl1rWctcuIT1DKVDc7hCoJogn6ftw6LBRIX5M2CxpovaV2eMOCY98jbqVQhrUNXmM
	gZWGfRBeoOiS1UbPXUOyhRb0f03i9o7hZwkGQCfRbleQjKvYw53u+Xn+EA7RqdRNNVIqEG1Ayz+
	CZ15CTJ8OByhrqfTXn0KpEmkHwrhjeNQ573iySHZVAHraqKycnLDt+qMsdM+qrKUm6QKfiy1c1d
	jGXx4v43TzUgDsq1zWsK7qbt3tEH+nDMa5Wy6ZcOWyzYYuqgAxc7GskoogN3bAdyiUJ3uexvQGk
	inSkhE4YR362BE
X-Received: by 2002:a05:600d:82c1:b0:4a1:7690:d878 with SMTP id 5b1f17b1804b1-4a1fdb0a0b7mr21253175e9.17.1792564436036;
        Tue, 20 Oct 2026 23:33:56 -0700 (PDT)
X-Received: by 2002:a05:600d:82c1:b0:4a1:7690:d878 with SMTP id 5b1f17b1804b1-4a1fdb0a0b7mr21252765e9.17.1792564435675;
        Tue, 20 Oct 2026 23:33:55 -0700 (PDT)
Received: from ibm-ic922-09.lab.eng.brq2.redhat.com ([85.93.121.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fb864dacsm51763965e9.12.2026.10.20.23.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:33:55 -0700 (PDT)
From: Ravi Singh <ravising@redhat.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dave Chinner <dgc@kernel.org>,
	Ravi Singh <ravising@redhat.com>
Subject: [PATCH] xfs: mark i_mode=0 and shut down on attr fork inactivation failure
Date: Wed, 21 Oct 2026 08:33:29 +0200
Message-ID: <20261021063329.2853484-1-ravising@redhat.com>
X-Mailer: git-send-email 2.56.0
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

xfs_attr_inactive() can fail on an I/O error reading the attribute
fork's btree blocks, for example from fault injection such as the
dm-flakey errors used by xfstests generic/475. On failure,
xfs_ifork_zap_attr() zeros af_nextents without freeing the attribute
blocks or decrementing i_nblocks, leaving the inode in an
inconsistent in-memory state.

The inode is marked XFS_IRECLAIMABLE and remains in the cache. If a
concurrent operation (e.g., XFS_IOC_FSBULKSTAT) calls xfs_iget() on
this inode, xfs_iget_check_free_state() will allow recycling if
i_mode != 0. The recycled inode reuses the stale in-memory state
(af_nextents=0, i_nblocks=1).

When the recycled inode is queued for inactivation again,
xfs_attr_inactive() sees af_nextents=0 and skips truncation, leaving
i_nblocks non-zero. This triggers the assertion in xfs_ifree():

  XFS: Assertion failed: ip->i_nblocks == 0

Clear i_mode so the stale inode cannot be recycled, and force a
shutdown so log recovery frees the still-unlinked inode on the next
mount.

Suggested-by: Dave Chinner <dgc@kernel.org>
Signed-off-by: Ravi Singh <ravising@redhat.com>
---
 fs/xfs/xfs_inode.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 05a14da28..fceedb699 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1481,8 +1481,17 @@ xfs_inactive(
 	 */
 	if (xfs_inode_has_attr_fork(ip)) {
 		error = xfs_attr_inactive(ip);
-		if (error)
+		if (error) {
+			/*
+			 * Attr teardown failed, leaking blocks with no in-core
+			 * record. Clear i_mode to block xfs_iget() recycling,
+			 * then shut down so recovery cleans up the inode.
+			 */
+			VFS_I(ip)->i_mode = 0;
+			if (!xfs_is_shutdown(mp))
+				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 			goto out;
+		}
 	}
 
 	ASSERT(ip->i_forkoff == 0);
-- 
2.56.0

