Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SEvgmC259707 for <xfs@oss.sgi.com>; Thu, 28 May 2009 09:57:43 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1477C1A35950
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 07:57:56 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id vufnScg7EICY5H09 for <xfs@oss.sgi.com>;
	Thu, 28 May 2009 07:57:56 -0700 (PDT)
Message-ID: <4A1EA669.2070908@sandeen.net>
Date: Thu, 28 May 2009 09:57:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 7/9] Set default extN mount options
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>	<1243450413-12681-8-git-send-email-sandeen@sandeen.net>
	<20090528100122.GG651@infradead.org>
In-Reply-To: <20090528100122.GG651@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

>> @@ -585,7 +589,7 @@ _require_scratch()
>>  		     _notrun "this test requires a valid \$SCRATCH_DEV"
>>  		 fi
>>  		 ;;
>> -	nfs*|ext2|ext3|reiserfs)
>> +	nfs*|ext2|ext3|ext4|reiserfs)
>>  		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
>>  		 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]
> 
> This whole function looks fishy to me, but just treating ext4 the same
> as ext2/ext3 makes sense at least.

I agree, I Need to sort out what's going on here but this was a "make it
work" patch :)

Thanks,

-Eric

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
