Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 394F07F37
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 21:17:38 -0500 (CDT)
Date: Thu, 11 Jul 2013 21:17:34 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v11 2/4] xfs: Start using pquotaino from the superblock.
Message-ID: <20130712021734.GA32736@sgi.com>
References: <1373518843-1492-1-git-send-email-sekharan@us.ibm.com>
	<1373518843-1492-3-git-send-email-sekharan@us.ibm.com>
	<20130711211610.GC20932@sgi.com>
	<1373591398.20769.9.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373591398.20769.9.camel@chandra-dt.ibm.com>
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
Cc: xfs@oss.sgi.com

Hey Chandra,

On Thu, Jul 11, 2013 at 08:09:58PM -0500, Chandra Seetharaman wrote:
> On Thu, 2013-07-11 at 16:16 -0500, Ben Myers wrote:
> > Hey Chandra,
> > 
> > On Thu, Jul 11, 2013 at 12:00:41AM -0500, Chandra Seetharaman wrote:
> > > Start using pquotino and define a macro to check if the
> > > superblock has pquotino.
> > > 
> > > Keep backward compatibilty by alowing mount of older superblock
> > > with no separate pquota inode.
> > > 
> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > 
> > Here are a few notes from my review.
> > 
> > > +		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
> > > +			xfs_notice(mp,
> > > +			   "Version 5 of Super block has XFS_OQUOTA bits.\n");
> > > +			return XFS_ERROR(EFSCORRUPTED);
> > > +		}
> > 
> > If I'm reading that right... Now if you had a v5 super block with oquota
> > bits it will become unmountable.  Could that happen if you were using
> > crcs and quotas with a 3.10 kernel and then upgrade?
> 
> yes. My thinking is that v5 (with crc) is still experimental and not
> supported yet. Not true ?

Right.  v5 superblock is still experimental.

> Previously this was being fixed without failing. But, Dave suggested
> that this certainly would be an inconsistent state and hence need to be
> failed. I agreed and changed the code.

Sounds fine.  I just wanted to make sure we're all aware of this possibility.

> The problem you stated can be fixed by adding functionality to
> xfs_repair. 

Maybe a workaround for those users would be to shut of quotas before upgrading,
      and then turn them back on after?

> > 
> > >  		xfs_sb_version_addquota(&mp->m_sb);
> > >  		mp->m_sb.sb_uquotino = NULLFSINO;
> > >  		mp->m_sb.sb_gquotino = NULLFSINO;
> > > +		mp->m_sb.sb_pquotino = NULLFSINO;
> > >  
> > > -		/* qflags will get updated _after_ quotacheck */
> > > -		mp->m_sb.sb_qflags = 0;
> > > +		/* qflags will get updated fully _after_ quotacheck */
> > > +		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
> > 
> > I didn't quite catch why you changed from 0 to ALL_QUOTA_ACCT here, will
> > take another look.
> 
> We wanted to move all (well, almost all :) the logic of managing
> PQUOTINO/GQUOTINO in older superblock in just the two functions
> xfs_sb_quota_to/from_disk(). In order to do that I had to use sb_qflags
> (you can see that in xfs_sb_quota_to_disk()). So, we have to have
> sb_qflags valid before we try to write these fields to the disk. Hence
> this change.

Oh, that explains it.  Thanks.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
