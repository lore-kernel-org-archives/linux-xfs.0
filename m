Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A475C8024
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 16:57:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB161AC001
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 14:57:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id x1Q3E9mecoCCVHII for <xfs@oss.sgi.com>;
	Sun, 03 Mar 2013 14:57:53 -0800 (PST)
Message-ID: <5133D573.3050106@sandeen.net>
Date: Sun, 03 Mar 2013 16:57:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Do not check ocfs2
References: <1362269150-21478-1-git-send-email-richard@nod.at>
	<20130303011917.GI23616@dastard>
	<20130303100254.500b076f@spider.haslach.nod.at>
	<5133C900.9050300@sandeen.net>
	<20130303231905.0efd6d08@spider.haslach.nod.at>
	<5133D15A.9010600@sandeen.net>
	<20130303235341.7470085e@spider.haslach.nod.at>
In-Reply-To: <20130303235341.7470085e@spider.haslach.nod.at>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 3/3/13 4:53 PM, Richard Weinberger wrote:

>> Anyway, what if you did something more along the lines of [pseudocode]
>>
>> ocfs2)
>> 	if mounted.ocfs2 -f $TEST-DEV | frob_as_necessary[1]
>> 		;
>> 	else
>> 		fsck.ocfs2 $TEST-DEV
>> 	fi
>> 	;;
>>
>> so that *if* it's mounted on some other node, the fsck won't run.
>> That has downsides as Dave mentioned, but for the case where the
>> xfstests node is the only one with it in use, it'll still do the
>> beneficial consistency check.
>>
>> Just tweaking the fsck action bsed on *if* it's mounted (or,
>> maybe, if the node is in a cluster?) might be a more generic solution
>> that is widely applicable to all ocfs2 test environments.
> 
> Good point. mounted.ocfs2 really makes sense. I'll implement this on my
> test suite and submit a new patch.

Sounds good to me.

It'd be most preferable to do a cluster-wide unmount and fsck,
but if that's unfeasible, then skipping the fsck (with a warning) is
still preferable to simply disabling it outright for everyone.

Thanks,
-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
