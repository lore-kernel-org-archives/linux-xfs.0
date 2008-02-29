Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 23:39:40 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1T7dSUl010990
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 23:39:31 -0800
Message-ID: <47C7B6C2.4030304@sgi.com>
Date: Fri, 29 Feb 2008 18:39:46 +1100
From: Timothy Shimmin <tes@sgi.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, lachlan@sgi.com, xfs@oss.sgi.com

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
> 
Yes it would.
One needs the signed-off-by's.
 From our sgi internal web page...

==============================================================================
Bad ptool checkin descriptions

Bad checkin descriptions for XFS to ptools are ones which are missing a one
line overall description and ones where the mod has an external author and
there is no Signed-Off-By lines for him/her.

So what you need to have is:...
The first line to be a summary description.  Then if you need further details,
then add a blank line followed by more details in further paragraphs.
Then end with the signed-off-by's.  The script needs signed-off-by to determine
real author and Linus uses the first line as a summary line in his summary code.

The script will look at the ptools mod reviewer list to add in further
signed-off-by's when it gets converted to git.  So you only need 1 signed-off-by
for the external author and if it is just an internal author, you don't need any
signed-off-bys.  (And yes ideally, the reviewers should probably be acked-by...
it is on the TODO list).
==============================================================================

--Tim
