Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E4397F4E
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 15:13:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C9DB8F8049
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 13:12:59 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	eSYgbzULShGjHFHZ for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 13:12:56 -0800 (PST)
Date: Thu, 22 Jan 2015 08:12:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: buffer types need to be set
Message-ID: <20150121211247.GK16510@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150121171110.GE20357@quack.suse.cz>
	<20150121160757.GA20357@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Wed, Jan 21, 2015 at 05:07:57PM +0100, Jan Kara wrote:
>   Thanks for a quick response with patches. My test round has finished and
> the new assertion didn't trigger so things look fine. I've also provided a
> test kernel to the guy seeing these issues in the wild but there it took
> days / weeks to trigger so I wouldn't wait for it...

Given the timing requirement to hit the logging condition just
right, then to crash immeidately afterwards, I'm not surprised it
has taken this long to be uncovered in the wild...

> BTW, this should be stable material I guess (just that I didn't
> see CC to stable in the patches).

Probably should - I hadn't even thought that far ahead.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
