Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F402A2BEC5A
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229398; cv=none; b=Mc34XWAwdw5C6Rhaeg3A1KWXIAVwjpVge/1lajhoHFt7qiNyZd3lQumMyNuOMbso4a85N9ddC0edF+TWkLuDiAj4aQlGZyhJEKY1ksi8SOgHmkKOV+9PtWbE2MUnOuFOuCvywuDoBAEtJWTEtHcO+3QzXbTZk0BcCtaPhZGgVn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229398; c=relaxed/simple;
	bh=4pIvem8pTEBLg0KjsB8Rdb+YjFU50+kOccXs+aqTA3g=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XCQnHSMf7Y/rGj2llMKdV2U8dIxqTkhnqjlFfrXz8WHyt35isziY7WI7MPxIvX1ROSj1SGVg1Ob6uoCWLp3Olsk9XYxtjit0TQVkEtM7vRCGaUIyfRb3oNG2rccbAkEw6VmU3k4pO/0zYbxo1i3HD3zL5q1YBtunQo2NDbpkQmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hKBEKRDl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=r+6fbCj0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hKBEKRDl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="r+6fbCj0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W1J1NsEeqAiSWKeOnLnnShK9Aap7A5is4sYRY8AfigM=;
	b=hKBEKRDl15pHO9/qkx4F+C3lV+0Q3RpO4UUdArqZ9OAX46F2LagKS73eEbPRhiEGHRj45s
	KqI42mDCEXGqdI523q75gc3I+1UyoJsuFFCcN6Piu6aqjij+jJqzFsgk0vGJ/9efLa7ATq
	wLPJIpIBN0RCzjzZw5KcFVE/GZrYIvc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-PEGGP26tMBej0DgOeZResA-1; Mon, 12 Jan 2026 09:49:53 -0500
X-MC-Unique: PEGGP26tMBej0DgOeZResA-1
X-Mimecast-MFC-AGG-ID: PEGGP26tMBej0DgOeZResA_1768229393
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6502d9e9ddbso7694945a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229392; x=1768834192; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W1J1NsEeqAiSWKeOnLnnShK9Aap7A5is4sYRY8AfigM=;
        b=r+6fbCj01JX8AV84w6mmusfJsNdJl2Y7AQ8Gyc9nbN8O3VTv8k3ddb9HAP+2tSLnyL
         oAtCvU+KLLugDmYjMBi1Ox2Jbc9F+YXmSX+Hea1Wmvh918JgXMcFI4SlIbRBht5GNndW
         H7UnhWBAvf/qFYG7EsRKvfpeGjlhq+sMvfthDzLEbcfazRBE7Wnql3cKFBpxT+RTxZos
         krv2fCK/gE01ZRllqSm/BdL6NpAQ4Afx+DDZedM5xH6gQSEdmMsgk8RJK5N7bmueDlGV
         b974DNNkYBR7wzS8CrP0Fsa4n0P6OiEUod0JOkZpqTuqudGtzdb9GbH6+diwriGBiTL5
         gTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229392; x=1768834192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W1J1NsEeqAiSWKeOnLnnShK9Aap7A5is4sYRY8AfigM=;
        b=IrJakalMMCOylvp5XjTcE8jZKDtmJKZ4l+R68EomQkBbLW4WhAb84tqFutwyoTyxLb
         TPdqkOROP2oiWV1hA0rJRFPonlCRkkxY4cbnQPYTSD5+qsVN16xPFKQLsPoDRB9CHS7X
         Nc9fDGLNE/tjnHRjGQd4GhQonv7bDcmQ7hBFktsN7UfyqImbztxWhPHxG2AAY6mEV7W4
         UTPLB3Hi6UMS7F8ZEEVuS7N5vYKNOG8PWXg0lt1coWICNHEa2KH0pSDqyVk3KFp1bdTF
         EzlbIXL+BI3nKmPf+9LQwcPQpYAYelCGk9sCHkY7bpcQhfp4jihj4rDd6N+GyL8tci4Z
         AIXA==
X-Forwarded-Encrypted: i=1; AJvYcCUD2dLDkmMFnfsFWAH1jdtbG63kujn+eTgRejJKY5VcC2jK6MFQWq1f5xn3xEQsfSVXZCIQbZqba/8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb9+zduMJgT3iBWGLG//hZ8tuouN27EFuGbBxFnPBYMMdWzP0H
	RIvn+Wi2daLGfUPMsjlafN3Aw7VHbiOHO0scDPrIBgt2JxFkCpr4nf0OY/UX0dad6bSMRI9OcbL
	B/O6HNqhq82GQWIjWmeHq6FATC07kOKxTBZBL6cXOGp1MsINvA6FgN8t0f2HF
