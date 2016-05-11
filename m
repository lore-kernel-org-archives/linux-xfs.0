Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 919E17CA0
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 19:10:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 478158F8049
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 17:09:57 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	uecXqg0Yy1jb4UVL for <xfs@oss.sgi.com>;
	Tue, 10 May 2016 17:09:54 -0700 (PDT)
Date: Wed, 11 May 2016 10:09:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs_quota: print quota id number if the name can't be
	found
Message-ID: <20160511000940.GJ26977@dastard>
References: <1460040514-23834-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460040514-23834-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Thu, Apr 07, 2016 at 10:48:34PM +0800, Zorro Lang wrote:
> When use GETNEXTQUOTA ioctl to report project quota, it always
> report an unexpected quota:
> 
>   (null) 0 0 0 00 [--------]
> 
> The ID 0 store the default quota, even if no one set default quota,
> it still have quota accounting, but not enforced. So GETNEXTQUOTA
> can find and report this undefined quota.
> 
> From this problem, I thought if others' quota name miss, (null) will
> be printed too. e.g.
> 
>   # xfs_quota -xc "limit -u bsoft=300m bhard=400m test" $mnt
>   # xfs_quota -xc "report -u" $mnt
>   User ID          Used       Soft       Hard    Warn/Grace
>   ---------- --------------------------------------------------
>   root                0          0          0     00 [--------]
>   test                0     307200     409600     00 [--------]
>   # userdel -r test
>   # xfs_quota -xc "report -u" $mnt
>   User ID          Used       Soft       Hard    Warn/Grace
>   ---------- --------------------------------------------------
>   root                0          0          0     00 [--------]
>   (null)              0     307200     409600     00 [--------]
> 
> So this problem same with above id 0's problem. For deal with this,
> this patch will print id number if the name can't be found.
> 
> But if use old GETQUOTA ioctl, it won't print project id 0 quota
> information(if it's not defined). That's different with GETNEXTQUOTA.
> For keep consistent, this patch also print project id 0 when use old
> GETQUOTA.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

OK, so with this applied xfs/133 and xfs/134 both now fail with
this extra output:

+#0 0 0 0 00 [--------]

Can you send patches for these tests to filter out these lines so
that the tests pass again for both old and new xfsprogs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
