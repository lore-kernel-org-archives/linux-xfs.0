Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E74C3932C8;
	Tue, 29 Sep 2026 03:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790653400; cv=none; b=DM4JOO7Zzst9MGumtL8fXTY3H7YeEzqn6jlm4LPw9YQj5+hlHiIwlFAwhLRRfT7C7i6kTkNO7Fk4I+ICK6VohITtGH+ksPsro8C+fjsNapw+TqRX29byXWn6oU2P6x6Ul8tc24l6Ss7Vk+aTn/IY73mfXKl42voOX5vsyQzIMBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790653400; c=relaxed/simple;
	bh=xIjZpVn/ute/SzRWn/fX2IkTV9K8GsbnlAD+Bj9ORZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+lQAxQZv3oaOyIO7kBevdzXo6Lwg/b/6DQmqE6F5b/om1mPHPWO17QPtbPdB+KMkjK92TrBZLjNYBst6i7Z1aVRr+vvwrHDbGqjUDG5CTEndqXEQbYueMDo5tsqiN8bTj1Vibi+RGw4THOLtRgz9ysefrzxeIxvuzds1GrTI0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=LxQem3Ae; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OyuSYWck; arc=none smtp.client-ip=202.12.124.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="LxQem3Ae";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OyuSYWck"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 5395B1301946;
	Mon, 28 Sep 2026 23:43:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 28 Sep 2026 23:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790653398;
	 x=1790660598; bh=EqEhO7Cozx+p7o/41OHsqkMCNNwlRf46rdwfInGgzf4=; b=
	LxQem3AeAIdgW2wUGqeNqnqkgRWQaHq9wDkFmB/9zLcZ+iIHT9dt/v7t/iXup9VP
	6WqyTwy+LxqGATI1WezGc9fEy0t37fqldUDR7Qxu5ZoGktwIwCThOQhQicvHKG2u
	y8Y6VjtkHIMYKrMcF2SyZ1aPQIYO6YBfDTJy/qXd4mYs8rj2o9d0Gm4WHs3+gjwP
	JJ/fUspMc585l2jVWewvTZl1cuyuc/rU0KjCRvIkWscG+pMvoSBmkHhI5fz4pg+j
	eCXomriAlE4tH7QNo6Ka4/FOyaYNrduP2jBP/JCmJPJ+kmfw88KtgIH0PhgI5wm4
	rh6ONHizGQvqayX4K/Kq9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790653398; x=1790660598; bh=E
	qEhO7Cozx+p7o/41OHsqkMCNNwlRf46rdwfInGgzf4=; b=OyuSYWckGaG5itR4y
	yumxTNLaNORsdFn6ZpTXNr7EzBKq1Fgvk5YIAseZ9B77cCpZ0fHHpMB7SMgqOCyb
	xgq2y2I3ypWTHMlc7TBx94ABArNzK770/ALVIUMygT4d8eDv8r1/D1p81Yed3SO7
	YhL1fQbyfM9i9YeTvjYwImi1x036LhGJIOlpEdSVgJSY5fX0Pq5BE5T6JzTlraXc
	qyUkv4LkWXam6canynD0fWqIf0Pz1wPK4Vncr/hTAtB9YwZtCvznDcB5T5TlUo3c
	Htdd8pjyt0grv7cCU1oVx+NbBn/Vj+Vceubx/K64SUOn5OJIBN3N3yHBR/BOa03B
	Y42Kg==
X-ME-Sender: <xms:1jO7aqMq7p3Zqr9vjkwi-VJLeM1c8_hyJXeIOa67iBIQWM05HaBqoQ>
    <xme:1jO7ar63-_CA0BHZTA5SIKPaHXedcRWSvqSvoDST3uv3nGp4YDWYrWqxqNAjnOJvF
    Z0OMDy_OqWGH25KXKjgTmc7gDJtiNN2N2elho8f3MJcqYwM6qw>
