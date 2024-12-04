Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79E215E97
	for <linux-xfs@vger.kernel.org>; Wed,  4 Dec 2024 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733320235; cv=none; b=SGfT/YnPdXuao/Wnox9BP99p//J6zF+cpB0RL03Npd4vouykC3hJUNLj7anON82BGu/oYsDCp40kr4T3x3UtgV1WlzdLtaXmH+1etXFjtT4zJbTCaGxWA2eFZjULKdb+WyrZB3WeGQK0ovrJYQvs6MwsjBd0ccuiyqgViC9qVFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733320235; c=relaxed/simple;
	bh=/vEdYSBDqMf9g3WzdFpXH5Evo29XzY5VIA9NXkfBfDc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=fq/pYQ6NntZhBoE/GVf7WcZWKgGMPVDihY79bQhw9r9DkF+HzRCijW51+sWEd9Lt4nYhtAguq/ZLohvhBYzJc0V50KjW1TzuDPrDbJvgVOyA7fSiFkgB5poMWWZZ9b0b/FiREVXIYKRdlKs4TrqM7ctZcnUypDscYSCBGtuhNzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XbmpaQ2a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XbmpaQ2a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733320233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5pf9S0wjsHVB1d0I1/9M9wV7z3+qpSZXgCM8JJTgUk0=;
	b=XbmpaQ2aIwMc8WgXiAqVjoGP6uG4NBK2bUc572skQvYzEkfhxKMY63MIVC8YilyFQ/+iY1
	GUvL9g2SB69RD/l9bOPR+tGam4GoCbPE/cKvfAw/vSP7L/WYkKqLZQVK590kjvvExt1UU/
	n53weD8ckBZSeXQGLw3HyiaTuQnHEBk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-WXOwaOqmOmi2t4B_0faD0w-1; Wed, 04 Dec 2024 08:50:31 -0500
X-MC-Unique: WXOwaOqmOmi2t4B_0faD0w-1
X-Mimecast-MFC-AGG-ID: WXOwaOqmOmi2t4B_0faD0w
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a7a5031e75so66759035ab.3
        for <linux-xfs@vger.kernel.org>; Wed, 04 Dec 2024 05:50:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733320230; x=1733925030;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5pf9S0wjsHVB1d0I1/9M9wV7z3+qpSZXgCM8JJTgUk0=;
        b=Io65hhIEn4y8Ku6Vg5BH6XA691Kq2zhXNW96xt72rFJnBkwA1ZXybdqOYEaiWkTOPo
         e54o12oKC+p1SkCLXegOlb0JzhTxT814rLPvvGPgOi3KurGfdepFmg9uLdxfy1jr2gap
         bDyEzF8JZ6GstDunsThr3F+cC+2qJbzJU4UOz9OHmGJKImhIEjfWoen77DPQSPXIXBmi
         LL2hEOzng0XOUUg+Zy8k6dH26JmfSYBbM4sN58i9VVtPvjtTtZHxOjlKtu1DrcFUZMCr
         cMltBg2mmkqDb7YWqT30nTrJRoFjX+OI78Nc4p4tY/2jv1sG1J7cuMXLEH1G4N1RBJU4
         wfYw==
X-Gm-Message-State: AOJu0Yx8O+spIviEPQfvUTrME9I/R8O+NiDquObSFXTZjE3vmGQhD7+6
	9LqKneKnsJXuwfM7jDMrTiZ2IoQgC8tgA5Oa3YVDPqL5dy7AuxZi/kmEg/827gzCbMrsW5FBzI6
	L43Tn31OTkJjMuFLU5VGh45Njnu3y7GPGPJOcT5AdaQEwS63jqPZdCohJ4g==
X-Gm-Gg: ASbGncsh/00KB/jNCDpUBEIQgnYTPce8NDIEif/e95DItiCAptYMh82iRpRRc3Isz9f
	IKyGN/RaPSKzNpFrLC7Fn6FKdZXlfxeA87HZdGK08TN1v9r96e+uoTuf6kyE7Ty/tUEnA3JRXNg
	qDTlJjkKzZlHddZGK49IfwJEEQ9LJppkN3BkeMVdUtVwLpi2knEeFwzJIxFcz4yweJwkrPZmQiK
	zEug48i1rvaJF2JwXJtJCWiJICwT9iNnt1PmJsdIFWipljhlgJDM1JIdFufgwsHYdmJniL3EtcN
	1IukMJXr02uA
X-Received: by 2002:a05:6e02:1947:b0:3a7:86ab:be6d with SMTP id e9e14a558f8ab-3a7f9a98002mr78600355ab.16.1733320230433;
        Wed, 04 Dec 2024 05:50:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHJTJhFY2RkeecoVqc8TmnWUl/lXTdWQIbV3hxDrxsH9RqzgNpW8Lo2I4Bckols8CiOL9prQQ==
X-Received: by 2002:a05:6e02:1947:b0:3a7:86ab:be6d with SMTP id e9e14a558f8ab-3a7f9a98002mr78600145ab.16.1733320230168;
        Wed, 04 Dec 2024 05:50:30 -0800 (PST)
Received: from [10.0.0.214] (97-116-181-73.mpls.qwest.net. [97.116.181.73])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a7e2046ecfsm22892885ab.2.2024.12.04.05.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 05:50:29 -0800 (PST)
Message-ID: <985816b8-35e6-4083-994f-ec9138bd35d2@redhat.com>
Date: Wed, 4 Dec 2024 07:50:28 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: grub-devel@gnu.org
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Anthony Iliopoulos <ailiop@suse.com>, Marta Lewandowska
 <mlewando@redhat.com>, Andrey Albershteyn <aalbersh@redhat.com>,
 Jon DeVree <nuxi@vault24.org>
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH GRUB] fs/xfs: fix large extent counters incompat feature
 support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When large extent counter / NREXT64 support was added to grub, it missed
a couple of direct reads of nextents which need to be changed to the new
NREXT64-aware helper as well. Without this, we'll have mis-reads of some
directories with this feature enabled.

(The large extent counter fix likely raced on merge with
07318ee7e ("fs/xfs: Fix XFS directory extent parsing") which added the new
direct nextents reads just prior, causing this issue.)

Fixes: aa7c1322671e ("fs/xfs: Add large extent counters incompat feature support")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/grub-core/fs/xfs.c b/grub-core/fs/xfs.c
index 8e02ab4a3..92046f9bd 100644
--- a/grub-core/fs/xfs.c
+++ b/grub-core/fs/xfs.c
@@ -926,7 +926,7 @@ grub_xfs_iterate_dir (grub_fshelp_node_t dir,
 	     * Leaf and tail information are only in the data block if the number
 	     * of extents is 1.
 	     */
-	    if (dir->inode.nextents == grub_cpu_to_be32_compile_time (1))
+	    if (grub_xfs_get_inode_nextents(&dir->inode) == 1)
 	      {
 		struct grub_xfs_dirblock_tail *tail = grub_xfs_dir_tail (dir->data, dirblock);
 
@@ -980,7 +980,7 @@ grub_xfs_iterate_dir (grub_fshelp_node_t dir,
 		 * The expected number of directory entries is only tracked for the
 		 * single extent case.
 		 */
-		if (dir->inode.nextents == grub_cpu_to_be32_compile_time (1))
+		if (grub_xfs_get_inode_nextents(&dir->inode) == 1)
 		  {
 		    /* Check if last direntry in this block is reached. */
 		    entries--;

