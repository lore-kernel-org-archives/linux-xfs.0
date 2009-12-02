Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2FJk6A008929 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 09:19:46 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DC7CC6B1E
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 07:19:49 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id kWlYpQfDeGJNtwUV for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2009 07:19:49 -0800 (PST)
Message-ID: <4B168592.1090305@sandeen.net>
Date: Wed, 02 Dec 2009 09:19:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_db: modify bad_features2 when modifying features2
References: <4B156BE3.2080107@sandeen.net>
	<20091202150422.GA16338@infradead.org>
In-Reply-To: <20091202150422.GA16338@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Tue, Dec 01, 2009 at 01:17:55PM -0600, Eric Sandeen wrote:
>> +	if (xfs_sb_has_mismatched_features2(&tsb)) {
>> +		dbprintf(_("Superblock has mismatched features2 fields, "
>> +			   "skipping modification\n"));
>> +		return 0;
>> +	}
> 
> However I'm not sure if this one is an all that good idea.  It'll make
> all version updates fail if we have a mismatched features2.  That way
> people can't use xfs_db to fix it up which seems odd.
> 
> To me just printing the warning but not aborting would be the best way
> to inform the user about it.

hm yeah I suppose so.

I wonder if we should catch it somehow on the feature-set shortcuts
like "attr1" but allow it for explicit value sets ...

?

-Eric

> 
>> +
>>  	if ((version & XFS_SB_VERSION_LOGV2BIT) &&
>>  					!xfs_sb_version_haslogv2(&tsb)) {
>>  		tsb.sb_logsunit = 1;
>> @@ -564,7 +570,8 @@ do_version(xfs_agnumber_t agno, __uint16_t version, __uint32_t features)
>>  
>>  	tsb.sb_versionnum = version;
>>  	tsb.sb_features2 = features;
>> -	fields |= XFS_SB_VERSIONNUM | XFS_SB_FEATURES2;
>> +	tsb.sb_bad_features2 = features;
>> +	fields |= XFS_SB_VERSIONNUM | XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
> 
> This one looks good to me.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
