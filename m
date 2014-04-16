Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E75C67F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:32:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D29FA30407A
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 17:32:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	X8zSv6zFj32oFxcs for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 17:32:17 -0700 (PDT)
Date: Wed, 16 Apr 2014 10:32:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] renameat2: add system call number for i386
Message-ID: <20140416003202.GY15995@dastard>
References: <1397344384-15302-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397344384-15302-1-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Miklos Szeredi <mszeredi@suse.cz>, xfs@oss.sgi.com

On Sat, Apr 12, 2014 at 07:13:04PM -0400, Theodore Ts'o wrote:
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  src/renameat2.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/src/renameat2.c b/src/renameat2.c
> index 5145959..8613aa9 100644
> --- a/src/renameat2.c
> +++ b/src/renameat2.c
> @@ -14,6 +14,10 @@
>  #define SYS_renameat2 316
>  #endif
>  
> +#if !defined(SYS_renameat2) && defined(__i386__)
> +#define SYS_renameat2 353
> +#endif
> +
>  static int renameat2(int dfd1, const char *path1,
>  		     int dfd2, const char *path2,
>  		     unsigned int flags)

Yup, matches the kernel code.  Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
