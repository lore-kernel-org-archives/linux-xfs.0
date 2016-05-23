Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FE4F7CA4
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 17:35:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 744698F8065
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 15:35:50 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5FpD7y18HGqE9hDD for <xfs@oss.sgi.com>;
	Mon, 23 May 2016 15:35:45 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id D1840B55
	for <xfs@oss.sgi.com>; Mon, 23 May 2016 17:35:44 -0500 (CDT)
Subject: Re: [PATCH 2/2] linux.h: include <linux/fs.h>
References: <1464015836-25127-1-git-send-email-hch@lst.de>
	<1464015836-25127-3-git-send-email-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5b74eb3a-b1dc-65a7-aba4-9633cb62c037@sandeen.net>
Date: Mon, 23 May 2016 17:35:44 -0500
MIME-Version: 1.0
In-Reply-To: <1464015836-25127-3-git-send-email-hch@lst.de>
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
To: xfs@oss.sgi.com

On 5/23/16 10:03 AM, Christoph Hellwig wrote:
> To reliably prevent the redefinition of struct fsxattr.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Jeffrey Bastian <jbastian@redhat.com>

Christoph, thanks for taking care of this :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/linux.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux.h b/include/linux.h
> index cc0f70c..0c616f4 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -32,6 +32,7 @@
>  #include <stdio.h>
>  #include <asm/types.h>
>  #include <mntent.h>
> +#include <linux/fs.h> /* fsxattr defintion for new kernels */
>  
>  static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
>  {
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
