Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8BJuJqe221979 for <xfs@oss.sgi.com>; Sat, 11 Sep 2010 14:56:19 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44B9F17DAE5A
	for <xfs@oss.sgi.com>; Sat, 11 Sep 2010 12:57:05 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id UgtRnQEuAtTizJ91
	for <xfs@oss.sgi.com>; Sat, 11 Sep 2010 12:57:05 -0700 (PDT)
Received: by ewy3 with SMTP id 3so2335213ewy.26
	for <xfs@oss.sgi.com>; Sat, 11 Sep 2010 12:57:05 -0700 (PDT)
Date: Sat, 11 Sep 2010 21:57:02 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: XFS defragmentation issue
Message-ID: <20100911195702.GB25185@teal.hq.k1024.org>
References: <4C8A4395.5070702@kickstone.com> <4C8B27E4.2050102@kickstone.com>
	<20100911082330.GG705@dastard> <4C8BDAC8.8010203@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C8BDAC8.8010203@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Sat, Sep 11, 2010 at 02:38:48PM -0500, Stan Hoeppner wrote:
> Dave Chinner put forth on 9/11/2010 3:23 AM:
> > On Sat, Sep 11, 2010 at 07:55:32AM +0100, John Lister wrote:
> >>  Stan Hoeppner wrote on 9/10/2010 14:00
> >>>> On 10/09/2010 15:41, John Lister wrote:
> >>> Try unmounting and remounting the filesystem, and see if the various
> >>> tools all report the same thing afterwards. This solved the exact same
> >>> problem for me very recently, though I'm on kernel 2.6.34.1 and xfsprogs
> >>> 2.9.8.
> >>
> >> Cheers, that got rid of most of it, there is still a slight
> >> discrepency  (50 extra fragments) which I can live with.
> > 
> > xfs_db used buffered IO on the block device, which is not coherent
> > with the filesystem. If you are using it on an active filesystem,
> > then running "echo 1 > /proc/sys/vm/drop_caches" before you run
> > xfs_db should make it read from disk at least once....

I wonder if xfs_db shouldn't use by default direct I/O, or at least take
a flag to allow it to do direct I/O only against the blocks it needs.
Dropping the entire caches on a big box is not nice :)

> That's good to know Dave.  Thanks.  I created a short-name script a
> while back with "echo 3 > /proc/sys/vm/drop_caches" merely so I could
> "clear the baffles" now and then.  Looks like it now has multiple uses
> (if I can just remember to use it in this context).
> 
> Out of curiosity, who here schedules automatic xfs_fsr runs, and with
> what frequency?  Currently I just run it manually now and then when
> performance starts to seem sluggish.

This is my setup, on a machine with multiple XFS filesystems:

$ cat /etc/cron.d/xfsfsr 
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

0   01  *   *   7   root    xfs_fsr -v

I've set it up a few years back and, except for a few rare bugs in 2.6.x
which are then fixed in 2.6.x.y, I've had no issues.

regards,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
