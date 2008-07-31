Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jul 2008 22:04:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6V545Jk031541
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 22:04:06 -0700
Message-ID: <4891496D.8040102@sgi.com>
Date: Thu, 31 Jul 2008 15:11:09 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.27
References: <20080731025328.6328358C4C3F@chook.melbourne.sgi.com> <48913AFD.9050407@sandeen.net>
In-Reply-To: <48913AFD.9050407@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
> 
> ...
> 
>> Eric Sandeen (3):
>>       [XFS]
>>       [XFS] Pack some shortform dir2 structures for the ARM old ABI
>>       [XFS] Disable queue flag test in barrier check.
> 
> Lachlan, you might want to fix up that blank summary as well?

Sorry about that Eric.

The summary is in the commit log - the committer started the log with a blank line.

    de-duplicate calls to xfs_attr_trace_enter
    
    Every call to xfs_attr_trace_enter() shares the exact same 16 args in the
    middle... just send in the context pointer and let the next level down
    split it into the ktrace.


> 
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
