Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E4EFD7CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 15:49:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9479E30404E
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 13:49:23 -0700 (PDT)
Received: from dayis01iron02.ad.reyrey.com ([192.112.245.73]) by cuda.sgi.com
	with ESMTP id BzIgeGIiqVCAiijj (version=TLSv1.2 cipher=RC4-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 13:49:21 -0700 (PDT)
From: "Simpson, John R" <john_simpson@reyrey.com>
Date: Thu, 7 Apr 2016 16:49:10 -0400
Subject: RE: Determining whether stripe unit and stripe size were detected
	correctly
Message-ID: <5BDD118B6525E24D82051EDA520EB5FC010533AE@IS-EXMB07-RP.ad.reyrey.com>
References: <5BDD118B6525E24D82051EDA520EB5FC0105339D@IS-EXMB07-RP.ad.reyrey.com>
	<5706C157.5070400@sandeen.net>
In-Reply-To: <5706C157.5070400@sandeen.net>
Content-Language: en-US
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
To: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>



> -----Original Message-----
> From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf
> Of Eric Sandeen
> Sent: Thursday, April 07, 2016 4:22 PM
> To: xfs@oss.sgi.com
> Subject: Re: Determining whether stripe unit and stripe size were
> detected correctly
> 
> 
> 
> On 4/7/16 3:16 PM, Simpson, John R wrote:
> > Greetings,
> >
> >
> >
> >                 I'm in the process of tracking down lower than
> expected performance and occasional blocked tasks on some internal file
> servers with XFS datastores.  Several sources have pointed out the
> importance of using the correct stripe unit and stripe size when
> formatting and mounting XFS filesystems, and that XFS can detect these
> values for some, but not all, hardware RAID controllers.  The servers in
> question are PowerEdge R510b servers with PERC H700 controllers.
> Datastores are RAID5 with a 128K stripe.
> >                 Is there any way to determine if the stripe unit and
> stripe size were detected correctly?  These values were not specified
> when the filesystems were formatted or mounted.  If they were not
> detected, is there any way to determine them programmatically?
> >                 If this is not the correct forum for this question
> please point me in the right direction.
> >
> >
> >
> > Best regards,
> 
> > # xfs_info /DS01
> >
> > meta-data=/dev/sdb1              isize=256    agcount=5,
> agsize=268435455 blks
> >          =                       sectsz=512   attr=2, projid32bit=0
> > data     =                       bsize=4096   blocks=1212415488,
> imaxpct=5
> >          =                       sunit=0      swidth=0 blks
> 
> sunit == swidth == 0, so no geometry is present on this filesystem.
> 
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=521728, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-
> count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> mkfs.xfs uses values exported by the block device, and can be seen by
> using blockdev to query them, i.e.
> 
> blockdev --getiomin --getioopt /dev/sdb1
> 
> If it returns 0, no geometry is exported by the device, and you'd need
> to use your own knowledge of the device to set appropriate values (and
> to properly partition on aligned boundaries as well)
> 
> -Eric
> 

Thank you, I was hoping sunit == swidth == 0 meant 'auto-detected' but suspected that wasn't the case.  It looks like blockdev is reporting 0 for getioopt so we'll have to calculate and supply sunit and swidth.  I believe the partition is properly aligned, I used the following.  Any suggested improvements are appreciated.

parted --align optimal --script $device mklabel gpt mkpart -- primary 1 -1

Blockdev reports:

#  blockdev --getiomin --getioopt /dev/sdb1
512
0


Is there a way, other than testing, to determine the potential performance improvement gained by providing the geometry?

John

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
