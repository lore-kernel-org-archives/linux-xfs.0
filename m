Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6QMpg2B048730 for <xfs@oss.sgi.com>; Sun, 26 Jul 2009 17:51:43 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 979F010C2908
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2009 16:01:03 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id v0E93xAB53hKaVJK for
	<xfs@oss.sgi.com>; Sun, 26 Jul 2009 16:01:03 -0700 (PDT)
Message-ID: <4A6CDE2C.9070508@sandeen.net>
Date: Sun, 26 Jul 2009 17:52:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: check for null single-block dir buffer	pointer
	in phase6
References: <4A69C660.9000604@sandeen.net>
	<20090725150256.GA12148@infradead.org>
In-Reply-To: <20090725150256.GA12148@infradead.org>
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
> On Fri, Jul 24, 2009 at 09:34:08AM -0500, Eric Sandeen wrote:
>> @@ -2524,7 +2525,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>>  
>>  	if (!dotdot_update) {
>>  		/* check btree and freespace */
>> -		if (isblock) {
>> +		if (isblock && bplist[0]) {
>>  			xfs_dir2_block_tail_t	*btp;
>>  			xfs_dir2_leaf_entry_t	*blp;
> 
> This doesn't look quite correct to me.  Now we falls through to the
> final else statement when bplist[0] is zeroed.
> 

Oh, ugh, you're right.  Will fix that up, thanks.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
