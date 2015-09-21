Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1DD937F37
	for <xfs@oss.sgi.com>; Sun, 20 Sep 2015 20:20:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE7918F8033
	for <xfs@oss.sgi.com>; Sun, 20 Sep 2015 18:20:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	AG67sAYn9sGkPdiN for <xfs@oss.sgi.com>;
	Sun, 20 Sep 2015 18:19:52 -0700 (PDT)
Date: Mon, 21 Sep 2015 11:19:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fstests: Add test of rename
Message-ID: <20150921011950.GK26895@dastard>
References: <1440495730-14093-1-git-send-email-jack@suse.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1440495730-14093-1-git-send-email-jack@suse.com>
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
To: Jan Kara <jack@suse.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 25, 2015 at 11:42:10AM +0200, Jan Kara wrote:
> Test renaming of various entry types in directories of various sizes.
> Check that filesystem didn't get corrupted.
> 
> Signed-off-by: Jan Kara <jack@suse.com>
> ---
>  tests/generic/326   | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/group |  1 +
>  2 files changed, 94 insertions(+)
>  create mode 100755 tests/generic/326

Missing an output file. I'll fix it on commit.

> +if _check_scratch_fs; then
> +	_echofull "Scratch fs is fine after renames"
> +	status=0
> +fi

This happens automatically now as a result of _require_scratch being
called, so I'll remove it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
