Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 17:56:22 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q0uJpx016061
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 17:56:19 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: TAKE 976035 - streamline init/exit path
References: <20080625030057.973173A5D1@itchy>
	<20080625135719.GA30735@infradead.org>
Date: Thu, 26 Jun 2008 10:56:51 +1000
In-Reply-To: <20080625135719.GA30735@infradead.org> (Christoph Hellwig's
	message of "Wed, 25 Jun 2008 09:57:19 -0400")
Message-ID: <ncc8wwt2euk.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Jun 25, 2008 at 01:00:57PM +1000, Niv Sardi wrote:
>> streamline init/exit path
>> 
>> Currently the xfs module init/exit code is a mess.  It's farmed out
>> over a lot of function with very little error checking.  This patch
>> makes sure we propagate all initialization failures properly and clean
>> up after them.  Various runtime initializations are replaced with
>> compile-time initializations where possible to make this easier.  The
>> exit path is similarly consolidated.
>
> Umm, this has been in for a long time.  Did the mail leave your mail
> queue only now? :)

Nah, it got into ptools with a bogus commit message and PV and all, and
now is in master tottally broken, the plan is to let it die in master
and cherry-pick the new one in for-linus.

Sorry for the mess !

Cheers,
-- 
Niv Sardi
