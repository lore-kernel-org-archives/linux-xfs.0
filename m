Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51654 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbeJKEsz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 00:48:55 -0400
Date: Wed, 10 Oct 2018 14:24:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/18] xfsprogs: enable sparse checking with "make C=[12]"
Message-ID: <20181010212449.GW28243@magnolia>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-2-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:05PM -0500, Eric Sandeen wrote:
> Enable "make C=1" or "make C=2" to do sparse checking.
> Blatantly ripped off from djwong's patch in e2fsprogs to do the same.
> 
> This is a bit simpler than redefining CC for the whole build, which
> requires extra commandline definitions and apparently is enough of a
> barrier that nobody's doing sparse checking.
> 
> Note, this requires unreleased sparse after v0.5, which enables the
> CHAR_BIT definition; otherwise it chokes.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  Makefile           | 14 ++++++++++++++
>  include/buildrules |  2 ++

Please update doc/sparse.txt...

--D

>  2 files changed, 16 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index d031a60..7f3e774 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -16,6 +16,20 @@ else
>    Q = @
>  endif
>  
> +CHECK=sparse
> +CHECK_OPTS=-Wsparse-all -Wno-transparent-union -Wno-return-void -Wno-undef \
> +	-Wno-non-pointer-null -D__linux__
> +ifeq ("$(C)", "2")
> +  CHECK_CMD=$(CHECK) $(CHECK_OPTS) -Wbitwise -D__CHECK_ENDIAN__
> +else
> +  ifeq ("$(C)", "1")
> +    CHECK_CMD=$(CHECK) $(CHECK_OPTS)
> +   else
> +    CHECK_CMD=@true
> +  endif
> +endif
> +export CHECK_CMD
> +
>  MAKEOPTS = --no-print-directory Q=$(Q)
>  
>  TOPDIR = .
> diff --git a/include/buildrules b/include/buildrules
> index c57fdfc..23fc866 100644
> --- a/include/buildrules
> +++ b/include/buildrules
> @@ -54,10 +54,12 @@ $(LTLIBRARY) : $(SUBDIRS) $(LTOBJECTS)
>  %.lo: %.c
>  	@echo "    [CC]     $@"
>  	$(Q)$(LTCOMPILE) -c $<
> +	$(Q)$(CHECK_CMD) $(CFLAGS) $<
>  else
>  %.o: %.c
>  	@echo "    [CC]     $@"
>  	$(Q)$(CC) $(CFLAGS) -c $<
> +	$(Q)$(CHECK_CMD) $(CFLAGS) $<
>  
>  endif
>  
> -- 
> 1.8.3.1
> 
