Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TNTNLi208060 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 18:29:23 -0500
Received: from mho-01-ewr.mailhop.org (mho-01-ewr.mailhop.org [204.13.248.71])
	by cuda.sgi.com with ESMTP id kM1LSrEEzAo0W279 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 16:29:22 -0700 (PDT)
From: "Kirk Anderson" <kirkande@tx.rr.com>
References: <004b01cd0d3f$c6d4fbc0$547ef340$@tx.rr.com>
	<20120329064054.GP5091@dastard>
	<002501cd0dbe$24be21c0$6e3a6540$@tx.rr.com>
	<20120329213100.GA18323@dastard>
	<005101cd0df9$67f61250$37e236f0$@tx.rr.com>
	<20120329230317.GD18323@dastard>
In-Reply-To: <20120329230317.GD18323@dastard>
Subject: RE: Buffalo LS-Q4.0 Raid 5 XFS errors
Date: Thu, 29 Mar 2012 18:29:14 -0500
Message-ID: <005501cd0e03$c1ccaf00$45660d00$@tx.rr.com>
MIME-Version: 1.0
Content-Language: en-us
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
To: 'Dave Chinner' <david@fromorbit.com>
Cc: xfs@oss.sgi.com

These two matched.

root@LS-QLF55:~# dd if=/dev/sda6 bs=512 count=1 2> /dev/null | hexdump -C >
dump_sda6.txt
root@LS-QLF55:~# dd if=/dev/md2 bs=512 count=1 2> /dev/null | hexdump -C >
dump_md2.txt
root@LS-QLF55:~# diff dump_sda6.txt dump_md2.txt
root@LS-QLF55:~#

root@LS-QLF55:~# dd if=/dev/md2 bs=512 count=4 2> /dev/null | hexdump -C
00000000  58 46 53 42 00 00 10 00  00 00 00 00 2b 4e 92 c0
|XFSB........+N..|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
00000020  1b 5a c5 ad cc e3 40 11  87 4d f5 8e 9b f8 37 c0
|.Z....@..M....7.|
00000030  00 00 00 00 20 00 00 07  00 00 00 00 00 00 01 00  |....
...........|
00000040  00 00 00 00 00 00 01 01  00 00 00 00 00 00 01 02
|................|
00000050  00 00 00 30 01 5a 74 a0  00 00 00 20 00 00 00 00  |...0.Zt....
....|
00000060  00 00 80 00 3d 84 10 00  01 00 00 10 00 00 00 00
|....=...........|
00000070  00 00 00 00 00 00 00 00  0c 0c 08 04 19 00 00 19
|................|
00000080  00 00 00 00 00 04 50 c0  00 00 00 00 00 00 02 ce
|......P.........|
00000090  00 00 00 00 0b ba 45 ab  00 00 00 00 00 00 00 00
|......E.........|
000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
000000b0  00 00 00 00 00 00 00 02  00 00 00 10 00 00 00 30
|...............0|
000000c0  00 0c 10 00 00 00 10 00  00 00 00 00 00 00 00 00
|................|
000000d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
*
00000800


root@LS-QLF55:~# xfs_db -c "sb 0" -c p -c "agf 0" -c p -c "agi 0" -c p
/dev/md2
cache_node_purge: refcount was 1, not zero (node=0xb1698)
xfs_db: cannot read root inode (22)
cache_node_purge: refcount was 1, not zero (node=0xb4e08)
xfs_db: cannot read realtime bitmap inode (22)
Segmentation fault
root@LS-QLF55:~#

Please let me know what my next steps are.  Thanks, Kirk


-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Thursday, March 29, 2012 6:03 PM
To: Kirk Anderson
Cc: xfs@oss.sgi.com
Subject: Re: Buffalo LS-Q4.0 Raid 5 XFS errors

On Thu, Mar 29, 2012 at 05:15:08PM -0500, Kirk Anderson wrote:
> Thank you again for your help.  Please let me know what my next step 
> should be.
> 
> Here is the output from the dd command.  My understanding is that I 
> use the
> /dev/sd[a-d]6 for mine as the  cat /proc/mdstat indicated that
> md2 : active raid5 sda6[0] sdd6[3] sdc6[2] sdb6[1]
>       2906278656 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
> 
> root@LS-QLF55:~# dd if=/dev/sda6 bs=512 count=1 2> /dev/null | hexdump 
> -C
> 00000000  58 46 53 42 00 00 10 00  00 00 00 00 2b 4e 92 c0 
> |XFSB........+N..|
.....

Ok, so that's a superblock. Does it match the output of

# dd if=/dev/md2 bs=512 count=1 2> /dev/null | hexdump -C

It should match according to the above, but it doesn't hurt to confirm.  If
it doesn't then your RAID device has been SBTW and that's what you need to
fix first.

If it does match, can you dump the output of

# dd if=/dev/md2 bs=512 count=4 2> /dev/null | hexdump -C

and

# xfs_db -c "sb 0" -c p -c "agf 0" -c p -c "agi 0" -c p /dev/md2

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
