Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Feb 2008 06:12:17 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1KEC6Da017609
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 06:12:11 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4E8275A8DB
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 06:12:32 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id MnGNfAfE8vYT3dLu for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 06:12:32 -0800 (PST)
Message-ID: <47BC3530.1080803@sandeen.net>
Date: Wed, 20 Feb 2008 08:12:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch] Prevent excessive xfsaild wakeups
References: <20080218225906.GS155407@sgi.com> <20080220055318.GO155407@sgi.com>
In-Reply-To: <20080220055318.GO155407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> ping?
> 
> This is needed for 2.6.25-rcX....
> 
> On Tue, Feb 19, 2008 at 09:59:06AM +1100, David Chinner wrote:
>> Idle state is not being detected properly by the xfsaild push
>> code. The current idle state is detected by an empty list
>> which may never happen with mostly idle filesystem or one
>> using lazy superblock counters. A single dirty item in the
>> list will result repeated looping to push everything past
>> the target when everything because it fails to check if we
>> managed to push anything.
>>
>> Fix by considering a dirty list with everything past the target
>> as an idle state and set the timeout appropriately.

Seems good to me.

Acked-by: Eric Sandeen <sandeen@sandeen.net>

-Eric

>> Signed-off-by: Dave Chinner <dgc@sgi.com>
>> ---
>>  fs/xfs/xfs_trans_ail.c |   15 +++++++++------
>>  1 file changed, 9 insertions(+), 6 deletions(-)
>>
>> Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c
>> ===================================================================
>> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_ail.c	2008-02-18 09:14:34.000000000 +1100
>> +++ 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c	2008-02-18 09:18:52.070682570 +1100
>> @@ -261,14 +261,17 @@ xfsaild_push(
>>  		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
>>  	}
>>  
>> -	/*
>> -	 * We reached the target so wait a bit longer for I/O to complete and
>> -	 * remove pushed items from the AIL before we start the next scan from
>> -	 * the start of the AIL.
>> -	 */
>> -	if ((XFS_LSN_CMP(lsn, target) >= 0)) {
>> +	if (count && (XFS_LSN_CMP(lsn, target) >= 0)) {
>> +		/*
>> +		 * We reached the target so wait a bit longer for I/O to
>> +		 * complete and remove pushed items from the AIL before we
>> +		 * start the next scan from the start of the AIL.
>> +		 */
>>  		tout += 20;
>>  		last_pushed_lsn = 0;
>> +	} else if (!count) {
>> +		/* We're past our target or empty, so idle */
>> +		tout = 1000;
>>  	} else if ((restarts > XFS_TRANS_PUSH_AIL_RESTARTS) ||
>>  		   (count && ((stuck * 100) / count > 90))) {
>>  		/*
> 
