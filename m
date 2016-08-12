Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C5CC7CA0
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 04:58:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D3CD08F804B
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 02:58:19 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CWWceqCjjjmNqI6g for <xfs@oss.sgi.com>;
	Fri, 12 Aug 2016 02:58:17 -0700 (PDT)
Date: Fri, 12 Aug 2016 19:58:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160812095813.GZ16044@dastard>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160812025026.GA975@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: peterz@infradead.org, xfs@oss.sgi.com

On Fri, Aug 12, 2016 at 04:50:26AM +0200, Christoph Hellwig wrote:
> On Fri, Aug 12, 2016 at 09:43:35AM +1000, Dave Chinner wrote:
> > Regardless, if the rwsem code can be made to check for exclusive or
> > shared locking, we can get rid of the mrlock abstraction. Can we do
> > that first, Christoph, then make this lock change?
> 
> I was going to do that next, but if you want the patch order switched
> around I can do that as well.

Yeah, I'd prefer we remove te abstraction first, then switch to the
vfs inode lock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
