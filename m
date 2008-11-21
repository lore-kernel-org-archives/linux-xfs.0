Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALLWAg4011082 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 15:32:11 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4603B15BFB4D
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 13:32:09 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id pp2QZyp1B0F4FZQs for <xfs@oss.sgi.com>;
	Fri, 21 Nov 2008 13:32:09 -0800 (PST)
Message-ID: <492725C0.2070302@sandeen.net>
Date: Fri, 21 Nov 2008 15:18:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] clean up printk formats with DMAPI_DEBUG
References: <49031BB1.7080609@sandeen.net>
	<20081025202005.GC28002@infradead.org>
	<49038127.8010608@sandeen.net>
In-Reply-To: <49038127.8010608@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:

> Christoph Hellwig wrote:
>   
>> On Sat, Oct 25, 2008 at 08:14:25AM -0500, Eric Sandeen wrote:
>>     
>>>  #ifdef CONFIG_DMAPI_DEBUG
>>> -	printk("xfs_dm_round_hole: off %lu, len %ld, align %lu, "
>>> -	       "filesize %llu, roff %ld, rlen %ld\n",
>>> +	printk("xfs_dm_round_hole: off %lld, len %llu, align %llu, "
>>> +	       "filesize %lld, roff %lld, rlen %llu\n",
>>>  	       offset, length, align, filesize, *roff, *rlen);
>>>       
>> We'd still need casts to (unsigned) long long because the 64 bit
>> types may be either variant on 64 bit platforms.
>>     
> Ah crud you're right, I forgot that s64 was sometimes just a "long"
>
> Bah; is there no format that does this cleanly? :)
>
> -Eric
>   

Fix up warnings when building with DMAPI_DEBUG

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
--

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
@@ -2334,9 +2334,11 @@ xfs_dm_round_hole(
 			return -EINVAL; /* requested length is too small */
 	}
 #ifdef CONFIG_DMAPI_DEBUG
-	printk("xfs_dm_round_hole: off %lu, len %ld, align %lu, "
-	       "filesize %llu, roff %ld, rlen %ld\n",
-	       offset, length, align, filesize, *roff, *rlen);
+	printk("xfs_dm_round_hole: off %lld, len %llu, align %llu, "
+	       "filesize %lld, roff %lld, rlen %llu\n",
+	       (long long)offset, (unsigned long long)length,
+	       (unsigned long long)align, filesize, (long long)*roff,
+	       (unsigned long long)*rlen);
 #endif
 	return 0; /* hole geometry successfully rounded */
 }
@@ -2467,8 +2469,9 @@ xfs_dm_punch_hole(
 	}
 
 #ifdef CONFIG_DMAPI_DEBUG
-	printk("xfs_dm_punch_hole: off %lu, len %ld, align %lu\n",
-		off, len, align);
+	printk("xfs_dm_punch_hole: off %lld, len %llu, align %llu\n",
+		(long long)off, (unsigned long long)len,
+		(unsigned long long)align);
 #endif
 
 	error = xfs_change_file_space(ip, XFS_IOC_UNRESVSP, &bf,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
