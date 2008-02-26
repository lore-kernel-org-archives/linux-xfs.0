Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 23:26:31 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1Q7QPM2018389
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 23:26:27 -0800
Message-ID: <47C3C07C.2090009@sgi.com>
Date: Tue, 26 Feb 2008 18:32:12 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc4
References: <20080226064909.5457F58C4C0F@chook.melbourne.sgi.com> <47C3BBF9.8090403@sandeen.net>
In-Reply-To: <47C3BBF9.8090403@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>> Please pull from the for-linus branch:
>>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
>>
>> This will update the following files:
>>
>>  fs/xfs/xfs_bit.c     |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/xfs/xfs_bit.h     |   27 ++-----------
>>  fs/xfs/xfs_rtalloc.c |   19 ++++++---
>>  3 files changed, 120 insertions(+), 29 deletions(-)
> 
> what's the thought on fixing the ikeep regression for 2.6.25?
I think the thought is we need to!  Niv is looking into which way we are
going to fix it (Barry came up with an alternative) and I'll send out a git
pull request as soon as we've checked in the fix.

> 
> -Eric
> 
>> through these commits:
>>
>> commit ef8ece55d9b6825c28a5c1a4bd89b94040cb7b32
>> Author: Lachlan McIlroy <lachlan@sgi.com>
>> Date:   Tue Feb 26 17:00:22 2008 +1100
>>
>>     [XFS] Undo bit ops cleanup mod due to regression on 32-bit powermac
>>     platform.
>>     
>>     SGI-PV: 971186
>>     SGI-Modid: xfs-linux-melb:xfs-kern:30559a
>>     
>>     Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
>>
>> commit db69c915e67705daac25cad06d816c09be634de0
>> Author: Lachlan McIlroy <lachlan@sgi.com>
>> Date:   Tue Feb 26 17:00:14 2008 +1100
>>
>>     [XFS] Undo bit ops cleanup mod due to regression on 32-bit powermac
>>     platform.
>>     
>>     SGI-PV: 974005
>>     SGI-Modid: xfs-linux-melb:xfs-kern:30558a
>>     
>>     Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
>>
>>
> 
> 
