Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C5F27F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 15:02:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 349BD8F8087
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 13:01:57 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PDX0FWrSc0NvDwOi for <xfs@oss.sgi.com>;
	Tue, 17 Dec 2013 13:01:55 -0800 (PST)
Date: Wed, 18 Dec 2013 08:01:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 4/10] xfsprog: xfsio: Add support
	FALLOC_FL_COLLAPSE_RANGE for fallocate
Message-ID: <20131217210137.GF31386@dastard>
References: <1386511890-3794-1-git-send-email-linkinjeon@gmail.com>
	<52B08446.3080102@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52B08446.3080102@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org

On Tue, Dec 17, 2013 at 11:05:10AM -0600, Rich Johnston wrote:
> This patch stands alone and has been committed.
> 
> Thanks
> --Rich
> 
> commit ca692f162d36c871c9c1b6169136b2c70503f2d8
> Author: Namjae Jeon <namjae.jeon@samsung.com>
> Date:   Sun Dec 8 14:11:30 2013 +0000
> 
>     xfsprog: xfsio: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate

<sigh>

Rich, we've been here before:

19e73c9 Revert "[RESEND, 4/7] xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE"

Please go back and read the discussion that lead to that revert.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
