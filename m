Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Sep 2008 21:12:57 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M4CrGr009983
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 21:12:53 -0700
Message-ID: <48D71B9D.2040800@sgi.com>
Date: Mon, 22 Sep 2008 14:14:21 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Remove xfs_iext_irec_compact_full()
References: <48D7160B.8020108@sgi.com> <48D71701.6070900@sandeen.net>
In-Reply-To: <48D71701.6070900@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: lachlan@sgi.com, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>



Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>> Yet another bug was found in xfs_iext_irec_compact_full() and while the
>> source of the bug was found it wasn't an easy task to track it down because
>> the conditions are very difficult to reproduce.  Code that is difficult to
>> reach is difficult to test and debug.
> 
> It might be nice to give credit to those who helped find it in the commit ;)

yes, this is a very significant bug to find, thanks.

I'm wondering whether it would be worth auditing or re-reviewing the entire
incore-extents-optimization patchset (if that's possible against the current
code base). Or should we just fix this and move on - let the testing 
speak for
itself? The hard to hit code paths are a worry IMO.

Cheers
-- Mark
