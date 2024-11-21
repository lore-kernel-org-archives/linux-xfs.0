Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492681FB3
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 00:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732147743; cv=none; b=pct3CgwSMUF5IniU2ci9ACvN9sfQ1lquCC9hRHjg9znfot5dfE7fYUNNka5THRXkptv9jtMMjBf2Tq8de4cquBixwzz8SCMWfZ6y9Qybe9i/XDNOn5sbI4J9ck8hjAWNW9pd1F5a1ls1jg9Smn6GdnREMZqlZgrLPuITLkQ42NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732147743; c=relaxed/simple;
	bh=ZYiYddF5sGojVFhhWNYd/4or6aRWXtJe5Hoaz2NjL0o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dNm+cTxSKsglCwFytp4wBmF+vZK5x9UVoDkMqfFy9JxcojLyp34RA5jjpf/UDq5bZPcqwcfhMoH4CM6uiRA0s3VJKxlZ04FwV8E8fxFKbuvpYiW3Ukjhppat0SrNgcNzLuKCSGmBAG+VuQeThtiMlQMaAOPzVCSJT7q33Y6egSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TznfoYTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TznfoYTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14ADC4CECE;
	Thu, 21 Nov 2024 00:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732147742;
	bh=ZYiYddF5sGojVFhhWNYd/4or6aRWXtJe5Hoaz2NjL0o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TznfoYTWEQ1KgW3WwVSQHXHalR7/14gvpkZYBlY+tDUxZm8//QErSCrmFJ5sRVwTw
	 wFIQCq8dgrZBZQEsnYGbog4E0RqjERiiJ7xGVrpCIlnB24TpFDMyyryWTsh0eRvr9r
	 5WVdk2ILOCNBoXe2guXOAjWaRiAuZeArchDgKasYNeJY/LvCEoNFv9pmkBuZepca8l
	 N5rXBcmvAPFHzYzaimbs58P+RHjC2RYMf1RWJwBcb5MsNw5VxxF+7hRIKe71AdSmpT
	 j3fRP6LiggeNYoUP31gJY2SaoW0kyTqTI0aTOwKp3HXLJ5K/pFYKr+DuH4DJNfl49j
	 IpOnCE6Lpzdgw==
Date: Wed, 20 Nov 2024 16:09:02 -0800
Subject: [PATCH 1/1] xfs: Reduce unnecessary searches when searching for the
 best extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: chizhiling@kylinos.cn, dchinner@redhat.com, cem@kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <173214768464.2957437.13487208103941199940.stgit@frogsfrogsfrogs>
In-Reply-To: <173214768449.2957437.8329676911721535813.stgit@frogsfrogsfrogs>
References: <173214768449.2957437.8329676911721535813.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Chi Zhiling <chizhiling@kylinos.cn>

Source kernel commit: 3ef22684038aa577c10972ee9c6a2455f5fac941

Recently, we found that the CPU spent a lot of time in
xfs_alloc_ag_vextent_size when the filesystem has millions of fragmented
spaces.

The reason is that we conducted much extra searching for extents that
could not yield a better result, and these searches would cost a lot of
time when there were millions of extents to search through. Even if we
get the same result length, we don't switch our choice to the new one,
so we can definitely terminate the search early.

Since the result length cannot exceed the found length, when the found
length equals the best result length we already have, we can conclude
the search.

We did a test in that filesystem:
[root@localhost ~]# xfs_db -c freesp /dev/vdb
from      to extents  blocks    pct
1       1     215     215   0.01
2       3  994476 1988952  99.99

Before this patch:
0)               |  xfs_alloc_ag_vextent_size [xfs]() {
0) * 15597.94 us |  }

After this patch:
0)               |  xfs_alloc_ag_vextent_size [xfs]() {
0)   19.176 us    |  }

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 61453709ae515c..f0635b17f18548 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1919,7 +1919,7 @@ xfs_alloc_ag_vextent_size(
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
-			if (flen < bestrlen)
+			if (flen <= bestrlen)
 				break;
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
 					&rbno, &rlen, &busy_gen);

