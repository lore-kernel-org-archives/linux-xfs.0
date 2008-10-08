Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 17:13:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m980DsCq026526
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 17:13:55 -0700
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3E0A4C9BE9
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 17:15:33 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by cuda.sgi.com with ESMTP id OG3rdwh3tZr0tZ91 for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 17:15:33 -0700 (PDT)
Subject: Re: xfs file system corruption
From: Andi Kleen <andi@firstfloor.org>
References: <E8DED08235A93F4D8A2AB6CD0ABAB32A0A937FC8EC@NA-EXMSG-C121.redmond.corp.microsoft.com>
	<20081007233418.GB7342@disturbed>
	<E8DED08235A93F4D8A2AB6CD0ABAB32A0A937FC922@NA-EXMSG-C121.redmond.corp.microsoft.com>
Date: Wed, 08 Oct 2008 02:15:29 +0200
In-Reply-To: <E8DED08235A93F4D8A2AB6CD0ABAB32A0A937FC922@NA-EXMSG-C121.redmond.corp.microsoft.com> (Allan Haywood's message of "Tue, 7 Oct 2008 16:49:40 -0700")
Message-ID: <87r66skkm6.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Allan Haywood <Allan.Haywood@microsoft.com>
Cc: Dave Chinner <david@fromorbit.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Allan Haywood <Allan.Haywood@microsoft.com> writes:
>
>         Would reloading the xfs module work also, to clear any pending
>         writes (if I could get it to a point where modprobe -r xfs
>         would work)? Although I am doubting that if there are pending
>         writes that it would be easy to get xfs to unload.

Linux doesn't have IO cancel and it's hard to stop everything
in the IO stack, so the usual way is to fence it at a high level
and then wait for all pending IO. But that might take a long time.

That is why most HA setups use hard stonith, as in power switch.

-Andi
-- 
ak@linux.intel.com
