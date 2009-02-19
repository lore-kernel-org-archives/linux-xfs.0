Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1J7GT9v087602 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 01:16:29 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AB68132C7F
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2009 23:15:55 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	ivjgGr2SX1eJwJBO for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2009 23:15:55 -0800 (PST)
Date: Thu, 19 Feb 2009 17:19:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs problems (possibly after upgrading from linux kernel
	2.6.27.10 to .14)
Message-ID: <20090219061925.GE8830@disturbed>
References: <499ACE6C.4060304@aei.mpg.de> <20090218091935.GD8830@disturbed>
	<499BD6BB.2000406@aei.mpg.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <499BD6BB.2000406@aei.mpg.de>
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
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Feb 18, 2009 at 10:36:59AM +0100, Carsten Aulbert wrote:
> Dave Chinner schrieb:
> > On Tue, Feb 17, 2009 at 03:49:16PM +0100, Carsten Aulbert wrote:
> >> Do you need more information or can I send these nodes into a re-install?
> > 
> > More information. Can you get a machine into a state where you can
> > trigger this condition reproducably by doing:
> > 
> > 	mount filesystem
> > 	touch /mnt/filesystem/some_new_file
> > 
> > If you can get it to that state, and you can provide an xfs_metadump
> > image of the filesystem when in that state, I can track down the
> > problem and fix it.
> 
> I can try doing that on a few machines, would a metadump help on a
> machine where this corruption occurred some time ago and is still in
> this state?

If you unmount the filesystem, mount it again and then touch a new
file and it reports the error again, then yes, a metadump woul dbe
great.

If the error doesn't show up after a unmount/mount, then I
can't use a metadump image to reproduce the problem.

> >> Feb 16 22:01:28 n0260 kernel: [1129250.851451] Filesystem "sda6": xfs_iflush: Bad inode 1176564060 magic number 0x36b5, ptr 0xffff8801a7c06c00
> > 
> > However, this implies some kind of memory corruption is occurring.
> > That is reading the inode out of the buffer before flushing the
> > in-memory state to disk. This implies someone has scribbled over
> > page cache pages.
> > 
> > 
> >> Feb 17 05:57:44 n0463 kernel: [1156816.912129] Filesystem "sda6": XFS internal error xfs_btree_check_sblock at line 307 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff802dd15b
> > 
> > And that is another buffer that has been scribbled over.
> > Something is corrupting the page cache, I think. Whether the
> > original shutdown is caused by the some corruption, i don't
> > know.
> > 
> 
> At least on two nodes  we ran memtest86+ overnight and so far no error.

I don't think it is hardware related.

> >> plus a few more nodes showing the same characteristics 
> > 
> > Hmmmm. Did this show up in 2.6.27.10? Or did it start occurring only
> > after you upgraded from .10 to .14?
> 
> As far as I can see this only happened after the upgrade about 14 days
> ago. What strikes me odd is that we only had this occurring massively on
> Monday and Tuesday this week.
> 
> I don't know if a certain access pattern could trigger this somehow.

I suspect so. We've already had XFS trigger one bug in the new
lockless pagecache code, and the fix for that went in 2.6.27.11 -
between the good version and the version that you've been seeing
these memory corruptions on. I'm wondering if that fix exposed or
introduced another bug that you've hit....

Nick?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
