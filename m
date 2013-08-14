Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 390BA7FBF
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 04:31:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5C11AC001
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 02:31:15 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id WDdJI02NChua3elB for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 02:31:14 -0700 (PDT)
Date: Wed, 14 Aug 2013 11:31:10 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
Message-ID: <20130814093110.GB12015@quack.suse.cz>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
	<520A9A2F.5090009@sgi.com> <20130813212242.GA9158@quack.suse.cz>
	<1376433544.971.38.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1376433544.971.38.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Abhijith Das <adas@redhat.com>, Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>

On Tue 13-08-13 17:39:04, Chandra Seetharaman wrote:
> On Tue, 2013-08-13 at 23:22 +0200, Jan Kara wrote:
> > Hi,
> > 
> >   Neither me nor linux-fsdevel has been CCed on this change. Please do that
> 
> Jan,
> 
> All the CC in the email you got were from my original email. I did CC
> you and linux-fsdevel when I sent this patchset a week ago
> (http://oss.sgi.com/archives/xfs/2013-08/msg00171.html). 
> 
> I am confused on what happened and how you didn't get the original
> email. Just now I checked linux-fsdevel archive. I do not see it there
> either. Bizarre. (May be something wrong in the way I used
> git-send-email)
> 
> Sorry.
  No problem.

> > next time. Now looking into the patch in xfs mailing list archive I have
> > one comment: You declare:
> > struct fs_quota_statv {
> > 	__s8			qs_version;	/* version for future changes */
> > 	__u8			qs_pad1;	/* pad for 16bit alignment */
> > 	__u16			qs_flags;	/* FS_QUOTA_.* flags */
> > 	__u32			qs_incoredqs;	/* number of dquots incore */
> > 	struct fs_qfilestatv	qs_uquota;	/* user quota information */
> > 	struct fs_qfilestatv	qs_gquota;	/* group quota information */
> > 	struct fs_qfilestatv	qs_pquota;	/* project quota information */
> > 	__s32			qs_btimelimit;  /* limit for blks timer */
> > 	__s32			qs_itimelimit;  /* limit for inodes timer */
> > 	__s32			qs_rtbtimelimit;/* limit for rt blks timer */
> > 	__u16			qs_bwarnlimit;	/* limit for num warnings */
> > 	__u16			qs_iwarnlimit;	/* limit for num warnings */
> > 	__u64			qs_pad2[8];	/* for future proofing */
> > };
> > 
> > Now do you really need qs_pad2 field? Since the structure is properly
> > versioned now, even its size can vary between versions, cannot it?
> 
> Yes, it can.
> 
> I added the pad based on Dave Chinner's suggestion:
  OK, makes sense. So I'm ok with the patch. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> ----------
> > > Dave:
> > > > > future enhancements, maybe we should add 64 bytes of empty
> > > > > space at the end of the structure....
> > > > Chandra:
> > > > Since this version is fully backward compatible, I didn't think a 
> > > > future pad was needed. Do you want me to add ?
> > > Dave:
> > > We only really need to change the structure version when we change
> > > input parameters, the size or the shape of the structure being
> > > passed in from userspace. If we add padding now, then we can expand
> > > output of the call without needing to bump the version of the
> > > structure. Old code simply won't know (or care) about the new output
> > > in the region of the structure it considers empty padding....
> > Chandra:
> > Ok. I will all 64 bytes of additional padding at the end.
> > Otherwise the patch looks fine.
> > 
> ----------
> 
> His argument convinced me to add the padding. What do you think ?
> 
> 
> > 								Honza
> > 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
