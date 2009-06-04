Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n54DXKPv245916 for <xfs@oss.sgi.com>; Thu, 4 Jun 2009 08:33:20 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7B8DAAC0AA
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2009 06:33:35 -0700 (PDT)
Message-Id: <5D22C0D8-9A67-4DC3-8848-45F3540A2183@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090604130310.GA14560@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfstests: fix for bash 3.2
Date: Thu, 4 Jun 2009 08:33:33 -0500
References: <20090604130310.GA14560@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Jun 4, 2009, at 8:03 AM, Christoph Hellwig wrote:

> Bash 3.2 wants a space before the closing "]" in a test:
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
> Index: xfstests-dev/check
> ===================================================================
> --- xfstests-dev.orig/check	2009-06-04 12:36:21.000000000 +0000
> +++ xfstests-dev/check	2009-06-04 12:36:26.000000000 +0000
> @@ -160,7 +160,7 @@
>
> EOF
>
> -if [ ! -z "$SCRATCH_DEV"]; then
> +if [ ! -z "$SCRATCH_DEV" ]; then
>   umount $SCRATCH_DEV 2>/dev/null
>   # call the overridden mkfs - make sure the FS is built
>   # the same as we'll create it later.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
