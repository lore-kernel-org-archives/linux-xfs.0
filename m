Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 07:47:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9IElGGM027186
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 07:47:16 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8839610AC427
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 07:48:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id wNZC16x0VAtSDRfZ for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 07:48:59 -0700 (PDT)
Message-ID: <48F9F759.5070602@sandeen.net>
Date: Sat, 18 Oct 2008 09:48:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption on the arm(el) architecture
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <48F89E0F.6030307@sandeen.net> <20081018085752.GS25834@deprecation.cyrius.com>
In-Reply-To: <20081018085752.GS25834@deprecation.cyrius.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

Martin Michlmayr wrote:
> * Eric Sandeen <sandeen@sandeen.net> [2008-10-17 09:15]:

>> Do you know what cachepolicy you're booted with?  If it's writeallocate,
>> you might try cachepolicy=writeback, otherwise try cachepolicy=uncached
>> (which will be horribly slow) and see if the problem goes away or not;
>> it'd be a clue.
> 
> I just tried with cachepolicy=writeback and cachepolicy=uncached but I
> get the same problem.

Oh, wow.  This sounds like a new problem then; not a cache problem, and
not an alignment problem...  hrm.  I'll try to think of something else
to try.

Thanks,
-Eric
