Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135388;
	b=BpS7ZfB+kYMxXMBCKN2B+TyJxLN/og2Ho8WUO9Z7JBu3Aab/PI+8/CVatuEs63JUJKna
	 znm5UjjOQrbC00O0uXdzpuiO65BjBAQolg7peOLiVK+mIS8Sd5RAntrQJUlQOrBpbFqED
	 45xX4ft8i1sKXqnmxzwSrn4GC/Ho/QFd+1662TH2owCy7DR7u41HXfkvg2VqGRZN8XWTy
	 1vTQ/la210Qd3RnQRBiP1EMaliJ2v3/Se0/xgZa94hcB6TgaZ+8130LmM+Xk6OTjwosTT
	 tlwVNFf7CKzz8Ia/OIIx5ZH4lDriz11sWVSq5UylGT+DXVvVY9zV5WVVFyMR0NXxJIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135388;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=VCEcm4cS+10pCnJSMFad8ba5TMU2TuUeL3FkRRgF6q8=;
	b=QYWB7nxXorkM9hJq6j3N2DzZJSPEqenvHwi2ntHGwyBO6OjiykWSosU8aK8fIKegr1DJ
	 4Sg8wF94RLTKjqJH2CVfHM5yN86a6wObuNJCQ8oZi3iTFVQGU0oHyqu8qXeJg2pOWkTR0
	 PEzgARuXIpVK6n9NaXS5kBXX2kOfZlb5qQly17CqSTGcOiCEZ+XoaD1BlAGRn8goT/B59
	 R8a4IHfROgj/WUemYksBXSgi0HcXWBnDPPJ7Y60hM6pek9Y8VOKHhrNrldRB8uHw8d8IY
	 8Ey6acwQXi88V6Vtqi6lsrYl8xrMSlacq2iGMhqUZMnPTolEFBaOj8c7SpEzkE5n78A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=FQHSQ1Xj;
	arc=none smtp.remote-ip=209.85.219.45
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B954606A33F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B954606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=FQHSQ1Xj
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91c76540d0bso3999966d6.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135386; x=1793740186; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VCEcm4cS+10pCnJSMFad8ba5TMU2TuUeL3FkRRgF6q8=;
        b=FQHSQ1Xjob3WHhUaX3x82quOmbvHijcNo87LcLe3hU66UzYG7bmQwI85uzpWaWJupm
         KykqsDzMCN6X2n23+/flDGS6Gspdiaa5tT+DP+M0411w7Eendt5bGh5d1Z3u8wgc0VW4
         NnO1tcD7gy9x94obfitEPTCsxXkZWuxozR1KbYqMaiO++B8nwmaqeBZkDthLx5WJmtAe
         5F49sYgLIG9zMONMcysfC6D9lMML1dymiQwjT7EVKAjPgB+nHNpESM8ljHUNbr2h3Cp5
         +w5xWRdb0LP5CXtBDP5U2nb+mIXEzN5tPXWQhnELmIZ2JM11s+TUoSzPlfWzOtvusXjo
         fcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135386; x=1793740186;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VCEcm4cS+10pCnJSMFad8ba5TMU2TuUeL3FkRRgF6q8=;
        b=QGWjFn71Fc16i67p4DCqIhma7IFguETKRVa+Ygs8MUp7cM3rgKej/bVe9FyF2JweTY
         dXVzjnrQc214B1aAPsZAaIA7QcRslWIMcT7Xqt0SbzLZKhRwEKCANNe12EtIKZVczdk1
         Luv8S2uCx9AhHLfpIQOeyl6+R7ZetTm+XfLAilOv2j2kgo8YkJ6mKfeymgwJSmCPuwhc
         IccTkwJB6obDEsYMFc0gLfYLWQFKTKLqYFKm1arCSVJHssUOJcWH1lnyy2Es2XP9Ze5a
         G2T32CcPSAqZR2nXpyM1CNy9Gz6q6QdnvzKK5n7rxGL1R/YuwdH/OBtkZ6rMzwB6IA+c
         v2uA==
