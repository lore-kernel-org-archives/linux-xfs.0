Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 905487F51
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 16:45:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 719BF8F8050
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 14:45:17 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	lnr2Bu4c0PjSQI1V for <xfs@oss.sgi.com>;
	Thu, 06 Feb 2014 14:45:15 -0800 (PST)
Date: Fri, 7 Feb 2014 09:45:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/3] btrfs/035: add new clone overwrite regression test
Message-ID: <20140206224509.GC13647@dastard>
References: <1391695154-2039-1-git-send-email-ddiss@suse.de>
	<1391695154-2039-4-git-send-email-ddiss@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391695154-2039-4-git-send-email-ddiss@suse.de>
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
To: David Disseldorp <ddiss@suse.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Feb 06, 2014 at 02:59:14PM +0100, David Disseldorp wrote:
> This test uses the newly added cloner binary to dispatch full file and
> range specific clone (reflink) requests.

....
> +
> +echo -n "$src_str" > $SCRATCH_MNT/src || echo "failed to create src"

Not exactly what I intended.

If echo fails, it will output some kind of error message, and that
will cause the golden image mismatch.

Otherwise the test looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
