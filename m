Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6DEXTQH053477 for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 09:33:29 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B9DF10A1CBC
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 07:41:31 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id CMI6BbFpvm82E4Vn for
	<xfs@oss.sgi.com>; Mon, 13 Jul 2009 07:41:31 -0700 (PDT)
Message-ID: <4A5B45DC.5070408@sandeen.net>
Date: Mon, 13 Jul 2009 09:34:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs_repair - clear inodes in incorrect btree format
References: <4A582070.9040907@sandeen.net>
	<bzytz1hq65t.fsf@fransum.emea.sgi.com>
In-Reply-To: <bzytz1hq65t.fsf@fransum.emea.sgi.com>
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
To: Olaf Weber <olaf@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Olaf Weber wrote:
> Eric Sandeen writes:
> 
> [...]
> 
>> But questions remain...
> 
>> 1) How'd it get into this state? ... but maybe more importantly...
>> 2) Should these really get cleared?  It's possibly a sane extent list,
>> it's just that it -could- be in extents rather than btree format...
>> 3) By the same token, should the kernel really be choking on it?
> 
> It is not clear to me yet how you could get into this state, but this
> is clearly an invariant the kernel actively maintains.
> 
> If the kernel "just" missed the underflow and kept the extents in
> btree format, then I don't see an apriori reason why the extent list
> as such would be invalid (as opposed to inefficiently stored).  If
> that's the primary model for getting into this state, then the file
> contents can be rescued and kernel-side the event should be
> survivable.
> 
> But if the kernel tried to convert, failed, and didn't properly detect
> failure...  Without having a good answer for (1) I find it hard to
> convince myself that to be more forgiving wrt to (2) and (3) is safe.

True.

Though FWIW, in this case, the user edited out the kernel check,
mounted, and successfully copied off the files before running xfs_repair
and nuking it with this patch.

So I guess bonus points would be teaching repair to fix up the problem
if the list seems valid ... and maybe even the same kernelside....

Thanks,
-Eric

> Olaf
> 
> 
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Acked-By: Olaf Weber <olaf@sgi.com>
> 
>> ---
> 
>> diff --git a/repair/dinode.c b/repair/dinode.c
>> index 84e1d05..3fc6cac 100644
>> --- a/repair/dinode.c
>> +++ b/repair/dinode.c
>> @@ -1280,6 +1280,14 @@ process_btinode(
>>  			last_key = cursor.level[level-1].first_key;
>>  		}
>>  	}
>> +	if (*nex <= XFS_DFORK_SIZE(dip, mp, whichfork) / sizeof(xfs_bmbt_rec_t)) {
>> +		do_warn(_("extent count for ino %lld %s fork too low "
>> +			  "(%d) for file format\n"),
>> +				lino,
>> +				whichfork == XFS_DATA_FORK ? _("data") : _("attr"),
>> +				*nex);
>> +		return(1);
>> +	}
>>  	/*
>>  	 * Check that the last child block's forward sibling pointer
>>  	 * is NULL.
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
