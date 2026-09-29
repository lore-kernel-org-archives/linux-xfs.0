Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859723B0ACC;
	Tue, 29 Sep 2026 03:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790653345; cv=none; b=FYdgZmY2QFdl+vUcA4Z8GGQF5zehC/gNxXJolxlYM2+SRN2HnF+MiqJNPsr7DzwwakY0GeOvrgI+Sye8cAvG7vMWMQRWIa+zm2gOnGpJv7bgTMXqHaBf/LzUnmjY/N/NAjWVlCMsy7CsqtrQNHfdJ1ipPN7kKnT5u6aPySHLbKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790653345; c=relaxed/simple;
	bh=kuWxtqIf8o5jNm8l41LqbBudX8x+tQxZGsWJ2zyJT/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aWaLb2VshbuJNBGH73VVfyzrQOVZLWEtTmPt9wUZcCy3s+7tuOxFCtFI0MkMR72xTWWYKp/bOEg9Iiue/VB+t7E8nqGoOYX2fqocW9eVATaKHEtbz5TPE9OvlEv8MDFohIJiwYz7cwQ2cQ8bJMTzE0zDF0q0ZqR0vSPAmqO/jU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=ezrNfBFy; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=m1pxEK64; arc=none smtp.client-ip=202.12.124.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="ezrNfBFy";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="m1pxEK64"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id EFDCB1301921;
	Mon, 28 Sep 2026 23:42:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 23:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to; s=fm1; t=1790653341; x=1790660541; bh=J+5l9qBwl1
	WsRT1XtTAjxybHRH86RKo2RdAumZXCUic=; b=ezrNfBFyCCbOBOQcOfLx8TAUnY
	8SgRBoaEspMTu6k11+fYYjuEnc3SePghudHE1Dym9tFUvy5UdnR6Ku1ax+jVwUNk
	mVCTP1FF9IyZ6hRvfNCp6sUNtNrtZZkkGBgh9WyZYju6hbyJQgqaTXvmXlknQb3N
	RkcAIWz/GZnhwYc22H/f5F1NAijCRiBbGJp1y9s5JrEv1QKv6gvQ9WyuZZS1GlMT
	dHQ0otbWzyZJY0KO4jZta/EWTfL1ecG1/7b/lT1GZsQXKKUWObXbF8DV7be4ynW7
	hI00msB0tj+bAz8SjQa0Rsfwm4uLkf/mA1RhrYHFG5QbJ+sZzWj5sbcGCFxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790653341; x=1790660541; bh=J+5l9qBwl1WsRT1XtTAjxybHRH86
	RKo2RdAumZXCUic=; b=m1pxEK64gcDWc4E2kWsLqlfPzYLSD2ut6wsH706XVv1L
	fE211x87dQOmSZpUSu7g+gTHfsKRktK0HJP8MLYjASkEWZsTOIFkO2vnhygFeo/U
	HSFK3JtI6z3nsNti3fFP2txOe5BdAPzf9Yuc9sFdRN0Sgm9RzSHUCROB0k6WAOoA
	d0Is6fPQCoGDQ9SJRRAvDV5QgxuDJL03wb2vGFovMa7thOHOdW3k/E2nN3bd1PT9
	RG1jYCb9wqtuBdNqsMpKOFjtrY0/qD9CrrvCYDb+ME33gLZfGphVJbfpRSEFjdLm
	9Nf6GFQ9vOhMx26WrlOi3L30Jx9M8yQ3quE1aedPHQ==
X-ME-Sender: <xms:nDO7am0N1cltCdtQ9djUqBYsF9ZHmLY-xqP78oi_T1etXlChobih6A>
    <xme:nDO7asDDQ1CFjWJZN0KCCwdr6Vi6TibSGR7XCbeiY7YUsCoUk9vd6BPOmKnYfNysZ
    HWIdFjyIqMLOW-wfcH2nxhqtZj4FYBS9DZUy9LyvyVy2LViWos>
