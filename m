Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0R25uRJ007972 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 20:05:57 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96ED1BBA42
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 18:05:13 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id 6MvSI7XXfOEACbkd for
	<xfs@oss.sgi.com>; Mon, 26 Jan 2009 18:05:13 -0800 (PST)
Subject: Re: Disable journaling
From: Nathan Scott <nscott@aconex.com>
In-Reply-To: <497E6759.3060300@sandeen.net>
References: <b211fe280901261723h6dd1db69t9d24c8d6774b18bc@mail.gmail.com>
	<497E6759.3060300@sandeen.net>
Date: Tue, 27 Jan 2009 13:02:04 +1100
Message-Id: <1233021724.4460.25.camel@verge.scott.net.au>
Mime-Version: 1.0
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
To: Iuri Diniz <iuridiniz@gmail.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, 2009-01-26 at 19:46 -0600, Eric Sandeen wrote:
> 
> > Maybe, the ext4 (like ext3 does) will support it by doing this:
> > 
> > tune2fs -O ^has_journal /dev/sda1
> > 
> > Is possible to disable journaling on XFS too?
> 
> No, it's not right possible today.  There used to be a sort of config
> option that disabled journaling ages ago, but it's gone now.  Not sure
> it ever worked on Linux.

It never did - suffered from adding "never-tested" code paths
in critical areas at the top of the journalling layer in XFS.
Alot of the ordering of work, releasing of resources, etc in
metadata I/O depends on work being scheduled at log I/O
completion time, so if you remove the log entirely, it moves
several things around in ways that are tricky to get right.

Its much simpler to just create a ramdisk and house the journal
there, if you don't want the benefits of a journal (which might
sound attractive, right up to the point you actually need them).

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
