Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2U4k32u251571 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 23:46:03 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id j5ZRCPtXhbGgFzrt for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 21:46:02 -0700 (PDT)
Message-ID: <4F753A89.5050909@sandeen.net>
Date: Thu, 29 Mar 2012 23:46:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Buffalo LS-Q4.0 Raid 5 XFS errors
References: <004b01cd0d3f$c6d4fbc0$547ef340$@tx.rr.com>
	<20120329064054.GP5091@dastard>
	<002501cd0dbe$24be21c0$6e3a6540$@tx.rr.com>
	<20120329213100.GA18323@dastard>
	<005101cd0df9$67f61250$37e236f0$@tx.rr.com>
	<20120329230317.GD18323@dastard>
	<005501cd0e03$c1ccaf00$45660d00$@tx.rr.com>
	<20120329235200.GE18323@dastard>
	<005601cd0e11$c0b62d90$422288b0$@tx.rr.com>
In-Reply-To: <005601cd0e11$c0b62d90$422288b0$@tx.rr.com>
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
To: Kirk Anderson <kirkande@tx.rr.com>
Cc: xfs@oss.sgi.com

On 3/29/12 8:09 PM, Kirk Anderson wrote:
> I really appreciate your help to this point.  I do not have the xfs_irecover
> command available.  Do you think there is an rpm for it that would be
> compatible with the flavor of Linux this box is running? 

xfs_irecover isn't packaged up anywhere AFAIK.  If/when Christoph's patch
makes it upstream, it'll make its way into packages.

Until then you'd need to get it built yourself...

-Eric

> root@LS-QLF55:~# uname -a
> Linux LS-QLF55 2.6.22.7 #395 Thu May 21 22:24:49 JST 2009 armv5tejl unknown
> 
>  If so, where may I find it?  Since I do not have a backup of this it sounds
> like I have nothing to lose in trying the xfs_repair or should I hold out
> for xfs_irecover?  Please let me know.  Thanks, Kirk
> 
> -----Original Message-----
> From: Dave Chinner [mailto:david@fromorbit.com] 
> Sent: Thursday, March 29, 2012 6:52 PM
> To: Kirk Anderson
> Cc: xfs@oss.sgi.com
> Subject: Re: Buffalo LS-Q4.0 Raid 5 XFS errors
> 
> On Thu, Mar 29, 2012 at 06:29:14PM -0500, Kirk Anderson wrote:
>> These two matched.
>>
>> root@LS-QLF55:~# dd if=/dev/sda6 bs=512 count=1 2> /dev/null | hexdump 
>> -C > dump_sda6.txt root@LS-QLF55:~# dd if=/dev/md2 bs=512 count=1 2> 
>> /dev/null | hexdump -C > dump_md2.txt root@LS-QLF55:~# diff 
>> dump_sda6.txt dump_md2.txt root@LS-QLF55:~#
>>
>> root@LS-QLF55:~# dd if=/dev/md2 bs=512 count=4 2> /dev/null | hexdump 
>> -C
>> 00000000  58 46 53 42 00 00 10 00  00 00 00 00 2b 4e 92 c0
>> |XFSB........+N..|
>> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> |................|
>> 00000020  1b 5a c5 ad cc e3 40 11  87 4d f5 8e 9b f8 37 c0
>> |.Z....@..M....7.|
>> 00000030  00 00 00 00 20 00 00 07  00 00 00 00 00 00 01 00  |....
>> ...........|
>> 00000040  00 00 00 00 00 00 01 01  00 00 00 00 00 00 01 02
>> |................|
>> 00000050  00 00 00 30 01 5a 74 a0  00 00 00 20 00 00 00 00  |...0.Zt....
>> ....|
>> 00000060  00 00 80 00 3d 84 10 00  01 00 00 10 00 00 00 00
>> |....=...........|
>> 00000070  00 00 00 00 00 00 00 00  0c 0c 08 04 19 00 00 19
>> |................|
>> 00000080  00 00 00 00 00 04 50 c0  00 00 00 00 00 00 02 ce
>> |......P.........|
>> 00000090  00 00 00 00 0b ba 45 ab  00 00 00 00 00 00 00 00
>> |......E.........|
>> 000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> |................|
>> 000000b0  00 00 00 00 00 00 00 02  00 00 00 10 00 00 00 30
>> |...............0|
>> 000000c0  00 0c 10 00 00 00 10 00  00 00 00 00 00 00 00 00
>> |................|
>> 000000d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>> |................|
>> *
>> 00000800
> 
> The AGF, AGI and AGFL have all been zeroed. Something has overwritten them.
> Your filesysetm is likely to be toast.
> 
>>
>>
>> root@LS-QLF55:~# xfs_db -c "sb 0" -c p -c "agf 0" -c p -c "agi 0" -c p
>> /dev/md2
>> cache_node_purge: refcount was 1, not zero (node=0xb1698)
>> xfs_db: cannot read root inode (22)
> 
> And that means the zeroing has extended well into the filesystem, and your
> root directory has been lost. There's really not that much that reapir can
> do for you at this point execpt make a mess. There is no AGI left to find
> where in-use inodes might live to recover them, and the directory structure
> cannot be used to find them, either, so I think the only thing you can do
> now is start on disaster recovery.
> 
> Christoph had a patch to xfs_repair that allowed it to run xfs_irecover like
> functionality - I don't think he ever posted it, so you might just have to
> find the original xfs_irecover utility and make use of that to extract
> whatever you can from the busted filesystem.
> 
> Other than that, I think that there's little we can do to help you recover
> the filesystem intact at this point....
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
