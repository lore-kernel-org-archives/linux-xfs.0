Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 20:19:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3E3JPgm009023
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 20:19:27 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A87F19C4B0B
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 20:20:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id JPbZ1PSCZyqmClfQ for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 20:20:04 -0700 (PDT)
Message-ID: <4802CD62.4040201@sandeen.net>
Date: Sun, 13 Apr 2008 22:20:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch] xfsqa - 166 - fix filter for stripe aligned filesystems
References: <20080411033628.GN103491721@sgi.com> <nccprstf7yg.fsf@sgi.com>
In-Reply-To: <nccprstf7yg.fsf@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@cxhome.ath.cx>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Niv Sardi wrote:
> Looks good, one minor comment.
> 
> David Chinner <dgc@sgi.com> writes:
> 
>> Flags has extra bits set in it xfs_bmap output when
>> the filesyste is using stripe alignment. Fix the test
>> to only look at the unwritten flag. Capture the xfs_bmap
>> output as well so failures can be debugged easily.
>>
>> Signed-off-by: Dave Chinner <dgc@sgi.com>
>> ---
>>  xfstests/166 |   17 ++++++++++-------
>>  1 file changed, 10 insertions(+), 7 deletions(-)
>>
>> Index: xfs-cmds/xfstests/166
>> ===================================================================
>> --- xfs-cmds.orig/xfstests/166	2008-03-25 15:29:35.000000000 +1100
>> +++ xfs-cmds/xfstests/166	2008-04-11 13:33:31.220068950 +1000
>> @@ -17,6 +17,7 @@ here=`pwd`
>>  tmp=/tmp/$$
>>  status=1    # failure is the default!
>>  trap "_cleanup; exit \$status" 0 1 2 3 15
>> +rm $seq.full
> 
> rm -f ? so that it doesn't complain when file is not there ?

All other tests do use rm -f here, it seems.

-Eric
