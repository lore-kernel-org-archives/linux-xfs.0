Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UEBh9h198043 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 09:11:53 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9ABD61D4968
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 07:11:19 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id kK0wsvx9ymr2IOLg for
	<xfs@oss.sgi.com>; Mon, 30 Mar 2009 07:11:19 -0700 (PDT)
Message-ID: <49D0D306.5040204@sandeen.net>
Date: Mon, 30 Mar 2009 09:11:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_freeze -f misbehaving under lenny / xfsprogs 2.9.8
References: <49D09F2C.8060406@decisionsoft.co.uk>
	<49D0CCEB.1000404@sandeen.net>
	<49D0D01A.8090608@decisionsoft.co.uk>
In-Reply-To: <49D0D01A.8090608@decisionsoft.co.uk>
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
To: strr-debian@decisionsoft.co.uk
Cc: xfs@oss.sgi.com

Stuart Rowan wrote:
> Eric Sandeen wrote, on 30/03/09 14:45:
>> Stuart Rowan wrote:
>>> Hi,
>>>
>>> We have a backup script running on another machine that ssh's in to the 
>>> affected server and does the following:
>>> mkdir -p /tmp/foo;
>>> /usr/sbin/xfs_freeze -f /home;
>>> /sbin/lvcreate -s -L 20G -n snap-shot home ;
>>> /usr/sbin/xfs_freeze -u /home;
>>> mount -o nouuid,ro /dev/data/snap-shot /tmp/foo;
>>>
>>> It then rsyncs (over ssh) the data to the backup store from /tmp/foo
>>>
>>> The above command set hangs at running "/sbin/lvcreate -s -L 20G -n 
>>> snap-shot home;"
>>>
>>> All I/O to /home is of course blocked at this point so for example exim 
>>> starts queueing up all the mail.
>>
>> lvcreate now does the fs freeze on its own via the snapshot ioctl, so if
>> you run freeze manually first, you are stuck behind that first freeze.
>>
>> Just drop the xfs_freeze's from the above, and all should be well.
>>
>> -Eric
> Eric,
> 
> Many thanks for your prompt reply and explanation :-)
> 
> It's good to know that there's an easy solution ... except we now have to 
> differentiate the commands to run in the backup script based on the version 
> of lvm on the remote system :-$

can't be *that* bad ... ;)

> OOI when implementing the freeze ioctl, what made the developers decide 
> that a freeze can't succeed on an already frozen filesystem ... you'd 
> expect it to just be a no-op really?

To complicate matters more, on newer upstream kernels w/ the freeze
ioctl exposed for all filesystems, nested freezes are in fact supported.

I'm not sure why sequential freezes were serialized initially, TBH...

-Eric

> Cheers,
> Stu.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
