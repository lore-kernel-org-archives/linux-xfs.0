Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0ON3Xb4104018 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 17:03:33 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id XoBb1qBKtOUCTHEc for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 15:03:32 -0800 (PST)
Message-ID: <4F1F38C3.9090409@sandeen.net>
Date: Tue, 24 Jan 2012 17:03:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: log recovery fails at mount
References: <20120124024340.GA6689@starfish.mcs.anl.gov>
	<4F1E3C71.1020303@sandeen.net>
	<20120124225840.GA20222@starfish.mcs.anl.gov>
In-Reply-To: <20120124225840.GA20222@starfish.mcs.anl.gov>
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
To: John Valdes <valdes@anl.gov>
Cc: xfs@oss.sgi.com

On 1/24/12 4:58 PM, John Valdes wrote:
> On Mon, Jan 23, 2012 at 11:06:57PM -0600, Eric Sandeen wrote:
>> try:
>>
>> # xfs_metadump /dev/md4 md4.metadump
>> # xfs_mdrestore md4.metadump md4.img
>> # xfs_repair -L md4.img
>>
>> that'll repair a metadata image and you can see how much it runs into.
> 
> Good suggestion.  Here's the result; looks innocuous:
> 

<snip reasonable looking repair output>

> 
> However, if I loopback mount the img file, the file/directory names in
> the mounted fs are mostly corrupted; that may be expected though since
> it's just a metadata dump/restore?
> 
>   prompt# mount -r -t xfs -o loop md4.img /mnt
>   prompt# ls /mnt
>   ??5?z+o??%F_4(?R?.wrhE*]  data  K?ckw?  T?o??n2o?,?0-|K#\o Z?w?9=ol\?7j??1T
> 
> Any other suggestions or comments before I let loose xfs_repair -L on
> the real filesystem?

that's because metadump obfuscates filenames by default.  There's an option
to keep them in the clear, and then you won't see all that garbage.

-Eric

> John
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
