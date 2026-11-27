Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795769499;
	b=IW2qR3+C64o/xRlYAp0h+MhIsV6iCJLDPrgrt58CyUKcqVznD6A9N01ZRKuTixZmiZXK
	 yL7cQRqQASiK8qCA4bLsC7a5eJ6xr1JueE11muM5rANudpqK46djHBa5PBD6+tMftT7dd
	 00NNn1REr8AsL3By87qkvFiEI0yYgCIxNZWo+eHotYn4JxLX7deLv2brBSOA+9DPuCSrX
	 6qMTjn7Dr27E8q+ytJAsBT1k59ZdvPNT/zuoMkl+apCWNZDyxAXUXqSiyTv7RZ7sJBQ/D
	 Q2lw5kG87+pbGzQ5V00Tv2U1csr6W2mxOocGVePUUx7piMwBr54nk8HTC8oxgXN6Pzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795769499;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ROnGks4KYpRui41sSEQf6LMRfROe8Og9QvbvYoT1JlE=;
	b=o+EpbMdpGE5T0ZPbuS4K39BfWmeFgsR3mIPvBfurUekCStYSoJNBA/DSSSauMgru2b5+
	 RJxF8Fr9V3PxI+pyscIHpoTZ+lnTCODGt/9+WpBOIPkNc+a0vlUyAiIJvU1nf3oUJhjYL
	 bQ9cwQbhdu0Isvkkxf99jdgYI7KHuFrTyviOB6SviOZztblmT7XdIR01rbXD6/JIu7wa1
	 LM0Iev7FQu2vzsgBQHGnecddvj1vjwKDsJuL2M8yrLkzPUltp4WetVrAtauIY2E2oJI54
	 cNmoAs31GDWK2OdjyPbmsL3BJ2hJxbIxoc5v6cUWZrIdOtMblfbnI2aqwBKc6Ct3J3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jycF48jN;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276D6606A31C
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 08:51:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 276D6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jycF48jN
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-492690dd5daso5989321f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 00:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795769496; x=1796374296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ROnGks4KYpRui41sSEQf6LMRfROe8Og9QvbvYoT1JlE=;
        b=jycF48jNPsUQ9iQ4obcMgC4D8lLeeiJlBONFTHKNm+rSfBrnk3kngtKHacobMiedZj
         G4vkv+ubR0FS+aaIOC9RmkxVGA7BTztW80RI32AEtjUckdj7P19myLljSxbK9nELbQpc
         NKTZ1U+muo+j2ahqLG6P4PThjMoGJv8fcYOgRmdTA/OUYQYCTwLFdENaPf6fWRvO/N91
         UzBjIqdlCmkWuwuubiYJY0yJIihNztfAqAf89Zzh7cg+aYSyabCN/l6qkz5hkOVkwRKW
         Ba0a41rYsNvf2AwVnVddv0PHN2ejbJVmWhzkL58m/VsWpx5QTaMHqUUrN5WvHTP1NI+x
         t2SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795769496; x=1796374296;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ROnGks4KYpRui41sSEQf6LMRfROe8Og9QvbvYoT1JlE=;
        b=tc/sJw5YF5sfTtwkCOb5SlCI5PJ9T0wQVZksohhNYzqIxEJfDeLtLXKdjF2zTxG7vi
         cgWJhztmRGDoYttnoHW4x+q0+oL2i99CVnHNyS7kC6TFyhxWJ6/qrO4rhgX8YKErtlgs
         UE6GOoJn100ofUpOtoPS5FefQ/mMCi31OMroSuNDA4zR9l6Od5ahcL56KjXznytytxoI
         MlDagvdTODOjleQLkgFlRPGjgPseDOeyrwjlhzRxEe+vsstSraQqmFB1Emac17B+AC02
         EAV7ckcw+mxm1aIbqfHrP5UMLwqGA1iNSPAlzV4PytCmKX1iLk7g16Rx2vVbI8dZ0wbK
         4qUQ==
