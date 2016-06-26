Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B36E67CA0
	for <xfs@oss.sgi.com>; Sun, 26 Jun 2016 07:16:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 802A48F8037
	for <xfs@oss.sgi.com>; Sun, 26 Jun 2016 05:16:27 -0700 (PDT)
Received: from basicbox7.server-home.net (basicbox7.server-home.net
	[195.137.212.29]) by cuda.sgi.com with ESMTP id
	iQKBWGS7ebYpSNm1 (version=TLSv1 cipher=DHE-RSA-AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jun 2016 05:16:21 -0700 (PDT)
Subject: Re: Internal error xfs_trans_cancel
References: <ab487269-a423-e3dc-6f59-3dda004960c3@monom.org>
	<20160601071047.GJ12670@dastard>
	<e80cee4f-1789-5418-ffa8-7551138bda0a@monom.org>
	<0644b434-6cea-4188-9702-469c26d191b8@monom.org>
	<20160602002653.GL12670@dastard>
	<af997005-e144-5509-885c-a688562ea3ec@monom.org>
	<20160602063539.GM12670@dastard>
	<a933729c-afa8-3cc1-6fe4-5f49b9629326@monom.org>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Message-ID: <a738e82e-ffa5-53e0-ba58-a85a1254baf3@leemhuis.info>
Date: Sun, 26 Jun 2016 14:16:19 +0200
MIME-Version: 1.0
In-Reply-To: <a933729c-afa8-3cc1-6fe4-5f49b9629326@monom.org>
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
To: Daniel Wagner <wagi@monom.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 02.06.2016 15:29, Daniel Wagner wrote:
>> Hmmm, Ok. I've been running the lockperf test and kernel builds all
>> day on a filesystem that is identical in shape and size to yours
>> (i.e. xfs_info output is the same) but I haven't reproduced it yet.
> I don't know if that is important: I run the lockperf test and after
> they have finished I do a kernel build.
> 
>> Is it possible to get a metadump image of your filesystem to see if
>> I can reproduce it on that?
> Sure, see private mail.

Dave, Daniel, what's the latest status on this issue? It made it to my
list of know 4.7 regressions after Christoph suggested it should be
listed. But this thread looks stalled, as afaics nothing happened for
three weeks apart from Josh (added to CC) mentioning he also saw it. Or
is this discussed elsewhere? Or fixed already?

Sincerely, your regression tracker for Linux 4.7 (http://bit.ly/28JRmJo)
 Thorsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
