Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB6CJQZi239796 for <xfs@oss.sgi.com>; Mon, 6 Dec 2010 06:19:26 -0600
Received: from mx2.isti.cnr.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADAC51C9397
	for <xfs@oss.sgi.com>; Mon,  6 Dec 2010 04:21:11 -0800 (PST)
Received: from mx2.isti.cnr.it (mx2.isti.cnr.it [194.119.192.4]) by
	cuda.sgi.com with ESMTP id N6wdpLr4AeKLLJZB for
	<xfs@oss.sgi.com>; Mon, 06 Dec 2010 04:21:11 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NV3O6KBVIOLS8X2Z@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Mon, 06 Dec 2010 13:20:00 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NV3O6JBJIOLVX0OJ@mx.isti.cnr.it> for xfs@oss.sgi.com; Mon,
	06 Dec 2010 13:19:55 +0100 (MET)
Date: Mon, 06 Dec 2010 13:20:02 +0100
From: Spelic <spelic@shiftmail.org>
Subject: NFS corruption on ENOSPC (was: Re: Bugs in mkfs.xfs, device mapper,
	xfs, and /dev/ram)
In-reply-to: <20101206040940.GA16103@dastard>
Message-id: <4CFCD4F2.10300@shiftmail.org>
MIME-version: 1.0
References: <4CF7A539.1050206@shiftmail.org> <4CF7A9CF.2020904@shiftmail.org>
	<20101202230743.GZ16922@dastard> <4CF8F9BE.6000604@shiftmail.org>
	<20101206040940.GA16103@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nfs@vger.kernel.org, linux-lvm@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 12/06/2010 05:09 AM, Dave Chinner wrote:
>> [Files become sparse at nfs-server-side upon hitting ENOSPC if NFS client uses local writeback caching]
>>
>>
>> It's nice that the NFS server does local writeback caching but it
>> should also cache the filesystem's free space (and check it
>> periodically, since nfs-server is presumably not the only process
>> writing in that filesystem) so that it doesn't accept more data than
>> it can really write. Alternatively, when free space drops below 1GB
>> (or a reasonable size based on network speed), nfs-server should
>> turn off filesystem writeback caching.
>>      
> This isn't a NFS server problem, or one that canbe worked around at
> the server. it's a NFS _client_ problem in that it does not get
> synchronous ENOSPC errors when using writeback caching. There is no
> way for the NFS client to know the server is near ENOSPC conditions
> prior to writing the data to the server as clients operate
> independently.
>
> If you really want your NFS clients to behave correctly when the
> server goes ENOSPC, turn off writeback caching at the client side,
> not the server (i.e. use sync mounts on the client side).
> Write performance will suck, but if you want sane ENOSPC behaviour...
>
>    

[adding NFS ML in cc]

Thank you for your very clear explanation.

Going without writeback cache is a problem (write performance sucks as 
you say), but guaranteeing to never reach ENOSPC also is hardly 
feasible, especially if humans are logged at client side and they are 
doing "whatever they want".

I would suggest that either be the NFS client to do polling to see if 
it's near an ENOSPC and if yes disable writeback caching, or be the 
server to do the polling and if it finds out it's near-ENOSPC condition 
it sends a specific message to clients to warn them so that they can 
disable caching.

Performed at client side wouldn't change the NFS protocol and can be 
good enough if one can specify how often freespace should be polled and 
what is the freespace threshold. Or with just one value: specify what is 
the max speed at which server disk can fill (next polling period can be 
inferred from current free space), and maybe also specify a minimum 
polling period (just in case).

Regarding the last part of the email, perhaps I was not clear:


> .....
>    
>> Holes in a random file!
>> This is data corruption, and nobody is notified of this data
>> corruption: no error at client side or server side!
>> Is it good semantics? How could client get notified of this? Some
>> kind of fsync maybe?
>>      
> Use wireshark to determine if the server sends an ENOSPC to the
> client when the first background write fails. I bet it does and that
> your dd write failed with ENOSPC, too. Something stopped it writing
> at 1.9GB....
>    

No, in that case I had written 15x100MB which was more than the 
available space but less than available+writeback_cache.
So "cat" ended by itself and never got an ENOSPC error but data never 
reached the disk at the other side.

However today I found that by using fsync, the problem is fortunately 
detected:

# time cat randfile{001..015} | pv -b | dd conv=fsync 
of=/mnt/nfsram/randfile
1.46GB
dd: fsync failed for `/mnt/nfsram/randfile': Input/output error
3072000+0 records in
3072000+0 records out
1572864000 bytes (1.6 GB) copied, 20.9101 s, 75.2 MB/s

real    0m21.364s
user    0m0.470s
sys     0m11.440s


so ok I understand that processes needing guarantees on written data 
should use fsync/fdatasync (which is good practice also for a local 
filesystem actually...)

Thank you

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
