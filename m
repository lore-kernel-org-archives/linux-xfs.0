Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B2AD7F54
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 06:15:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BCD39AC001
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 04:15:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id oBenuQGPri4SScB1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 04:15:30 -0700 (PDT)
Date: Thu, 31 Oct 2013 04:15:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix _filter_ro_mount and make xfs/200 pass
	with old mount
Message-ID: <20131031111529.GA24560@infradead.org>
References: <1383216916-2211-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383216916-2211-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 31, 2013 at 06:55:16PM +0800, Eryu Guan wrote:
> We just want to remove "block device" in _filter_ro_mount(), so add
> "mount:" back.
> 
> Add one more call of _filter_ro_mount() in xfs/200 to match 200.out.

Thanks, I've seen this issue too but didn't have time to debug it yet.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
