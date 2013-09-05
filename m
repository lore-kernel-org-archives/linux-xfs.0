Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2FB637F50
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 14:04:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1DE35304048
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 12:04:11 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id JPNF2RlpymXHW6TH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 12:04:08 -0700 (PDT)
Date: Thu, 5 Sep 2013 12:04:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: move buf_ops externs to a xfs_format.h
Message-ID: <20130905190407.GA603@infradead.org>
References: <1378382015-16026-1-git-send-email-david@fromorbit.com>
	<1378382015-16026-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378382015-16026-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 05, 2013 at 09:53:33PM +1000, Dave Chinner wrote:
> All of the buffer operations structures are needed to be exported
> for xfs_db, so move them all to a common location rather than
> spreading them all over the place. They are verifying the on-disk
> format, so xfs_format.h is as good a place as any.
> 
> Don't move the dir2 buffer verifiers - they are already shared in a
> "central" place for all the dir2 and moving them just requires
> adding more include files...

Please only keep the actual format in the _format.h headers and use
a different shared header for incore bits that can be shared.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
