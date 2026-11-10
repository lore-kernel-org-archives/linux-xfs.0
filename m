Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270686;
	b=l2vnfLfx5a+e9zRd6A1twLTAYNz6FLtpw3ueWmHEnUIZ+TQCZwAuhSvUhS69VQN8DBZ7
	 k5KWGmopwQ9Ho5n8qLLX4b4EsW+LXqKlgcWi3V9fhY2C0BnBVZlnhioi/MVp+xSqE2A/V
	 bmj/U4g6VG0hb0zvv4YAuKsY0wfP5R6HUN9abpBKNSKwCkuO8vdyeydmM1BPuf932PUrn
	 lAUoO1sFHKGb84Lr8+eYSBe8pV5uy9XoMU9Ie/er578ysCWhKzsx7KD/07i7hdJbKKCMA
	 jehwPLD04LeFUnaQaOY7U7nQ+9DsTQGZ3fXTY2gFAV9bdhXZSKrZqsUPuhBsyt5Xwng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=hS/zIzU1WdcTFYvpdEe7CbXkgAM7vi7+moNYWxJQy0M=;
	b=L0okZctOLlu/INfuCUiZb12sM1MKa18hRbQdkAo11+83Fd06pQ92LDUcwz59o2mKpijl
	 iHeRmRqtuko3XlzyfwuTfAgs+5f8J0nBO0ARiUXte2QNrt/cvSu1Ocr0pMQ906c5IZSD8
	 BFMyGfrlAXvm6l0Liux5KR1+r0iJP3kZH8+YhmShJdoT9lHEpcEoORepbWetwOaLVeBbW
	 0cvyzrq5w0ry5N1ElrvjUM4biNM0NVXwFpkCI3zfJcQHSAuAWnfGHx8lBk39apZPJcX1r
	 moywQk5uoXgZcsIH1s5cU6bBoP+xiSAeaBXg030eTJrLN+wHMJKB3B3iBgTM3Bvd0Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NclOJu4K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E579A606A31C;
	Tue, 10 Nov 2026 00:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NclOJu4K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECCF1F008A1;
	Tue, 10 Nov 2026 00:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270685;
	bh=hS/zIzU1WdcTFYvpdEe7CbXkgAM7vi7+moNYWxJQy0M=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=NclOJu4K6+DSoHKA9YjKhT5fvVcyYqHSpT2468lHwoOURVIN3k+niT6EhpfTbtCEf
	 StTwtYpGzm3feLBvxqTx7+UFMQ3xjQ3cZHAJx0Ao4ZsuQoUnv1uhU6DkVpbl9/zRG1
	 DbQ4IkG5l/NtOQ8FpdUFB8kmHK7aph8SQj7+9oxPoQjVSgzwxHOxd0HZGDeYOzmOhT
	 dRStTtEZn4y0qO2WVbh0I8sJjjQu9p4gPGPEb+YXlGKODh34ZzANWWBHK7aXN3rX2I
	 r5A8SB64ZLbzRZYsZ7euFTxASNgWhdLFORnl15kWs9670Mu2zd6obrgPw7ZRho6kh7
	 dsFamAxtB86jA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	skibletz@gmail.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()" has been added to the 6.12-stable tree
Date: Mon,  9 Nov 2026 19:31:23 -0500
Message-ID: <20261110003124.3518088-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-fix-wrong-compat-fields-in-xfs_ioctl32_bstat_cop.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit fe21d098786d16b66894ab96524f844f7fa92d5a
Author: Reid Downing <skibletz@gmail.com>
Date:   Tue Oct 27 12:17:48 2026 -0400

    xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
    
    [ Upstream commit b7eb276a39b14e685c2fe578f8ac22fc48ff9e6c ]
    
    bs_blocks and bs_xflags were both read from bstat32->bs_size.
    Read each one from its own field instead.
    
    Fixes: e94fc4a43e5c39 ("[XFS] Add compat handlers for swapext ioctl")
    Cc: stable@vger.kernel.org # v2.6.29
    Signed-off-by: Reid Downing <skibletz@gmail.com>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index b64785dc4354e..c2e01fcb6015d 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -123,8 +123,8 @@ xfs_ioctl32_bstat_copyin(
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_atime, &bstat32->bs_atime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
-	    get_user(bstat->bs_blocks,	&bstat32->bs_size)	||
-	    get_user(bstat->bs_xflags,	&bstat32->bs_size)	||
+	    get_user(bstat->bs_blocks,	&bstat32->bs_blocks)	||
+	    get_user(bstat->bs_xflags,	&bstat32->bs_xflags)	||
 	    get_user(bstat->bs_extsize,	&bstat32->bs_extsize)	||
 	    get_user(bstat->bs_extents,	&bstat32->bs_extents)	||
 	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
