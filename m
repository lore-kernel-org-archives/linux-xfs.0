Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5UL1QFv229784 for <xfs@oss.sgi.com>; Tue, 30 Jun 2009 16:01:26 -0500
Received: from ssec.wisc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43FE2333803
	for <xfs@oss.sgi.com>; Tue, 30 Jun 2009 14:01:57 -0700 (PDT)
Received: from ssec.wisc.edu (mahogany.ssec.wisc.edu [128.104.110.2]) by
	cuda.sgi.com with ESMTP id jGvOByBtD6pp0rvS for
	<xfs@oss.sgi.com>; Tue, 30 Jun 2009 14:01:57 -0700 (PDT)
Message-ID: <4A4A7D44.7040009@ssec.wisc.edu>
Date: Tue, 30 Jun 2009 16:01:56 -0500
From: Jesse Stroik <jstroik@ssec.wisc.edu>
MIME-Version: 1.0
Subject: Re: Seg fault during xfs repair (segmentation fault / segv)
References: <4A4A596D.8030800@ssec.wisc.edu> <4A4A5C4E.7030605@sandeen.net>
In-Reply-To: <4A4A5C4E.7030605@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric,

Eric Sandeen wrote:
> Jesse Stroik wrote:
>> I have a server with a ~20TB xfs file system on Linux 
>> (2.6.18-92.1.22.el5) and am running xfsprogs-2.9.4-4.el5.  We had a few 
>> corrupted files which I believe were due to a SCSI issue after a recent 
>> power outage.  Due to the corruption, I ran xfs_check and would like to 
>> run xfs_repair on the system.
> 
> It'd really be great to test more recent xfsprogs first, that one is
> about 2 years old.
> 
> You can probably grab any recent fedora src.rpm and rebuild it, and
> later go back to the centos version if you wish.


I fetched the current version from SVN using these directions: 
http://xfs.org/index.php/Getting_the_latest_source_code

I get identical results.

--------
...
reset bad sb for ag 31
reset bad agf for ag 31
reset bad agi for ag 31
Segmentation fault

$ ./xfs_repair -V
xfs_repair version 3.0.2
--------

If you want me to rebuild with debug and get you any specific 
information, let me know.

Best,
Jesse

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
