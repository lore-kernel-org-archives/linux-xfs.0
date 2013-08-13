Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 70E3E7F86
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 17:39:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE2DFAC002
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 15:39:09 -0700 (PDT)
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159]) by
	cuda.sgi.com with ESMTP id yRSkE9mkknUzLw5q (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 15:39:09 -0700 (PDT)
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 13 Aug 2013 16:39:08 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id D82E719D8045
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 16:38:52 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7DMd5Eo087180 for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 16:39:05 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r7DMd5VH019406
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 16:39:05 -0600
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130813212242.GA9158@quack.suse.cz>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
	<520A9A2F.5090009@sgi.com>  <20130813212242.GA9158@quack.suse.cz>
Date: Tue, 13 Aug 2013 17:39:04 -0500
Message-ID: <1376433544.971.38.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Abhijith Das <adas@redhat.com>, Rich Johnston <rjohnston@sgi.com>, Steven Whitehouse <swhiteho@redhat.com>, xfs@oss.sgi.com

On Tue, 2013-08-13 at 23:22 +0200, Jan Kara wrote:
> Hi,
> 
>   Neither me nor linux-fsdevel has been CCed on this change. Please do that

Jan,

All the CC in the email you got were from my original email. I did CC
you and linux-fsdevel when I sent this patchset a week ago
(http://oss.sgi.com/archives/xfs/2013-08/msg00171.html). 

I am confused on what happened and how you didn't get the original
email. Just now I checked linux-fsdevel archive. I do not see it there
either. Bizarre. (May be something wrong in the way I used
git-send-email)

Sorry.

> next time. Now looking into the patch in xfs mailing list archive I have
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

Yes, it can.

I added the pad based on Dave Chinner's suggestion:

----------
> > Dave:
> > > > future enhancements, maybe we should add 64 bytes of empty
> > > > space at the end of the structure....
> > > Chandra:
> > > Since this version is fully backward compatible, I didn't think a 
> > > future pad was needed. Do you want me to add ?
> > Dave:
> > We only really need to change the structure version when we change
> > input parameters, the size or the shape of the structure being
> > passed in from userspace. If we add padding now, then we can expand
> > output of the call without needing to bump the version of the
> > structure. Old code simply won't know (or care) about the new output
> > in the region of the structure it considers empty padding....
> Chandra:
> Ok. I will all 64 bytes of additional padding at the end.
> Otherwise the patch looks fine.
> 
----------

His argument convinced me to add the padding. What do you think ?


> 								Honza
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
