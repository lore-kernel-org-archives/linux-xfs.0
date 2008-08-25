Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 15:11:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7PMBHDL029601
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 15:11:18 -0700
Received: from millhouse.houseofnate.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C821F3CCD0E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 15:12:39 -0700 (PDT)
Received: from millhouse.houseofnate.net (dsl092-086-237.bos1.dsl.speakeasy.net [66.92.86.237]) by cuda.sgi.com with ESMTP id yZAtmLfHoIgB0TFq for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 15:12:39 -0700 (PDT)
Message-ID: <48B32E36.7060305@houseofnate.net>
Date: Mon, 25 Aug 2008 18:12:06 -0400
From: "Nathaniel W. Turner" <nate@houseofnate.net>
MIME-Version: 1.0
Subject: XFS_BUF_ORDERED instead of XFS_BUF_ISORDERED?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi folks,

While doing a little light reading, I noticed the following in 
fs/xfs/xfs_log.c:1011 (in the 2.6.26.3 Linux kernel tree).  Am I missing 
something, or should XFS_BUF_ORDERED be replaced with XFS_BUF_ISORDERED 
in this check?

nate


        /*
         * If the ordered flag has been removed by a lower
         * layer, it means the underlyin device no longer supports
         * barrier I/O. Warn loudly and turn off barriers.
         */
        if ((l->l_mp->m_flags & XFS_MOUNT_BARRIER) && 
!XFS_BUF_ORDERED(bp)) {
                l->l_mp->m_flags &= ~XFS_MOUNT_BARRIER;
                xfs_fs_cmn_err(CE_WARN, l->l_mp,
                                "xlog_iodone: Barriers are no longer 
supported"
                                " by device. Disabling barriers\n");
                xfs_buftrace("XLOG_IODONE BARRIERS OFF", bp);
        }
