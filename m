Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4DEq0ZX231470 for <xfs@oss.sgi.com>; Thu, 13 May 2010 09:52:01 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA35333DB88
	for <xfs@oss.sgi.com>; Thu, 13 May 2010 07:54:13 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id RFZlsnnox3aYOJjD for
	<xfs@oss.sgi.com>; Thu, 13 May 2010 07:54:13 -0700 (PDT)
Message-ID: <4BEC1294.2000904@sandeen.net>
Date: Thu, 13 May 2010 09:54:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fsfreeze: suspend and resume access to an filesystem
References: <1194896399.685821273733580088.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<20100513.163313.67205054690538917.yamato@redhat.com>
In-Reply-To: <20100513.163313.67205054690538917.yamato@redhat.com>
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
To: Masatake YAMATO <yamato@redhat.com>
Cc: e2fsprogs-ext4@lists.sourceforge.net, util-linux-ng@vger.kernel.org, linux-cluster@redhat.com, htaira@redhat.com, xfs@oss.sgi.com

Masatake YAMATO wrote:
> Hi,
> 
> (The disscussion can be found at
>  http://thread.gmane.org/gmane.linux.utilities.util-linux-ng/3181/focus=3193)
> 
>> Hello.
>>
>> I understand reason when it use with device-mapper.
>> I think, fsfreeze command need for filesystem on physical block device without device-mapper.
>> For example, by storage controller based LUN snapshot.
>>
>> # fsfreeze -f /data
>> # ssh root@192.168.0.1 "take snapshot lun0"
>> # fsfreeze -u /data
>>
>> * /data is mounted physical block device(/dev/sdb1)
> 
> As Hajime wrote, taking snapshot in physical storage level is popular
> situation. It seems that xfs_freeze can be used for the purpose but
> the name `xfs_freeze' gives the impression that the command is only 
> for xfs. 
> 
> My argument can be applicable to gfs2_tool, too.  "gfs2_tool freeze"
> also does ``ioctl(fd, FIFREEZE, 0)''.
> 
> 
> One of the solution is to add xxx_freeze for each file system implementation
> which has freeze/unfreeze methods to eash util-xxx, xxx-progs or xxx-utils. 
> e.g. Adding ext4_freeze or ext3_freeze command to e2fsprogs package.
> 
> However, I think this is not good idea. Linux provides file system neutral
> interface already. So it is better to have file system neutral command(fsfreeze)
> and the command is included in file system neutral package, util-linux-ng.

I tend to agree, since there is a common interface, there is no reason to
have filesystem-specific tools which all do the same thing.

Note that xfs_freeze existed long before the common interface, and in fact
the common ioctl number was chosen based on the xfs number, so that explains
the existence of the xfs-specific tool, and why it does happen to work
now on non-xfs filesystems....

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
