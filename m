Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1KEdddd182345 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 08:39:40 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94B21139336
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 06:39:06 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id AVfu6eDOLvQ5vSPO for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2009 06:39:06 -0800 (PST)
Message-ID: <499EB797.4030907@sandeen.net>
Date: Fri, 20 Feb 2009 08:00:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: test 134 requires quotas
References: <20090220105917.GA11888@infradead.org>
In-Reply-To: <20090220105917.GA11888@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Add a  _require_quota call to make sure it shows up as not run and not
> as failed if the kernel doesn't support quotas.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfstests-dev/134
> ===================================================================
> --- xfstests-dev.orig/134	2009-02-20 10:57:34.000000000 +0000
> +++ xfstests-dev/134	2009-02-20 10:57:42.000000000 +0000
> @@ -36,6 +36,8 @@
>  _supported_fs xfs
>  _supported_os Linux IRIX
>  
> +_require_quota
> +
>  dir=$SCRATCH_MNT/project
>  
>  #project quota files
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
