Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BDA3B7D01
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 18:09:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9063F8F8037
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 16:09:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dDPL5NyRLoVryQ3W for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2016 16:09:50 -0700 (PDT)
Date: Wed, 27 Apr 2016 09:09:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: development APIs for used/free blocks information
Message-ID: <20160426230925.GH26977@dastard>
References: <97A4F433DEE099488FE21C1718A641D2139E86F5@wmsexchsvr01.winmagic.local>
	<20160426222129.GD26977@dastard> <571FF0F6.2030202@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <571FF0F6.2030202@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Apr 26, 2016 at 05:51:34PM -0500, Eric Sandeen wrote:
> 
> 
> On 4/26/16 5:21 PM, Dave Chinner wrote:
> > On Tue, Apr 26, 2016 at 08:51:10PM +0000, Benjamin Wirth wrote:
> >> Hello,
> >>
> >> I was looking for development APIs for XFS. The contents of
> >> xfsprogs-devel seem to only contain a few IOCTL commands, mostly
> >> file/inode based operations.
> >>
> >> I need to query free/used blocks of an entire XFS filesystem and
> >> was hoping to find some user-space APIs for this.
> > 
> > $ man 2 statvfs
> 
> I was assuming that he was interested in the actual used/free block
> locations, not just the total count.  But maybe I was wrong!

Maybe I'm wrong, but asking for free/used blocks is ambiguous to say
the least. If he wants free/used blocks, then we just need to
forward port this kernel branch:

https://git.kernel.org/cgit/linux/kernel/git/dgc/linux-xfs.git/log/?h=fiemapfs

And this xfsprogs branch:

https://git.kernel.org/cgit/fs/xfs/xfsprogs-dev.git/log/?h=spaceman

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
