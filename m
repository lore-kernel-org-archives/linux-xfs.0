Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D5FA27F63
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 11:34:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 583BAAC001
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 09:34:51 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IkI3NWsH07fmTlab (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 09:34:46 -0800 (PST)
Date: Thu, 29 Jan 2015 12:34:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_repair fails with corrupt dinode
Message-ID: <20150129173414.GL17652@laptop.bfoster>
References: <587A9635632B174A943E53AF3B58A9082E3BE068CE@vanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <587A9635632B174A943E53AF3B58A9082E3BE068CE@vanda>
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
To: "SCHEFFER, Philippe" <Philippe.SCHEFFER@inist.fr>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jan 29, 2015 at 04:48:15PM +0100, SCHEFFER, Philippe wrote:
> Hi,
> 
> I have a corrupted xfs filesytem. When I try to repair I get this error :
> disconnected inode 1427919, moving to lost+found
> corrupt dinode 1427919, extent total = 1, nblocks = 0.  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=0x1f6c19620)
> 
> fatal error -- 117 - couldn't iget disconnected inode
> 
> I captured metada with xfs_metadump but the file is 1,4Gb long. I can't send it to you.
> 

What kernel/xfsprogs version, xfs_info, mount options? Do you have the
full xfs_repair output? In general:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

It's not clear to me from your report whether repair fixed this or
failed itself. Also, can you compress the metadump image?

Brian

> I printed inode1427919 :
> 
> xfs_db> inode 1427919
> xfs_db> print
> core.magic = 0x494e
> core.mode = 0100644
> core.version = 2
> core.format = 2 (extents)
> core.nlinkv2 = 1
> core.onlink = 0
> core.projid_lo = 0
> core.projid_hi = 0
> core.uid = 1144
> core.gid = 1144
> core.flushiter = 19
> core.atime.sec = Fri Jan  9 21:50:25 2015
> core.atime.nsec = 132886289
> core.mtime.sec = Wed Oct 15 16:28:33 2014
> core.mtime.nsec = 166360243
> core.ctime.sec = Wed Oct 15 16:28:33 2014
> core.ctime.nsec = 166360243
> core.size = 2536
> core.nblocks = 1
> core.extsize = 0
> core.nextents = 1
> core.naextents = 0
> core.forkoff = 0
> core.aformat = 2 (extents)
> core.dmevmask = 0
> core.dmstate = 0
> core.newrtbm = 0
> core.prealloc = 0
> core.realtime = 0
> core.immutable = 0
> core.append = 0
> core.sync = 0
> core.noatime = 0
> core.nodump = 0
> core.rtinherit = 0
> core.projinherit = 0
> core.nosymlinks = 0
> core.extsz = 0
> core.extszinherit = 0
> core.nodefrag = 0
> core.filestream = 0
> core.gen = 837444118
> next_unlinked = null
> u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,320660992,1,0]
> 
> What could I do for solve this problem.
> 
> Thanks in advance.
> 
> Philippe
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
