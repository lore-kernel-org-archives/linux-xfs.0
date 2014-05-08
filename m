Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BEA537F55
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 15:40:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A254E8F8035
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 13:40:55 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HWSTrqRqGAh9h4RU for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 13:40:54 -0700 (PDT)
Message-ID: <536BEBD9.4060604@sandeen.net>
Date: Thu, 08 May 2014 15:40:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Remove xfs_check for 3.2.0?
References: <536BCF95.201@sandeen.net> <20140508203936.GV5421@dastard>
In-Reply-To: <20140508203936.GV5421@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 5/8/14, 3:39 PM, Dave Chinner wrote:
> On Thu, May 08, 2014 at 01:40:21PM -0500, Eric Sandeen wrote:
>> I think we had stated removal in June 2014, but it seems close enough.
>>
>> Should xfs_check be removed prior to 3.2.0's release?
> 
> I'd prefer to do it slightly later than earlier.
> 
> As it is, 3.2.0 is really in the "critical fixes only" stage - like
> that repair prefetch bug. So apart from fixes like that, I don't
> want to be changing things right now.
> 
> Cheers,
> 
> Dave.
> 

*shrug* ok.  Let a thousand "hey my xfs_check OOM'd" emails blossom! :)

FWIW, I did not have time to work on that prefetch bug yet today.  :(

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
