Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7CIPCNR075107
	for <linux-xfs@oss.sgi.com>; Fri, 12 Aug 2011 13:25:15 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFCA753AE52
	for <linux-xfs@oss.sgi.com>; Fri, 12 Aug 2011 11:25:10 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id Muh8wBFy4p9bLzxF for <linux-xfs@oss.sgi.com>;
	Fri, 12 Aug 2011 11:25:10 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1QrwPq-0003P0-SD
	for linux-xfs@oss.sgi.com; Fri, 12 Aug 2011 20:25:06 +0200
Received: from tc-gate2.pci.uni-heidelberg.de ([129.206.21.242])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 12 Aug 2011 20:25:06 +0200
Received: from bernd.schubert by tc-gate2.pci.uni-heidelberg.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 12 Aug 2011 20:25:06 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Deleting files with extended attributes is dead slow
Date: Fri, 12 Aug 2011 20:19:53 +0200
Message-ID: <j23qs9$1c3$1@dough.gmane.org>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Hi there,

with FhGFS we may use extended attributes to store file meta data and 
with ext3/ext4 that also works very well and the rate to create files 
and to write those EAs (create() + fsetxattr()  is about 2.5 to 3 times 
faster than with a create() + write(). Size of those EA data is about 
256 bytes depending on the number of storage stripes.
However, with XFS using extended attributes is *extremely* slow. Here 
are some numbers with ext4 and xfs using a patched [1] bonnie++

> schubert@fsdevel3 bonnie++-1.96>./bonnie++ -d /mnt/fstestXFS/ -s0 -n 1:256:256:1 -r 0 -X
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version  1.96       ------Sequential Create------ --------Random Create--------
> fsdevel3            -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
> files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>           1:256:256   330   6 +++++ +++    47   1   469   9 +++++ +++    31   1
> Latency               962ms      36us     140ms     866ms      28us     311ms
> 1.96,1.96,fsdevel3,1,1314378941,,,,,,,,,,,,,,1,256,256,,,330,6,+++++,+++,47,1,469,9,+++++,+++,31,1,,,,,,,962ms,36us,140ms,866ms,28us,311ms



> schubert@fsdevel3 bonnie++-1.96>./bonnie++ -d /mnt/fstestEXT4/ -s0 -n 100:256:256:10 -r 0 -X
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version  1.96       ------Sequential Create------ --------Random Create--------
> fsdevel3            -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
> files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>      100:256:256/10 21348  52 +++++ +++ 32878  61 25286  60 +++++ +++ 25873  53
> Latency               746us    1926us    2553us     653us     118us   32250us
> 1.96,1.96,fsdevel3,1,1314379136,,,,,,,,,,,,,,100,256,256,,10,21348,52,+++++,+++,32878,61,25286,60,+++++,+++,25873,53,,,,,,,746us,1926us,2553us,653us,118us,32250us


NOTE: For ext4 I had to increase the number of files by factor 100 to 
get any sane number (it would only print '+++++' otherwise). Running the 
benchmark with the same numbers on xfs deleted in so slow delete 
numbers, that it probably still would be busy to delete files by tomorrow.


The xfs file system was formated with these parameters:
> mkfs.xfs -f -i size=512 -i maxpct=90  -l lazy-count=1 -n size=64k /dev/mapper/vg0fsdev3-XFStest


ext4 was formated to have an inode size of 512B and to have a joural 
size of 400MB.

Both file systems are mounted with "nobarrier" (real FhGFS production 
systems usually have raid controllers with battery backups).


Any ideas why xfs is so slow with extended attributes? Without extended 
attributes, so skipping the "-X" option in our patched bonnie also 
results in slower Create numbers (about 4500 on xfs vs. 7500 on ext4) 
compared to ext4, but that is 'only' factor 1.67 and not 50 or more as 
with EAs.


Thanks,
Bernd


[1] Updated bonnie to support extended attributes:
https://bitbucket.org/aakef/bonnie/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
