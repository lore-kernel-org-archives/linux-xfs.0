Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 22:11:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C5BCWt001407
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 22:11:15 -0700
Message-ID: <466E2B76.7010707@sgi.com>
Date: Tue, 12 Jun 2007 15:13:26 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: Review: factor extracting extent size hints from the inode
References: <20070604052333.GR85884050@sgi.com>
In-Reply-To: <20070604052333.GR85884050@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> Replace frequently repeated, open coded extraction of the
> extent size hint from the xfs_inode with a single helper
> function.
>
> Cheers,
>
> Dave.
>   
Dave,

I think XFS_DIFLAG_REALTIME and XFS_DIFLAG_EXTSIZE flags are
mutually exclusive.
XFS_DIFLAG_REALTIME and di_extsize have been introduced and used
on Irix and Linux before XFS_DIFLAG_EXTSIZE.
This code:

+	if (unlikely(ip->i_d.di_flags & XFS_DIFLAG_REALTIME)) {
+		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
+				? ip->i_d.di_extsize
+				: ip->i_mount->m_sb.sb_rextsize;
+		ASSERT(extsz);
+	} else {

shouldn't test for XFS_DIFLAG_EXTSIZE but use di_extsize if non zero.


Regards,
Vlad 
