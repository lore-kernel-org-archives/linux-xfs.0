Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 638A57F75
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 20:41:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3AA008F804B
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 18:41:02 -0700 (PDT)
Received: from mail-gh0-f178.google.com (mail-gh0-f178.google.com
	[209.85.160.178]) by cuda.sgi.com with ESMTP id
	FRo0Qeyj2iAoO4vZ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 18:41:01 -0700 (PDT)
Received: by mail-gh0-f178.google.com with SMTP id g15so814423ghb.37
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 18:41:00 -0700 (PDT)
Message-ID: <51B9231F.9050707@gmail.com>
Date: Wed, 12 Jun 2013 21:40:47 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfs: fix implicit padding in directory and attr CRC
	formats
References: <1371003548-4026-1-git-send-email-david@fromorbit.com>
	<1371003548-4026-3-git-send-email-david@fromorbit.com>
	<20130613005819.GW20932@sgi.com>
In-Reply-To: <20130613005819.GW20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 06/12/2013 08:58 PM, Ben Myers wrote:
> On Wed, Jun 12, 2013 at 12:19:07PM +1000, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Michael L. Semon has been testing CRC patches ona 32 bit system and
> 						on a
> 
>> been seeing assert failures in the directory code from xfs/080.
>> Thanks to Michael's heroic efforts with printk debugging, we found
>> that the problem was that the last free space being left in the
>> directory structure was too small to fit a unused tag structure and
>> it was being corrupted and attempting to log a region out of bounds.
>> Hence the assert failure looked something like:
>>
>> .....
>> #5 calling xfs_dir2_data_log_unused() 36 32
>> #1 4092 4095 4096
>> #2 8182 8183 4096
>      first? 
>           last?
>                bp->b_length?

           BBTOB(bp->b_length)

This is all terrible numbering on my part...

>> #1 4092 4095 4096
>> #2 8182 8183 4096

xfs_dir2_data_log_unused() calls xfs_trans_log_buf() twice in the same 
function.  #1 is the first call, #2 is the second call, and there's no 
running count.  The printk() is a copy-and-paste of those two function 
calls plus a BBTOB(bp->b_length) below it.

>> #5 calling xfs_dir2_data_log_unused() 36 32

The #5 was caused by numbering all the calls to 
xfs_dir2_data_log_unused() to see if one code path was being called 
every time.  #5 is in the xfs_dir2_data_use_free() function, starting 
with this else-if...

        else if (matchfront) {
                newdup = (xfs_dir2_data_unused_t *)((char *)hdr + offset + len);
                newdup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
                newdup->length = cpu_to_be16(oldlen - len);
                *xfs_dir2_data_unused_tag_p(newdup) =
                        cpu_to_be16((char *)newdup - (char *)hdr);
                printk( KERN_INFO "#5 calling xfs_dir2_data_log_unused() %d %d\n", oldlen, len );
                xfs_dir2_data_log_unused(tp, bp, newdup);

Sorry about that!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
