Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C0B9D7CB7
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 03:19:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42380AC001
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 01:19:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DPc9gasvKg9EV6Ms for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 01:19:51 -0700 (PDT)
Date: Tue, 12 Apr 2016 18:19:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
	after disk failure/recovery
Message-ID: <20160412081935.GH9088@dastard>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
	<20160322121922.GA53693@bfoster.bfoster>
	<232dd85fde11d4ef1625f070eabfd167@mail.gmail.com>
	<20160408224648.GD567@dastard>
	<CAOcd+r0s3FfahxaqfJKuZ_D+0FbUHaKqi8b_bwGbXekCN3w_oQ@mail.gmail.com>
	<20160411012127.GF567@dastard>
	<0cfd6b7bfb3ef9dbac02a19a1f8fe568@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0cfd6b7bfb3ef9dbac02a19a1f8fe568@mail.gmail.com>
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
To: Shyam Kaushik <shyam@zadarastorage.com>
Cc: Brian Foster <bfoster@redhat.com>, Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Tue, Apr 12, 2016 at 12:29:48PM +0530, Shyam Kaushik wrote:
> Hi Dave,
> 
> I posted the patch.
> 
> After applying this patch & your use-after-free patch,
> xfs_ail_push_all_sync() processing intent-logs that are no longer relevant
> upon disk failure/recovery doesn't happen anymore. I tried several times
> to recreate and the issue doesn't show up.

OK, so that confirms we are leaking inodes at that spot. I'll have a
look at the patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
