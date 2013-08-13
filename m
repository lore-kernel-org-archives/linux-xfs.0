Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF9247F8E
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 16:22:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF1618F804C
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 14:22:45 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id rDUj7AoHky5de7zb for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 14:22:44 -0700 (PDT)
Date: Tue, 13 Aug 2013 23:22:42 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
Message-ID: <20130813212242.GA9158@quack.suse.cz>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
	<520A9A2F.5090009@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520A9A2F.5090009@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Jan Kara <jack@suse.cz>, Chandra Seetharaman <sekharan@us.ibm.com>, Abhijith Das <adas@redhat.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>

  Hi,

  Neither me nor linux-fsdevel has been CCed on this change. Please do that
next time. Now looking into the patch in xfs mailing list archive I have
one comment: You declare:
struct fs_quota_statv {
	__s8			qs_version;	/* version for future changes */
	__u8			qs_pad1;	/* pad for 16bit alignment */
	__u16			qs_flags;	/* FS_QUOTA_.* flags */
	__u32			qs_incoredqs;	/* number of dquots incore */
	struct fs_qfilestatv	qs_uquota;	/* user quota information */
	struct fs_qfilestatv	qs_gquota;	/* group quota information */
	struct fs_qfilestatv	qs_pquota;	/* project quota information */
	__s32			qs_btimelimit;  /* limit for blks timer */
	__s32			qs_itimelimit;  /* limit for inodes timer */
	__s32			qs_rtbtimelimit;/* limit for rt blks timer */
	__u16			qs_bwarnlimit;	/* limit for num warnings */
	__u16			qs_iwarnlimit;	/* limit for num warnings */
	__u64			qs_pad2[8];	/* for future proofing */
};

Now do you really need qs_pad2 field? Since the structure is properly
versioned now, even its size can vary between versions, cannot it?
Otherwise the patch looks fine.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
