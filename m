Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4CC4D7CA1
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 00:13:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B55AFAC005
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 22:13:10 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id aKdjwazIQWLpu737 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Feb 2016 22:13:08 -0800 (PST)
Date: Tue, 23 Feb 2016 22:12:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Accidental FS corruption: Mapping files to blocks
Message-ID: <20160224061258.GA19107@birch.djwong.org>
References: <CADUjHbXfFEVVk661XMEoAOUM+pQs0LdQh3xFVx6_5tsLZP+P2g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADUjHbXfFEVVk661XMEoAOUM+pQs0LdQh3xFVx6_5tsLZP+P2g@mail.gmail.com>
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
To: Paul Cannon <paul.cannon3128@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 23, 2016 at 10:37:36PM -0500, Paul Cannon wrote:
> I have accidentally damaged my XFS, and need help (and a little prayer).
> The way it happened will provide your daily amusement dose (and hopefully a
> lesson).
> 
> * What happened?
> I have two file systems xfsA (18 TBs on /dev/sdc1) and xfsB (36 TBs on
> /dev/sdd1). They were mounted and working fine. I accidentally executed an
> old script that effectively ran the following command:
> >ddrescue /dev/sdc /dev/sdd sdc_sdd.log
> For those unfamiliar with the ddrescue command, it claims to rescue/image
> data from a drive A to B. It does multiple passes to rescue data with
> maximum efficiency.
> 
> * Why did I do it?
> I am careless or dumb or may be a combination of both. But the fact that
> drives got remapped (sdc/sdd became sde/sdf and otherway around) might also
> be part of it.
> 
> * What happened to XFS on sdd (xfsB)?
> Luckily, the imaging started with an offset of about 2.7 TBs. Why? Because
> this was a restart of ddrescue and it started from past point. IT WROTE a
> total of 6.1 GBs of data on sdd/xfsB
> 
> So I quickly stopped as I realized my mistake. I ran xfs_repair on xfsB.
> Due to the offset of 2.7 TBs, metadata seemed fine. The xfs_repair shows
> everything is fine. But if I extract out data using (dd skip=2.7TB) into a
> file -- I can see things are different! I recognize the abrupt change in a
> text file, exactly where the data overwritten.
> 
> * Luckily I have old copy of the original data!

Good for you!  Seriously. :D

> So I did a rsync -rvn /olddata/ /xfsB
> Nothing! No difference in any data files. I even tried mirrordir, same
> thing -- nothing, no difference!

rsync -c to force it to checksum the data blocks?

By default I think it only compares file size and timestamps.

> * Here is what I think is going on, and I need help.
> I suspect that the access time of the file/files stored at this location
> are perhaps in another location in inode (does this sound correct? I am a
> newbie to XFS). But the data itself has changed at the location.

Quite possible.

> * QUESTION: How do I find what files were stored at the location? I have an
> EXACT location of the range affected. Once I find the affected files, I can
> perhaps do further surgery.

Sounds like something that the reverse-mapping btree and associated GETFSMAP
ioctl could help solve ... too bad it only exists as experimental patches to
the on-disk format. :(

In the meantime, I guess you could umount the filesystem and run xfs_db on it
to find out what was in the areas that got overwritten, assuming rsync -c also
shows no difference.  Something along the lines of:

# xfs_db /dev/sdXX
xfs_db> blockget -n
xfs_db> fsblock <block number of where the overwritten area starts>
xfs_db> blockuse -n -c <number of blocks you think got overwritten>

Have a look at the xfs_db manpage for more info on what those commands do.

--D

> 
> Any help (and prayers) will be highly appreciated.

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
