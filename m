Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAGETdNp166407 for <xfs@oss.sgi.com>; Mon, 16 Nov 2009 08:29:39 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B04898D5FF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2009 06:30:00 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id L88Jf9aBrcdPWhiZ for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2009 06:30:00 -0800 (PST)
Message-ID: <4B0161E5.5060800@sandeen.net>
Date: Mon, 16 Nov 2009 08:29:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS bug in log recover with quota (bugzilla id 855)
References: <20091116115702.GN23522@sith.mimuw.edu.pl>
	<20091116130824.GA27442@infradead.org>
In-Reply-To: <20091116130824.GA27442@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Alex Elder <aelder@sgi.com>, Jan Rekorajski <baggins@sith.mimuw.edu.pl>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Mon, Nov 16, 2009 at 12:57:02PM +0100, Jan Rekorajski wrote:
>> Hi,
>> I was hit by a bug in linux 2.6.31 when XFS is not able to recover the
>> log after a crash if fs was mounted with quotas. Gory details in XFS
>> bugzilla: http://oss.sgi.com/bugzilla/show_bug.cgi?id=855.
>>
>> It looks like wrong struct is used in buffer length check, and the following
>> patch should fix the problem.
>>
>> xfs_dqblk_t has a size of 104+32 bytes, while xfs_disk_dquot_t is 104 bytes
>> long, and this is exactly what I see in system logs - "XFS: dquot too small
>> (104) in xlog_recover_do_dquot_trans."
> 
> Yikes, great brown paperbag bug.  Indeed, as per
> xfs_qm_dquot_logitem_format() we only log the xfs_disk_dquot_t and not
> the full xfs_dqblk_t.
> 
> Felix, can you try to get this to Linus before .32 as this is clearly a
   ^^^ Alex ;)

-Eric

> regression.
> 
> I'll also put the writing of more quota testcases including testing the
> log recovery even higher on my todo list.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
