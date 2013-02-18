Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 17B7F7F53
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 16:12:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 069878F8035
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 14:12:51 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	n8BcqbhCLCoTULa7 for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 14:12:50 -0800 (PST)
Date: Tue, 19 Feb 2013 09:12:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 100: do not use scratch
Message-ID: <20130218221248.GC26694@dastard>
References: <1361173911-12422-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361173911-12422-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 18, 2013 at 08:51:51AM +0100, Lukas Czerner wrote:
> Test #100 does not use scratch device at all but it still
> _require_scratch and _check_scratch_fs. This might also be a problem if
> the test before this one failed and corrupted scratch partition.
> 
> Remove the _require_scratch() and _check_scratch_fs() from the test.

Actaully, I think it should be using scratch - have  a look at where
TEMP_DIR is located. Yeah, it's /tmp, not the scratch device.

i.e. it should be using the TEST_DIR rather than tmp for building
the tarball, and scratch for restoring it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
