Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269086;
	b=vlOn5wFb9s8/aUvyIcZrjGWJ/KDu9CiwYc9F3nIahgcwUfpXCNwQJgdXDw/gu1O2SCsH
	 gdW4AnCskxpHc0x9xIHD9HsPxzVKjOP+L6Wyz972IAk4nDxyMLA6PWWuuwFdOlqbPB1K9
	 2RHDfu/WXBhgNuBNTgVjAiGvzsabSu7juUeRwJtgUxCPWikfqNbzDbPhkMSNvaf7rN0ZH
	 bXV2qrflyPYe0p549Phs4ifDAnxOia4Alx22tlUQuCTH+pn+ELWtDJc+iOL3OHLiG+6zW
	 RYx6M6oYTsN00zT7jDmuzZNc3MNDBfcclOZTsmV8atWBt72Ayv/SI0LMTSqfaFUZt7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=VY9rwYteYgJ+pn+O9h/zrh8ERDwpjeNOi6OywWM0Fjs=;
	b=NfTkA5//oEzcZgKdtWNJjV7W08QS4GjWP8LucdQkIuoOiPuaOyj6BL3tbj+EwMlQvV3l
	 uCq6n57zIhz1jt33/I8nDLUGJi595x4SrdWKzAmJ+O+L8UxzUknCRRxti8pC+vK85ca0G
	 R9Dcg+/KzdKqkd5Mhb/dmtLWZG58U8p/V7V8U8QVpVfT3jdhZz/5yw1Fv8QLRiX1e9AyF
	 KyEJeFQswcFWuUOfnDkkNeI8oNlqlQDp72sYFpMaLA0FmJvpObOlbpVhpbomlynmUuJrg
	 jXWZdbigfCAeZT6dx7q15PtlhAvzKb5uR6yc51tlfOfgNXLC2JGFGEnJvTESUsmgcXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ehouJtcJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90039606A326;
	Tue, 10 Nov 2026 00:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ehouJtcJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93361F0089F;
	Tue, 10 Nov 2026 00:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269086;
	bh=VY9rwYteYgJ+pn+O9h/zrh8ERDwpjeNOi6OywWM0Fjs=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=ehouJtcJAfZWZRp0watcoJiWJHWgsOXx1cO48HXYRj8sBXPmBqr9+jjILogX5pX1e
	 Ed+PKMM0lkqoPvx31tqPT1oHiTjv1ByjPxiNOMWrW4Pu1HetmZa6yMRRMCAOtSCpvy
	 s8M4LnQl1sv8q297A5rEssSVswZbtU695e1YOCiQVm+mdUMVGnLnZ6yEpfaSN7eoyn
	 AguahbnyAk2iBZ4vne+tUrql6tm/mrnTz73USDkb8SQciAAd2cLpbqkZUGzjlcishN
	 5QuZy39uSglaO98FxQew/KtsFs89a7eNRBm5zsH+HtSJ25hnxPjqdMnetufoflsGDH
	 /yyXT9TCW8Vzg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	18983559317@163.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: set healthmon mount cookie before publishing it" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:04:44 -0500
Message-ID: <20261110000444.3481986-1-sashal@kernel.org>
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

    xfs: set healthmon mount cookie before publishing it

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-set-healthmon-mount-cookie-before-publishing-it.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 8b5b37338aa9db56a72115e694a6b4339cdf15ba
Author: Binbin Deng <18983559317@163.com>
Date:   Thu Oct 15 16:02:25 2026 +0800

    xfs: set healthmon mount cookie before publishing it
    
    [ Upstream commit 0344a9492efac4c79202a07cf284a382f7054170 ]
    
    xfs_ioc_health_monitor() allocates the healthmon object with kzalloc(), so
    mount_cookie starts as zero.  zero is also DETACHED_MOUNT_COOKIE, but
    xfs_healthmon_attach() publishes hm through mp->m_healthmon before storing
    the mount cookie.  A concurrent reporter can therefore acquire hm from
    xfs_healthmon_get(), see the detached cookie in xfs_healthmon_push(), and
    drop the event even though the monitor is being attached.
    
    This is reachable by racing XFS_IOC_HEALTH_MONITOR with an operation
    that reports a health event, such as a filesystem shutdown.  Initialize
    the mount cookie before making hm visible through the RCU pointer so
    reporters always observe an attached monitor.
    
    Found during a static-analysis-assisted audit: candidate sites were
    surfaced by a Coccinelle rule, and the reader/writer paths were
    confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
    not observed at runtime; it is identified by code inspection only.
    
    Fixes: a48373e7d35a ("xfs: start creating infrastructure for health monitoring")
    Cc: stable@vger.kernel.org
    Signed-off-by: Binbin Deng <18983559317@163.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 2bdd747f1ead2..05d6f0494139d 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -114,8 +114,8 @@ xfs_healthmon_attach(
 	}
 
 	refcount_inc(&hm->ref);
-	rcu_assign_pointer(mp->m_healthmon, hm);
 	hm->mount_cookie = (uintptr_t)mp->m_super;
+	rcu_assign_pointer(mp->m_healthmon, hm);
 	spin_unlock(&xfs_healthmon_lock);
 
 	return 0;
