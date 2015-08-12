Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 51DDB7F50
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 02:17:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17718304043
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 00:17:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6nX4XNafgDBy6NeM (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 00:17:27 -0700 (PDT)
Date: Wed, 12 Aug 2015 00:17:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 12/13] xfs: add helper to conditionally remove items
	from the AIL
Message-ID: <20150812071727.GB14237@infradead.org>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
	<1439233309-19959-13-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439233309-19959-13-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

> +			xfs_trans_ail_remove(lip->li_ailp, lip,
> +					     SHUTDOWN_LOG_IO_ERROR);

I'd say remove the ail argument, lip->li_ailp can be derferenced inside
xfs_trans_ail_remove safely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
