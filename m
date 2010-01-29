Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0THBUMH131992
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 11:11:30 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A7D61C8E4C7
	for <linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 09:12:35 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id TAOaBtuv3hwdRzaU for
	<linux-xfs@oss.sgi.com>; Fri, 29 Jan 2010 09:12:35 -0800 (PST)
Message-ID: <4B631704.8080902@sandeen.net>
Date: Fri, 29 Jan 2010 11:12:36 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Filesystem corrupted: "Sorry, could not find valid secondary
	superblock"
References: <hjus58$6oi$1@ger.gmane.org> <4B63010D.1080608@sandeen.net>
	<hjv12n$r2o$1@ger.gmane.org>
In-Reply-To: <hjv12n$r2o$1@ger.gmane.org>
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
To: Nicolas Stransky <nico@stransky.cx>
Cc: linux-xfs@oss.sgi.com

Nicolas Stransky wrote:
> On 1/29/10 10:38 AM, Eric Sandeen wrote:
>> xfs_repair needs to be smarter about this; I at least wish it'd say 
>> -why- the candidate was not valid.
>>
>> Can you include the whole repair output?  Then maybe we can direct 
>> you to some xfs_db jujitsu to examine the fs.
>>
>> Trying newer xfsprogs would not be a -bad- idea...
>>
>> -Eric
> 
> The output is as follows:
> 
> # xfs_repair /dev/sda
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!

xfs_db /dev/sda
xfs_db> sb 0
xfs_db> p

might be interesting to see what's there.

-Eric

> attempting to find secondary superblock...
> ......................
> found candidate secondary superblock...
> unable to verify superblock, continuing...
> ......................
> found candidate secondary superblock...
> unable to verify superblock, continuing...
> ......................
> [The previous one repeats hundreds of times over many hours]
> ......................
> Sorry, could not find valid secondary superblock
> Exiting now.
> 
> 
> I am trying right now xfsprogs 3.1.0 from Debian testing, will see what
> it gives...
> 
> Thanks!
> NS
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
