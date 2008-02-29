Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 22:53:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1T6rhAq007989
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 22:53:45 -0800
Message-ID: <47C7AD58.3080207@sgi.com>
Date: Fri, 29 Feb 2008 17:59:36 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc4
References: <20080229035000.7B24058C4C0F@chook.melbourne.sgi.com> <47C78629.104@sandeen.net> <47C79078.4070504@sgi.com> <47C79BD8.4050708@sandeen.net> <47C7A92C.10007@sgi.com>
In-Reply-To: <47C7A92C.10007@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



Mark Goodwin wrote:
> 
> 
> Eric Sandeen wrote:
>> Lachlan McIlroy wrote:
>>> Eric Sandeen wrote:
>>>> Lachlan McIlroy wrote:
>>>>> Please pull from the for-linus branch:
>>>>>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
>>>>>
>>>>> This will update the following files:
>>>>>
>>>>>  fs/xfs/linux-2.6/xfs_super.c |   14 +++++++-------
>>>>>  fs/xfs/xfs_clnt.h            |    2 +-
>>>>>  fs/xfs/xfs_ialloc.c          |    2 +-
>>>>>  fs/xfs/xfs_mount.h           |    2 +-
>>>>>  fs/xfs/xfs_vfsops.c          |    4 ++--
>>>>>  5 files changed, 12 insertions(+), 12 deletions(-)
>>>>>
>>>>> through these commits:
>>>>>
>>>>> commit b7405bb65a83e819dd3b21a6d9636c279d9ce79a
>>>>> Author: Niv Sardi <xaiki@sgi.com>
>>>> um, I thought Jeff wrote that patch.
>>> I'm sure he did too.  Every now and then our ptools -> git merge 
>>> tools stuff up.
>>>
>>
>> IMHO it's worth finding out why; authorship should not be taken lightly.
>>
>> -Eric
> 
> yes I agree. Niv's take:
> Inspected by:  bnaujok,jeffpc
> and no Signed-off
> 
> Lachlan, would that have confused the scripts?

Maybe, I don't know - I didn't write them.  I suppose I could have fixed
the commit message but didn't think at the time it would be messed up.
Niv said he hacked the commit on OSS so that it has the correct author now.
The sooner we move to git the sooner we can get rid of these scripts.
