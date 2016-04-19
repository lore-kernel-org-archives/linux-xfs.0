Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 539CD7CA0
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 06:30:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28E3E304039
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 04:30:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MCD3vOl71pWdOHay (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Apr 2016 04:30:41 -0700 (PDT)
Date: Tue, 19 Apr 2016 07:30:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [XFS] Any process to a particular XFS device hung in D state
	forever.
Message-ID: <20160419113038.GA2649@laptop.bfoster>
References: <CAJBkf_egQ1WdYHm5iRXCt4=CgraN4A=HfLvvsZxJEi7g4sUf5A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJBkf_egQ1WdYHm5iRXCt4=CgraN4A=HfLvvsZxJEi7g4sUf5A@mail.gmail.com>
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
To: Hugo Kuo <hugo@swiftstack.com>
Cc: Darrell Bishop <darrell@swiftstack.com>, xfs@oss.sgi.com

On Tue, Apr 19, 2016 at 05:56:19PM +0800, Hugo Kuo wrote:
> Hi XFS team,
> 
> We encountered a problem frequently in past three weeks. Our daemons store
> data to XFS partition associate with xattr.
> 
> Disk seems not responding since all processes to this disk in D state and
> can't be killed at all.
> 
>    - It happens on several disks. I feel it's randomly.
>    - Reboot seems solve the problem temporarily.
>    - All disks are multipath devices.
> 
> 
> I suspected that's an issue from disk corrupted at beginning. But smartctl
> doesn't show any clue about disk bad. And reboot makes the problem gone
> away.
> 
> 
>    - Any process to this disk is blocked. Even a simple $ls . Kernel log
>    <https://gist.github.com/HugoKuo/f87748786b26ea04fd9e1d86d9538293>

Looks like it's waiting on an AGF buffer. The buffer could be held by
something else, but we don't have enough information from that one
trace. Could you get all of the blocked tasks when in this state (e.g.,
"echo w > /proc/sysrq-trigger")?

>    - I tested the disk by read bytes on block via $dd . It works fine
>    without any error in dmesg.
>    - The `xfs_repair -n` output of a problematic mount point [xfs_repair -n]
>    <https://gist.github.com/HugoKuo/76f65bdc0b860ca6ed5e786f8c43da0e> . It
>    is still processing.

I presume this was run after a forced reboot..? If so, was the
filesystem remounted first to replay the log (xfs_repair -n doesn't
detect/warn about a dirty log, iirc). If the log was dirty, then repair
is a bit less interesting simply because some corruption is to be
expected in that scenario.

>    - Kernel : Linux node9 2.6.32-573.8.1.el6.x86_64 #1 SMP Tue Nov 10
>    18:01:38 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>    - OS : CentOS release 6.5 (Final)
>    - XFS : xfsprogs.x86_64         3.1.1-14.el6
> 
> 
> There's an interesting behaviour of $ls command.
> 
> * This is completed in 1sec. Very quick and give me the result in the
> test.d864 file $ls /srv/node/d864/tmp > test.d864
> * This is hanging $ls /srv/node/d864/tmp
> 

I'm not following you here. Are you missing an attachment (test.d864)?

Brian

> [image: Inline image 1]
> 
> I suspect there's something wrong with imap. Is there a known bug ?
> 
> Thanks // Hugo



> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
