Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0824929DF8
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 14:27:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E49F78F8052
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 12:27:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cQfz72tvkjDyRkUA for <xfs@oss.sgi.com>;
	Wed, 29 May 2013 12:27:18 -0700 (PDT)
Message-ID: <51A65696.1050900@sandeen.net>
Date: Wed, 29 May 2013 14:27:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATH 0/9] xfs: fixes for 3.10-rc4
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<20130528175627.GZ20028@sgi.com> <20130528235424.GY29466@dastard>
	<20130529190122.GE19505@sgi.com>
In-Reply-To: <20130529190122.GE19505@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 5/29/13 2:01 PM, Ben Myers wrote:
> Hi Dave,
> 
> On Wed, May 29, 2013 at 09:54:24AM +1000, Dave Chinner wrote:

<giant snip>

>> I'd much prefer that we don't have to add code to 3.11 to reject any
>> CRC-enabled filesystem without any feature bits set because we don't
>> support a broken remote attr format that was fixed weeks before 3.10
>> released but was not allowed to be fixed in 3.10. That's just crazy
>> from any release management perspective you care to look at it from.
> 
> So would I.
>  
>> Ben, if the problem is that you can't review all the fixes in a timely
>> manner, then we can fix that. I'm sure that Mark, Eric and Brian can
>> help review the code if this is the sticking point.
> 
> Reviews are always welcome...

But it won't matter for the sake of this argument, sounds like?

<another snip>

> A worse outcome is that I pull in this code and something goes very
> wrong for the thousands of users of 3.10 with existing non-crc XFS
> filesystems.  A feature bit and some inconvenience for a few XFS
> developers and testers is a safer choice.

Your concern (rightly) seems to be stability for non-crc users, so:

I'll review these patches with a special eye towards if/how they
affect any non-crc codepaths.  If it's wholly contained in crc
code, you can merge them without fear.  Sound like a deal?

-Eric

> Regards,
> Ben
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
