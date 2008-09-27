Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 18:10:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8R1ARp7018759
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:10:27 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F99F12119FD
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:12:02 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id leXpLjv09oJJ3x6U for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:12:02 -0700 (PDT)
Date: Sat, 27 Sep 2008 11:11:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080927011159.GR27997@disturbed>
References: <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com> <20080926003401.GG27997@disturbed> <48DC3BBB.4080807@sgi.com> <20080926025718.GJ27997@disturbed> <48DC5945.9060506@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC5945.9060506@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Fri, Sep 26, 2008 at 01:38:45PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> Right, but keep in mind that the patch doesn't prevent spurious
>> wakeups - it merely causes the thread to wakeup and go back to sleep
> Yes that's right and it's why I suggested replacing the uses of wake_up_process
> with wake_up and a wait queue where both the xfsaild and xfssyncd threads can
> have a wait queue specific to them.  This way we only wake them up if they are
> sleeping on that wait queue and not somewhere else waiting for a different event.
> I'm pretty sure that will be a safe change to make.

Yes, that sounds like a good idea.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
