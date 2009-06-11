Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5BLl2wi172607 for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 16:47:02 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 713E33040E9
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 14:47:21 -0700 (PDT)
Message-Id: <8EE3C044-FB47-46BC-A06F-DA0EF65D8236@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A313F84.20900@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many processes
Date: Thu, 11 Jun 2009 14:02:53 -0500
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
	<alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>
	<4A313F84.20900@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org


On Jun 11, 2009, at 12:31 PM, Eric Sandeen wrote:

> Justin Piszcz wrote:
>>
>> On Thu, 11 Jun 2009, Justin Piszcz wrote:
>>
>>> Hello,
>>>
>>> I have a daily cron that backs up my root filesystem using  
>>> xfsdump, it has
>>> remain unchanged for at least 7-10 kernel versions.  When I  
>>> migrated to
>>> 2.6.30, when the xfsdump ran at its scheduled time, nearly all of my
>>> processes were killed due to an OOM situation, I can reproduce the  
>>> situation.
>>>
>>> Kernel: 2.6.30
>>> Dist: Debian Testing
>>> xfsdump: 2.2.48-1
>>
>> Kernel 2.6.29.4 does not exhibit this problem:
>>
>> xfsdump: estimated dump size: 8694781376 bytes
>> xfsdump: creating dump session media file 0 (media 0, file 0)
>> xfsdump: dumping ino map
>> xfsdump: dumping directories
>> xfsdump: dumping non-directory files
>> xfsdump: ending media file
>> xfsdump: media file size 8294709848 bytes
>> xfsdump: dump size (non-dir files) : 8208863560 bytes
>> xfsdump: dump complete: 102 seconds elapsed
>> xfsdump: Dump Status: SUCCESS
>>
>> XFS(?) bug in 2.6.30.
>
> Any chance for a bisect run? :)

Well, Hedi (@sgi) pointed out to the problem without
bisect :)

commit 28e211700a81b0a934b6c7a4b8e7dda843634d2f
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Feb 24 08:39:02 2009 -0500

    xfs: fix getbmap vs mmap deadlock


we do allocate memory for out

    out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx),  
KM_MAYFAIL);

but I am not seeing where it's being released.

If I am reading the code correctly we need to handle the freeing in
in out_unlock_iolock.

The following should fix it:

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 4b0f6ef..7928b99 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -6086,6 +6086,7 @@ xfs_getbmap(
                         break;
         }

+       kmem_free(out);
         return error;
  }


Felix

>
> Or, just as a thought, watch slabtop while you run the dump?
>
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
