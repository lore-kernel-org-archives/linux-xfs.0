Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAMGqdP4159180 for <xfs@oss.sgi.com>; Sun, 22 Nov 2009 10:52:39 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5DA6A4516
	for <xfs@oss.sgi.com>; Sun, 22 Nov 2009 08:53:03 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id PFmI2bYNXfFsfAnv for
	<xfs@oss.sgi.com>; Sun, 22 Nov 2009 08:53:03 -0800 (PST)
Message-ID: <4B096C6E.8010508@sandeen.net>
Date: Sun, 22 Nov 2009 10:53:02 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS support for ARMv5
References: <14274282.01258546868484.JavaMail.root@wombat>
	<4B041AEE.4040506@sandeen.net>
	<EE71107DF0D1F24FA2D95041E64AB9E8985A59F17F@IL-MB01.marvell.com>
In-Reply-To: <EE71107DF0D1F24FA2D95041E64AB9E8985A59F17F@IL-MB01.marvell.com>
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
To: Ofer Heifetz <oferh@marvell.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Ofer Heifetz wrote:
> Hi Eric,
> 
> I have tried the patch you advised and still get the same error using 2.6.31.6, xfs version 2.10.2 on Ubuntu 9.04.
> 
> Any other suggestions you think that might help me with this?

Please start by:

> when you get that error from mount, look at dmesg to see what really went wrong ...

because all I know now is "it didn't mount" which isn't much to go on.

-Eric

> -Ofer
> 
> -----Original Message-----
> From: Eric Sandeen [mailto:sandeen@sandeen.net] 
> Sent: Wednesday, November 18, 2009 6:04 PM
> To: Ofer Heifetz
> Cc: xfs@oss.sgi.com
> Subject: Re: XFS support for ARMv5
> 
> oferh@marvell.com wrote:
>> Hi,
>>
>> I have noticed that XFS on ARMv5TE with latest kernel (2.6.31.6)
>> fails to mount after copying some data and reboot the system.
>>
>> I get "mount: /dev/sda1: can't read superblock", I understand that
>> there were some problems with virtual aliasing that was added to XFS
>> some time ago but ARM arch has not dealt with this properly.
> 
> when you get that error from mount, look at dmesg to see what really went wrong ...
> 
>> Is there any patch for this bug?
> 
> This is a big-hammer approach for the aliasing problem:
> 
> Index: linux-2.6.25-rc1/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.25-rc1.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ linux-2.6.25-rc1/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1172,6 +1172,7 @@ _xfs_buf_ioapply(
>  		bio->bi_end_io = xfs_buf_bio_end_io;
>  		bio->bi_private = bp;
>  
> +		flush_dcache_page(bp->b_pages[0]);
>  		bio_add_page(bio, bp->b_pages[0], PAGE_CACHE_SIZE, 0);
>  		size = 0;
>  
> @@ -1198,6 +1199,7 @@ next_chunk:
>  		if (nbytes > size)
>  			nbytes = size;
>  
> +		flush_dcache_page(bp->b_pages[map_i]);
>  		rbytes = bio_add_page(bio, bp->b_pages[map_i], nbytes, offset);
>  		if (rbytes < nbytes)
>  			break;
> 
> 
>  
>> xfsprogs version used: 2.10.2
>>
>> -Ofer
>>
>> -- This message was sent on behalf of oferh@marvell.com at
>> openSubscriber.com 
>> http://www.opensubscriber.com/messages/xfs@oss.sgi.com/topic.html
>>
>> _______________________________________________ xfs mailing list 
>> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
