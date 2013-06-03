Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3C807CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 14:08:29 -0500 (CDT)
Message-ID: <51ACE9A7.30208@sgi.com>
Date: Mon, 3 Jun 2013 14:08:23 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3 v2] 285: Fix test for ext4 in some configurations
References: <1369948905-6693-1-git-send-email-jack@suse.cz>
In-Reply-To: <1369948905-6693-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 05/30/2013 04:21 PM, Jan Kara wrote:
> In some configurations (e.g. 1 KB block size), ext4 can decide it is
> better to zero out several blocks rather than splitting unwritten
> extent. This changes results SEEK_HOLE / SEEK_DATA returns and thus the
> test fails. Fix the problem by disabling the feature for this test.
>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, this patch has been committed.

commit ce9d1cdd618eaea256356c81cfd579039169b999
Author: Jan Kara <jack@suse.cz>
Date:   Mon Jun 3 13:40:36 2013 -0500

     xfstests 285: Fix test for ext4 in some configurations

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
