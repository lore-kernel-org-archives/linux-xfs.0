Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E3C6D7F76
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 12:39:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 71E1CAC007
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 10:39:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BvtioNvmLG5AdV40 for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 10:39:13 -0700 (PDT)
Message-ID: <544FD4C1.4020004@sandeen.net>
Date: Tue, 28 Oct 2014 12:39:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS shrinking planned?
References: <544FC202.1000200@shiftmail.org>
In-Reply-To: <544FC202.1000200@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>, xfs@oss.sgi.com

On 10/28/14 11:19 AM, Spelic wrote:
> Hello all,
> XFS is such a good high performance filesystem, kudos for that.
> 
> However for large filesystems (which are mainly those that require high performance) the ability to shrink would be really needed. People usually do not have double the space so to move files to a smaller XFS filesystem, and the inability of XFS to shrink forbids major reorganizations of the storage systems.
> 
> Currently, for that reason I use ext4. Performance is still decent and flexibility is higher due to the ability to shrink, but I would use XFS if it could shrink.
> 
> I suppose shrinking ability is not even planned, is it?

Not formally planned, there are bits and pieces out there (i.e. the inode
mover) which are part of what it might take to achieve a shrinker.

Another option, rather than fs shrinking, is to use the dm-thinp target, which
would allow you to allocate a large-but-sparse block device, create a very
large filesystem on that, and add or remove storage as needed.
(At least I think you can remove it...!)

-Eric

> Thank you
> S.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
