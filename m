Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AAF507F3F
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 18:01:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9998B8F804C
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 16:01:46 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4RLROkkvO5lGLoJh for <xfs@oss.sgi.com>;
	Sun, 15 Dec 2013 16:01:44 -0800 (PST)
Date: Mon, 16 Dec 2013 11:01:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS_REPAIR on LVM partition
Message-ID: <20131216000141.GU31386@dastard>
References: <CAG97raf61XGnTakrYjcfv9cjM6CTVdEEB3wQK+wOBvpowWO3Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAG97raf61XGnTakrYjcfv9cjM6CTVdEEB3wQK+wOBvpowWO3Cw@mail.gmail.com>
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
To: Rafael Weingartner <rafaelweingartner@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Dec 15, 2013 at 08:47:30PM -0200, Rafael Weingartner wrote:
> Hi folks,
> I am having some troubles with a XFS over one LVM partition. After an
> unexpected reboot, I am getting the following message when I try to mount
> it:
> *mount: Structure needs cleaning*

And the error in dmesg is?

> I tried "sudo xfs_check /dev/mapper/volume". Sadly, I got the message:
> xfs_check: cannot init perag data (117)

xfs_check is deprecated, please use "xfs_repair -n" instead.

> *ERROR: The filesystem has valuable metadata changes in a log which needs
> to*
> *be replayed.  Mount the filesystem to replay the log, and unmount it
> before*
> *re-running xfs_check.  If you are unable to mount the filesystem, then use*
> *the xfs_repair -L option to destroy the log and attempt a repair.*
> *Note that destroying the log may cause corruption -- please attempt a
> mount*
> *of the filesystem before doing this*
> 
> So, I tried:
> xfs_repair -L

Ok, so you went immediately for the big hammer. There's the
possibility that might not be able to recover your filesystem from
whatever went wrong now that the log has been zeroed.

> The command is running for over 3 hours and still just dots on my screen, I
> have no idea of what is happening. Any ideas how I can get it to work
> again? Or at least some work around that would enable me to extract the
> data that it contains.

I'm guessing it can't find or validate the primary superblock, so
it's looking for a secondary superblock. Please post the output of
the running repair so we can see exactly what it is doing.

Also we need more information about your problem - why did the
machine reboot? what's your storage configuration? You hardware,
etc.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> The server is a Ubuntu server 12.04.
> The XFS version is: xfs_info version 3.1.7
> If you need I can provide you with more info.

That's an old version of xfsprogs - you might want to start by
upgrading it to 3.11...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
