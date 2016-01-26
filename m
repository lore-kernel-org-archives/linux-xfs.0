Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07D4B7CA2
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 11:52:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8A29BAC003
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 09:52:01 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id zdYsICoVOTRe8CfU (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2016 09:51:55 -0800 (PST)
Date: Tue, 26 Jan 2016 18:52:05 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/7] quota: add new quotactl Q_XGETNEXTQUOTA
Message-ID: <20160126175205.GA29388@quack.suse.cz>
References: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
	<1453487136-12681-3-git-send-email-sandeen@redhat.com>
	<20160126125710.GA23820@quack.suse.cz>
	<56A78A09.5080307@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56A78A09.5080307@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue 26-01-16 09:00:25, Eric Sandeen wrote:
> On 1/26/16 6:57 AM, Jan Kara wrote:
> > On Fri 22-01-16 12:25:31, Eric Sandeen wrote:
> >> Q_XGETNEXTQUOTA is exactly like Q_XGETQUOTA, except that it
> >> will return quota information for the id equal to or greater
> >> than the id requested.  In other words, if the requested id has
> >> no quota, the command will return quota information for the
> >> next higher id which does have a quota set.  If no higher id
> >> has an active quota, -ESRCH is returned.
> > 
> > Actually, is -ESRCH the right return value? It seems XFS traditionally
> > returns -ENOENT when id doesn't exist. So that would look more logical to
> > me.
> 
> Hm, I was just going by the quotactl manpage, TBH, which says:
> 
>        ESRCH          No disc quota is found for the indicated user.
> 
> 
> But yes, you are right, it is ENOENT for xfs... argh.  I suppose the
> quotactl manpage could use an update as well, then.

Yeah, so VFS quotas use ESRCH when quota for particular fs is not enabled
(while ENOENT means device you passed in doesn't exist). So probably a
solution that keeps XFS and VFS interfaces most selfconsistent is to return
ENOENT from Q_XGETNEXTQUOTA and ESRCH from Q_GETNEXTQUOTA. I'll update your
patches in this sense in the comments and changelogs. But XFS patches
(which I don't carry) need updating the actual code...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
