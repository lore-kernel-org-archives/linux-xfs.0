Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Jun 2008 22:43:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m565h3Z4021975
	for <xfs@oss.sgi.com>; Thu, 5 Jun 2008 22:43:03 -0700
Date: Fri, 6 Jun 2008 07:43:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] simplify xfs_vn_listxattr
Message-ID: <20080606054347.GA29902@lst.de>
References: <20080603114837.GB2703@lst.de> <4848BFE8.6000205@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4848BFE8.6000205@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jun 06, 2008 at 02:41:12PM +1000, Timothy Shimmin wrote:
> Need to fix param type.
> 
> re:
> 
> static int
> list_one_attr(const char *name, const size_t len, void *data,
>                 size_t size, ssize_t *result)
> 
> typedef struct xfs_attr_list_context {
>         struct xfs_inode                *dp;            /* inode */
>         struct attrlist_cursor_kern     *cursor;        /* position in list */
>         char                            *alist;         /* output buffer */
>         int                             seen_enough;    /* T/F: seen enough of list? */
>         int                             count;          /* num used entries */
> 
> => mismatch type on &context.count (int) and list_one_attr's result
> param (ssize_t => long)

Yes, didn't see that on my 32-bit machine :)  count should probably
be ssize_t.
