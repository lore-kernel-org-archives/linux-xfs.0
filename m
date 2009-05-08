Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n48ChqgW016859 for <xfs@oss.sgi.com>; Fri, 8 May 2009 07:43:52 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C97CF1D1CAFE
	for <xfs@oss.sgi.com>; Fri,  8 May 2009 05:43:56 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Gbhkq7jltxlZhlby for
	<xfs@oss.sgi.com>; Fri, 08 May 2009 05:43:56 -0700 (PDT)
Message-ID: <4A04290B.7020309@sandeen.net>
Date: Fri, 08 May 2009 07:43:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 042: point xfs_fsr right at the fragmented	file
References: <4A0386FD.7000108@sandeen.net>
	<20090508062658.GA1689@infradead.org>
In-Reply-To: <20090508062658.GA1689@infradead.org>
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
> On Thu, May 07, 2009 at 08:12:29PM -0500, Eric Sandeen wrote:
>> Somehow 042 as it stands isn't actually defragging the fragmented
>> file we created (see 042.full post-run)
>>
>> Probably need to look into that as well, but for now this should
>> make the call to fsr actually _do_ something.
>>
>> This has let 2 fsr bugs slip through qa in the past few months.  :(
> 
> Looks good.  Can you open a bugzilla for the problem of fsr not actually
> finding the fragmented file so that we don't forget about that one?
> 

Good idea and done: http://oss.sgi.com/bugzilla/show_bug.cgi?id=821

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