X-ME-Received: <xmr:1jO7apdEMkaiJ8bXRBvFD_mBedPOLWBa2fPqv5q4yNRLABm3K56iFDr_v_DlZLmpZD4BdTx3QmnzNSL1dbWLjpJNLBGjgGA>
X-ME-Proxy-Cause: dmFkZTGTB6wQwJMDK2BlhP9ieoZtexL1tb4zR3ndzWyJLLylmMRFItDY6TtE2FJJnT+n9Q
    EA6CVH8Q6gG2q0z9eQymFQCCGXw2+bPKorNcLTcHtn6fe93ZdKVlCNeXpSVxjpIWPnE0uc
    R4cSRx11BDHvcVwwLSaXZYcSNN4uv+OrH4LpadiDCk6Bcm4w9Hs9AKTMCbQiCTdXMUg6Ak
    Qm5fUt4YyHFWpJ/BrTyArilq7pXWfKlpAWul2kfKNjb82sfwswf0FjscN0S8HtzC9tCLhj
    LmdhZ13ZxXliGQ357j0bxUi4bFw4qlzJKWjuFAMisvE+iZjOO7jJZKzba9DBfSYpFlPNOA
    e7Nud6FLGM7w4sQZ9NqRHWDmmgNYAVTeqgj4feEgxkJuOL85YTQjtF+sEG/hpsGZpQEr0C
    6fNwYiRIdTWwxl6Auq1tq/6V4UGQAgvvvv7bs+DIVng73Pik9D4GP8E2Xrl1pSUY2JlfZG
    9tMmUGoLeAdhujjliX8jHGXWu7ZDXH9JxWG+Ggl5G1RCx1eoucDH8rcJOlHS7CcQxhkcun
    Vl8fFThOqBBea7hViAzR0UEHyokxUj9S+gRoS6w2PEZ03b2rZMqiNeU4h0DdgyZkkNGOP4
    vmYWYEukgUzkG/UMKaNGTuWxomMedSbXOObNTsEz42yCdPoLy0jDcfyrkGOw
X-ME-Proxy: <xmx:1jO7apiCNNccNouf7FQ9ebSiPg-rqpwEvL5bd_nBziRrkuI-veAv2w>
    <xmx:1jO7ahOIox_9WR4YTsctfrwOoHRpnOu_7CacKaBJaZeHvLK2D2IcgQ>
    <xmx:1jO7av4Xk8lAkrSTk0l0Ivny-v5OJ0SQrDf0T6DWriTEywgtmBuhZw>
    <xmx:1jO7ajWI6PpVoWR-e92dkdiE00V_a950P9kUulmr7mCjsXfd9txZ9Q>
    <xmx:1jO7atSd86_VZbzI0WOPyxULG3ZiL725tkxqi4MkA-uVixsDjwIjV-z1>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 23:43:10 -0400 (EDT)
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
Subject: [PATCH 5/7] hostfs: don't d_drop() before d_splice_alias() in hostfs_mkdir()
Date: Tue, 29 Sep 2026 13:36:05 +1000
Message-ID: <20260929034158.1455429-6-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929034158.1455429-1-neilb@ownmail.net>
References: <20260929034158.1455429-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

hostfs_mkdir() uses d_drop() and d_splice_alias() to ensure it has the
right dentry after a mkdir.
d_drop() is no longer needed here and will cause problem for future
changes to directory locking.  So remove the d_drop().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/hostfs/hostfs_kern.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 7add056d47d8..f68e75981436 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -700,7 +700,6 @@ static struct dentry *hostfs_mkdir(struct mnt_idmap *idmap, struct inode *ino,
 		dentry = ERR_PTR(err);
 	} else {
 		inode = hostfs_iget(dentry->d_sb, file);
-		d_drop(dentry);
 		dentry = d_splice_alias(inode, dentry);
 	}
 	__putname(file);
-- 
2.50.0.107.gf914562f5916.dirty

