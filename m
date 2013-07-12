Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C25567F50
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 09:51:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8F8A8F8035
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 07:51:10 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id ZP4C81qqDYWcSWzG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Jul 2013 07:51:10 -0700 (PDT)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 12 Jul 2013 08:51:09 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 323D43E4005E
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 08:50:46 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6CEp2VP140420 for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 08:51:04 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6CEp2eR009231
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 08:51:02 -0600
Subject: Re: [PATCH v11 2/4] xfs: Start using pquotaino from the superblock.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130712021734.GA32736@sgi.com>
References: <1373518843-1492-1-git-send-email-sekharan@us.ibm.com>
	<1373518843-1492-3-git-send-email-sekharan@us.ibm.com>
	<20130711211610.GC20932@sgi.com>
	<1373591398.20769.9.camel@chandra-dt.ibm.com>
	<20130712021734.GA32736@sgi.com>
Date: Fri, 12 Jul 2013 09:51:02 -0500
Message-ID: <1373640662.20769.14.camel@chandra-dt.ibm.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, 2013-07-11 at 21:17 -0500, Ben Myers wrote:
> Hey Chandra,
> 
> On Thu, Jul 11, 2013 at 08:09:58PM -0500, Chandra Seetharaman wrote:
> > On Thu, 2013-07-11 at 16:16 -0500, Ben Myers wrote:
> > > Hey Chandra,
> > > 
> > > On Thu, Jul 11, 2013 at 12:00:41AM -0500, Chandra Seetharaman wrote:
> > > > Start using pquotino and define a macro to check if the
> > > > superblock has pquotino.
> > > > 
> > > > Keep backward compatibilty by alowing mount of older superblock
> > > > with no separate pquota inode.
> > > > 
> > > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > 
> > > Here are a few notes from my review.
> > > 
> > > > +		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
> > > > +			xfs_notice(mp,
> > > > +			   "Version 5 of Super block has XFS_OQUOTA bits.\n");
> > > > +			return XFS_ERROR(EFSCORRUPTED);
> > > > +		}
> > > 
> > > If I'm reading that right... Now if you had a v5 super block with oquota
> > > bits it will become unmountable.  Could that happen if you were using
> > > crcs and quotas with a 3.10 kernel and then upgrade?
> > 
> > yes. My thinking is that v5 (with crc) is still experimental and not
> > supported yet. Not true ?
> 
> Right.  v5 superblock is still experimental.
> 
> > Previously this was being fixed without failing. But, Dave suggested
> > that this certainly would be an inconsistent state and hence need to be
> > failed. I agreed and changed the code.
> 
> Sounds fine.  I just wanted to make sure we're all aware of this possibility.
> 
> > The problem you stated can be fixed by adding functionality to
> > xfs_repair. 
> 
> Maybe a workaround for those users would be to shut of quotas before upgrading,
>       and then turn them back on after?

That would work too.
> 
> > > 
> > > >  		xfs_sb_version_addquota(&mp->m_sb);
> > > >  		mp->m_sb.sb_uquotino = NULLFSINO;
> > > >  		mp->m_sb.sb_gquotino = NULLFSINO;
> > > > +		mp->m_sb.sb_pquotino = NULLFSINO;
> > > >  
> > > > -		/* qflags will get updated _after_ quotacheck */
> > > > -		mp->m_sb.sb_qflags = 0;
> > > > +		/* qflags will get updated fully _after_ quotacheck */
> > > > +		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
> > > 
> > > I didn't quite catch why you changed from 0 to ALL_QUOTA_ACCT here, will
> > > take another look.
> > 
> > We wanted to move all (well, almost all :) the logic of managing
> > PQUOTINO/GQUOTINO in older superblock in just the two functions
> > xfs_sb_quota_to/from_disk(). In order to do that I had to use sb_qflags
> > (you can see that in xfs_sb_quota_to_disk()). So, we have to have
> > sb_qflags valid before we try to write these fields to the disk. Hence
> > this change.
> 
> Oh, that explains it.  Thanks.
> 
> -Ben
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
