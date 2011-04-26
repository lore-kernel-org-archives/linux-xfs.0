Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3QLmrxb183972
	for <linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 16:48:53 -0500
Received: from mail.1-click.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C17C416B59
	for <linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 14:52:24 -0700 (PDT)
Received: from mail.1-click.hu (ns2.netcenter.hu [195.228.155.139]) by
	cuda.sgi.com with ESMTP id JurAkUBmChYUqXZL for
	<linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 14:52:24 -0700 (PDT)
Message-ID: <0C7B7E669F9046FEAC7C2AA3B52BA1B2@myXP>
From: "Janos Haar" <janos.haar@netcenter.hu>
References: <DFA094D472104424BEA7AA9060DE0D6F@myXP>
	<20110411214238.GE21395@dastard>
Subject: Re: 2 question about XFS fragmentation and _fsr: SPLITTED Q2:normal
	files, samba share
Date: Tue, 26 Apr 2011 23:51:19 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com

Note: I have splitted my previous letter for easyer discusion...
This have only Question-2 the storage with only normal files and samba
share.


----- Original Message ----- 
From: "Dave Chinner" <david@fromorbit.com>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-xfs@oss.sgi.com>
Sent: Monday, April 11, 2011 11:42 PM
Subject: Re: 2 question about XFS fragmentation and _fsr


> On Mon, Apr 11, 2011 at 07:39:07PM +0200, Janos Haar wrote:
>> Hello list,

>> Question 2:
>> One of our customers have one storage wich is exactly the same like
>> the one wich is described on the Q1, but only used for samba storage
>> for storing media files (big files.)
>> I am sure, there is no torrent or similar, and i have told to the
>> customers on the beginning "don't write more files parallel, to
>> avoid fragmentation", but today the storage is >95% fragmented.
>
> Once again, what does 95% fragmented mean?

[root@Clarus-gl2k10-2 admin]# cat xfs_get_frag_ratio
echo loop0
xfs_db -c frag -r /dev/loop0
[root@Clarus-gl2k10-2 admin]# ./xfs_get_frag_ratio
loop0
actual 51179670, ideal 5914, fragmentation factor 99.99%

>
>> The customer sad, he only does file write one by one, and nothing more.
>> How can this be?
>
> Depends on your samba configuration to how it does writes. If it is
> conigured to do sync writes then it will have all sorts of
> fragmentation problems. So without more details about the workload,
> the kernel that is being used, the fragmentation occurring (xfs_bmap
> is your friend) and the samba config, there's little that can be
> suggested here.

[root@Clarus-gl2k10-2 ~]# uname -a
Linux Clarus-gl2k10-2 2.6.28.10 #6 SMP Thu Apr 29 01:00:58 CEST 2010 x86_64 
x86_64 x86_64 GNU/Linux

In kernel, i have tried out the pdflush-patch wich let me set the number of 
pdflushd-s to 8-64.
This was not a good idea i know that, but if i am right this have no effet 
to the fragmentation because pdflush not works on the FS layer.
Or i have missed something?

[root@Clarus-gl2k10-2 ~]# smbd -V
Version 3.0.23c-2

smb.conf (filtered the # lines and the ; lines)

[global]
   workgroup = WORKGROUP
   server string = Gladiator-StreamLine-gl2k10-2
   security = user
   load printers = yes
   cups options = raw
   log file = /var/log/samba/%m.log
   max log size = 50
   dns proxy = no
[store]
......

The workload is one PC for "administration" namely filling up the storage, 
and 2 client wich can reach the media files in RO mount point.
The customer knows about "only write on file at one time".

>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

Thanks,
Janos 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
