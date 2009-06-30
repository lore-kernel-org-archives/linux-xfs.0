Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ULBPs4230297 for <xfs@oss.sgi.com>; Tue, 30 Jun 2009 16:11:25 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D69113272AE
	for <xfs@oss.sgi.com>; Tue, 30 Jun 2009 14:11:55 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Vn1z16Q4N6xCXG6f for
	<xfs@oss.sgi.com>; Tue, 30 Jun 2009 14:11:55 -0700 (PDT)
Message-ID: <4A4A7F9A.7000304@sandeen.net>
Date: Tue, 30 Jun 2009 16:11:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Seg fault during xfs repair (segmentation fault / segv)
References: <4A4A596D.8030800@ssec.wisc.edu> <4A4A5C4E.7030605@sandeen.net>
	<4A4A7D44.7040009@ssec.wisc.edu>
In-Reply-To: <4A4A7D44.7040009@ssec.wisc.edu>
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
To: Jesse Stroik <jstroik@ssec.wisc.edu>
Cc: xfs@oss.sgi.com

Jesse Stroik wrote:
> Eric,
> 
> Eric Sandeen wrote:
>> Jesse Stroik wrote:
>>> I have a server with a ~20TB xfs file system on Linux 
>>> (2.6.18-92.1.22.el5) and am running xfsprogs-2.9.4-4.el5.  We had a few 
>>> corrupted files which I believe were due to a SCSI issue after a recent 
>>> power outage.  Due to the corruption, I ran xfs_check and would like to 
>>> run xfs_repair on the system.
>> It'd really be great to test more recent xfsprogs first, that one is
>> about 2 years old.
>>
>> You can probably grab any recent fedora src.rpm and rebuild it, and
>> later go back to the centos version if you wish.
> 
> 
> I fetched the current version from SVN using these directions: 
> http://xfs.org/index.php/Getting_the_latest_source_code
> 
> I get identical results.

Bummer :)

> --------
> ...
> reset bad sb for ag 31
> reset bad agf for ag 31
> reset bad agi for ag 31
> Segmentation fault
> 
> $ ./xfs_repair -V
> xfs_repair version 3.0.2
> --------
> 
> If you want me to rebuild with debug and get you any specific 
> information, let me know.

That'd be great.

Perhaps you can give these a shot:

http://sandeen.fedorapeople.org/test/xfsprogs-3.0.1-8.test1.x86_64.rpm
http://sandeen.fedorapeople.org/test/xfsprogs-debuginfo-3.0.1-8.test1.x86_64.rpm

(they're just rebuilt from fedora, no special sauce in there)

run with ulimit -c unlimited & gather a core dump for starters?

You could also try creating an xfs_metadump of the filesystem and see if
xfs_repair also segfaults on that; then perhaps you could provide the
metadump for analysis.

Thanks,
-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
