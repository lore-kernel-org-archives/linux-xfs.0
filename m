Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE514AD55
	for <linux-xfs@vger.kernel.org>; Sat,  1 Jun 2024 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717264734; cv=none; b=EPnO6ylU23sXOPGWLMABFQcn8ljjo27b6kblpDSuyF47sf+JljBD+1HA020/Nt8CniqlxRe4FAGHFmE3nenX67WI7mT3cs7x3pH6rb3Uj66t0EFiOnxYtPR/2j6mb8uMZ7v5dr3AvAX92DZHbMLDhN776bsm7j9OBnU45Rs5wmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717264734; c=relaxed/simple;
	bh=yFsf91TwEFTAxksbJbTZNExjdjVwcPCAMkYGGKOk7SM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z6iXril8D1+2CuaLKIbgVjAm3KYL4rxysldQecmBllaiGl7pxAaZgHB3CHmAD172GlSMuCoF9neEA+pyBhlmQRXbYPL4Vo4o80bd1OdM6/co6TzaqZXDarxLTw7gDEgZxpp8TnNDYbYDPZxPYdkvvye+cAWyHEwrCNLPd2oyXqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRhjf6fA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRhjf6fA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DF5C116B1;
	Sat,  1 Jun 2024 17:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717264733;
	bh=yFsf91TwEFTAxksbJbTZNExjdjVwcPCAMkYGGKOk7SM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aRhjf6fA+CahUxu6n6QGzGFLml5+syOSTHyKPWEa7wOuv1rEGloqZonKhZLqLA963
	 nDZ1VGbw9k3t8u+svVRIuUQPfP5EgUYbQb2llUYwmH741tTyY/MhndIBxwOJHf0VjC
	 +NgP99UFcX01KLJDvSDUwyUbTF/E2owW8pEUGYQu8F8tZRCmXkGOkevyxkHIJV6Kf2
	 WmMGQiYV+mJUVTemhQs/jK0NRz9CfwOIWb/nn/wsFvcC+b8FL5OAXOd1GU7ePowxdR
	 z6ErGk48W7kF6anb9sA+T1PxkZh4uaj6hHWfXA4qaQTvOh1L4jl/tMlE1QkXaeu2bb
	 yfqxqPj4gr++g==
Date: Sat, 1 Jun 2024 10:58:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] xfs_repair: detect null buf passed to duration
Message-ID: <20240601175853.GY52987@frogsfrogsfrogs>
References: <20240531201039.GR52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240531201039.GR52987@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

gcc 12.2 with ubsan and fortify turned on complains about this:

In file included from /usr/include/stdio.h:906,
                 from ../include/platform_defs.h:9,
                 from ../include/libxfs.h:16,
                 from progress.c:3:
In function ‘sprintf’,
    inlined from ‘duration’ at progress.c:443:4:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:30:10: error: null destination pointer [-Werror=format-overflow=]
   30 |   return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   31 |                                   __glibc_objsize (__s), __fmt,
      |                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   32 |                                   __va_arg_pack ());
      |                                   ~~~~~~~~~~~~~~~~~

I think this is a false negative since all callers are careful not to
pass in a null pointer.  Unfortunately the compiler cannot detect that
since this isn't a static function and complains.  Fix this by adding an
explicit declaration that buf isn't null.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/progress.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/progress.h b/repair/progress.h
index 0b06b2c4f43f..c09aa69413ac 100644
--- a/repair/progress.h
+++ b/repair/progress.h
@@ -38,7 +38,7 @@ extern void summary_report(void);
 extern int  set_progress_msg(int report, uint64_t total);
 extern uint64_t print_final_rpt(void);
 extern char *timestamp(struct xfs_mount *mp, int end, int phase, char *buf);
-extern char *duration(time_t val, char *buf);
+char *duration(time_t val, char *buf) __attribute__((nonnull(2)));
 extern int do_parallel;
 
 #define	PROG_RPT_INC(a,b) if (ag_stride && prog_rpt_done) (a) += (b)
