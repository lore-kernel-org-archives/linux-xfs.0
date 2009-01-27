Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0RDVG0A048231 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 07:31:17 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC1E1BD203
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 05:30:33 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id dciFllLW9OfPQTeF for
	<xfs@oss.sgi.com>; Tue, 27 Jan 2009 05:30:33 -0800 (PST)
Message-ID: <497F0C78.7060501@sandeen.net>
Date: Tue, 27 Jan 2009 07:30:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Strange fragmentation in nearly empty filesystem
References: <20090123102130.GB8012@doctronic.de>	<20090124003329.GE32390@disturbed>	<20090126075724.GA1753@doctronic.de>
	<497E02CD.2020000@sandeen.net>	<20090127071023.GA16511@doctronic.de>
	<20090127084034.GA16931@doctronic.de>
In-Reply-To: <20090127084034.GA16931@doctronic.de>
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
To: Carsten Oberscheid <oberscheid@doctronic.de>
Cc: xfs@oss.sgi.com

Carsten Oberscheid wrote:
> On Tue, Jan 27, 2009 at 08:10:23AM +0100, Carsten Oberscheid wrote:
>> I'll see what tests I can do and report back about the findings.
> 
> Just booted an Ubuntu live CD from October 2007 and mounted the
> filesystem in question. Could not run vmware from there easily, so I
> tried just a copy of the vmem file:

It'd be best to run vmware under some other kernel, and observe its
behavior, not just mount some existing filesystem and look at existing
files and do other non-vmware-related tests.

> 
> root@ubuntu# uname -a
> Linux tangchai 2.6.27-7-generic #1 SMP Tue Nov 4 19:33:06 UTC 2008 x86_64 GNU/Linux
> 
> root@ubuntu# xfs_bmap -vvp foo.vmem | grep hole | wc -l
> 34
> root@ubuntu# xfs_bmap -vvp foo.vmem | grep -v hole | wc -l
> 38
> 
> root@ubuntu# cp foo.vmem test
> 
> root@ubuntu# xfs_bmap -vvp test | grep hole | wc -l
> 27078
> root@ubuntu# xfs_bmap -vvp test | grep -v hole | wc -l
> 27081

You went from a file with 34 holes to one with 27k holes by copying it?
 Perhaps this is cp's sparse file detection in action, seeking over
swaths of zeros.
> 
> So a simple copy of a hardly fragmented vmem file gets very badly
> fragmented. If we assume the vmem file fragmentation to be caused by
> vmware writing this file inefficiently, does this mean that cp is even
> worse?

Perhaps, if by "worse" you mean "leaves holes for regions with zeros".
Try cp --sparse=never and see how that goes.

> For comparison, I created a new clean dummy file:
> 
> 
> root@ubuntu# dd if=/dev/zero of=ztest bs=1000 count=500000
> 500000+0 records in
> 500000+0 records out
> 500000000 bytes (500 MB) copied, 6.52903 seconds, 76.6 MB/s
> 
> root@ubuntu# xfs_bmap -vvp ztest | grep hole | wc -l 
> 0

of course, I'd hope you have no holes here ;)

> root@ubuntu# xfs_bmap -vvp ztest | grep -v hole | wc -l 
> 14
> 
> root@ubuntu# cp ztest ztest2
> 
> root@ubuntu# xfs_bmap -vvp ztest2 | grep hole | wc -l 
> 0
> 
> root@ubuntu# xfs_bmap -vvp ztest2 | grep -v hole | wc -l 
> 3
> 
> 
> No problem here. I repeated all this after rebooting my current
> kernel, with the same results. Copying the vmem file to an etx3
> filesystem gives about 1,700 extents, which is also bad, but not as
> bad as on the XFS disk.
> 
> While this test says nothing about the interaction of old/new kernel
> and old/new VMware, for me it raises some questions about
> file-specific properties affecting fragmentation which appear to be
> independent of recent kernel changes. Please bear with me if I miss
> something obvious, I'm just a user.

My best guess is that your cp test is making the file even more sparse
by detecting blocks full of zeros and seeking over them, leaving more
holes.  Not really related to vmware behavior, though.

-Eric

> Regards
> 
> 
> Carsten Oberscheid

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
