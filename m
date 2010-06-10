Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5AKixaX094860 for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 15:44:59 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F000F3BC627
	for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 13:43:45 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id SRn3NvjpVHmba57b for
	<xfs@oss.sgi.com>; Thu, 10 Jun 2010 13:43:45 -0700 (PDT)
Message-ID: <4C114E80.4050803@sandeen.net>
Date: Thu, 10 Jun 2010 15:43:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
References: <1274710459-11446-1-git-send-email-jack@suse.cz>	<1274710459-11446-5-git-send-email-jack@suse.cz>	<4C0FD43D.3040803@sandeen.net>	<20100610105813.GB10827@quack.suse.cz>
	<4C1117F3.2010008@sandeen.net>
In-Reply-To: <4C1117F3.2010008@sandeen.net>
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
To: Jan Kara <jack@suse.cz>
Cc: hch@infradead.org, xfs@oss.sgi.com

Eric Sandeen wrote:
> Jan Kara wrote:
>> On Wed 09-06-10 12:49:49, Eric Sandeen wrote:
>>> Jan Kara wrote:
>>>> Run fsx (and also several fsx threads in parallel) and verify that
>>>> quota accounting is correct after they finish.
>>> Jan, I'm having trouble with this one on XFS for some reason, with our 
>>> RHEL6 kernel and quota-3.17...

These don't seem to be working properly at all with xfs.

In quota-3.17, quotaoff seems to turn off both accounting and enforcement,
despite what the man page says - 

       To turn off quota limit enforcement on any XFS filesystem, first make sure
       that quota accounting and enforcement are both turned on using repquota -v
       filesystem.   Then,  use  quotaoff -v filesystem to disable limit enforce-
       ment.  This may be done while the filesystem is mounted.

And once accounting is turned off, it can't be re-enabled without a remount.

With quota-4.0.0-preX, it seems to turn off -neither- accounting nor enforcement,
based on hch's test:

[14:59]  <hch> qemu1:~/xfstests-dev# mount -o quota /dev/vdb5 /mnt/test
[14:59]  <hch> qemu1:~/xfstests-dev# quotaon -f /dev/vdb5
[15:00]  <hch> qemu1:~/xfstests-dev# quotaon /dev/vdb5
[15:00]  <hch> quotaon: Enable XFS group quota accounting during mount
[15:00]  <hch> quotaon: Enforcing user quota already on /dev/vdb5
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Argh ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
