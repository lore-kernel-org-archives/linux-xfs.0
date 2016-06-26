Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D9D607CA0
	for <xfs@oss.sgi.com>; Sun, 26 Jun 2016 10:13:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9B7598F8033
	for <xfs@oss.sgi.com>; Sun, 26 Jun 2016 08:13:39 -0700 (PDT)
Received: from hotel311.server4you.de (hotel311.server4you.de [85.25.146.15])
	by cuda.sgi.com with ESMTP id hDS6khOZOxQpOBBH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 26 Jun 2016 08:13:37 -0700 (PDT)
Subject: Re: Internal error xfs_trans_cancel
References: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
	<20160601071047.GJ12670@dastard>
	<e80cee4f-1789-5418-ffa8-7551138bda0a@monom.org>
	<0644b434-6cea-4188-9702-469c26d191b8@monom.org>
	<20160602002653.GL12670@dastard>
	<af997005-e144-5509-885c-a688562ea3ec@monom.org>
	<20160602063539.GM12670@dastard>
	<a933729c-afa8-3cc1-6fe4-5f49b9629326@monom.org>
	<a738e82e-ffa5-53e0-ba58-a85a1254baf3@leemhuis.info>
From: Daniel Wagner <wagi@monom.org>
Message-ID: <af4706ea-0129-1692-e354-0bd08fabd255@monom.org>
Date: Sun, 26 Jun 2016 17:13:33 +0200
MIME-Version: 1.0
In-Reply-To: <a738e82e-ffa5-53e0-ba58-a85a1254baf3@leemhuis.info>
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
To: Thorsten Leemhuis <regressions@leemhuis.info>, Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 06/26/2016 02:16 PM, Thorsten Leemhuis wrote:
> On 02.06.2016 15:29, Daniel Wagner wrote:
>>> Hmmm, Ok. I've been running the lockperf test and kernel builds all
>>> day on a filesystem that is identical in shape and size to yours
>>> (i.e. xfs_info output is the same) but I haven't reproduced it yet.
>> I don't know if that is important: I run the lockperf test and after
>> they have finished I do a kernel build.
>>
>>> Is it possible to get a metadump image of your filesystem to see if
>>> I can reproduce it on that?
>> Sure, see private mail.
> 
> Dave, Daniel, what's the latest status on this issue? 

I had no time to do some more testing in last couple of weeks. Tomorrow
I'll try to reproduce it again, though last time I tried it couldn't
trigger it.

> It made it to my
> list of know 4.7 regressions after Christoph suggested it should be
> listed. But this thread looks stalled, as afaics nothing happened for
> three weeks apart from Josh (added to CC) mentioning he also saw it. Or
> is this discussed elsewhere? Or fixed already?

The discussion wandered over to the thread called 'crash in xfs in
current' and there are some instruction by Al what to do test

Message-ID: <20160622014253.GS12670@dastard>

cheers,
daniel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
