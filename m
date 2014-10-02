Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47F2B7F63
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 06:29:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25D66304077
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 04:29:58 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 8pcJr8N1Eyl1NKzI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 04:29:54 -0700 (PDT)
Date: Thu, 2 Oct 2014 13:29:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] xfs: add RWF_NONBLOCK support
Message-ID: <20141002112952.GA32112@lst.de>
References: <1412197494-7655-1-git-send-email-hch@lst.de>
	<1412197494-7655-2-git-send-email-hch@lst.de>
	<20141001222327.GT4758@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141001222327.GT4758@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>, Milosz Tanski <milosz@adfin.com>

On Thu, Oct 02, 2014 at 08:23:27AM +1000, Dave Chinner wrote:
> Shouldn't that be:
> 
> 		if (type & XFS_IOLOCK_EXCL) {
> 			mutex_unlock(&VFS_I(ip)->i_mutex);

Yes, I will resend the fixed version.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
