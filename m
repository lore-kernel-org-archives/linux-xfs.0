Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30754 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbeKJFQp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Nov 2018 00:16:45 -0500
Subject: Re: [PATCH] make: don't spray static check failures all over the
 subdir build
References: <20181109192822.GF15721@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <267751ec-88d1-cdbb-a6f2-74d6b8b437da@redhat.com>
Date: Fri, 9 Nov 2018 13:34:44 -0600
MIME-Version: 1.0
In-Reply-To: <20181109192822.GF15721@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 11/9/18 1:28 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Debian package building is special -- it directly calls make -C libxfs
> when building the debian-installer packages.  This means that any
> variables we define in the top level Makefile don't get passed down to
> subdir make processes.
> 
> This means that the new static checker support effectively runs the
> first argument in $(CFLAGS) as a command, which is surprising.  Fix up
> buildrules to patch out CHECK_CMD if nobody's defined it, so that direct
> subdir make works again.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/buildrules |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/buildrules b/include/buildrules
> index 83dfe05b..5c3e6eb9 100644
> --- a/include/buildrules
> +++ b/include/buildrules
> @@ -36,6 +36,10 @@ $(SUBDIRS):
>  	$(Q)$(MAKE) $(MAKEOPTS) -q -C $@ || $(MAKE) $(MAKEOPTS) -C $@
>  endif
>  
> +ifndef CHECK_CMD
> +CHECK_CMD = @true
> +endif
> +

Hm, ok, not quite clear if this is a hack or a proper fix - maybe
all the check stuff should have gone into buildrules in the first
place?  But at this late stage in the game, it's probably good enough.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-eric