X-Gm-Gg: AY/fxX6hsnxJXzRbJgwCCt/njnXVibXQthrtV5HFfTRSfBF8Ow/pT4togvXghQhni6W
	0KBv3ZlMgy7dpdgPAgGnKDDgSyY4wMuGmG9VBVQSfJydxNtiZWqbicQxwhBKfPiGorakwW2rzuo
	zmxhZVSUOywoym0m/e+9Edgw9Fc+y2JdTmjydzzwoIyFtnBF7nJm4beiaSjAcM5Ix/is2YjlqFQ
	vwifyIfU6jt5cfqEw9kahG8REr7n2f41ANqmXRCzZd5ml0T7udy6NUs+3l9fXOZns+AaO1fMblN
	e+0m84ScJscSCbuXkicD/OTKcFJIGVLqes7t8gcfiTM3AJKT8XSgZmXrCmug4Iu67AVOJ1m/
X-Received: by 2002:aa7:df83:0:b0:64b:5771:8fbd with SMTP id 4fb4d7f45d1cf-6507bc6074dmr15225865a12.5.1768229392538;
        Mon, 12 Jan 2026 06:49:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFg3PYG3ssKkijdwkuNYFR4RE+iz8xuOvUCCQ6SXhVaANeWsiyZJ3Lv3ASL045hcT/Z291XKA==
X-Received: by 2002:aa7:df83:0:b0:64b:5771:8fbd with SMTP id 4fb4d7f45d1cf-6507bc6074dmr15225841a12.5.1768229392054;
        Mon, 12 Jan 2026 06:49:52 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf6648fsm17707771a12.28.2026.01.12.06.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:49:51 -0800 (PST)
From: "Darrick J. Wong" <aalbersh@redhat.com>
X-Google-Original-From: "Darrick J. Wong" <djwong@kernel.org>
Date: Mon, 12 Jan 2026 15:49:50 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 1/22] fsverity: report validation errors back to the
 filesystem
Message-ID: <dx6z2f5lrnevosqoqr4a2aa5bmxldmishn6ln22hvdkuxxmjqa@rddd4kri6bce>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768229271.patch-series@thinky>

Provide a new function call so that validation errors can be reported
back to the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/verify.c              |  4 ++++
 include/linux/fsverity.h        | 14 ++++++++++++++
 include/trace/events/fsverity.h | 19 +++++++++++++++++++
 3 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 47a66f088f..ef411cf5d8 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -271,6 +271,10 @@
 		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
 		params->hash_alg->name, hsize,
 		level == 0 ? dblock->real_hash : real_hash);
+	trace_fsverity_file_corrupt(inode, data_pos, params->block_size);
+	if (inode->i_sb->s_vop->file_corrupt)
+		inode->i_sb->s_vop->file_corrupt(inode, data_pos,
+						 params->block_size);
 error:
 	for (; level > 0; level--) {
 		kunmap_local(hblocks[level - 1].addr);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 5bc7280425..b75e232890 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -128,6 +128,20 @@
 	 */
 	int (*write_merkle_tree_block)(struct inode *inode, const void *buf,
 				       u64 pos, unsigned int size);
+
+	/**
+	 * Notify the filesystem that file data is corrupt.
+	 *
+	 * @inode: the inode being validated
+	 * @pos: the file position of the invalid data
+	 * @len: the length of the invalid data
+	 *
+	 * This function is called when fs-verity detects that a portion of a
+	 * file's data is inconsistent with the Merkle tree, or a Merkle tree
+	 * block needed to validate the data is inconsistent with the level
+	 * above it.
+	 */
+	void (*file_corrupt)(struct inode *inode, loff_t pos, size_t len);
 };
 
 #ifdef CONFIG_FS_VERITY
diff --git a/include/trace/events/fsverity.h b/include/trace/events/fsverity.h
index dab220884b..375fdddac6 100644
--- a/include/trace/events/fsverity.h
+++ b/include/trace/events/fsverity.h
@@ -137,6 +137,25 @@
 		__entry->hidx)
 );
 
+TRACE_EVENT(fsverity_file_corrupt,
+	TP_PROTO(const struct inode *inode, loff_t pos, size_t len),
+	TP_ARGS(inode, pos, len),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(loff_t, pos)
+		__field(size_t, len)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->pos = pos;
+		__entry->len = len;
+	),
+	TP_printk("ino %lu pos %llu len %zu",
+		(unsigned long) __entry->ino,
+		__entry->pos,
+		__entry->len)
+);
+
 #endif /* _TRACE_FSVERITY_H */
 
 /* This part must be outside protection */

-- 
- Andrey

