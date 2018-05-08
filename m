Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46632 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755273AbeEHRcy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 13:32:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w48HVqtO124984
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:32:53 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2hs4k29q7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 17:32:53 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w48HWr6h011118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:32:53 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w48HWr6W003834
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:32:53 GMT
Date: Tue, 8 May 2018 10:32:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 19/21] xfsprogs: Remove single byte array from struct
 parent
Message-ID: <20180508173252.GS11261@magnolia>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-20-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525754479-12177-20-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 07, 2018 at 09:41:17PM -0700, Allison Henderson wrote:
> Variable sized arrays implemented this way may cause
> corruptions depending on how different compilers pack
> the structure.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  include/parent.h | 1 -
>  io/parent.c      | 9 ++++++---
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/parent.h b/include/parent.h
> index f338f96..85cef85 100644
> --- a/include/parent.h
> +++ b/include/parent.h
> @@ -22,7 +22,6 @@ typedef struct parent {
>  	__u64	p_ino;
>  	__u32	p_gen;
>  	__u16	p_reclen;
> -	char	p_name[1];
>  } parent_t;

Two options here: Either we finally fix up this part of libhandle to
talk to the kernel ioctls (whether or not we use the new apis in the
'upper half' patch at the end of this series to provide that emulation)
or just deprecate and kill all this old parent pointer stuff since it
has never worked on Linux.

FWIW struct parent is an in-core structure exposed via libhandle so (a)
we can't change it and (b) the padding problems don't exist.

--D

>  
>  typedef struct parent_cursor {
> diff --git a/io/parent.c b/io/parent.c
> index 1968516..55b8b49 100644
> --- a/io/parent.c
> +++ b/io/parent.c
> @@ -45,7 +45,8 @@ check_parent_entry(xfs_bstat_t *bstatp, parent_t *parent)
>  	struct stat statbuf;
>  	char *str;
>  
> -	sprintf(fullpath, _("%s%s"), mntpt, parent->p_name);
> +	snprintf(fullpath, parent->p_reclen, _("%s%s"), mntpt,
> +				((char*)parent)+sizeof(struct parent));
>  
>  	sts = lstat(fullpath, &statbuf);
>  	if (sts != 0) {
> @@ -284,9 +285,11 @@ print_parent_entry(parent_t *parent, int fullpath)
>  	printf(_("p_gen    = %u\n"),	parent->p_gen);
>  	printf(_("p_reclen = %u\n"),	parent->p_reclen);
>  	if (fullpath)
> -		printf(_("p_name   = \"%s%s\"\n"), mntpt, parent->p_name);
> +		printf(_("p_name   = \"%s%s\"\n"), mntpt,
> +					((char*)parent)+sizeof(struct parent));
>  	else
> -		printf(_("p_name   = \"%s\"\n"), parent->p_name);
> +		printf(_("p_name   = \"%s\"\n"),
> +					((char*)parent)+sizeof(struct parent));
>  }
>  
>  static int
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
