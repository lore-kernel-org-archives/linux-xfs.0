Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 80C9B7F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 17:16:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07C498F8065
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 15:16:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pvieSSvdzzZHTBIt for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 15:16:40 -0700 (PDT)
Date: Thu, 17 Oct 2013 09:16:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs corrupted
Message-ID: <20131016221636.GL4446@dastard>
References: <1381826507281-35009.post@n7.nabble.com>
	<20131015203434.2f336fd8@galadriel.home>
	<525D8D67.2090301@keptprivate.com>
	<20131015213447.40d05ea0@galadriel.home>
	<525D9E3B.5040507@keptprivate.com> <20131015202640.GR4446@dastard>
	<525E9550.80008@keptprivate.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525E9550.80008@keptprivate.com>
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
To: Stefanita Rares Dumitrescu <katmai@keptprivate.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 16, 2013 at 03:32:00PM +0200, Stefanita Rares Dumitrescu wrote:
> Quick update:
> 
> The xfsprogs from the centos6 yum are newer and they don't use that
> much memory, however i got 2 segfaults and the process stopped.
> 
> I cloned the xfsprogs git and i am running it now with the new 15 gb
> swap that i created, and this is a monster in memory usage.
> 
> Pretty bit of discrepancy.

Not if the centos 6 version is segfaulting before it gets to the
stage that consumes all the memory. From your subsequent post, you
have 76 million inodes in the filesystem. If xfs_repair has to track
all those inodes as part of the recovery (e.g. you lost the root
directory), then it has to index them all in memory.

Most people have no idea how much disk space this amount of metadata
consumes and hence why xfs_repair might run out of memory.  For
example, an newly created 100TB filesystem with 50 million zero
length files in it consumes 28GB of space in metadata.
You've got 50% more inodes than that, so you've xfs_repair is
probably walking in excess of 40GB of metadata in your filesystem.

If a significant portion of that metadata is corrupt, then repair
needs to hold both the suspicious metadata and a cross reference
index in memory to be able to rebuild it all. Hence when you have
etns of gigabytes of metadata, xfs_repair can need tens of GB of RAM
to be able to repair it. There's simply no easy way around this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
