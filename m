Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F97C7F7C
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 16:40:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5810A30407A
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 14:40:50 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 2GfKYlw5ChbX6Fbi
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 14:40:49 -0800 (PST)
Message-ID: <52E98373.4070301@hardwarefreak.com>
Date: Wed, 29 Jan 2014 16:40:51 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <1391005406-sup-1881@al.wesleyan.edu>
	<52E91923.4070706@sandeen.net>
In-Reply-To: <52E91923.4070706@sandeen.net>
Reply-To: stan@hardwarefreak.com
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
To: Eric Sandeen <sandeen@sandeen.net>, "C. Morgan Hamill" <chamill@wesleyan.edu>, xfs <xfs@oss.sgi.com>

On 1/29/2014 9:07 AM, Eric Sandeen wrote:
> On 1/29/14, 8:26 AM, C. Morgan Hamill wrote:
>> Howdy folks,
>>
>> I understand that XFS have stripe unit and width configured according to
>> the underlying RAID device when using LVM, but I was wondering if this
>> is still the case when a given XFS-formatted logical volume takes up
>> only part of the available space on the RAID.  In particular, I could
>> imagine that stripe width would need to be modified proportionally with
>> the decrease in filesystem size.  My intuition says that's false, but
>> I wanted to check with folks who know for sure.
> 
> The stripe unit and width are units of geometry of the underlying
> storage; a filesystem will span some number of stripe units, depending
> on its size.
> 
> So no, the filesystem's notion of stripe geometry does not change
> with the filesystem size.
> 
> You do want to make sure that stripe geometry is correct and aligned
> from top to bottom.

This is correct if indeed stripe alignment is beneficial to the
workload.  But not all workloads benefit from stripe alignment.  Some
may perform worse when XFS is stripe aligned to the underlying storage.

For instance, when a workload performs lots of allocations that are
significantly smaller than the RAID stripe width.  Here you end up with
a small file allocated at the start of each stripe and the rest of the
stripe left empty.  This can create an IO hot spot on the first one or
two drives in the array, and the others may sit idle.  This obviously
has a negative impact on throughput with such a workload.

Thus for a workload that performs lots of predominantly small
allocations, it is best to not align during mkfs.xfs with hardware RAID
that doesn't provide geometry to Linux.  If the underlying storage
device does do so, or if it is is a striped md/RAID device, you will
want to manually specify 4K alignment, as mkfs.xfs will auto align to md
geometry.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
