Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 01:45:58 -0700 (PDT)
Received: from dimat.polito.it (dimat.polito.it [130.192.22.105])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6I8jpbm026691
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 01:45:54 -0700
Message-ID: <469DD3B5.1010308@mandriva.com>
Date: Wed, 18 Jul 2007 10:47:49 +0200
From: =?ISO-8859-1?Q?Giuseppe_Ghib=F2?= <ghibo@mandriva.com>
MIME-Version: 1.0
Subject: Re: [Advocacy] Re: 3ware 9650 tips
References: <582908739-1184695294-cardhu_decombobulator_blackberry.rim.net-122921225-@bxe015.bisx.prod.on.blackberry> <469D24A6.6080409@mandriva.com> <20070718014150.GW12413810@sgi.com>
In-Reply-To: <20070718014150.GW12413810@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com

David Chinner wrote:

> On Tue, Jul 17, 2007 at 10:20:54PM +0200, Giuseppe Ghibò wrote:
>> Indeed XFS is a lot faster than ext3 on many task (e.g.
>> copy/moving or delete huge files o creating filesystems or dumping
>> with xfsdump), and worked fine, until linux kernels around
>> 2.6.15|16|17|18 when it had serious problems about data
>> corruptions.
> 
> <sigh>
> 
> I don't mind advocacy, but misleading FUD about filesystem
> corruption, regardless of filesystem type, is *not acceptable* in
> any forum.
> 
> So, to set the record straight, the only XFS corruption I know of in the
> releases you mention above is this:
> 
> http://oss.sgi.com/projects/xfs/faq.html#dir2
> 
> Which was introduced in 2.6.17-rc1 and fixed in 2.6.18-rc2 (IIRC).i
> The only released kernels affected are 2.6.17.0-6. i.e. it was fixed
> in 2.6.17.7.
> 
> And in the interest of full disclosure, there was another in 2.6.19 (IIRC)
> to do with a brand new feature that nobody used (the attr2 bug) - until
> it was enabled by default on Fedora and the installer tripped over
> it - that was fixed in 2.6.20.

Sorry, but I'm not doing any FUD (if you think so, then my apologies),
I'm just reporting experiences, like any other in this thread.
I was a *strong* estimator of xfs for several reasons (I was even using it for /usr, and
also I was using it everywhere including for /home), but after the experience that lead
to me to that problems I switched back to ext3+dir_index, though it's slower, basically because
I've often to access to the filesystems (e.g. I use it mobile on removable devices)
though different kernels, and I don't know which kernel I would find (e.g.
i might write with a 2.6.12, then reopen with a 2.6.17 or other).

FYI, yes, I was the first who spotted the problem (or rather the first
who did the bug report there), but I was not the only one experiencing that problem, also
Olivier Thauvin, the maintainer of distrib-coffee (which is a 3TB mirror
here http://distrib-coffee.ipsl.jussieu.fr/) and he had the problem
also with kernel based on 2.6.17.14 (final not RC): the problem occurs usually under high|heavy
I/O load/pressure rsync (especially during rsyncing hard and soft links, e.g. over a gigabit
network or an USB external disk). He resolved right now just upgrading
to the final stock 2.6.20|21.

> 
> If you know of more, then where are the bug reports?
> 
>> Furthermore when you run xfs_repair to fix such errors, you find that it lost
>> all the directory names, and places restored files into "random" dirs
>> named with "number" names.
> 
> Please, a little research would tell you what these mean.
> 
> When you lose directory entries on a filesystem for *any* reason,
> you'll end up with files named by *inode number* placed in
> lost+found because they are guaranteed to be unique.  The names and
> the structure that end up in lost+found are certainly not random
> and it's not just XFS that does this. e.g. ext2/3/4 does this, too [1]:
> 
> "Some of the directory and files may not pop-up at their right
> places. Instead they will be located in /lost+found with names after
> their inode numbers."

yes, I knew names should come from the inode numbers, but indeed
were notjust "some" file which takes the inode dir name, but a bunch.
Note that in my case if I shouldn't have done any xfs_repair I problably
wouldn't have lost any file. Indeed the term "lost" is wrong, it didn't
loose any file, the files were there just moved by xfs_repair under the inodes names
(but was not just a couple but thousand of dirs like so, but the problem
originated on try deleting a simple softlink). I know that also other
filesystem place files in lost+found, but I've not experienced a
so high number of recovered|renamed dirs (thousand) in the past, and
if you have the same filename repated under thousand of dir (think to a mirror
of software branches), then it's hard to manually replace them in the right place.

> [...]
> Hence in future can you please try to stick to facts as filesystem
> corruption is something that we take extremely seriously.

so I.

Bye
Giuseppe.
