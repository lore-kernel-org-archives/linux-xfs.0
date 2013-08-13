Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67E007F80
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 17:22:27 -0500 (CDT)
Message-ID: <520AB1A1.1090803@sgi.com>
Date: Tue, 13 Aug 2013 17:22:25 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
	<520A9A2F.5090009@sgi.com> <20130813212242.GA9158@quack.suse.cz>
In-Reply-To: <20130813212242.GA9158@quack.suse.cz>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>, Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On 08/13/2013 04:22 PM, Jan Kara wrote:
>    Hi,
>
>    Neither me nor linux-fsdevel has been CCed on this change. Please do that
> next time. Now looking into the patch in xfs mailing list archive I have
Did you mean the email or the commit header?

As far as I can see you and linux-fsdevel were CCed on this entire email 
thread.

--Rich

> one comment: You declare:
> struct fs_quota_statv {
> 	__s8			qs_version;	/* version for future changes */
> 	__u8			qs_pad1;	/* pad for 16bit alignment */
> 	__u16			qs_flags;	/* FS_QUOTA_.* flags */
> 	__u32			qs_incoredqs;	/* number of dquots incore */
> 	struct fs_qfilestatv	qs_uquota;	/* user quota information */
> 	struct fs_qfilestatv	qs_gquota;	/* group quota information */
> 	struct fs_qfilestatv	qs_pquota;	/* project quota information */
> 	__s32			qs_btimelimit;  /* limit for blks timer */
> 	__s32			qs_itimelimit;  /* limit for inodes timer */
> 	__s32			qs_rtbtimelimit;/* limit for rt blks timer */
> 	__u16			qs_bwarnlimit;	/* limit for num warnings */
> 	__u16			qs_iwarnlimit;	/* limit for num warnings */
> 	__u64			qs_pad2[8];	/* for future proofing */
> };
>
> Now do you really need qs_pad2 field? Since the structure is properly
> versioned now, even its size can vary between versions, cannot it?
> Otherwise the patch looks fine.
>
> 								Honza
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
