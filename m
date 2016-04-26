Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E664C7CEE
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 17:21:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8E798F804C
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 15:21:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	j8OIwdlQ82sDZ9OW for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2016 15:21:43 -0700 (PDT)
Date: Wed, 27 Apr 2016 08:21:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: development APIs for used/free blocks information
Message-ID: <20160426222129.GD26977@dastard>
References: <97A4F433DEE099488FE21C1718A641D2139E86F5@wmsexchsvr01.winmagic.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <97A4F433DEE099488FE21C1718A641D2139E86F5@wmsexchsvr01.winmagic.local>
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
To: Benjamin Wirth <Benjamin.Wirth@winmagic.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Apr 26, 2016 at 08:51:10PM +0000, Benjamin Wirth wrote:
> Hello,
> 
> I was looking for development APIs for XFS. The contents of
> xfsprogs-devel seem to only contain a few IOCTL commands, mostly
> file/inode based operations.
> 
> I need to query free/used blocks of an entire XFS filesystem and
> was hoping to find some user-space APIs for this.

$ man 2 statvfs

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
