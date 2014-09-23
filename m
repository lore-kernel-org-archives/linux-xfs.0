Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB00429DF9
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 17:29:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33B4AAC008
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 15:29:48 -0700 (PDT)
Received: from chaos.caltech.edu (chaos.caltech.edu [131.215.34.119]) by
	cuda.sgi.com with ESMTP id 4MjiRUEpbiwXVJJ4 (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 15:29:46 -0700 (PDT)
From: Diane Trout <diane@caltech.edu>
Subject: Re: Corrupted file system
Date: Tue, 23 Sep 2014 15:29:43 -0700
Message-ID: <6825577.fQrC5yyUIR@myrada>
In-Reply-To: <CAA43vkWP5MEv=EoUxthjniyiiLm8hZNSS-agcm2C3dBDMXQ8Zw@mail.gmail.com>
References: <5839367.DyqsVHbRuQ@myrada>
	<CAA43vkWP5MEv=EoUxthjniyiiLm8hZNSS-agcm2C3dBDMXQ8Zw@mail.gmail.com>
MIME-Version: 1.0
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
To: Sean Caron <scaron@umich.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello,

Yes, I had my doubts about that there's anything reasonable one could do after 
part of the file system was randomized. I'll trying updating to xfsprogs 3.2.1 
and see if that does any better.

Thank you for the advice.

Diane

On Tuesday, September 23, 2014 18:12:22 Sean Caron wrote:
> Hi Diane,
> 
> Probably best to reformat and restore from a backup at this point. I'm
> notorious for my views on xfs_repair but most folks here will agree that in
> the case where there has been a major underlying array failure, there is
> not much it can do to help. Better to just mount ro,noreplaylog and get
> what you can in these sorts of scenarios, IMO.
> 
> "Did you try the latest copy of xfs_repair"? Sometimes it will get further
> or not crash, but it likely will still maul whatever's left of your
> filesystem.
> 
> Best of luck,
> 
> Sean
> 
> On Tue, Sep 23, 2014 at 6:02 PM, Diane Trout <diane@caltech.edu> wrote:
> > Hi,
> > 
> > I had a raid failure at work that ended up corrupting an xfs filesystem
> > the
> > tail of the xfs_repair command looks like the below. I was able to
> > generate a
> > metadata dump but is there a point to making it available?
> > 
> > It does crash repeatedly at the same place
> > 
> > (I'm not subscribed to the list, so could you reply directly as well?)
> > 
> > disconnected inode 15276, moving to lost+found
> > disconnected inode 15277, moving to lost+found
> > disconnected inode 15278, moving to lost+found
> > disconnected inode 15279, moving to lost+found
> > disconnected inode 15280, moving to lost+found
> > disconnected inode 15281, moving to lost+found
> > disconnected inode 15282, moving to lost+found
> > disconnected inode 15283, moving to lost+found
> > disconnected inode 15284, moving to lost+found
> > disconnected inode 15286, moving to lost+found
> > disconnected inode 15287, moving to lost+found
> > disconnected inode 15288, moving to lost+found
> > disconnected inode 15289, moving to lost+found
> > disconnected inode 15290, moving to lost+found
> > disconnected inode 15291, moving to lost+found
> > disconnected inode 15292, moving to lost+found
> > disconnected inode 15293, moving to lost+found
> > disconnected inode 15294, moving to lost+found
> > disconnected inode 15295, moving to lost+found
> > disconnected inode 15360, moving to lost+found
> > corrupt dinode 15360, extent total = 1, nblocks = 0.  This is a bug.
> > Please capture the filesystem metadata with xfs_metadump and
> > report it to xfs@oss.sgi.com.
> > cache_node_purge: refcount was 1, not zero (node=0x7f369883e6f0)
> > 
> > fatal error -- 117 - couldn't iget disconnected inode
> > 
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