X-Forwarded-Encrypted: i=1; AL+hErHGESkjsX4nCXBHfnMxPXPonvpG5Hkn3JjKzoG6gYsIZvfiOw9p+FntkfAoFeNKF87dBP4ATaZ1YMI=@vger.kernel.org
X-Gm-Message-State: APuU4Z/c2pv9wNSCtcJZZbaOyZFE8K07IC+vViZEdIR5ynnKpTQVDFCf
	fslPmk+lBJFR7BYRP2aEFTakcCB18Tep+EJYYuABaRG5wa16SAOmN+Th
X-Gm-Gg: AZFdTZd8gEBE1yhdXBBKb0R9q5v2SHZWw5q0sLyZYqmZtooNa15W+6vBytjRDNUWGs9
	7O0Lg0auYos8edGj3yBlCoz/QYYl7gbf0ocMJt/vLbAkhwCv5p8xBCTCf0OLpz4Lq8g3L1l/Sje
	53sHDTCrRdwL97WLfGIPxvIuZbKZAZj8fqWrlG5P+X+zkhdXEvR5T5REGuj4stAvU7W6R2gDP6c
	F/tANH84LSlnpeB5fQfzl+HXp8i1l0yVplu7oROO8sCW2Oh9SFlZYEa+NiPNzmosd/s6EOcKIc8
	UsDPZYx/O0CXpzjQ56VyxMd+osJqr42/EXEIIx8d84YLqdxVj3n9y3W4hyhwkm3446bNpr9SYJ5
	0rqfWQoJekCbkv/GnikIRUkt9AR90tIP54jruSyV3Kfx+djsn5/0F5UnjA/fSEHU9r/tFucg9xn
	ycn4MVvpbbi8/2+tQZ7he4xdunYMxukyBHNWdErgNAb++BY0UyM+ocD2/QOvmImMAc5K+WpEQZb
	jvjyeCMZIWiAidpUlVTC7Hr0R41YGMJKDePjNW94pd5ULb0VjbvdVczrxtkRwjsOfBSaI7PVNf/
	p+Jh2OlWoVfhC3KdBj2n8gGiw0Tr9tO02waeenqSXRTNt2AJRJTB/4olw/VoSFpojshir9RExey
	9l6/rKC9vwwI=
X-Received: by 2002:a5d:4b49:0:b0:4a4:c39a:1d4d with SMTP id ffacd0b85a97d-4abb4d70005mr34452186f8f.52.1795769496428;
        Fri, 27 Nov 2026 00:51:36 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb41f4sm44244528f8f.7.2026.11.27.00.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 00:51:35 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12] xfs: only assert new size for datafork during truncate extents
Date: Fri, 27 Nov 2026 09:51:35 +0100
Message-ID: <20261127085135.2341177-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
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

From: Long Li <leo.lilong@huawei.com>

commit e942498385bf80f4d6d075b47174035545eb6a2e upstream.

The assertion functions properly because we currently only truncate the
attr to a zero size. Any other new size of the attr is not preempted.
Make this assertion is specific to the datafork, preparing for
subsequent patches to truncate the attribute to a non-zero size.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: b854e1c4eff3 ("xfs: close crash window in attr dabtree inactivation")
[amir: without this patch, the backport of b854e1c4eff3 trips
 this assertion from xfs_attr_inactive() in fstests generic/013, generic/070,
 generic/103, generic/117, generic/417 and xfs/181 with CONFIG_XFS_WARN=y]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3b487341348a..5abdcf1f46c9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1025,7 +1025,8 @@ xfs_itruncate_extents_flags(
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	if (atomic_read(&VFS_I(ip)->i_count))
 		xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
-	ASSERT(new_size <= XFS_ISIZE(ip));
+	if (whichfork == XFS_DATA_FORK)
+		ASSERT(new_size <= XFS_ISIZE(ip));
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(ip->i_itemp->ili_lock_flags == 0);
-- 
2.47.1

