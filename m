Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439BB38552C
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 23:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772063087; cv=none; b=W8ucXTYekSd8BlNW8R5Mho9667okONshCIWv+iXFiTAHHYK+JJJAcRJKLvIgFpJpkX9duXmvCE1k2SpElj41+cEOAjWLEJhH5Wh2VToF9gi2QBebbx+j+oBZLfM8naa5luGDrjCjOOt7nmMNgnaA4SZJLFLWRj3Zu2avfyTf2Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772063087; c=relaxed/simple;
	bh=86tTrdoOnAn/xo3cekp1XuyRqb4HRFNzoiKbv0I1ps4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sV2uDRCEZmp2gtsPMBpNFUSoPfYeAo8quhxvpUonHfpvQAmZiWBLuZchegfEHPsnRjdwPyWqmEL+JQ26RmRZeXWejDFuRTVWjEf9pcVmBrMntia8OMkpqONpyA9krDsFDwvrVXmvMWw0YREBmBOs4R7v68kIN3TmyS2KMeM5PdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=k8p8qfY6; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="k8p8qfY6"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PNNAeK4067655
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 18:44:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=QbU8
	qIjBMGeq/4CCh33jplvuFV4mV/Z7tLyPGzkrhRQ=; b=k8p8qfY6LKJTKzyyIu1T
	MBHAySeSL2rGW18v7FXhhfE5FBzkAnsvzwwdn7GkjnE3GX/FS+1Labq+PlugfXXz
	vOec7glehBd8/aUWG3kwI+2K7MIntwvnNxIlbXeb4MC2Iz8OIYCgGdmmdQomMWcR
	jawfPFhJyFIek32736qXfJ1Zsf8PihQodtpVLS4wPMGxrg7MiHzMTOTAz5tsZHSw
	kZ64SjLH0jiAaG/crVhQ9y25MdtNe8NaKVc7DRq0nHaElnWsMUg1K68u6t5fD41K
	7efzQ1T71c41RoTR8AQXiabnd0+DiFVVEkIL0sRUwP2Sy7x2D3aUqGREmAiKw7yl
	/g==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4chsqwxykn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 18:44:43 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cb37db8b79so258494385a.3
        for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 15:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063082; x=1772667882;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QbU8qIjBMGeq/4CCh33jplvuFV4mV/Z7tLyPGzkrhRQ=;
        b=ek8ANEN4X8+ipyAQxiMUIA9neWALOxiiVQzs2E7wGCQ7uq3Fqv+TwkGoLn5Xe2uz0M
         TfFWKXGr2oTJxS0aiLx1sY2ajQgSbYM30UIUh1LoVK4jej7w+2PUHyV89p58xvmxRHZX
         g7MdgtHOUC+sH/nnjwtTwgZOjAFEq7InAtH7jTz3fhFSjVkBGg3O4P1YtHVznOdfG+JV
         DNSyqMDJoZ5UkTf6TWKKZcTLtVYJRBy3g4Yt84/t6Pz12N3TpuDFZf/i8vYJSBxcSTEz
         0zzcw+fjJsY1wujOuRGkqltKNiJ4fEr7RCwxsFcakJ9m9l0e4TiTHII0RBhpFje1+nJ7
         WG7w==
X-Forwarded-Encrypted: i=1; AJvYcCXpHhSB1QIaY2zbmlofXCAEn3m4Mu2Qtyj+KFkOcGoOYtxJLHAYhxKpGH4vlzrKG8JvLDNnNT5rBZM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlxCi92+N7ugbadZk3qZwqzq+bbCYbVWXvX05Il77ldnKTNx96
	/YsKptd2XMDQAyuT3deibfTk6vWp/RyhnYIloeysFNPa0ISRGn32wsDzpxoKxhBQasGMb61q5Iq
	7NVx415uPKM9/IJ3hxWvTTdOa3lnM0KHJpSqwmgzFQqBvcpa+ZhWNRe2JfQ==
X-Gm-Gg: ATEYQzzHkiGHuLev8fOEX8t+hdYTEmHi5EDOpx9p/E5wyoSlGSHp57x/t2L6aAY92qa
	2SHJDhgOOVDUhtutqcTKfEKHIHtryt/kKRrje4LL5Ff9pxqXaps0S5CZepd45lgbnyL7duk1Fjo
	MF0oe+oJYdU4/mREiOjD9cQ+S6J9fNFlOCwbwIbi3UVxkeTJs2Itg1D1B+CWYsaPuGjvGrWJ/hF
	Wuz6AoRXcDv7dZzeStsqy2E6CCIySJik9VgGnniB1lYIF0lZ0GBYG3BnZzMxq//EslQqcPJ6lcC
	Q8XPefYNLN7vvdrtE2wuXhl2w2le7JY8eku/YgmASNnF5EHNj1VVG5zRjy0pnJ2vpFh4xdLPyxU
	lKYx8zhFGbFgvKP1WMmcfzvlVQbVRvpV+
