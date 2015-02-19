Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F17787F5E
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 15:41:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DEE308F8039
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:41:15 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zCm259RDFjcZ5zuE for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 13:41:14 -0800 (PST)
Message-ID: <54E65878.2000302@sandeen.net>
Date: Thu, 19 Feb 2015 15:41:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Introduce permanent async buffer write IO failures
References: <1424298740-25821-1-git-send-email-david@fromorbit.com>
	<20150219142842.GA2291@laptop.bfoster>
In-Reply-To: <20150219142842.GA2291@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 2/19/15 8:28 AM, Brian Foster wrote:
> On Thu, Feb 19, 2015 at 09:32:20AM +1100, Dave Chinner wrote:

...

>> +	if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL))) {
>> +		bp->b_flags |= XBF_WRITE | XBF_ASYNC |
>> +			       XBF_DONE | XBF_WRITE_FAIL;
>> +		xfs_buf_submit(bp);
>> +		return true;

so, shouldn't

		xfs_buf_ioerror(bp, 0);

go under this conditional to address Brian's point... ok, you just responded to that. :)

FWIW, this is re-setting XBF_ASYNC which must already be set, right?
 
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
