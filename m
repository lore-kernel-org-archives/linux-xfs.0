Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBDC25A62C;
	Tue,  4 Feb 2025 21:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704593; cv=none; b=F7Vb3E5/+pv68THofhk+dKC8M7KOuiQyjtwXpfGVQAldUIE9nkritZ5mdL2RBxUfv+TKzzFqSzfHCAwq7bl26aiqh85mUgplNHE6nOregqOsOguihDqPHg3PQiJ3IRzmXI4NEAcL6Bw/oSU72fII3H3LEFvhZFVUWqbrsJlQvHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704593; c=relaxed/simple;
	bh=At3Bxfr7sSrI/qpBYHOXD7YiHX585/7ELYh3rNmWhwQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lpflRdabfYTSHw6kWQ8HrmOT1cko2fuUAFLtS4Pxa2yXOJh4pQDBuaEzYXCCN3KVKjDM2j1DFKIHmpjwhLkVVDuddKtanfaHk1fSEe2t2EyZRA+TxxJAeQgpAJY2cxfKwKTn6/31hzT1nNQ8kBtkHyt9yK25FDpD1jDUeOztVbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RRlzMQUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RRlzMQUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FB1C4CEDF;
	Tue,  4 Feb 2025 21:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704592;
	bh=At3Bxfr7sSrI/qpBYHOXD7YiHX585/7ELYh3rNmWhwQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RRlzMQUNddenD3QuNhsPtpOJnJ6ACfV5BOvJrMqLBhyWnh/b11Otp9n8xo0PszYq/
	 PiPYSeRbhfwCEd/ttq4viMXWvYSzXi1M8srMkB6H6Jue/LCEV72qDOSOM6lfzZCvKV
	 auosbPap3+8+gXbFFJXB8DkcQ4KXSzTEWCgcQlKmPWlaSUJEVdfhhbQmAEOMZqLWwX
	 ZkQLcxFvwiESL6taYjW6njV62/W5d+gSqJF1eUmgAoKSDlRru2VP2T3UiPs9GeI8X+
	 bRPgGs8R/dALuvaZnuIOYChj6jXcOc7T5K+JIV8n/DIP97GdHnBBwcBsrznkxalmVG
	 dKGpLjiBDLivQ==
Date: Tue, 04 Feb 2025 13:29:52 -0800
Subject: [PATCH 29/34] fsstress: fix a memory leak
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406549.546134.4341905130116308600.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Someone forgot to free the iovec that readv_f allocates.

Fixes: 80499d8f5f251e ("fsstress: new writev and readv operations test")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 ltp/fsstress.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 9e8eaa6d8656da..14c29921e8b0f8 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -4652,6 +4652,7 @@ readv_f(opnum_t opno, long r)
 	}
 
 	e = readv(fd, iov, iovcnt) < 0 ? errno : 0;
+	free(iov);
 	free(buf);
 	if (v)
 		printf("%d/%lld: readv %s%s [%lld,%d,%d] %d\n",

