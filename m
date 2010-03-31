Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2VMVdQq062030 for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 17:31:40 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A79BBF7CE69
	for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 15:33:24 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	dgrocU9TP4i5yENF for <xfs@oss.sgi.com>;
	Wed, 31 Mar 2010 15:33:24 -0700 (PDT)
Date: Thu, 1 Apr 2010 09:33:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: made test 215 backwards compatible with
	older version of bash.
Message-ID: <20100331223321.GJ7671@dastard>
References: <1270062393-5233-1-git-send-email-akshaylal@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270062393-5233-1-git-send-email-akshaylal@google.com>
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
To: Akshay Lal <akshaylal@google.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 31, 2010 at 12:06:33PM -0700, Akshay Lal wrote:
> Test 215 fails on older versions of bash (2.x), mainly due to the use of
> 'let' for arithemetic operations. Changed to 'expr'.

If that is a problem for older bash versions, then there's going
systemic problems throughout the xfstests suite. The let expression
is used about 80 different places, and I don't see anything special
about test 215 that makes it any different from other uses. i might
be missing something, but there's not much context to go on from
your changelog....

Perhaps upgrading your version of bash might be a better approach?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
