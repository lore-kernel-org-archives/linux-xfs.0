Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 34A3E7F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 23:20:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4C91AC007
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 21:20:23 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id VBvBZMZtuk8ViTFV
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 21:20:22 -0800 (PST)
Message-ID: <54780618.1000009@hardwarefreak.com>
Date: Thu, 27 Nov 2014 23:20:24 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: OS Upgrade Considerations For XFS Volume
References: <CANoQhnbjv08FVe0iRFff0fNMV7u7POY9kPtAhCbe_Vz=d8kPxg@mail.gmail.com>
In-Reply-To: <CANoQhnbjv08FVe0iRFff0fNMV7u7POY9kPtAhCbe_Vz=d8kPxg@mail.gmail.com>
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
To: Bharathiraja P <raja@where2getit.com>, xfs@oss.sgi.com

On 11/27/2014 08:29 AM, Bharathiraja P wrote:
> Hi there,
> 
> We recently upgraded our database system from OpenSuSE-11.4 to OpenSuSE-13.1
> 
> Post the upgrade we are noticing load spikes on our database system.
> 
> OpenSuSE 11.4 uses kernel-2.6.37 and OpenSuSE-13.1 uses kernel-3.11.10
> 
> There seems to be some changes related to XFS in new kernel and I'm
> getting this error when I run xfs_logprint

The two major XFS defaults changes here are:

1.  Delayed logging
2.  inode64 allocator

Read about each.  They should not be impacting performance of a DB
workload nor system load.

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
