Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CDF177F4E
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 16:30:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A730C8F8040
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 14:30:55 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZcXFAzkNNOFa8zQM for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 14:30:53 -0700 (PDT)
Date: Wed, 23 Apr 2014 07:30:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: fix Q_XQUOTARM ioctl
Message-ID: <20140422213051.GL18672@dastard>
References: <535580A1.20806@redhat.com>
 <5356B986.2060906@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5356B986.2060906@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 22, 2014 at 01:48:38PM -0500, Eric Sandeen wrote:
> The Q_XQUOTARM quotactl was not working properly, because
> we weren't passing around proper flags.  The xfs_fs_set_xstate()
> ioctl handler used the same flags for Q_XQUOTAON/OFF as
> well as for Q_XQUOTARM, but Q_XQUOTAON/OFF look for
> XFS_UQUOTA_ACCT, XFS_UQUOTA_ENFD, XFS_GQUOTA_ACCT etc,
> i.e. quota type + state, while Q_XQUOTARM looks only for
> the type of quota, i.e. XFS_DQ_USER, XFS_DQ_GROUP etc.
> 
> Unfortunately these flag spaces overlap a bit, so we
> got semi-random results for Q_XQUOTARM; i.e. the value
> for XFS_DQ_USER == XFS_UQUOTA_ACCT, etc.  yeargh.
> 
> Add a new quotactl op vector specifically for the QUOTARM
> operation, since it operates with a different flag space.
> 
> This has been broken more or less forever, AFAICT.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks fine to me, but I'll need Jan to ack it before I pull it in.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
