Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93A6215765;
	Tue,  4 Feb 2025 21:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704609; cv=none; b=Vks0tCS+yVaj8FRnRSiccHRLY5/TckfMvVJ57E5NvyNe0QMXEAlSKsZEQloVLq+juQ5qDiEe7f+BAepDUOEaoTlzHUz38Wix4QvGhmDJUjf2YvB+NL+beEK48cMU8nzabYnD3mzCblVYQxMNmDirPYdTPo+OmD9VJ8afoxpeS/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704609; c=relaxed/simple;
	bh=g5abhxL9Inf7+E51bS1OdMsDLZ9aa8FW85EzynjhvVI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VLFjOlVwKc2r1PNjTz34RiGTk05fXo1tu+ecJa2q6p/Jc7w1S35U8MoEqGQRQzSwZx3DAfZvuUJw9uoSiBX4T0jaZVXTNx+HLj+HOAU5YoI+gQYm2VAcyWRDq6raOf5jfq8C+7lQFNtKGM+E01G2HnBBl9h/4l7KaVW499wK7q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVzRZ8tc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVzRZ8tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A789C4CEDF;
	Tue,  4 Feb 2025 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704608;
	bh=g5abhxL9Inf7+E51bS1OdMsDLZ9aa8FW85EzynjhvVI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EVzRZ8tckQWdZwbwwy774ZnYuSBUL9upjHnLWadKEf1B+nvuaXS1mlEJNO11YFT1a
	 X6CDfC9LnrVg4fNgASNSMkInh+jfcqvgovHjXWOAvsfslXWemTQbN3oUGtwCZl2qMF
	 e1VEjrvRiYDsJFAw6Vl40FDH9Z0LxhCqd4ag/hsgWphEA9vKoDZwK2HGzvvI9pg6Vb
	 SJEcoAzTktVLnFZB+jHCFikjNU+GHjzd/gkkLjmwJOYQHSNgcNO6bMKRRZWq9Kiy3t
	 rw28sEHgI/hj0M+8kR31PTttKxzrkiCaWmn+5Wmxyc+ipS0SnpZMGaWtzIW5mIfRaQ
	 bk7gLUtsl3CZg==
Date: Tue, 04 Feb 2025 13:30:07 -0800
Subject: [PATCH 30/34] fsx: fix leaked log file pointer
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406564.546134.12817088521328536453.stgit@frogsfrogsfrogs>
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

Fix a resource leaks in fsx, where we fail to close the fsx logfile,
because the C library could have some buffered contents that aren't
flushed when the program terminates.  glibc seems to do this for us, but
I wouldn't be so sure about the others.

Fixes: 3f742550dfed84 ("fsx: add support for recording operations to a file")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 ltp/fsx.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index d1b0f245582b31..163b9453b5418b 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -3489,6 +3489,7 @@ main(int argc, char **argv)
 	if (recordops)
 		logdump();
 
+	fclose(fsxlogf);
 	exit(0);
 	return 0;
 }

