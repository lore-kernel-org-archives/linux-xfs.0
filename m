Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A9587F51
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 08:53:56 -0600 (CST)
Message-ID: <530E0007.9080806@sgi.com>
Date: Wed, 26 Feb 2014 08:53:59 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] [RFC] xfs: byte range buffer dirty region tracking
References: <1393194354-12780-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1393194354-12780-1-git-send-email-david@fromorbit.com>
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

On 02/23/14 16:25, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
> Switching this to just track the first and last modified bytes in
> the block and only converting that to a dirty bitmap in the buffer
> log item at format time, however, gets rid of most of this dirty
> bitmap overhead without increasing memcpy time  at all. the result
> is that peformance on a 64k directory block size increases to
> roughly 16,000 files/s with memcpy() overhead only slightly
> increasing.

Looks interesting. 4 regions seems reasonable to me.


--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
