Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F04F429DF8
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 11:48:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C67DA8F8040
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 09:48:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id pPJa4cTYLcdVElfl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Feb 2014 09:47:55 -0800 (PST)
Date: Fri, 7 Feb 2014 09:47:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/189: noattr2 invalid for CRC enabled filesystems
Message-ID: <20140207174754.GA31464@infradead.org>
References: <1391590000-7171-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391590000-7171-1-git-send-email-david@fromorbit.com>
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

On Wed, Feb 05, 2014 at 07:46:40PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Version 5 filesystems always have attr2 format enabled, and it
> cannot be turned off via the noattr2 mount option. As such, attempts
> to mount with noattr2 will be rejected and this causes cascading
> failures within the test.
> 
> Hence detect if we've created a CRC enabled filesystem, and if this
> is the case _notrun the test.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  tests/xfs/189 | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/189 b/tests/xfs/189
> index 27bfb63..addf7ce 100755
> --- a/tests/xfs/189
> +++ b/tests/xfs/189
> @@ -241,7 +241,16 @@ _require_scratch
>  unset SCRATCH_RTDEV
>  unset SCRATCH_LOGDEV
>  
> -_scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
> +_scratch_mkfs_xfs | _filter_mkfs 2> $tmp.mkfs
> +
> +# check to see if we've made a CRC enabled filesystem. If so,
> +# we can't run the test because CRc enabled filesystems don't support
> +# noattr2 mount options and this will cause cascading failures that are
> +# impossible to filter.
> +. $tmp.mkfs
> +if [ $crc -eq 1 ]; then
> +	_notrun "Filesystem CRCs enabled, noattr2 is not supported."
> +fi

I really don't like opencoding this.  Shouldn't we instead simplfy
pass a nocrc argument to _scratch_mkfs_xfs?

Alternatively this magic should move into a helper.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
