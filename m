Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 491397F8A
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 21:30:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 374CF8F806F
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 19:30:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0PPdeLLjl1jLSMgl for <xfs@oss.sgi.com>;
	Tue, 29 Jul 2014 19:30:29 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1XCJdv-0001Td-0d
	for xfs@oss.sgi.com; Wed, 30 Jul 2014 12:29:27 +1000
Date: Wed, 30 Jul 2014 12:29:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: catch buffers written without verifiers attached
Message-ID: <20140730022926.GL26465@dastard>
References: <1406684929-11133-1-git-send-email-david@fromorbit.com>
	<1406684929-11133-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406684929-11133-2-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Wed, Jul 30, 2014 at 11:48:46AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We recently had a bug where buffers were slipping through log
> recovery without any verifier attached to them. This was resulting
> in on-disk CRC mismatches for valid data. Add some warning code to
> catch this occurrence so that we catch such bugs durin development
> rather than not being aware they exist.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Oops, this is an old version - didn't refresh the patch properly,
see V2...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
