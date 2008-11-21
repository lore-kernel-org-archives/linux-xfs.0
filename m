Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP
	id mAL0xVCn010736
	for <xfs@oss.sgi.com>; Thu, 20 Nov 2008 18:59:32 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by netops-testserver-3.corp.sgi.com (Postfix) with SMTP id 5B34090898
	for <xfs@oss.sgi.com>; Thu, 20 Nov 2008 16:59:27 -0800 (PST)
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com
	[134.14.55.58]) by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA28532 for
	<xfs@oss.sgi.com>; Fri, 21 Nov 2008 11:59:25 +1100
Date: Fri, 21 Nov 2008 12:03:36 +1100
Subject: Re: [PATCH V2] xfs_repair: print superblock offsets and why they
	can't	be verified
From: "Barry Naujok" <bnaujok@sgi.com>
MIME-Version: 1.0
References: <20081022183636.GE20550@kyra> <20081022234128.GC4395@kyra>
	<490081C6.1030301@sandeen.net>
Message-ID: <op.ukx2ka0p3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <490081C6.1030301@sandeen.net>
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
To: xfs@oss.sgi.com

On Fri, 24 Oct 2008 00:53:10 +1100, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> KELEMEN Peter wrote:
>> Eric has pointed out that verify_set_primary_sb() will either
>> return 1 or XR_INSUFF_SEC_SB.  Move the check lower into
>> verify_set_primary_sb() by checking the return value of
>> verify_sb().  Example output:
>>
>> found candidate secondary superblock...
>> verifying sb at 31249334272: bad magic number (1)
>> verifying sb at 62498668544: bad magic number (1)
>> verifying sb at 93748002816: bad magic number (1)
>> verifying sb at 124997337088: bad magic number (1)
>> unable to verify superblock, continuing...
>>
>
> This looks better :)  You may want to add even more info...
>
> while it's just searching block by block, if it finds a candidate, I'd
> print the sector offset for that candidate (your first output line).
>
> And rather than "verifying sb at..." you might do something like
> "comparing to sb N at offset X":
>
> +	} else {
> +		do_warn("comparing with sb %d at sector %Lu failed: %s (%d)\n",
> +			agno, off, err_string(reason), reason);
>
> because at this point it's using the geometry of the candidate sb to see
> if it can be used to find enough other valid sb's....

Do I check in the patch as is or will there be an update?

Regards,
Barry.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
