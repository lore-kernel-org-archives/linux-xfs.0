Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:35630 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753431AbcLAEEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2016 23:04:44 -0500
Message-ID: <583FA154.9050905@tlinx.org>
Date: Wed, 30 Nov 2016 20:04:36 -0800
From: L A Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: default mount options
References: <583E1488.7090502@tlinx.org> <6ecda11c-a993-3dd7-5b87-1947506953ff@sandeen.net> <583F2806.7080102@tlinx.org> <e727dd60-777a-60d4-121e-2dd68981e176@sandeen.net> <583F30C8.1000206@tlinx.org> <20161130221837.GH31101@dastard>
In-Reply-To: <20161130221837.GH31101@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org



Dave Chinner wrote:
> For /some/ RAID controllers in /some/ modes. For example, the
> megaraid driver that has been ignoring cache flushes for over 9
> years because in RAID mode it doesn't need it. However, in JBOD
> mode, that same controller requires cache flushes to be sent because
> it turns off sane cache management behaviour in JBOD mode...
---
  Lovely. For better or worse, none of my HW-based LSI-raid cards have
been able to do JBOD.
do JBOD.  

> This is a clear example of why "barriers" should always be on and
> cache flushes always passed through to the storage - because we just
> don't know WTF the storage is actually doing with it's caches.
----
	When it comes to JBOD, its not so clear about where caching
helps the most.  

	Related -- wondering about how external journals would 
affect need for barriers.  Haven't thought about it much, but it seems
like one would get alot of bang-for-the-buck to put journals on
SSD's.  _If_ data written to SSD's becomes "safe" as soon as it is 
accepted by SSDs (not saying it *is*, but _if_ it is), then how
"needed" is ordering of writes for rotating media -- apart from
special use/need cases like apps maintaining their own data-integrity
journals like DB's or such?  Just wondering about how increasing use
of SSD's might affect the need for barriers.

	Anyway, I have the illusion that I am mostly clear about
current params (at least until my next disillusioning)...   ;-)

-l



