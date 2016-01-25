Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F3997CBD
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 09:07:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9385304059
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 07:07:01 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id Swla8qqZM3264JHw (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2016 07:06:59 -0800 (PST)
Date: Mon, 25 Jan 2016 16:07:10 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/7 V3] quota: add new quotactl Q_GETNEXTQUOTA
Message-ID: <20160125150710.GN24938@quack.suse.cz>
References: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
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
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

On Fri 22-01-16 12:25:29, Eric Sandeen wrote:
> This adds a new quotactl, Q_GETNEXTQUOTA.
> 
> Q_GETNEXTQUOTA is exactly like Q_GETQUOTA, except that it will
> return quota information for the id equal to or greater than
> the id requested.  In other words, if the specified id has
> no quota, the command will return quota information for the
> next higher id which does have a quota set.  If no higher id
> has an active quota, -ESRCH is returned.
> 
> So if you ask for id X, you can get back quota for id X,
> id X+N, or -ESRCH if no higher id has a quota.
> 
> This allows filesystems to do efficient iteration in kernelspace,
> much like extN filesystems do in userspace when asked to report
> all active quotas.
> 
> Today, filesystems such as XFS require getpwent()-style iterations,
> and for systems which have i.e. LDAP backends, this can be very
> slow, or even impossible if iteration is not allowed in the
> configuration.
> 
> Patches 1 and 4 are just small fixups that turned up along the way;
> 2 and 3 add the actual quota plumbing, and the rest are xfs-specific
> to allow xfs to support this new interface.
> 
> For non-xfs quota, this does require a new structure which is
> able to pass back the discovered ID along with the quota info.
> For xfs-quota, the id is already present in the structure.
> 
> V3:
> * Remove 32-bit compat stuff (i686/x86_64 at least works w/o it...)
> * Require CAP_SYS_ADMIN for these calls
> * Pass back found ID in &qid passed to ->get_nextdqblk, rather
>   than modifying struct qc_dqblk
> * Munge that found ID back through user-namespace conversions
>   before returning it in the user structure.

So I've taken patch 1/7 into my tree since that is completely independent.
Patches 2/7 and 3/7 look mostly good to me (except for that small omission
in 3/7) so I can take them to my tree as well. Once I'll finish testing
some UDF changes I have pending I'll push the tree to:

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_next

and Dave can pull from there to have a basis for XFS patches. I want to
implement Q_GETNEXTQUOTA for VFS quota formats as well and those will go
through my tree so that's why I want the interface changes go via my tree.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
