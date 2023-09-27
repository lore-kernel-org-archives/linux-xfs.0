Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A217E80AB0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 14:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbjI0O1p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbjI0O1o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Sep 2023 10:27:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D81012A
        for <linux-xfs@vger.kernel.org>; Wed, 27 Sep 2023 07:27:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25715C433C7;
        Wed, 27 Sep 2023 14:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695824863;
        bh=pCN8bJEYJlfoJGFqSYNcJ3dtnwqI/T769uso5u7DEB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WM+vNfX9fW3VlTBOk6ECdZJ+6nJ1TTvqOuytzxqCPciqKsZPadLRDN2ZZKlGvs2Hj
         BanFCdzizTLNN94Vz6W7KUb3REUuKU1PV0HM2WcBXvNWj9JZjhLWG6KF+XONS/LcsW
         fCXxibt4kn5CcRyofiwiX9jxfFtzUU7XM8hkPjKx8nQ6r0XIZLBKeCzT5WszRnHlh9
         SilpVW6D5XJH679q9x3BtvMziHm2k+TJIpodOMFUtY+jgSqEvDOFM17HBG1vGtAhvr
         poTXazFByL5NuvG5Kw6u+ZWmVBzbLgF2RhrGcYE9KXJr16VOMsK3l7Qq70QgQd8YT7
         nzr+TXIN07Q7Q==
Date:   Wed, 27 Sep 2023 07:27:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Krzesimir Nowak <qdlacz@gmail.com>
Cc:     linux-xfs@vger.kernel.org, Krzesimir Nowak <knowak@microsoft.com>
Subject: Re: [PATCH] libfrog: drop build host crc32 selftest
Message-ID: <20230927142742.GG11439@frogsfrogsfrogs>
References: <20230927063847.81000-1-knowak@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927063847.81000-1-knowak@microsoft.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 27, 2023 at 08:38:47AM +0200, Krzesimir Nowak wrote:
> CRC selftests running on a build host were useful long time ago, when
> CRC support was added to the on-disk support. Now it's purpose is
> replaced by fstests. Also mkfs.xfs and xfs_repair have their own
> selftests.
> 
> On top of that, it fails to build when crosscompiling and would be
> useless anyway.

Nit: It doesn't fail if the crosscompile host itself has liburcu
installed.

> Signed-off-by: Krzesimir Nowak <knowak@microsoft.com>

Nits aside, this is a good simplification of the build process, so:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  libfrog/Makefile | 14 ++------------
>  libfrog/crc32.c  | 21 ---------------------
>  2 files changed, 2 insertions(+), 33 deletions(-)
> 
> diff --git a/libfrog/Makefile b/libfrog/Makefile
> index f292afe3..8cde97d4 100644
> --- a/libfrog/Makefile
> +++ b/libfrog/Makefile
> @@ -57,9 +57,9 @@ ifeq ($(HAVE_GETMNTENT),yes)
>  LCFLAGS += -DHAVE_GETMNTENT
>  endif
>  
> -LDIRT = gen_crc32table crc32table.h crc32selftest
> +LDIRT = gen_crc32table crc32table.h
>  
> -default: crc32selftest ltdepend $(LTLIBRARY)
> +default: ltdepend $(LTLIBRARY)
>  
>  crc32table.h: gen_crc32table.c crc32defs.h
>  	@echo "    [CC]     gen_crc32table"
> @@ -67,16 +67,6 @@ crc32table.h: gen_crc32table.c crc32defs.h
>  	@echo "    [GENERATE] $@"
>  	$(Q) ./gen_crc32table > crc32table.h
>  
> -# The selftest binary will return an error if it fails. This is made a
> -# dependency of the build process so that we refuse to build the tools on broken
> -# systems/architectures. Hence we make sure that xfsprogs will never use a
> -# busted CRC calculation at build time and hence avoid putting bad CRCs down on
> -# disk.
> -crc32selftest: gen_crc32table.c crc32table.h crc32.c crc32defs.h randbytes.c
> -	@echo "    [TEST]    CRC32"
> -	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -D CRC32_SELFTEST=1 randbytes.c crc32.c -o $@
> -	$(Q) ./$@
> -
>  include $(BUILDRULES)
>  
>  install install-dev: default
> diff --git a/libfrog/crc32.c b/libfrog/crc32.c
> index 2499615d..d07e5371 100644
> --- a/libfrog/crc32.c
> +++ b/libfrog/crc32.c
> @@ -186,24 +186,3 @@ u32 __pure crc32c_le(u32 crc, unsigned char const *p, size_t len)
>  			(const u32 (*)[256])crc32ctable_le, CRC32C_POLY_LE);
>  }
>  #endif
> -
> -
> -#ifdef CRC32_SELFTEST
> -# include "crc32cselftest.h"
> -
> -/*
> - * make sure we always return 0 for a successful test run, and non-zero for a
> - * failed run. The build infrastructure is looking for this information to
> - * determine whether to allow the build to proceed.
> - */
> -int main(int argc, char **argv)
> -{
> -	int errors;
> -
> -	printf("CRC_LE_BITS = %d\n", CRC_LE_BITS);
> -
> -	errors = crc32c_test(0);
> -
> -	return errors != 0;
> -}
> -#endif /* CRC32_SELFTEST */
> -- 
> 2.25.1
> 
