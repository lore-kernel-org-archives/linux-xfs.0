Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B3D329E2B
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 12:20:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7693304043
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 10:20:45 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id z2XLJlHWjtJ2QoiP for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 10:20:44 -0800 (PST)
Message-ID: <527A887F.2030807@sandeen.net>
Date: Wed, 06 Nov 2013 12:20:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstest failures
References: <20131106105451.GA31283@infradead.org>
	<20131106161825.GU1935@sgi.com>
In-Reply-To: <20131106161825.GU1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 11/6/13, 10:18 AM, Ben Myers wrote:
> On Wed, Nov 06, 2013 at 02:54:51AM -0800, Christoph Hellwig wrote:
>> xfs/296
>>
>> 	Checking for capability on restored file
>> 	-RESTORE_DIR/DUMP_SUBDIR/testfile cap_setgid,cap_setuid+ep
>> 	-# file: RESTORE_DIR/DUMP_SUBDIR/testfile
>> 	-security.capability
>>
>> 	Seems like theres some issues with file capabilities.
> 
> IIRC Eric noticed that this was broken and submitted a test for it.  It would
> be great if someone can work on it.  ;)

that's right, it's a known bug w/ a testcase but no fix yet.

I looked a bit, but ugh, xfsdump.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
