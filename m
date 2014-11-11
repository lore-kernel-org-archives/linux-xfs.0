Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 57D857F89
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 17:26:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 36CEA8F8033
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:26:37 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	uhZeijuATid84YEF for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 15:26:36 -0800 (PST)
Date: Wed, 12 Nov 2014 10:26:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11] xfs: Remove some useless flags tests
Message-ID: <20141111232634.GV28565@dastard>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
	<1415739865-2438-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415739865-2438-4-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 11, 2014 at 10:04:17PM +0100, Jan Kara wrote:
> 'flags' have XFS_ALL_QUOTA_ACCT cleared immediately on function entry.
> There's no point in checking these bits later in the function. Also
> because we check something is going to change, we know some enforcement
> bits are being added and thus there's no point in testing that later.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks sane. I'll pick this up straight away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
