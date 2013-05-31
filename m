Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BB9DA7F37
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 07:09:15 -0500 (CDT)
Message-ID: <51A89322.5090302@sgi.com>
Date: Fri, 31 May 2013 07:10:10 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: Fix test wildcard expansion.
References: <51A7CC6B.3030607@sgi.com> <51A7D390.3040108@sgi.com>
	<20130530223823.GS29466@dastard>
In-Reply-To: <20130530223823.GS29466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfstests <xfs@oss.sgi.com>

On 05/30/2013 05:38 PM, Dave Chinner wrote:
> On Thu, May 30, 2013 at 05:32:48PM -0500, Rich Johnston wrote:
>>
>> Before commit 38d58591 "xfstests: fix typo in check",
>> check xfs/[0-9]?? would execute all tests/xfs/[0-9]?? because:
>>
>> Change to use egrep to fix the parsing.
>>
>> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>> ---
>> V1-V2
>> Use egrep instead of my bulky method
>
> looks like you lost a bit of the commit message. Otherwise it works
> fine here ;)
Oops dang cut/paste, I put it back.
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>
Thanks for the review Dave.

commit 9267afb16b8e861888e54f829015667753034980
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Fri May 31 07:02:48 2013 -0500

     xfstests: Fix test wildcard expansion.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
