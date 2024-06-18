Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABB2E556;
	Tue, 18 Jun 2024 00:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671794; cv=none; b=rZez0+92JmDhlthQFaObjqL8xx0+8ykZKpSSpAbgH5vCWeFw+8M74r0on+8yINA8Ddzv/il3L+Pebr30DlNz6bc2rHH4Cre/YtBuchWtTtBN9w+avxJUHS66hs8W57KPGI32ZpvNeP9BrkNjF/GMzmRTi2Gd0lE/y3aZO+wYGSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671794; c=relaxed/simple;
	bh=Yl6K7tYnXsS+h46w8aN/PvCm2ugcpxESUdgngzJQcYE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VQ0LE/n+ohuhxY+N0p93q8sX0sw7qHZqa9S9AwauXC07HS3nGkoFZqncn/Q13juIwEUf8aWmTytJQVXe4j9T/ylOzWSzIkjqqeN6U+FzsBbAimvM/YSQ8uAobGlyZ2SVH1Exaqu3FsAacEnabM+OqZqpqz1HkF11MksukFNqb1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPucDqh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPucDqh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B753CC2BD10;
	Tue, 18 Jun 2024 00:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671793;
	bh=Yl6K7tYnXsS+h46w8aN/PvCm2ugcpxESUdgngzJQcYE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sPucDqh1C81yu7P0DZyOAMvx3fd3YSXihx9lSfZqnAB0Jb0XTZrGTvJ8G3bI4Fk9S
	 63sC/9+0vuiP1BW1pv5X5XLwJn5Df6eSNrUX+kmf/qADoVSgkVWjnKSTF9GWmTptQN
	 sLSXSJsuq9jeXcYHZ6fEJBMBnEaxNBKf4JAH586znn+Z39pdblNH7pP+PKCRx8zhfa
	 /gDf0ll4QGwLqovGfnfYJgIUCi9LR259fbu6ESR3Qhd1I+9j5yVWwMKBVXEDsIqArn
	 yjXTkFh1JJqVCo5s4LOcN+RRa2DKELWJMCPevvQm2dAJSFxkQEhihCaU4KCjkSHzav
	 A/pYFx/bJvYIg==
Date: Mon, 17 Jun 2024 17:49:53 -0700
Subject: [PATCH 02/11] xfs/206: filter out the parent= status from mkfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <171867145837.793846.12125891588945951991.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Filter out the parent pointer bits from the mkfs output so that we don't
cause a regression in this test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/206 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/206 b/tests/xfs/206
index f973980eb2..d81fe19857 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -65,6 +65,7 @@ mkfs_filter()
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
 	    -e "/exchange=/d" \
+	    -e 's/, parent=[01]//' \
 	    -e "/^Default configuration/d"
 }
 

