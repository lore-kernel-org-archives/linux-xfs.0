Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Jan 2007 17:21:38 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0C1LVqw021954
	for <xfs@oss.sgi.com>; Thu, 11 Jan 2007 17:21:33 -0800
Message-Id: <200701120120.MAA18610@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_repair: corrupt inode error
Date: Fri, 12 Jan 2007 12:25:48 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <1168272431.21580.14.camel@mustis>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Jyrki Muukkonen' <jyrki.muukkonen@futurice.fi>, xfs@oss.sgi.com

 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Jyrki Muukkonen
> Sent: Tuesday, 9 January 2007 3:07 AM
> To: xfs@oss.sgi.com
> Subject: Re: xfs_repair: corrupt inode error
> 
> On ma, 2007-01-08 at 12:23 +0200, Jyrki Muukkonen wrote:
> > Got this error in phase 6 when running xfs_repair 2.8.18 on ~1.2TB
> > partition over the weekend (it took around 60 hours to get to this
> > point :). On earlier versions xfs_repair aborted after 
> ~15-20 hours with
> > "invalid inode type" error.
> > 
> > ...
> > disconnected inode 4151889519, moving to lost+found
> > disconnected inode 4151889543, moving to lost+found
> > corrupt inode 4151889543 (btree).  This is a bug.
> > Please report it to xfs@oss.sgi.com.
> > cache_node_purge: refcount was 1, not zero (node=0x132650d0)
> > 
> > fatal error -- 117 - couldn't iget disconnected inode
> > 
> > I've got the full log (both stderr and stdout) and can put that
> > somewhere if needed. It's about 80MB uncompressed and around 7MB
> > gzipped. Running the xfs_repair without multithreading and 
> with -v might
> > also be possible if that's going to help.
> > 
> 
> Some more information:
> - running 64bit Ubuntu Edgy 2.6.17-10-generic
> - one processor so xfs_repair was run with two threads
> - 1.5GB RAM, 3GB swap (at some point the xfs_repair process took a bit
> over 2GB)
> - filesystem is ~1.14TB with about ~1.4 million files
> - most of the files are in subdirectories by date
> (/something/YYYY/MM/DD/), ~2-10 thousand per day
> 
> So is there a way to skip / ignore this error? I could do some testing
> with different command line options and small code patches if that's
> going to help solve the bug.
> 
> Most of the files have been recovered from backups, raw disk 
> images etc.
> but unfortunately some are still missing.
> 
> -- 
> Jyrki Muukkonen
> Futurice Oy
> jyrki.muukkonen@futurice.fi
> +358 41 501 7322

Would it be possible to run xfs_db and print out the inode above:

# xfs_db <dev>
xfs_db> inode 4151889543
xfs_db> print

and email the output back?

Regards,
Barry.