X-Forwarded-Encrypted: i=1; AKwUvBw36wOzu/GLlkRN0dDLE3OPZynzh1H0URJ0PyA7R1b6PVACDMeXifOXAAAG73uX2lrrxoH6mAHsug8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJVRqAiZ+QMoUvF4B0bf568f9n5nsIUiXOf14C9RjW4Efmy25j2
	PESl5XDcVrIkON+lMvVjkOXuvDn836T/NiDnKDtFnzMuSfJmaNIPIEwjvIrTW7J5wY0=
X-Gm-Gg: AYBFou1qbZG4GXPZAk8jt4nSGJmTsYFX7ILzMPvqlUbAgD8bBWvqi2WSA+enpB2qYeL
	3iws8NMPPZfuyJgheBxy/NBqd+K5lKqXlK+uoK7QVFJMwHsRUWMBYvedVqnjGYu9GZtHGTozZRV
	hG4G+fXil8w+Te4Q9YzKgR4AsTrFR//vFBcUuKOiiB4D5OJ+eZERSs6/k3cOcisC9G9alfi8wTd
	f2Q3BdK4jJDEXOqaYCOgCtWQZdI7Udbkx2YD6IsqjrK4+S5VRyhZlaNexZZUsXjQME8YhWNAHGA
	9xP1GSZ63OqqYH/aykjfwjGjsTdtkCGZFzFf4Y3GgebnRYGAc+sr8Ef4lO08gKPKaux+AEsWNLE
	yI/n5b9i6Gm3QCQgEBhl788T7b3dbXa+qmouw7O2J5MvXSYsscaIP+5bvbOai7O5JMuajZJtVAK
	09aOrGBWu5/Mk45tVg+1ZqARf5kzPO+0SxhsUkOU6W05Whk4MPwfbK4GYqawjWP7g5rlaQhfxMF
	KrQZSFKfKILKJAi33zxIhctC+15UdZ2reGJfebUSlYNAeECK5/v6LGCB40KMH47V2Yi66QQVDZd
	V4OItvrZ8YMCMIvyiw==
X-Received: by 2002:a05:620a:2807:b0:939:7683:33d5 with SMTP id af79cd13be357-94408a695a5mr30368085a.19.1793135386512;
        Tue, 27 Oct 2026 14:09:46 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.247])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f067e97csm1085505285a.21.2026.10.27.14.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:45 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:27 +0000
Subject: [PATCH 01/10] fs: add SB_I_OVL_USE_SYNC_FS
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=1928;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=BvxK3YOpk7h16bCpQ/+zltv4OfgiS86cLIhuZg2ctrA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QKlMexL787FCcvVxNerffS9t+F2LVb25W0OH2+5Jl6mnH6Q2yBl3k0xGc5yZMJyQWizXzvDekUq
 dgRiGoxsUwgQ=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

sync_filesystem() writes every dirty inode of a filesystem and then calls
->sync_fs().  The data needs that.  Whether the metadata does depends on
the filesystem.  ext2 copies an inode to its buffer in ->write_inode() and
nowhere else.  A filesystem which logs its metadata has recorded the
change when it was made, and ->sync_fs() commits the log.

overlayfs wants to sync what was changed through one overlay instead of
the whole upper filesystem.  It knows which inodes it wrote data to.  It
has a much harder time with all the inodes which the upper filesystem
dirtied on its behalf, many of which it has no inode of its own for:
whiteouts, index entries, work directories, the parents of all of them.
With a filesystem which logs its metadata it doesn't have to know.

Add SB_I_OVL_USE_SYNC_FS, by which a filesystem says that ->sync_fs() with
wait set makes every change of metadata durable which was made before the
call, whether ->write_inode() was called for the inode or not.  Timestamps
which lazytime holds back are not covered by that.  As an upper filesystem
of overlayfs it then gets ->sync_fs() instead of sync_filesystem().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 include/linux/fs/super_types.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index 72f4288e16c5..370b0d27815b 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -359,5 +359,6 @@ struct super_block {
 #define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on this superblock */
 #define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this superblock */
 #define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee data persistence on sync */
+#define SB_I_OVL_USE_SYNC_FS	0x00010000 /* overlayfs: ->sync_fs() commits all metadata */
 
 #endif /* _LINUX_FS_SUPER_TYPES_H */

-- 
2.55.0

