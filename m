Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47AC77CA2
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2016 04:44:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 29A4E8F8040
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2016 02:44:10 -0800 (PST)
Received: from mail.stepping-stone.ch (mail.stepping-stone.ch
	[194.176.109.206]) by cuda.sgi.com with ESMTP id
	0wGtz40Ab1DgC9rj (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 30 Jan 2016 02:44:07 -0800 (PST)
Subject: Re: Random write result differences between RAID device and XFS
References: <56AB44AF.8020807@purplehaze.ch> <20160129222553.GK20456@dastard>
From: Christian Affolter <c.affolter@purplehaze.ch>
Message-ID: <56AC93EC.80202@purplehaze.ch>
Date: Sat, 30 Jan 2016 11:43:56 +0100
MIME-Version: 1.0
In-Reply-To: <20160129222553.GK20456@dastard>
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

Hi Dave,

On 29.01.2016 23:25, Dave Chinner wrote:
> On Fri, Jan 29, 2016 at 11:53:35AM +0100, Christian Affolter wrote:
>> Hi everyone,
>>
>> I'm trying to understand the differences of some bandwidth and IOPs test
>> results I see while running a random-write full-stripe-width aligned fio
>> test (using libaio with direct IO) on a hardware RAID 6 raw device
>> versus on the same device with the XFS file system on top of it.
>>
>> On the raw device I get:
>> write: io=24828MB, bw=423132KB/s, iops=137, runt= 60085msec
>>
>> With XFS on top of it:
>> write: io=14658MB, bw=249407KB/s, iops=81, runt= 60182msec
> 
> Now repeat with a file that is contiguously allocated before you
> start. And also perhaps with the "swalloc" mount option.

Wow, thanks! After specifying --fallocate=none (instead of the default
fallocate=posix), bandwidth and iops increases and are even higher than
on the raw device:

write: io=30720MB, bw=599232KB/s, iops=195, runt= 52496msec

I'm eager to learn what's going on behind the scenes, can you give a
short explanation?

Btw. mounting the volume with "swalloc" didn't make any change.


Thanks a lot!
Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
