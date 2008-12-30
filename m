Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBU4GLcd028687 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 22:16:21 -0600
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2050151208
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 20:16:20 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com
	[208.42.117.202]) by cuda.sgi.com with ESMTP id
	7Upa6OAEbJYwssy5 for <xfs@oss.sgi.com>;
	Mon, 29 Dec 2008 20:16:20 -0800 (PST)
Message-ID: <4959A08C.3030003@thebarn.com>
Date: Mon, 29 Dec 2008 22:16:12 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] directory offset overflows in 2.6.28
References: <20081229220745.GA12966@infradead.org>
	<20081230001117.GA5220@disturbed>
In-Reply-To: <20081230001117.GA5220@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, John Stanley <jpsinthemix@verizon.net>

Dave Chinner wrote:
> On Mon, Dec 29, 2008 at 05:07:45PM -0500, Christoph Hellwig wrote:
>   
>> The patch below is a dumb version of just putting back the masking,
>> to make sure we have the same behavior as in 2.6.27 and earlier.
>> I think we should at least hide it in a macro that is well-commented,
>> but I suspect we also need to make sure that we never ever get bigger
>> offsets in directories in some way.
>>     
>
> I think we need that macro sooner rather than later ;)
>
>   
>> Index: xfs/fs/xfs/xfs_dir2_block.c
>> ===================================================================
>> --- xfs.orig/fs/xfs/xfs_dir2_block.c	2008-12-29 21:25:29.680613664 +0100
>> +++ xfs/fs/xfs/xfs_dir2_block.c	2008-12-29 21:29:57.341627581 +0100
>> @@ -517,9 +517,9 @@ xfs_dir2_block_getdents(
>>  		/*
>>  		 * If it didn't fit, set the final offset to here & return.
>>  		 */
>> -		if (filldir(dirent, dep->name, dep->namelen, cook,
>> +		if (filldir(dirent, dep->name, dep->namelen, cook & 0x7fffffff,
>>  			    ino, DT_UNKNOWN)) {
>> -			*offset = cook;
>> +			*offset = cook & 0x7fffffff;
>>  			xfs_da_brelse(NULL, bp);
>>  			return 0;
>>  		}
>>     
>
> In this case, you can do the masking at the time cook is
> assigned. I haven't checked, but I suspect the rest will be the
> same. That will make the patch less invasive and with a macro
> somewhat cleaner...
>
> Cheers,
>
> Dave.
>   
I'm still sorting out the readdir changes in the FreeBSD port so I'm not 
exactly sure how this would
affect things there but I'm thinking FreeBSD does not have 32 bit 
readdir offset limits, so this change
might be another undo patch I would have to maintain.
So I agree, lets make this less invasive.

I've managed to change things at bit by passing an opaque ptr  
containing the  uuio struct into a freebsd "filldir" function  so my xfs 
changes so far
are minimal.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
