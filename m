Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o95GqhDD236573 for <xfs@oss.sgi.com>; Tue, 5 Oct 2010 11:52:43 -0500
Message-ID: <4CAB5874.9060106@kernel.org>
Date: Tue, 05 Oct 2010 18:55:16 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: -mm: xfs lockdep warning
References: <201009161546.16909.ruirui.r.yang@tieto.com>	<20100917005227.GJ24409@dastard>	<20100920191355.GA28443@infradead.org>	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>	<4CA997DF.5030008@kernel.org>	<20101004092107.GJ4681@dastard>
	<AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>
	<4CAB5779.5020901@kernel.org>
In-Reply-To: <4CAB5779.5020901@kernel.org>
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
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Yang Ruirui <ruirui.r.yang@tieto.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>, Andrew Morton <akpm@linux-foundation.org>

On 10/05/2010 06:51 PM, Tejun Heo wrote:
> On 10/05/2010 12:09 PM, Torsten Kaiser wrote:
>> 2) the hang with 2.6.35-rc5 I have seen twice (triggered probably by
>> high load while building KOffice on an tmpfs)
> 
> The trace doesn't seem to firmly point at xfs locking up.  There are
> md and dm crypt involved.  Are you sure this is locking up inside xfs?
> Also, can you please enable frame pointers so that we can get more
> reliable backtrace?
> 
>> 3) the lockdep issue that started this thread and that I am seeing in
>> mainline 2.6.36-rc5 and -rc6 and that seems to be rather easy to
>> trigger for me.
>>
>> Because 3) is regarded as a false positive, it should not be the cause
>> of 2)
> 
> For now, let's not draw any conclusion or mix the issues.  I'll look
> up the original thread and look into what the lockdep warning means.

Ah, okay, David already looked into it and concluded it to be a
spurious one.  Can you please attach full kernel message of the
lockup?

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
