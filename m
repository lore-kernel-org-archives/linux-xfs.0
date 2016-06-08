Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 553D77CA0
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 06:49:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4B09AC004
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 04:49:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4b7sKzMjp9BfkGbs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2016 04:49:13 -0700 (PDT)
Date: Wed, 8 Jun 2016 13:49:07 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: invalid inode numbers ? after drive moved from Linux 2.6.32 to
	Linux 3.16.0 then back again
Message-ID: <20160608114907.GC8987@redhat.com>
References: <5757FE7A.8020504@codefaber.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5757FE7A.8020504@codefaber.co.uk>
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
To: Nigel Tamplin <ntamplin@codefaber.co.uk>
Cc: xfs@oss.sgi.com

On Wed, Jun 08, 2016 at 12:16:10PM +0100, Nigel Tamplin wrote:
> Hello,
> 
> I have a drive with a partition containing an XFS file system.
> This drive normally resides in a Linux 2.6.32 (Debian 6) server, which is
> also where the file system was created many months ago.
> Last week I removed this drive from it's usual 2.6.32 server and for a few
> hours it was attached to an alternative Linux 3.16.0 (Debian 8) server,
> where the XFS file system was mounted and during this time I created
> /modified / deleted some files.
> Later the drive was moved back to the normal Linux 2.6.32.
> 

Linux 3.16 has inode64 mount option enabled by default, which will cause inodes
to be spread along the whole disk, causing some inodes (those allocated on disk
blocks beyond 1TB offset) to have 64bit numbers.

2.6.32 doesn't use inode64 option by default, and so, files with inodes > 2^32
will not be accessible by the kernel 2.6.32, but, you can use `mount -o inode64`
mount option in the old system and then be able to access these inodes again.



> I've noticed something strange has happened.
> Some (maybe all) of the files worked on whilst the drive was in the Linux
> 3.16.0 are not accessible when the file system is mounted on the Linux
> 2.6.32.
> 
> If I put the drive back in the 3.16.0 server, all files are again
> accessible.
> 
> The few files which are inaccessible on 2.6.32 seem to have no inodes when
> viewed under 2.6.32 but look ok when the drive is in 3.16.0
> 
> 
> "ls -li" on 3.16.0
> 
> 7249604387 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 01
>     104207 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 02
>     101524 drwxrwxr-x 2 nigel users       62 Jun  2 16:39 03
> 2220005080 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 06
> 5637828101 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 07
> 1344499710 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 09
> 2958135019 drwxrwxr-x 2 nigel users       62 Jun  2 16:39 0b
> 7516254020 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 0c
> 5905580833 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 0f
> 3494120096 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 10
> 1988369908 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 12
> 2446706848 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 13
> 2446706832 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 14
> 5905580836 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 16
>  807056393 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 17
> 2688006922 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 18
> 
> 
> "ls -li" on 2.6.32
> 
>          ? ?????????? ? ?     ?            ?            ? 01
>     104207 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 02
>     101524 drwxrwxr-x 2 nigel users       62 Jun  2 16:39 03
> 2220005080 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 06
>          ? ?????????? ? ?     ?            ?            ? 07
> 1344499710 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 09
> 2958135019 drwxrwxr-x 2 nigel users       62 Jun  2 16:39 0b
>          ? ?????????? ? ?     ?            ?            ? 0c
>          ? ?????????? ? ?     ?            ?            ? 0f
> 3494120096 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 10
> 1988369908 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 12
> 2446706848 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 13
> 2446706832 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 14
>          ? ?????????? ? ?     ?            ?            ? 16
>  807056393 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 17
> 2688006922 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 18
> 
> 
> I notice that the files created on 3.16.0 which cannot be accessed on
> 2.6.32, seem to have much higher inode numbers than those which can be
> accessed on both systems.  Could the numbers chosen by 3.16.0 be overflowing
> on 2.6.32 ?  I experimented on another almost empty file system, and this
> seems fine in both systems, but this has very low inode numbers, hence my
> inode number idea.
> 
> I can attach the drive to either system and run diagnostic commands if more
> information is required.
> 
> Regards,
> Nigel
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
