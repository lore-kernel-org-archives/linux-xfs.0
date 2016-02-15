Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 511EC29DF5
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 17:07:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E7D25AC004
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 15:07:21 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fr3Bfhom7noVB7t9 for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 15:07:20 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id CF89463C5FF0
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 17:07:19 -0600 (CST)
Subject: Re: [PATCH 3/3] xfs: test for valid remount options, error if not
References: <56BBC982.50804@redhat.com> <56BBCB9D.6080404@sandeen.net>
	<20160215202521.GI14668@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56C25A26.3030909@sandeen.net>
Date: Mon, 15 Feb 2016 17:07:18 -0600
MIME-Version: 1.0
In-Reply-To: <20160215202521.GI14668@dastard>
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



On 2/15/16 2:25 PM, Dave Chinner wrote:
> I think hiding a goto like this is wrong - it forces you to go read
> the macro, making the code harder to read and follow. Really, what's
> wrong with the simple and obvious:
> 
> 
> 	if (bad option) {
> 		bad_option = "bad option string";
> 		goto out_warn;
> 	}
> 	.....
> 
> out_warn:
> 	xfs_warn(mp, "%s options may not be changed via remount",
> 		 bad_option);
> 	// free stuff
> 	return -EINVAL;
> }
> 
> Yes, I know that this sort of logic flow hiding was done with the
> XFS_WANT_CORRUPTED macros, but they were written back in 90s on Irix
> when using macros to implement everything were all the rage.

Yeah, fair point, not sure why I did that ;)  Old habits?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
