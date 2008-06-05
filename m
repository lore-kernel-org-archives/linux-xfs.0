Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Jun 2008 23:05:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m55659g9023631
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2008 23:05:09 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A60211C4D73
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2008 23:06:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id wXB2eHWLCmYCm7qX for <xfs@oss.sgi.com>; Wed, 04 Jun 2008 23:06:02 -0700 (PDT)
Message-ID: <48478249.8060301@sandeen.net>
Date: Thu, 05 Jun 2008 01:06:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <480E89B5.8070006@sandeen.net> <481B7FD1.3030107@sandeen.net> <20080505070847.GH155679365@sgi.com> <481FDCD1.2010905@sgi.com> <4820609C.9090306@sandeen.net> <48477BD6.2020909@sandeen.net> <48477DA3.8090602@sgi.com> <48477E54.9090309@sandeen.net> <48478175.9060009@sgi.com>
In-Reply-To: <48478175.9060009@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Timothy Shimmin <tes@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Mark Goodwin wrote:
> 
> Eric Sandeen wrote:
>> heh, thanks Mark.  Even though it's only CORRUPTION ON ARM I guess the
>> shouting worked.  :)
> 
> Well, we're dealing with apparent insidious corruption after
> failed btree AG allocations (which aren't supposed to fail).
> This seems to stem from the fixes for the ENOSPC deadlock bugs
> (two years ago, see below). you and Nathan probably remember
> this ..?

nah it's easier to hit than that.  Just run xfs-qa on arm with old abi
and you'll hit it plenty quickly.  there are other calculations around
that assume no padding.

Even if it doesn't look corrupted on arm, the filesystem isn't portable.

-Eric

> Timothy Shimmin wrote:
>> Okay some history in xfs-dev archives on this bug...
>> plenty of reading here :)
>> Reverse chronological order with initial report from
>> guy at NEC:
>>
>> May 2006
>> Review thread b/w Nathan and Ying Ping:
>> http://ils.corp.sgi.com/Archives/xfs-dev/200605/msg00128.html
>>
>> April 2006
>> Thread - dgc, Ying, nathan
>> http://ils.corp.sgi.com/Archives/xfs-dev/200604/msg00005.html
>>
>> March 2006 - 2 threads
>> http://ils.corp.sgi.com/Archives/xfs-dev/200603/msg00002.html
>> http://ils.corp.sgi.com/Archives/xfs-dev/200603/msg00140.html
>>
>> Feb 2006
>> http://ils.corp.sgi.com/Archives/xfs-dev/200602/msg00062.html
>> Initial report and suggested test case by Asano Masahiro - NEC
>> (fwd'ed by Eric).
>> Plenty of commentary by Asano.
>> Thread - including comments by Steve Lord:
>> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/13268 
> 
