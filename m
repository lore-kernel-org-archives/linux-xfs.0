Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3111A7F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 21:06:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1147230408D
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 19:06:29 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hv8fpbaQnOvyfX9h for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 19:06:27 -0800 (PST)
Date: Wed, 25 Feb 2015 14:04:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v10 10/12] xfstests: fsstress: Add fallocate insert range
	operation
Message-ID: <20150225030451.GG4251@dastard>
References: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
	<1424533554-28024-11-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424533554-28024-11-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Sun, Feb 22, 2015 at 12:45:52AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This commit adds insert operation support for fsstress, which is
> meant to exercise fallocate FALLOC_FL_INSERT_RANGE support.

This causes xfs/068 to fail because it changes the file creation
pattern that results from a specific fsstress random seed. As such,
I added this to xfs/068:

FSSTRESS_AVOID="-f insert=0 $FSSTRESS_AVOID"

To turn off the insert operation for that test and hence produce the
expected tree of files.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
