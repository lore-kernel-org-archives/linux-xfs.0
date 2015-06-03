Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CABB7F91
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 09:19:16 -0500 (CDT)
Message-ID: <556F0CE0.8080402@sgi.com>
Date: Wed, 03 Jun 2015 09:19:12 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] [RFC v2] xfs: byte range buffer dirty region tracking
References: <1432865777-14616-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1432865777-14616-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On 05/28/15 21:16, Dave Chinner wrote:
> Discussion:
>
> I think that we will eventually need to track multiple regions - 3
> is probably sufficient - because the nature of directory operations
> are that just about every operation modifies a header in the buffer,
> a tail section in the buffer and then some number of bytes/regions
> in the middle of the buffer.

Nod to the idea.

What made you change from your original idea of using 4 regions to 3 
regions?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
