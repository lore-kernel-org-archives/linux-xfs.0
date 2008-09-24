Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:52:58 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7quBr002405
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:52:56 -0700
Message-ID: <48D9F44A.5010601@sgi.com>
Date: Wed, 24 Sep 2008 18:03:22 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed>
In-Reply-To: <20080924074604.GK5448@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

Dave Chinner wrote:
> On Wed, Sep 24, 2008 at 05:42:38PM +1000, Lachlan McIlroy wrote:
>> Looks good Pete.
> 
> No, it is not yet good. Pete cannot explain the underlying problem
> and we need to understand if this is fixing the problem or just
> changing the timing so it doesn't show up....
> 

Pete clearly demonstrated to me that the sv_wait is being prematurely
woken up when it should not be.  There may be an underlying problem or
this could just be another peculiarity of the Linux kernel.  Either way
Pete will continue to look into this and whatever the explanation turns
out to be, we deperately need a way to prevent our customers from
running into this deadlock.  Even if there is another problem lurking
this code change is fine and if nothing else will serve as a performance
improvement.
