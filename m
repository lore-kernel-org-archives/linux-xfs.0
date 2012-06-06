Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q56EvRxH229958 for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 09:57:27 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id z3bF4vDbIguyrk21 for <xfs@oss.sgi.com>;
	Wed, 06 Jun 2012 07:57:25 -0700 (PDT)
Message-ID: <4FCF6FD5.7020901@sandeen.net>
Date: Wed, 06 Jun 2012 09:57:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Segmentation fault in xfs_db frag, xfsprogs-3.1.8
References: <4FCC77E1.4030600@cape-horn-eng.com>
	<20120605234528.GD22848@dastard>
	<4FCF2BAC.6050100@cape-horn-eng.com>
In-Reply-To: <4FCF2BAC.6050100@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On 6/6/12 5:06 AM, Richard Ems wrote:
> On 06/06/2012 01:45 AM, Dave Chinner wrote:
>> No surprise if you have a large filesystem and the filesystem is
>> changing while xfs_db is running. xfs_db is not coherent with
>> mounted filesytems, and it is not recommended that you use it that
>> way.s xfs-db is a debugging tool, not a filesystem state reporting
>> tool.
> 
> Ok, thanks, didn't know that.
> I would like to monitor the fragmentation value for all my mounted XFS.
> I think I read in previous list messages that also other people are
> using xfs_db this way. Or is there another way to get the fragmentation
> value?

As Dave said, this just isn't that useful.

http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25.__Is_that_bad.3F

explains why.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