X-ME-Received: <xmr:nDO7anEtgWDuV-AopVIK7HhKtm16SQz3BhCda0qPbxxg85PcmTiwquc5aQYTCFVISy1U6--6jI3CcTQQKuOjnp9mW_Xh898>
X-ME-Proxy-Cause: dmFkZTGomu/KFUxrpCS2PBVtm+v19yviLpAfhlazZQ97X/zXySAcrpPfoYtOfYsfxCq7zY
    lGW7Lj0q0zn2oKEKu/P6u+AyN7TjCj3Oll0HkXf2BAP4GqX3CeIc1llVgOoBz3bN3WZH2M
    Q6tIcdcujmSjhTqphrrgME7zNVS3GK+PKx2Xr4EBWNcuJQ+AoVvLj/xprJkbTAIAwZhntS
    tMImrep6J3GRsD6kiFNU66dFdqiHn0qul5cSZnmWjQGzoHx5F2vUqryNhuQzKkMpwPI2gY
    BXyLLWJ3oAYxdycb0nryq+7vTjl6LxyJ+qGtpSTh7tJ4j1fgk4d8OBfq6PhvWje+2fN6ra
    G6IZUHCvNfteSCcxFURhEza6qCpIMxK+lwEL4xTmqUnWjwUjIGroWGapPVvCNkORRLt6Q4
    riKYch+nP6mAsL6Gt3yv/XSM7P7NlI4FsjjUi+5g7NjdUB8duxxE25wDK9tJKvmWw98/ZD
    75f7Sx7ZVvev0Mc6Naf9LwB9zX4jvPr5h0mo6mWnC6eLYuuAnmDI9fNdo92SVHGpRTh6GG
    vIcRgm+DfpFRD206QgvoS+5qiBvwihDwM65WiUcD3ykb22Hv5qyisPQ1LskoJWWzUdzTng
    5H1x2Fm/ZkOs1AZw0HR97QLko8vvi3OEOH/s95gMfYjRJuN14l24nKtrxKHg
X-ME-Proxy: <xmx:nDO7amqD-aQXz8A1eLGocUH-lGGAU2_LbI5b_Xbll1PPyOVmY_ciew>
    <xmx:nDO7an2N2Zh8-InhDjWE_eDbbUgapGVIuYvvhyfZmGVlGFKuDyl2Pw>
    <xmx:nDO7aiCiKNiJ4-p_oIY8R3W358JrqbYX32qapwUm7QlKFM1aeX_7sw>
    <xmx:nDO7aq_kBl6N-CbicD0rhINBhWN5NqsCKuDr0HuAffVbl1XfHr3kHA>
    <xmx:nTO7ar68mhMRu4Zo-zsbyfbxJFxB-FbB4xCNncCW73mXsJrvm687DM-A>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 23:42:13 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org,
	codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: [PATCH 0/7] multiple-filesystems: prepare for changes to VFS locking
Date: Tue, 29 Sep 2026 13:36:00 +1000
Message-ID: <20260929034158.1455429-1-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I am working on changes to directory locking.  The medium term goal is
to lift d_alloc_parallel() locking above i_rwsem, so d_alloc_paralle()
can be run unlocked, and consequently cannot be called when ->i_rwsem is
held.

This patch set makes small changes to a number of filesystems which each
require just one patch.  Patch series for nfs, afs, cifs, fuse, cephfs
have been posted separately

The maint requirements are:
 1/ that d_alloc_parallel() not be called while i_rwsem is held.
    Places which currently do this can be changed to use d_alloc_trylock(),
    or d_duplicate(), or change to drop and retake the parent lock.


 2/ a dentry must not be d_drop()ed while an operation is ongoing, as an
    unlocked d_alloc_parallel() would then be able to create a new
    dentry with the same name.  d_splice_alias() can now work with a
    hash dentry, so often the d_drop() can simply be dropped.  Other
    tims it can be moved to after the operation has completed.

Though not strictly a requirement, the recent change to d_splice_alias()
means that there is nothing that d_add() which d_splice_alias() can do,
so it makes sense to deprecate d_add().  So d_add() calls have been changed
to d_splice_alias() in a few places.


The patches depend on patches recently added to the vfs tree.  I would
prefer these land in that tree too with an Acked-by or similar from
relevant maintainers.

Thanks,
NeilBrown


 [PATCH 1/7] VFS/xfs/ntfs: drop parent lock across d_alloc_parallel()
 [PATCH 2/7] shmem: use d_duplicate()
 [PATCH 3/7] coda: don't d_drop() early.
 [PATCH 4/7] configfs: remove d_add() calls before
 [PATCH 5/7] hostfs: don't d_drop() before d_splice_alias() in
 [PATCH 6/7] procfs: drop parent lock for d_alloc_parallel() in
 [PATCH 7/7] ovl: stop using lookup_one() in ovl_iterate().
