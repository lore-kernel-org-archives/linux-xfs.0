Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04D007F54
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 15:32:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 830AEAC007
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 13:32:49 -0700 (PDT)
Received: from mail-lb0-f171.google.com (mail-lb0-f171.google.com
	[209.85.217.171]) by cuda.sgi.com with ESMTP id
	HUeOzXtPyIScxs1R (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 13:32:46 -0700 (PDT)
Received: by lbbpu9 with SMTP id pu9so107588572lbb.3
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 13:32:44 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 Aug 2015 13:32:44 -0700
Message-ID: <CABppvi6GdaTQgqpYJi6RhkpjP9ydTV8-2VV8LF9tHSN63XzWtA@mail.gmail.com>
Subject: Performance impact of mkfs.xfs vs mkfs.xfs -f
From: Shrinand Javadekar <shrinand@maginatics.com>
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
To: xfs@oss.sgi.com

Hi,

I have 23 disks formatted with XFS on a single server. The workload is
Openstack Swift. See this email from a few months ago about the
details:

http://oss.sgi.com/archives/xfs/2015-06/msg00108.html

I am observing some strange behavior and would like to get some
feedback about why this is happening.

I formatted the disks with xfs (mkfs.xfs) and deployed Openstack Swift
on it. Writing 100GB of data into Swift in batches of 20GB each gave
us the following throughput:

 20 GB: 93MB/s
 40 GB: 65MB/s
 60 GB: 52MB/s
 80 GB: 50MB/s
100 GB: 48MB/s

I then re-formatted the disks with mkfs.xfs -f and ran the experiment
again. This time I got the following throughput:

 20 GB: 118MB/s
 40 GB: 95MB/s
 60 GB: 74MB/s
 80 GB: 68MB/s
100 GB: 63MB/s

I've seen similar results twice.

Any ideas why this might be happening?

Thanks in advance.
-Shri

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
