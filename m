Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3Q00pA9043817 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 19:00:51 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9BB98A8F61
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 17:02:45 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org
	(173-164-175-65-SFBA.hfc.comcastbusiness.net [173.164.175.65])
	by cuda.sgi.com with ESMTP id js05XvWKPixWF6k6 for
	<xfs@oss.sgi.com>; Sun, 25 Apr 2010 17:02:45 -0700 (PDT)
Message-ID: <4BD4D81C.5040503@tlinx.org>
Date: Sun, 25 Apr 2010 17:02:36 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs_fsr question for improvement
References: <201004161043.11243@zmi.at>
	<20100417012415.GE2493@dastard>	<20100417091357.4e7ad1e0@galadriel.home>
	<19412.9412.177637.116303@tree.ty.sabi.co.uk>
In-Reply-To: <19412.9412.177637.116303@tree.ty.sabi.co.uk>
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>

Peter Grandi wrote:
>>> XFS resists fragmentation better than most other filesystems,
>>> so defragmentation, while possible, is generally not needed.
>
> That's a common myth. For most file systems and filesystems.
> Also most applications write files really badly.
>   http://www.sabi.co.uk/blog/anno06-3rd.html#060914b
----
	Do you have any evidence to back this up?  The article you quote says nothing
about xfs allocation -- it's talking about Windows systems using FAT or NTFS -- unless,
you've ported XFS to Windows?   If not, I'm I don't see how your comments are
relevant.

> Fortunately 'xfs_fsr' is mostly reliable, but in-place
> defragmentation is a risky propostion for several reasons even
> if 'xfs_fsr' is fairly reliable.
---
	How is it risky?  Do you have any evidence to back up this claim?
It copies from where it is at, to a pre-reserved, vacant space (which it finds just
before it does the copy).  When the copy is done successfully, its points the inode
at the defragmented data, and frees the old copy -- or at least that's my
'not having looked at the code' understanding of it.  
	This is basically a file copy.  So you are saying that file defragmentation
in place using file copy is risky?  Doesn't this imply you are saying
that copying files is risky?  How is this meaninful?

> Note also that 'xfs_fsr' uses a terrible "defragmentation"
> strategy (from 'man xfs_fsr'):
>   "The reorganization algorithm operates on one file at a time,"
----
	xfs_fsr does a superb job of file defragmenting.  It doesn't 
do disk defragmenting.  But it does defragment single files well, which was
all it was designed to do.  We can lament that it hasn't been improved on, 
but no one with money or with 'free time' (ha) and the knowledge, has seen it as 
a problem, so it hasn't been fixed.


> That also should not be the case unless your applications write
> strategy is wrong and you get extremely interleaved streams, in
> which case you get what you paid for the application programmer.
---
	That's a rather naive view.  It may not be one application but several
writing to the disk at once.  Or it could be one, but recording multiple streams
to disk at the same time -- of course it would have to write them to disk as they
come in, as memory is limited -- how else would you prevent interleaving in such
a case?  There are too many situations where fragmenting can occur to toss them
all off and say they are the result of not paying an application programmer to do it
"correctly".

I don't see why you posted -- it wasn't to help anyone nor to offer constructive
criticism.  It was a bit harsh on the criticism side, as though something about it
was 'personal' for you....   Also sensed a tinge of bitterness in that last bit of
criticism about the video stream fragmentation.  I'm sorry for your loss, but please
try to understand, that this is a forum/list for developers/users to help with xfs problems.

Please rethink your approach here, and I'm apologize in advance if I'm out of
line, but something seemed off-key in this post, but maybe I'm misreading things
completetely... its happened before. :-)

Linda Walsh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
