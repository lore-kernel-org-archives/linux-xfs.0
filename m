Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 20:36:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8E3a14p028454
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 20:36:03 -0700
Message-ID: <46EA020A.2060106@sgi.com>
Date: Fri, 14 Sep 2007 13:37:46 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_dmapi: add MODULE_ tags
References: <20070828202102.GB17289@lst.de>
In-Reply-To: <20070828202102.GB17289@lst.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Sorry for the late reply Christoph.

It is looking good. I will push the patch in the XFS development tree.

Regards,
Vlad

Christoph Hellwig wrote:
> Without these I get a warning about an unspecified license everytime
> I try to load xfs_dmapi.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-25 00:05:33.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-25 00:05:53.000000000 +0200
> @@ -3372,5 +3372,9 @@ xfs_dm_exit(void)
>  	dmapi_unregister(&xfs_fs_type);
>  }
>  
> +MODULE_AUTHOR("Silicon Graphics, Inc.");
> +MODULE_DESCRIPTION("SGI XFS dmapi subsystem");
> +MODULE_LICENSE("GPL");
> +
>  module_init(xfs_dm_init);
>  module_exit(xfs_dm_exit);
>
>   
