Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E30977F52
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 16:48:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 81A94AC00D
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 14:48:34 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id I37s5WYaqCEmEDxU (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 14:48:32 -0700 (PDT)
Date: Tue, 22 Apr 2014 23:48:28 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V2] xfs: fix Q_XQUOTARM ioctl
Message-ID: <20140422214828.GL366@quack.suse.cz>
References: <535580A1.20806@redhat.com> <5356B986.2060906@sandeen.net>
	<20140422213051.GL18672@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140422213051.GL18672@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wed 23-04-14 07:30:51, Dave Chinner wrote:
> On Tue, Apr 22, 2014 at 01:48:38PM -0500, Eric Sandeen wrote:
> > The Q_XQUOTARM quotactl was not working properly, because
> > we weren't passing around proper flags.  The xfs_fs_set_xstate()
> > ioctl handler used the same flags for Q_XQUOTAON/OFF as
> > well as for Q_XQUOTARM, but Q_XQUOTAON/OFF look for
> > XFS_UQUOTA_ACCT, XFS_UQUOTA_ENFD, XFS_GQUOTA_ACCT etc,
> > i.e. quota type + state, while Q_XQUOTARM looks only for
> > the type of quota, i.e. XFS_DQ_USER, XFS_DQ_GROUP etc.
> > 
> > Unfortunately these flag spaces overlap a bit, so we
> > got semi-random results for Q_XQUOTARM; i.e. the value
> > for XFS_DQ_USER == XFS_UQUOTA_ACCT, etc.  yeargh.
> > 
> > Add a new quotactl op vector specifically for the QUOTARM
> > operation, since it operates with a different flag space.
> > 
> > This has been broken more or less forever, AFAICT.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> 
> Looks fine to me, but I'll need Jan to ack it before I pull it in.
  The patch looks good to me as well. So feel free to add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
