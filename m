Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9J9jTMq174672 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 04:45:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96C3E1D998C
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 02:45:28 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	va5LkBcu55PhbZC0 for <xfs@oss.sgi.com>;
	Wed, 19 Oct 2011 02:45:28 -0700 (PDT)
Date: Wed, 19 Oct 2011 05:45:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] 266: Functional test case for the btrfs raid
	operations
Message-ID: <20111019094527.GD3083@infradead.org>
References: <20111013005652.GM3159@dastard>
	<1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
	<1318919336-32206-4-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318919336-32206-4-git-send-email-Anand.Jain@oracle.com>
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
To: Anand Jain <Anand.Jain@oracle.com>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

> +    if [ $dev_removed == 1 ]; then
> +	umount $SCRATCH_MNT
> +        _devmgt_add "${DEVHTL}"
> +    fi

messy indendation.

> +	btrfs filesystem balance $SCRATCH_MNT || _fail "balance failed"
> +	#btrfs filesystem show $SCRATCH_DEV 2>&1 | egrep devid |awk '{
> +	#	if ( $6 == "0.00" ) { exit 1 }
> +	#}' || _fail "test6_add... failed"

what is the point of the commented out code?

otherwise looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
