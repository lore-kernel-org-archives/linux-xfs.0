Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3DGrvjY248525 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 11:53:57 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 335E179A8DB
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 09:55:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id F9XpIs9Ohcpm9NqJ for
	<xfs@oss.sgi.com>; Tue, 13 Apr 2010 09:55:51 -0700 (PDT)
Message-ID: <4BC49D94.8090402@sandeen.net>
Date: Tue, 13 Apr 2010 11:36:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS-filesystem corrupted by defragmentation
References: <87r5mjpn8l.fsf@workstation006.office.ice-sf.at>
In-Reply-To: <87r5mjpn8l.fsf@workstation006.office.ice-sf.at>
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
To: Bernhard Gschaider <bgschaid_lists@ice-sf.at>
Cc: xfs@oss.sgi.com

On 04/13/2010 07:10 AM, Bernhard Gschaider wrote:
> 
> Hi!
> 
> I'm asking here because I've been referred here fro the CentOS-mailing
> list (for the full story see
> http://www.pubbs.net/201004/centos/17112-centos-performance-problems-with-xfs-on-centos-54.html
> and 
> http://www.pubbs.net/201004/centos/24542-centos-xfs-filesystem-corrupted-by-defragmentation-was-performance-problems-with-xfs-on-centos-54.html
> the following stuff is a summary of this)
> 
> It was suggested to me that the source of my performance problems might
> be the fragmentation of the XFS-system. I tested for fragmentation and
> got 
> 
> xfs_db> frag
> actual 6349355, ideal 4865683, fragmentation factor 23.37%

so on average your filesystem has 6349355/4865683 = 1.3 extents per file.

Just as a casual side note, this is not even remotely bad, at least
on average.

> Before I'd try to defragment my whole filesystem I figured "Let's try
> it on some file". 
> 
> So I did
> 
>> xfs_bmap /raid/Temp/someDiskimage.iso
> [output shows 101 extents and 1 hole]
> 
> Then I defragmented the file
>> xfs_fsr /raid/Temp/someDiskimage.iso
> extents before:101 after:3 DONE
> 
>> xfs_bmap /raid/Temp/someDiskimage.iso
> [output shows 3 extents and 1 hole]
> 
> and now comes the bummer: i wanted to check the fragmentation of the
> whole filesystem (just for checking):
> 
>> xfs_db -r /dev/mapper/VolGroup00-LogVol04
> xfs_db: unexpected XFS SB magic number 0x00000000
> xfs_db: read failed: Invalid argument
> xfs_db: data size check failed
> cache_node_purge: refcount was 1, not zero (node=0x2a25c20)
> xfs_db: cannot read root inode (22)

So here you did:

# xfs_db -r /dev/mapper/VolGroup00-LogVol04

but below you show:

% xfs_info  /raid
> meta-data=/dev/VolGroup00/LogVol05

.... wrong device maybe?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
