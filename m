Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBG1llvu254526 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 19:47:47 -0600
Received: from mga14.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFCBF1F670C
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 17:49:40 -0800 (PST)
Received: from mga14.intel.com (mga14.intel.com [143.182.124.37]) by
	cuda.sgi.com with ESMTP id oNvsqpEQBuwEp2VB for
	<xfs@oss.sgi.com>; Wed, 15 Dec 2010 17:49:40 -0800 (PST)
From: "Zhong, Xin" <xin.zhong@intel.com>
Date: Thu, 16 Dec 2010 09:48:29 +0800
Subject: RE: [PATCH v3] xfstests: pwrite hang when writing from mmaped
	buffer of the same page
Message-ID: <1865303E0DED764181A9D882DEF65FB6859A064AFE@shsmsx502.ccr.corp.intel.com>
References: <1292304018-10827-1-git-send-email-xin.zhong@intel.com>
	<20101215120840.GA29650@infradead.org>
In-Reply-To: <20101215120840.GA29650@infradead.org>
Content-Language: en-US
MIME-Version: 1.0
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks a lot for your help!

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Wednesday, December 15, 2010 8:09 PM
To: Zhong, Xin
Cc: xfs@oss.sgi.com
Subject: Re: [PATCH v3] xfstests: pwrite hang when writing from mmaped buffer of the same page

On Tue, Dec 14, 2010 at 01:20:18PM +0800, Zhong, Xin wrote:
> The problem is found in meego testing on btrfs:
> http://bugs.meego.com/show_bug.cgi?id=6672
> 
> Reviewed-by: Hellwig, Christoph <hch@infradead.org> and Chinner, Dave <david@fromorbit.com>
> Signed-off-by: Zhong, Xin <xin.zhong@intel.com>

Thanks, the new patch looks good.  I'll fix up the rewiewed-by line to
be two separate ones, and move the variable declarations to the top of
the main functions as pointed out by Dave and will commit it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
