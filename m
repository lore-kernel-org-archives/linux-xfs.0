Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41438 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfAaUrh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 15:47:37 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88199AC61E
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 20:47:37 +0000 (UTC)
Date: Thu, 31 Jan 2019 14:47:30 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs_repair: fix incorrect return value in namecheck()
Message-ID: <20190131204730.GA21644@redhat.com>
References: <f17672e5-63eb-0f74-afdf-55ff006ee28d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17672e5-63eb-0f74-afdf-55ff006ee28d@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Jan 31, 2019 at 02:20:58PM -0600, Eric Sandeen wrote:
> Obviously a directory entry with a '/' in the name should return
> 1, i.e. failure.  This was just a dumb thinko.
> 
> Fixes: 45571fd5885d ("xfs_repair: allow '/' in attribute names")
> 
> Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Makes sense.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
> 
> diff --git a/repair/da_util.c b/repair/da_util.c
> index c5e690c..4a258e5 100644
> --- a/repair/da_util.c
> +++ b/repair/da_util.c
> @@ -31,7 +31,7 @@ namecheck(
>  
>  	for (c = name, i = 0; i < length; i++, c++) {
>  		if (isadir && *c == '/')
> -			return 0;
> +			return 1;
>  		if (*c == '\0')
>  			return 1;
>  	}
> 
