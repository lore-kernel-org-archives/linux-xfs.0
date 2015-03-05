Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D7C37F47
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 07:19:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3A57A8F8035
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 05:19:08 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id Y3TjDR4WVdE3jXyD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2015 05:19:03 -0800 (PST)
Date: Thu, 5 Mar 2015 14:19:01 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150305131901.GB16235@lst.de>
References: <20150303221033.GB19439@fieldses.org>
	<20150303224456.GV4251@dastard>
	<20150304020826.GD19439@fieldses.org>
	<20150304044141.GQ18360@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150304044141.GQ18360@dastard>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Mar 04, 2015 at 03:41:41PM +1100, Dave Chinner wrote:
> As I understand it, nothing will prevent this - if you don't change
> the UUID on the filesystem when you clone it, then the UUID will
> still match and writes can be directed to any block deice with a
> matching offset/UUID pair.

Unfortunately that's the case indeed.  The whole discovery part of
the block layout protocol is fundamentally flawed, as is the recall
part.  This is my attempt to fix it, but I have no idea how to proceed
from posting my draft to the IETF to actually making it a standard:

http://tools.ietf.org/html/draft-hellwig-nfsv4-scsi-layout-00

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
