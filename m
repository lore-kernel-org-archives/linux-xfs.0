Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 35D8E7F82
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 08:42:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07FEB8F8064
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 06:41:59 -0700 (PDT)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
	[209.85.220.44]) by cuda.sgi.com with ESMTP id 6E4TuXNvlclx9vap
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Aug 2014 06:41:57 -0700 (PDT)
Received: by mail-pa0-f44.google.com with SMTP id eu11so5484367pac.3
	for <xfs@oss.sgi.com>; Thu, 07 Aug 2014 06:41:57 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Aug 2014 15:41:57 +0200
Message-ID: <CACyNnZNAZUSf1Veybw24hU0snaTyp+Yg+wXS1_Kv-rynQjzjuw@mail.gmail.com>
Subject: Recovery of deleted files/directories
From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
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
To: xfs@oss.sgi.com

On Thu, Aug 7, 2014 at 2:56 PM, Brian Foster <bfoster@redhat.com> wrote:
>> But di_mode in particular is a key element as I am using it to
>> differentiate files from directories.
> In general you can't rely on on-disk data once the inode has been freed.
> Perhaps you should start a new thread with some kind of write up about
> what you're trying to accomplish and how you're going about it.

Yes, I know it is unreliable, and that's OK for me. I'm satisfied in
having a best effort solution which works often, it does not have to
be fully reliable.

What I am trying to accomplish is quite simple: Recover as many
deleted files in a XFS partition as possible. For example if someone
deletes a file by mistake, how to get it back?

And the current place where I got stuck is exactly the post-xfs_ifree
inode, specifically deciding if the inode is a directory or a file. In
my hex editor I see that all the information is still there, it would
be a petty to give up when so little is missing.

That di_format is overwritten is a big problem too, but I think I can
work around it by trying each format and choose the best result from
all tries.

Also, I just noticed that di_size is also overwritten ... which will
be very bad for file recovery.

But knowing if the inode is a file or a directory is the most pressing issue.

For a better illustration, here is the data I see for a directory
(xfs_del is the deleted, xfs_orig is before delete):

http://magnifier.sourceforge.net/temp/xfs/xfs_deleted_inode_dir.png

And the same for a file:

http://magnifier.sourceforge.net/temp/xfs/xfs_deleted_inode_file.png

Well, it might be that what I want to do is impossible, but I just I
might ask in case anyone knows any other way to differentiate a file
from a directory, if at least this information is present I could
somehow work around the other issues.

thanks,
-- 
Felipe Monteiro de Carvalho

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
