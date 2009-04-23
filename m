Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NHQWaf017246 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 12:26:32 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C24921444D82
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 10:29:21 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id m8flt30SkTv0v1qE for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2009 10:29:21 -0700 (PDT)
Message-ID: <49F0A485.8060408@sandeen.net>
Date: Thu, 23 Apr 2009 12:25:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add aio-dio-regress tests
References: <49EFB75B.5030700@sandeen.net>
	<20090423171937.GE11391@infradead.org>
In-Reply-To: <20090423171937.GE11391@infradead.org>
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
> On Wed, Apr 22, 2009 at 07:33:31PM -0500, Eric Sandeen wrote:
>> Think it's worth pulling this in?
>> Also not sure where to put it, under the top dir or under src ...
>>
>> Takes about 250s to run them all.  Could break out the longer
>> one into a separate test so the rest could be in quick.
> 
> I would prefer to have a separate test for each of the programs.

Fine by me.  Any thoughts on if this should live under src/ or not?  I'm
not sure why ltp/ doesn't, but I was just following that.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
