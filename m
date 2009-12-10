Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBAN2kUk123839 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 17:02:46 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B69A0E9779
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:03:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 13jLxs9RFLZzasFF for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:03:21 -0800 (PST)
Message-ID: <4B217E31.70107@sandeen.net>
Date: Thu, 10 Dec 2009 17:03:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: update bmap help text
References: <4B216FCF.5010108@sandeen.net>
	<20091210224408.GB30608@discord.disaster>
In-Reply-To: <20091210224408.GB30608@discord.disaster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Dec 10, 2009 at 04:01:51PM -0600, Eric Sandeen wrote:
>> Trivial addition of missing argument help text.
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>> ---
>>
>> iff --git a/io/bmap.c b/io/bmap.c
>> index f79cf8c..5c4cf48 100644
>> --- a/io/bmap.c
>> +++ b/io/bmap.c
>> @@ -43,6 +43,9 @@ bmap_help(void)
>>  " -a -- prints the attribute fork map instead of the data fork.\n"
>>  " -d -- suppresses a DMAPI read event, offline portions shown as holes.\n"
>>  " -l -- also displays the length of each extent in 512-byte blocks.\n"
>> +" -n -- query n extents.\n"
>> +" -p -- obtain all unwritten extents as well (w/ -v show which are unwritten.\n"
> 
> Closing ')"?

details details!  ;)  And with that I have your review? :)

Thanks,
-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
