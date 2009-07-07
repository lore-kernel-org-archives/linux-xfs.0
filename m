Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67Dswmm147654 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 08:54:58 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A98E9F5D26
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 07:02:25 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id zYeFYhfUADuCdz84 for
	<xfs@oss.sgi.com>; Tue, 07 Jul 2009 07:02:25 -0700 (PDT)
Message-ID: <4A5353D2.7010508@sandeen.net>
Date: Tue, 07 Jul 2009 08:55:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add tests to check log size scaling
References: <20090705194111.GA3834@infradead.org>	<4A52CAD6.1070807@sandeen.net>
	<20090707104403.GA21747@infradead.org>
In-Reply-To: <20090707104403.GA21747@infradead.org>
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
> On Mon, Jul 06, 2009 at 11:11:02PM -0500, Eric Sandeen wrote:
>> Any reason to do this on the scratch dir vs. the test dir?  (Since
>> scratch dir became optional, I figure stuff that can go on the test dev
>> instead, probably should?)
>>
>> not a big deal, it looks fine otherwise.
> 
> The test should work just fine using the test dir, and given that these
> bits all cam from Dave I can't speak for his reason to use the scratch
> dir.  But given that even creating an empty 16TB filesystem uses up a
> lot of space I'd rather have as much as possible free space available
> instead of sharing it with an aged filesystem.

Ok, it's fine by me as posted then, consider it reviewed.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
