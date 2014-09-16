Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3F32F7F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 17:03:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E5928F8039
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 15:03:10 -0700 (PDT)
Received: from autodiscover.rincon.com (smtp.rincon.com [67.128.198.140]) by
	cuda.sgi.com with ESMTP id j6yCIPIJEIFyLlRq for
	<xfs@oss.sgi.com>; Tue, 16 Sep 2014 15:03:09 -0700 (PDT)
Message-ID: <5418B39C.2060707@rincon.com>
Date: Tue, 16 Sep 2014 15:03:08 -0700
From: Brian Hemme <bmh@rincon.com>
MIME-Version: 1.0
Subject: mkfs.xfs fails with raid5 and smaller chunk sizes
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello all,

I am having some odd problems with mkfs.xfs when used on a raid 5 
array.  The array is built from 6 960GB SSDs all connected to SATA ports 
on the MB and created with mdadm.  If I use a chunk size any smaller 
then 512K mkfs.xfs just hangs forever.  It continues to use CPU and so 
does the raid array but never completes.  If the system is just left 
running for an extended length of time the whole OS eventually locks 
up.  I have tried this on three different systems with the same 
results.   I have searched all over for someone with similar issues 
without success.  I am hoping I am just doing something clearly wrong 
and you all can set me straight quickly.

Some specifics:
     Arch linux with 3.14.1 kernel
     mkfs.xfs version 3.1.11
     mdadm - v3.3 - 3rd September 2013

Commands:
 > mdadm --create /dev/md0 --chunk=64K --level=5 --raid-devices=6 
/dev/sd[a-f]
 > mkfs.xfs /dev/md0
   ** This command fails and locks up

I have tried specifying the arguments to mkfs.xfs with the same 
results.  Building a 4 drive array seems to require a chunk size of 1M 
or greater to work.  Same results if I make a partition on the array and 
make the fs there.

Any help would be appreciated
Thanks
Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
