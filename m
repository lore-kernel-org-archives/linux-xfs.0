Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8827B7F51
	for <xfs@oss.sgi.com>; Sat, 13 Jun 2015 17:39:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 521B9304032
	for <xfs@oss.sgi.com>; Sat, 13 Jun 2015 15:39:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bhh1gs6mFakPdHhA for <xfs@oss.sgi.com>;
	Sat, 13 Jun 2015 15:39:23 -0700 (PDT)
Date: Sun, 14 Jun 2015 08:39:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: your mail
Message-ID: <20150613223921.GC20262@dastard>
References: <71962FC942A61D42A3DECDFB7CC94F61193F6F07@STC-EXCH.stc.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <71962FC942A61D42A3DECDFB7CC94F61193F6F07@STC-EXCH.stc.local>
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
To: Tom Christensen <tom.christensen@storagecraft.com>
Cc: "swakefie@redhat.com" <swakefie@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Jun 13, 2015 at 01:02:51AM +0000, Tom Christensen wrote:
> We've run into a bit of an issue with xfs running Ceph.  The following bug details what we are seeing:
> https://bugs.launchpad.net/ubuntu/+source/xfs/+bug/1464308
> 
> Basically the Ceph OSD process gets hung in dstate due to the traceback in the bug.
> 
> Here is additional info gathered:
> 
> xfs bmap output for a random directory
> https://gist.github.com/dmmatson/e864252c7ff346df954a
> 
> attr -l of the file dchinner indicated from the xfs bmap output
> (attr -l)
> (6:11:41 PM) dmatson: Attribute "cephos.spill_out" has a 2 byte value for rbd\udata.66039648e29a80.0000000000000d35__head_23EA10B8__5
> (6:11:45 PM) dmatson: Attribute "ceph.snapset@3" has a 263 byte value for rbd\udata.66039648e29a80.0000000000000d35__head_23EA10B8__5
> (6:11:49 PM) dmatson: Attribute "ceph.snapset@2" has a 1131 byte value for rbd\udata.66039648e29a80.0000000000000d35__head_23EA10B8__5
> (6:11:53 PM) dmatson: Attribute "ceph.snapset@1" has a 2048 byte value for rbd\udata.66039648e29a80.0000000000000d35__head_23EA10B8__5
> (6:11:56 PM) dmatson: Attribute "ceph._" has a 259 byte value for rbd\udata.66039648e29a80.0000000000000d35__head_23EA10B8__5
> (6:12:00 PM) dmatson: Attribute "ceph.snapset" has a 2048 byte value for rbd\udata.66039648e29a80.0000000000000d35__head_23EA10B8__5
> 
> xfs_bmap -vp of same file
> 
> rbd\udata.66039648e29a80.0000000000000d35__head_23EA10B8__5:
> (6:13:21 PM) dmatson: EXT: FILE-OFFSET BLOCK-RANGE AG AG-OFFSET TOTAL FLAGS
> (6:13:25 PM) dmatson: 0: [0..8191]: 2944471376..2944479567 16 (24445776..24453967) 8192 00000

And the attribute fork was:

rbd\udata.66039648e29a80.0000000000000d35__head_23EA10B8__5:
EXT: FILE-OFFSET	BLOCK-RANGE		AG AG-OFFSET          TOTAL FLAGS
  0: [0..7]:		1461176488..1461176495  8  (1163688..1163695)     8 00000
  1: [8..31]:		1461176504..1461176527  8  (1163704..1163727)    24 00000

I just created a filesystem and attribute list identical to the
above, and came up with a attribute fork that looks like:

/mnt/scratch/udata.66039648e29a80.0000000000000d35__head_23EA10B8__5:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          120..127          0 (120..127)           8 00000
   1: [8..15]:         112..119          0 (112..119)           8 00000
   2: [16..23]:        104..111          0 (104..111)           8 00000

IOWs, there's an extra block in the attribute fork that is causing
problems than there needs to be.  That tends to imply attribute
overwrites might be contributing here (the 3-phase overwrite
algorithm increases the space usage) so I'm going to need to try a
few different things to see if I can get an attribute fork into the
same shape....

> LVM configuration: None
> 
> HGST 3TB
> 
> meta-data=/dev/mapper/63e3300b-6b7b-41a0-bdf2-b64ec3c20c51 isize=2048   agcount=32, agsize=22812700 blks

agcount=32 will actually be slowing your disks down. The default of
4AGs is usually best for a single spindle as it has sufficient
allocation cncurrency but results in much fewer seeks than a higher
AG count....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
