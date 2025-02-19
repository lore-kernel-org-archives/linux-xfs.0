Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B012557A;
	Wed, 19 Feb 2025 00:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926470; cv=none; b=DNfa2MDKhG+AE0sRE+fu4JVJ1TUgcY2M3Q9H9c6+0wjlfGiO4hRWSOUkQSedEBkgdXc4N6ib6iRgFDvzbSGsCJTeM5h8BkV/vUZfzRqc+yPuKsxlzFFkVkP7LoPm3db1v+V6eZ43Uhar6rVVhaxY0+eEuy7Cmy5DUlefcw2zQRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926470; c=relaxed/simple;
	bh=fPByFgcfrXOKjgxEIczajVdAf9wwpSMjnthzSZtwCOY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dcQle8/JwtHUxLi3gYABfJFo98xaTLCtxAZb575iRdiW/lvzVC3dhBk6NakCSD8rO4xxW/xiPensAb+YonZoCnBk3xEuOn6orMfDM7ea7NLhd7rH2TAx8BbhotuSYNB0rPkrVKhkv8zhjmwPcmxjycU2ZHy1HfNKYqZ/ujc8xXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uv0U3YHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uv0U3YHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E1DC4CEE6;
	Wed, 19 Feb 2025 00:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926470;
	bh=fPByFgcfrXOKjgxEIczajVdAf9wwpSMjnthzSZtwCOY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Uv0U3YHFfTmeXNptj8yYt1zuXiYRPZ19+Po8j9beBqB0E6R9i8NhsU42DKzMN+6DO
	 di/lQ5Vg8IoSk3fk5Xc/e97i1Vazz0OrzQQCQ44/3tdR+i0WUfQuuUgiy2LeZaksok
	 TwR++5vaGBQnfYYMTqrez1xqPcW+Cjp0bGz2Gh2+bGESJlZUuBb4cxJm3kItfOqAIG
	 1WjRVpfBGxJDh2TLxLpygM4cUZ0YfkMNNMRtCUN4PgshBHr9vXBTz3xRxryP2bG+7x
	 gfyTysfD9s46FKCrSgpqm1ESYKHalj8s8Assm2dMgUjS7ygkgRGXs8/ELFDU+m/g6T
	 WnLfwJTeLlg1w==
Date: Tue, 18 Feb 2025 16:54:29 -0800
Subject: [PATCH 04/12] xfs/206: update for metadata directory support
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588135.4078751.12082973016977797784.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Filter 'metadir=' out of the golden output so that metadata directories
don't cause this test to regress.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/206 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/206 b/tests/xfs/206
index 1297433188e868..ef5f4868e9bdca 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -63,6 +63,7 @@ mkfs_filter()
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
 	    -e "/exchange=/d" \
+	    -e '/metadir=.*/d' \
 	    -e 's/, parent=[01]//' \
 	    -e "/^Default configuration/d"
 }

