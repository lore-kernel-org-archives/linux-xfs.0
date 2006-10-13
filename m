Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Oct 2006 05:18:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9DCI9aG003492
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 05:18:12 -0700
Message-ID: <452F83BD.8050501@ah.jp.nec.com>
Date: Fri, 13 Oct 2006 21:17:01 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
MIME-Version: 1.0
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
References: <45237CCE.4010007@ah.jp.nec.com> <20061006032617.GC11034@melbourne.sgi.com> <20061011064357.GN19345@melbourne.sgi.com> <452E32FF.8010109@ah.jp.nec.com> <20061013014651.GC19345@melbourne.sgi.com>
In-Reply-To: <20061013014651.GC19345@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Hi David,

David Chinner wrote:
>> Block I/O performance degradation was very serious.
> 
> That was unexpected. :/
> 
>> Now, I am trying to ease the degradation.
>> Do you have any idea for resolving the degradation?
> 
> Did you see a degradation with your original fix? I suspect
> not.

No, I don't see any degradation with my patch.
But my patch is not perfect.
Because xfs_log_force() don't guarantee to write the log in run time.

> 
> Can you test this patch (on top of the last patch I sent)
> and see if it fixes the degradation?

I tried your patch, but it seems degradation was not resolved.

procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0      0 15585968  21856 151696    0    0    73   273  258  298  1  3 94  2  0
 0  0      0 15585968  21856 151840    0    0     0  2270 2156 2693  0  2 98  0  0
 1  0      0 15585744  21856 151920    0    0     0  2362 2161 2797  0  2 98  0  0
 0  0      0 15585408  21856 151824    0    0     0  2291 2156 2732  0  2 98  0  0
 0  0      0 15584848  21856 152288    0    0     0  2300 2156 2765  0  2 98  0  0
 2  0      0 15584848  21856 151952    0    0     0  2346 2161 2809  0  2 98  0  0

Ummmm, I think schedule() was called many times by wait_event().

Best Regards,
--
Takenori Nagano, NEC
t-nagano@ah.jp.nec.com
