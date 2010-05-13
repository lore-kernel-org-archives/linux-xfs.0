Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4D7W5AP211534 for <xfs@oss.sgi.com>; Thu, 13 May 2010 02:32:05 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5FE5128D2C1
	for <xfs@oss.sgi.com>; Thu, 13 May 2010 00:34:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RCsXWhxVBLfAzm57 for
	<xfs@oss.sgi.com>; Thu, 13 May 2010 00:34:52 -0700 (PDT)
Date: Thu, 13 May 2010 16:33:13 +0900 (JST)
Message-Id: <20100513.163313.67205054690538917.yamato@redhat.com>
Subject: Re: [PATCH] fsfreeze: suspend and resume access to an filesystem
From: Masatake YAMATO <yamato@redhat.com>
In-Reply-To: <1194896399.685821273733580088.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
References: <1194896399.685821273733580088.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
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
To: util-linux-ng@vger.kernel.org
Cc: e2fsprogs-ext4@lists.sourceforge.net, xfs@oss.sgi.com, linux-cluster@redhat.com, htaira@redhat.com

Hi,

(The disscussion can be found at
 http://thread.gmane.org/gmane.linux.utilities.util-linux-ng/3181/focus=3193)

> Hello.
> 
> I understand reason when it use with device-mapper.
> I think, fsfreeze command need for filesystem on physical block device without device-mapper.
> For example, by storage controller based LUN snapshot.
> 
> # fsfreeze -f /data
> # ssh root@192.168.0.1 "take snapshot lun0"
> # fsfreeze -u /data
> 
> * /data is mounted physical block device(/dev/sdb1)

As Hajime wrote, taking snapshot in physical storage level is popular
situation. It seems that xfs_freeze can be used for the purpose but
the name `xfs_freeze' gives the impression that the command is only 
for xfs. 

My argument can be applicable to gfs2_tool, too.  "gfs2_tool freeze"
also does ``ioctl(fd, FIFREEZE, 0)''.


One of the solution is to add xxx_freeze for each file system implementation
which has freeze/unfreeze methods to eash util-xxx, xxx-progs or xxx-utils. 
e.g. Adding ext4_freeze or ext3_freeze command to e2fsprogs package.

However, I think this is not good idea. Linux provides file system neutral
interface already. So it is better to have file system neutral command(fsfreeze)
and the command is included in file system neutral package, util-linux-ng.

Masatake YAMATO

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
