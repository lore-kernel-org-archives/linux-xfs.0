Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1RCGIvj054701 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 06:16:20 -0600
Received: from mail.bushveldgrain.co.za (mail.bushveldgrain.co.za
	[196.25.181.10]) by cuda.sgi.com with ESMTP id L3otADLXBq877fAP
	for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 04:16:12 -0800 (PST)
Received: from localhost (mail.bushveldgrain.co.za [127.0.0.1])
	by mail.bushveldgrain.co.za (Postfix) with ESMTP id 5FB2C660BE
	for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 14:16:10 +0200 (SAST)
Received: from mail.bushveldgrain.co.za ([127.0.0.1])
	by localhost (mail.bushveldgrain.co.za [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id EZTKE1Y4mkjW for <xfs@oss.sgi.com>;
	Mon, 27 Feb 2012 14:16:09 +0200 (SAST)
Received: from [196.1.1.163] (unknown [196.1.1.163])
	by mail.bushveldgrain.co.za (Postfix) with ESMTP id D10F16608D
	for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 14:16:08 +0200 (SAST)
Message-ID: <4F4B7408.8020706@waagmeester.co.za>
Date: Mon, 27 Feb 2012 14:16:08 +0200
From: Coert Waagmeester <lgroups@waagmeester.co.za>
MIME-Version: 1.0
Subject: Re: XFS status update for January 2012
References: <20120225120216.GA21721@infradead.org>
	<4F4B5CB3.8090107@cape-horn-eng.com>
In-Reply-To: <4F4B5CB3.8090107@cape-horn-eng.com>
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
Cc: xfs@oss.sgi.com

On 02/27/2012 12:36 PM, Richard Ems wrote:
> On 02/25/2012 01:02 PM, Christoph Hellwig wrote:
>> January saw the release of Linux 3.2, which as usual included a large
>> number of XFS changes, most notably an large speedup for removing files
>> that have external attribute blocks, speedups and livelock fixes for
>> sync while doing heavy I/O, and large internal cleanups of the inode
>> block map handling.  The diffstat for XFS in Linux 3.2 is:
>>
>>   54 files changed, 2414 insertions(+), 2625 deletions(-)
>>
>> which is slightly below the average of the last releases.
>>
>> In the meantime development for 3.3 went ahead full speed, including
>> the removal of the deprecated pre-delaylog logging code, various
>> quota cleanups, a shrink of the inode, a great simplification of the file
>> write path as well as the usual batch of fixes and cleanups.
>>
>> On the userland side xfs_repair saw various major fixes and speedups,
>> with few other fixes thrown in, while xfsdump got two commits fixing
>> longer standing issues recently reported on the mailing list.  For
>> xfstests January was an extremely slow month, seeing only two new test cases
>> and less than a handful of other updates.
>
> Many thanks to all of your for the good work and support on the mailing
> list !
>
> cheers,
> Richard
>
>

Hello Richard,

Here I am running gentoo with kernel 3.2
In the 2.6 era I always mounted my xfs file systems with the delaylog 
option, is this still necessary? Is delaylog now default?


Kind regards,
Coert Waagmeester

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
