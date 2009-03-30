Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UDxJJn197621 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 08:59:29 -0500
Received: from knox.decisionsoft.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FC5D13DB7B0
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 06:59:38 -0700 (PDT)
Received: from knox.decisionsoft.com (knox-be.decisionsoft.com
	[87.194.172.100]) by cuda.sgi.com with ESMTP id
	3janRbkOKqh8riHI for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2009 06:59:38 -0700 (PDT)
Message-ID: <49D0D01A.8090608@decisionsoft.co.uk>
Date: Mon, 30 Mar 2009 14:58:50 +0100
From: Stuart Rowan <strr-debian@decisionsoft.co.uk>
MIME-Version: 1.0
Subject: Re: xfs_freeze -f misbehaving under lenny / xfsprogs 2.9.8
References: <49D09F2C.8060406@decisionsoft.co.uk>
	<49D0CCEB.1000404@sandeen.net>
In-Reply-To: <49D0CCEB.1000404@sandeen.net>
Reply-To: strr-debian@decisionsoft.co.uk
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

Eric Sandeen wrote, on 30/03/09 14:45:
> Stuart Rowan wrote:
>> Hi,
>>
>> We have a backup script running on another machine that ssh's in to the 
>> affected server and does the following:
>> mkdir -p /tmp/foo;
>> /usr/sbin/xfs_freeze -f /home;
>> /sbin/lvcreate -s -L 20G -n snap-shot home ;
>> /usr/sbin/xfs_freeze -u /home;
>> mount -o nouuid,ro /dev/data/snap-shot /tmp/foo;
>>
>> It then rsyncs (over ssh) the data to the backup store from /tmp/foo
>>
>> The above command set hangs at running "/sbin/lvcreate -s -L 20G -n 
>> snap-shot home;"
>>
>> All I/O to /home is of course blocked at this point so for example exim 
>> starts queueing up all the mail.
> 
> 
> lvcreate now does the fs freeze on its own via the snapshot ioctl, so if
> you run freeze manually first, you are stuck behind that first freeze.
> 
> Just drop the xfs_freeze's from the above, and all should be well.
> 
> -Eric
Eric,

Many thanks for your prompt reply and explanation :-)

It's good to know that there's an easy solution ... except we now have to 
differentiate the commands to run in the backup script based on the version 
of lvm on the remote system :-$

OOI when implementing the freeze ioctl, what made the developers decide 
that a freeze can't succeed on an already frozen filesystem ... you'd 
expect it to just be a no-op really?

Cheers,
Stu.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
