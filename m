Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q37HAAmB045944 for <xfs@oss.sgi.com>; Sat, 7 Apr 2012 12:10:10 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	u5nF0qkEJOdmvi6R (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Apr 2012 10:10:07 -0700 (PDT)
Received: by obqv19 with SMTP id v19so4850258obq.26
	for <xfs@oss.sgi.com>; Sat, 07 Apr 2012 10:10:07 -0700 (PDT)
Message-ID: <4F8074EC.2030108@gmail.com>
Date: Sat, 07 Apr 2012 13:10:04 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<20352.28730.273834.568559@tree.ty.sabi.co.UK>
In-Reply-To: <20352.28730.273834.568559@tree.ty.sabi.co.UK>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 04/07/2012 12:50 PM, Peter Grandi wrote:

>    * Your storage layer does not seem to deliver parallel
>      operations: as the ~100MB/s overall 'ext4' speed and the
>      seek graphs show, in effect your 4+2 RAID6 performs in this
>      case as if it were a single drive with a single arm.

This is what lept out at me.  I retried a very similar test (pulled 
Icedtea 2.1, compiled it, tarred it, measured untar on our boxen).  I 
was getting a fairly consistent 4 +/- delta seconds.

Ignoring the rest of your post for brevity (basically to focus upon this 
one issue), I suspect that the observed performance issue has more to do 
with the RAID card, the disks, and the server than the file system.

100MB/s on some supposedly fast drives with a RAID card indicates that 
either the RAID is badly implemented, the RAID layout is suspect, or 
similar.  He should be getting closer to N(data disks) * BW(single disk) 
for something "close" to a streaming operation.

This isn't suggesting that he didn't hit some bug which happens to over 
specify use of ag=0, but he definitely had a weak RAID system (at best).

If he retries with a more capable system, or one with a saner RAID 
layout (16k chunk size?  For spinning rust?  Seriously?  Short stroking 
DB layout?), an agcount of 32 or higher, and still sees similar issues, 
then I'd be more suspicious of a bug.

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
