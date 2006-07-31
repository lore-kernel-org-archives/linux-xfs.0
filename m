Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Jul 2006 15:31:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6VMUgDW000972
	for <xfs@oss.sgi.com>; Mon, 31 Jul 2006 15:30:53 -0700
Date: Tue, 1 Aug 2006 08:29:54 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS setting custom extent size: real-time section only?
Message-ID: <20060801082953.C2286470@wobbly.melbourne.sgi.com>
References: <20060726090051.C2118045@wobbly.melbourne.sgi.com> <20060731123837.28243.qmail@web31713.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060731123837.28243.qmail@web31713.mail.mud.yahoo.com>; from hgheist@yahoo.com on Mon, Jul 31, 2006 at 05:38:37AM -0700
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Heilige Gheist <hgheist@yahoo.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 31, 2006 at 05:38:37AM -0700, Heilige Gheist wrote:
> I think that I'll go for the custom extent size as the harder guarantee
> against fragmentation. It also looks to me that custom extent is easier
> for application to implement.
> Are there any other reasons why NOT use custom extent size?

Not really... only things like "its not there in old kernels",
and "its not seen the level of testing and exposure of other
XFS features, like preallocation", etc.

> > > > > Do I have to have non-realtime regular section?
> > > > Yes.  All metadata is stored there.
> > > Is there any way I can do sizing of the meta-data? 
> > 
> > I'm not sure what you're asking there...?
> Provided I have 150G real-time section, how can I estimate a size of
> data section that I need to allocate in order to store filesystem
> meta-data?

Oh, I see.  You don't need to estimate, you can fairly quickly
tell like this (all realtime space management is done up-front
during mkfs/growfs)...

[note: need a very recent xfsprogs to use the -rfile option]

$ mkfs.xfs -d file,size=200m,name=/tmp/meta -r file,size=150g,name=/tmp/real
meta-data=/tmp/meta              isize=256    agcount=8, agsize=6400 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=51200, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=1200, version=1
         =                       sectsz=512   sunit=0 blks
realtime =/tmp/real              extsz=65536  blocks=39321600, rtextents=2457600
$ xfs_db /tmp/meta
xfs_db> sb 
xfs_db> p rbmino
rbmino = 129
xfs_db> p rsumino
rsumino = 130
xfs_db> inode 129
xfs_db> p core.size
core.size = 307200
xfs_db> inode 130
xfs_db> p core.size
core.size = 8192
xfs_db> 

So, it takes ~300k of metadata space to manage that realtime 150g.

cheers.

--
Nathan
