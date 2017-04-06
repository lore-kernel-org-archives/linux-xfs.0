Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751597AbdDFIT0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 04:19:26 -0400
Date: Thu, 6 Apr 2017 16:19:21 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/4] xfstests: Check the stx_attributes settable by
 chattr [ver #9]
Message-ID: <20170406081921.GI22845@eguan.usersys.redhat.com>
References: <149146415678.12061.13562442148388464862.stgit@warthog.procyon.org.uk>
 <149146417986.12061.3606889926872722812.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149146417986.12061.3606889926872722812.stgit@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Apr 06, 2017 at 08:36:19AM +0100, David Howells wrote:
> Check the stx_attributes that can be set by calling chattr.
> 
> The script probes the filesystem with chattr to find out which of +a, +c,
> +d and +i are supported before testing combinations of attrs.  Note that if
> a filesystem supports chattr with these, but doesn't paste the flag values
> into stx_attributes, the test will fail as there's no way to distinguish
> cleared from unset.
> 
> Certain chattr flags are reflected in specific stx_attributes flags:
> 
> 	chattr flag	stx_attributes flag
> 	+a		STATX_ATTR_APPEND
> 	+c		STATX_ATTR_COMPRESSED
> 	+d		STATX_ATTR_NODUMP
> 	+i		STATX_ATTR_IMMUTABLE
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks for the update! More nits follow :)

> ---
[snip]
>  
> -	check((B->tv_nsec - A->tv_nsec) >= 0,
> -	      "%s.nsec is before %s.nsec (%d < %d)\n",
> -	      B_name, A_name, B->tv_nsec, A->tv_nsec);
> +	if (B->tv_sec == A->tv_sec)
> +		check((B->tv_nsec - A->tv_nsec) >= 0,
> +		      "%s.nsec is before %s.nsec (%d < %d)\n",
> +		      B_name, A_name, B->tv_nsec, A->tv_nsec);
>  }

I think this hunk belongs to patch 2/4, make it right in the first
place, not introduce a bug and fix it later in the same patchset :)

[snip]
> diff --git a/tests/generic/422.out b/tests/generic/422.out
> index 21d6ffc..70a4eb6 100644
> --- a/tests/generic/422.out
> +++ b/tests/generic/422.out
> @@ -1,4 +1,4 @@
> -QA output created by 420
> +QA output created by 422
>  Test statx on a fifo
>  Test statx on a chardev
>  Test statx on a directory

This diff also belongs to the second patch.

Thanks,
Eryu
