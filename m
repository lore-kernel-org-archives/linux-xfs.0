Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D6217F5E
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 11:31:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE5CE304051
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 09:31:47 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id fBPE9m7JIWL0tXDH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 09:31:45 -0700 (PDT)
Date: Tue, 1 Sep 2015 09:31:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfsprogs: add nftw64 translation for OS X
Message-ID: <20150901163120.GA10397@birch.djwong.org>
References: <20150831185944.GI349@infradead.org>
	<1441094672-18368-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441094672-18368-1-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Tue, Sep 01, 2015 at 10:04:32AM +0200, Jan Tulak wrote:
> UPDATE: changed to #define
> 
> OS X has only nftw variant - not the 64 suffix used in xfs.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  include/darwin.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/darwin.h b/include/darwin.h
> index 72d9c1d..f0f05b3 100644
> --- a/include/darwin.h
> +++ b/include/darwin.h
> @@ -157,6 +157,8 @@ typedef int64_t		xfs_daddr_t;
>  
>  #define HAVE_FID	1
>  
> +#define nftw64 nftw
> +

Sorry for chiming in late, but there's only one caller of nftw64 and several
callers of nftw; why not just change it to use nftw?

<shrug> There could be other reasons why xfs_estimate requires the -64
variant, but I don't know. :)

--D

>  static __inline__ int
>  platform_discard_blocks(int fd, uint64_t start, uint64_t len)
>  {
> -- 
> 2.4.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