X-Received: by 2002:a05:620a:bc6:b0:8cb:50d6:18be with SMTP id af79cd13be357-8cbbcf5fcf3mr351655485a.18.1772063082586;
        Wed, 25 Feb 2026 15:44:42 -0800 (PST)
X-Received: by 2002:a05:620a:bc6:b0:8cb:50d6:18be with SMTP id af79cd13be357-8cbbcf5fcf3mr351647085a.18.1772063081985;
        Wed, 25 Feb 2026 15:44:41 -0800 (PST)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c738d80bsm3357606d6.41.2026.02.25.15.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:44:41 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 18:44:25 -0500
Subject: [PATCH v2 1/4] mm: Remove stray references to struct pagevec
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-pagevec_cleanup-v2-1-716868cc2d11@columbia.edu>
References: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
In-Reply-To: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
To: David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Paulo Alcantara <pc@manguebit.org>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
        Bharath SM <bharathsm@microsoft.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tursulin@ursulin.net>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
        Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
        NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>,
        Dai Ngo <Dai.Ngo@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>,
        Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
        netfs@lists.linux.dev, linux-nfs@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org, gfs2@lists.linux.dev,
        linux-nilfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        cgroups@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772063077; l=2123;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=86tTrdoOnAn/xo3cekp1XuyRqb4HRFNzoiKbv0I1ps4=;
 b=0ov9kj7XAzT78Flm+u7++Q86OOmjR2OlGmMBdpiKWPN48FTWijPSg85hjs6TZBPJjXCzDYWnL
 klFYhD+F1AcALAkegHF4EiMet5ndziKuMEd8gAJMsRTj0W6VnFL6fSO
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: LNvb8WqXtn5UafR8hDMeQlWefQVsl7f_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIyNyBTYWx0ZWRfX7SMM9NvEUOOg
 uwenMF4oBr/5GlRFCZKQEYXlkGE2bp9hsKhK1SEPGxOkvHp4EIxe18VsHA4lNYp06EXVZweWIcr
 MDNRVvl1fWeFKTiGypQnvdPRbgsPn/nx67rE4Nfx/L9O4pxNMWpEU5yYBPFbRlhbV9vxs9jDhPT
 bMwGYNwr/Rnha+/3WRNwTCHKbc5JFP2i/p3WIAL3sm04xpdeKqiS3ohcHwf+nM9TjnnS8BTrBbA
 K+4AYQafOX2Q9xLaZVN1963Md5/bQA+N16pBy5IsV+xt0dxJiqRBkF5CitSaYaQWIqfADWiGswV
 M5W2OiPwt6tAftC72Epa8Avfbs7bpeopoV1JxM7UtJU/Hw8WZ0M3OqqVQmbn3fe/dSHQwCTB55+
 P+mt4cFWjYaWlQidbUdZ13kjoJ9UX67SCH6hImLPLDkVqVTQ3rKyOV5wsPQtOABH+WF+9A6m9dC
 7ZBP0+kcCEqTExNAmdg==
X-Authority-Analysis: v=2.4 cv=Y8b1cxeN c=1 sm=1 tr=0 ts=699f896b cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=KlNbpEHeXbYZISPg4o8A:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: LNvb8WqXtn5UafR8hDMeQlWefQVsl7f_
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 clxscore=1011 priorityscore=1501 bulkscore=10 adultscore=0
 lowpriorityscore=10 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250227

struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
pagevec"). Remove remaining forward declarations and change
__folio_batch_release()'s declaration to match its definition.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/afs/internal.h       | 1 -
 fs/f2fs/f2fs.h          | 2 --
 include/linux/pagevec.h | 2 +-
 include/linux/swap.h    | 2 --
 4 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 009064b8d661..599353c33337 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -31,7 +31,6 @@
 
 #define AFS_CELL_MAX_ADDRS 15
 
-struct pagevec;
 struct afs_call;
 struct afs_vnode;
 struct afs_server_probe;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index bb34e864d0ef..d9e8531a5301 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -28,8 +28,6 @@
 #include <linux/fscrypt.h>
 #include <linux/fsverity.h>
 
-struct pagevec;
-
 #ifdef CONFIG_F2FS_CHECK_FS
 #define f2fs_bug_on(sbi, condition)	BUG_ON(condition)
 #else
diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
index 63be5a451627..007affabf335 100644
--- a/include/linux/pagevec.h
+++ b/include/linux/pagevec.h
@@ -93,7 +93,7 @@ static inline struct folio *folio_batch_next(struct folio_batch *fbatch)
 	return fbatch->folios[fbatch->i++];
 }
 
-void __folio_batch_release(struct folio_batch *pvec);
+void __folio_batch_release(struct folio_batch *fbatch);
 
 static inline void folio_batch_release(struct folio_batch *fbatch)
 {
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0effe3cc50f5..4b1f13b5bbad 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -20,8 +20,6 @@ struct notifier_block;
 
 struct bio;
 
-struct pagevec;
-
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */

-- 
2.39.5

