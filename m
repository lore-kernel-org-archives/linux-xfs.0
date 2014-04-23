Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C17DB7F52
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 10:27:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4BC19AC001
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 08:27:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id R6f4RFXDA0Zwx8cn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 08:27:10 -0700 (PDT)
Date: Wed, 23 Apr 2014 08:27:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs: fix Q_XQUOTARM ioctl
Message-ID: <20140423152708.GA3326@infradead.org>
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

Looks good for now:

Reviewed-by: Christoph Hellwig <hch@lst.de>

If you have a spare cycle or two I think splitting quotaon and quotaoff might
not be an all that bad idea either.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
