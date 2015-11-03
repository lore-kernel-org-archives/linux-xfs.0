Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ECEB27FCD
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 13:32:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 71244AC002
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 11:32:20 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[194.177.153.153]) by cuda.sgi.com with ESMTP id
	2UK82EkayX2gnIoe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 11:32:18 -0800 (PST)
Subject: Re: Is it possible to change sunit of log section post-mkfs
References: <5638A62D.1020802@dermichi.com> <20151103191132.GD19199@dastard>
From: Michael Weissenbacher <mw@dermichi.com>
Message-ID: <56390BBE.6030102@dermichi.com>
Date: Tue, 3 Nov 2015 20:32:14 +0100
MIME-Version: 1.0
In-Reply-To: <20151103191132.GD19199@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave!

>>
>> What i want to achieve is to set the log sunit to the maximum possible
>> of 64 blks (=256KiB).
On 2015-11-03 20:11, Dave Chinner wrote:
> 
> Why? Is there a performance problem with the default setting?
> 
I am seeing very bad performance of "rm" on this file system. Of course
I know that RAID-6 is kind of a worst case setup for that workload. But
I was hoping that aligning the log correctly plus increasing the stripe
size would help. Wouldn't the file system write more of the log at once
with a bigger sunit size; resulting in fewer RMW cycles?

I am already using delaylog, inode64, nobarrier to mount the fs;
lazy-count=1.

Maybe moving to an external log would be the best option?

tia,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
