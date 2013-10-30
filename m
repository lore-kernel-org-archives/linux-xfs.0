Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A657C7F4E
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:21:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 895468F8064
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:21:37 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iETyXpgxHRcPbZel for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:21:36 -0700 (PDT)
Date: Wed, 30 Oct 2013 15:21:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix compile error of src/fssum.c on bigendian
	host
Message-ID: <20131030042134.GF6188@dastard>
References: <1383105343-15348-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383105343-15348-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 30, 2013 at 11:55:43AM +0800, Eryu Guan wrote:
> Definition of htonll() is needed on bigendian host too, otherwise
> src/fssum.c won't compile on ppc64/s390x hosts.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  src/fssum.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/src/fssum.c b/src/fssum.c
> index c75ff8b..c26d32b 100644
> --- a/src/fssum.c
> +++ b/src/fssum.c
> @@ -50,6 +50,8 @@
>  
>  #if __BYTE_ORDER == __LITTLE_ENDIAN
>  #define htonll(x)     __bswap_64 (x)
> +#else
> +#define htonll(x)     (x)
>  #endif
>  #endif

Looks fine.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
