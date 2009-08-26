Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7QNQBSW049438 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 18:26:22 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CCD2400DD3
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 16:26:39 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Fk62C9xczGqAAN2w for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2009 16:26:39 -0700 (PDT)
References: <4A849096.1010600@sandeen.net>
	<20090826221106.GB18119@infradead.org>
Message-Id: <DCB2CFA0-E157-4848-92A7-2387D651C431@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20090826221106.GB18119@infradead.org>
Mime-Version: 1.0 (iPod Mail 7A341)
Subject: Re: [PATCH] xfs_io: actually issue 0 size writes
Date: Wed, 26 Aug 2009 16:26:25 -0700
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Aug 26, 2009, at 3:11 PM, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Thu, Aug 13, 2009 at 05:15:50PM -0500, Eric Sandeen wrote:
>> While testing some stuff in generic_write_checks() in the
>> kernel I realized that you can't actually use xfs_io to send
>> a 0-byte write in.  This is actually a condition worth testing:
>>
>>       If  count  is zero and fd refers to a regular file,
>>       then write() may return a failure status if one  of
>>       the  errors  below  is  detected.  If no errors are
>>       detected, 0 will be returned  without  causing  any
>>       other  effect.
>>
>> So fix that up.
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>
> Any reason you didn't put this in despite two positive reviews?

Just general busyness and a vacation :)

Will do it soon.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
