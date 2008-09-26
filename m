Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 18:07:45 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q17gt2013067
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 18:07:42 -0700
Message-ID: <48DC3638.3050601@sgi.com>
Date: Fri, 26 Sep 2008 11:09:12 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com> <20080926003401.GG27997@disturbed>
In-Reply-To: <20080926003401.GG27997@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-dev@sgi.com

Dave Chinner wrote:
> but it doesn't fix the underlying problem that was causing the
> spurious wakeups, which is the fact that xfs_qm_dqflush() is not
> obeying non-blocking flush directions. The patch below should fix
> that. Can you please test it before you add your patch?
>   
Yeah I already had this idea I  just have not posted a patch because 
Lachlan though
it might introduce a deadlock. If you think this is a good Idea I will 
update my patch
to  be non blocking.
