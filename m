Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5011729E07
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 14:45:38 -0500 (CDT)
Message-ID: <5176E4EE.7040005@sgi.com>
Date: Tue, 23 Apr 2013 14:45:50 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfsprogs: Fix manpages for missing or incorrect
	options
References: <5175BB8F.5090604@sandeen.net> <5175BC67.1000902@sandeen.net>
	<5176D46B.2030003@sgi.com> <5176E2AF.7080201@sandeen.net>
In-Reply-To: <5176E2AF.7080201@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 04/23/2013 02:36 PM, Eric Sandeen wrote:
> On 4/23/13 1:35 PM, Rich Johnston wrote:
>> Hey Eric,
>>
>> Couple of comments.
>>
>> 1. The OPTIONS are listed in several ways, (alphabetical order, same
>> order as they appear in the SYNOPSIS, ...). I don't really have a
>> preference, but as long as we are cleaning up the manpages, I suggest
>> we be consistent. (case insensitive alpha order maybe???)
>
> That'd make a fine followup patch, I agree! ;)  Re-ordering every
> manpage won't really be on my todo list soon, though.
>
Sounds good.
>> 2. How about making the -V option wording the same also?
>>      xfs_db and xfs_repair are:
>>             Prints out the current version number and exits.
>>                     ^^^^^^^^
>
> I suppose.  I'm not really sure anyone would care?
>
Not important just noting it ;)

>>      The others:
>>      man/man8/mkfs.xfs.8:Prints the version number and exits.
>>      man/man8/xfs_admin.8:Prints the version number and exits.
>>      man/man8/xfs_bmap.8:Prints the version number and exits.
>>      man/man8/xfs_check.8:Prints the version number and exits.
>>      man/man8/xfs_copy.8:Prints the version number and exits.
>>      man/man8/xfs_growfs.8:Prints the version number and exits. The
>>      man/man8/xfs_io.8:Prints the version number and exits.
>>      man/man8/xfs_logprint.8:Prints the version number and exits.
>>      man/man8/xfs_mkfile.8:Prints the version number and exits.
>>      man/man8/xfs_ncheck.8:Prints the version number and exits.
>>      man/man8/xfs_rtcp.8:Prints the version number and exits.
>>
>> 3. The following are missing the -V option in both the SYNOPSIS and OPTIONS sections.
>> (I did verify the -V option works for all commands)
>> man/man8/xfs_estimate.8
>> man/man8/xfs_freeze.8
>> man/man8/xfs_fsr.8
>> man/man8/xfs_mdrestore.8
>> man/man8/xfs_metadump.8
>> man/man8/xfs_quota.8
>> man/man8/xfs_repair.8
>
> not sure how I missed those, sorry.
Do you have time to add these?  This really the only todo for now I think.

>
>>
>> 4. The -V prints the version and exits, shouldn't all the SYNOPSIS look like this for the -V option?
>>
>> SYNOPSIS
>>         xfs_db [ -c cmd ] ... [ -i|r|x|F ] [ -f ] [ -l logdev ] ...
>>         xfs_db -V
>
> Probably.  -V is least important of the fixes; I'd be more inclined to just drop
> the -V changes and not spend a couple more hours rearranging manpages.
>
> This was fine work on a plane, but there are more pressing things to do now :(
Agreed

>
> Maybe some list-reader who wants some changelog glory could take this further?  :)
>
Yes a follow up patch works for me, any volunteers?

> -Eric
>
>> Regards
>> --Rich
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
