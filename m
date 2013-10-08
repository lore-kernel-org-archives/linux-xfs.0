Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6393A7FAF
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 18:00:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E24D304032
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 16:00:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xIS2CgGt3UkjBLV0 for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 16:00:55 -0700 (PDT)
Message-ID: <52548EA6.5040604@sandeen.net>
Date: Tue, 08 Oct 2013 18:00:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 01/32] xfsprogs: fix automatic dependency generation
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-2-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 9/29/13 10:15 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Adding are removing a header file does not result in dependency

s/are/or/

> regeneration like it should. make clean will rebuild the
> dependencies, but a normal make won't. Fix it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/buildrules | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/include/buildrules b/include/buildrules
> index 49cb2a4..edb1beb 100644
> --- a/include/buildrules
> +++ b/include/buildrules
> @@ -79,18 +79,30 @@ endif # _BUILDRULES_INCLUDED_
>  $(_FORCE):
>  
>  # dependency build is automatic, relies on gcc -MM to generate.
> +#
> +# This is a bit messy. It regenerates the depenencies on each build so

dependencies


I'm no make guru but seems relatively harmless. ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> +# that we catch files being added and removed. There are other ways of doing
> +# this (e.g. per-file dependency files) but that requires more in-depth changes
> +# to the build system. Compile time is not an issue for us, so the
> +# rebuild on every make invocation isn't a problem we need to care about. Just
> +# do it silently so it doesn't make the build unnecessarily noisy.
> +
>  .PHONY : depend ltdepend install-qa
>  
>  MAKEDEP := $(MAKEDEPEND) $(CFLAGS)
>  
> -ltdepend: .ltdep
> +ltdepend: rmltdep .ltdep
> +
> +rmltdep:
> +	@rm -f .ltdep
>  
>  .ltdep: $(CFILES) $(HFILES)
> -	@echo "    [LTDEP]"
>  	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
>  
> -depend: .dep
> +depend: rmdep .dep
> +
> +rmdep:
> +	@rm -f .dep
>  
>  .dep: $(CFILES) $(HFILES)
> -	@echo "    [DEP]"
>  	$(Q)$(MAKEDEP) $(CFILES) > .dep
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
