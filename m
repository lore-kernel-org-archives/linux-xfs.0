Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5AAu2BK070073 for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 05:56:02 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7B461D57D28
	for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 03:58:35 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id JhUREZhy9ZObRo1n for <xfs@oss.sgi.com>;
	Thu, 10 Jun 2010 03:58:35 -0700 (PDT)
Date: Thu, 10 Jun 2010 12:58:14 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
Message-ID: <20100610105813.GB10827@quack.suse.cz>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
	<1274710459-11446-5-git-send-email-jack@suse.cz>
	<4C0FD43D.3040803@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C0FD43D.3040803@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed 09-06-10 12:49:49, Eric Sandeen wrote:
> Jan Kara wrote:
> > Run fsx (and also several fsx threads in parallel) and verify that
> > quota accounting is correct after they finish.
> 
> Jan, I'm having trouble with this one on XFS for some reason, with our 
> RHEL6 kernel and quota-3.17...
> 
> +Disabling group quota enforcement and accounting on /dev/mapper/VolGroup00-testvol2
> +Disabling user quota enforcement and accounting on /dev/mapper/VolGroup00-testvol2
> +repquota: Mountpoint (or device) /mnt/testarea/scratch not found or has no quota enabled.
> +repquota: Not all specified mountpoints are using quota.
> +repquota: Mountpoint (or device) /mnt/testarea/scratch not found or has no quota enabled.
> +repquota: Not all specified mountpoints are using quota.
> 
> ...
> 
> however if I remove the quotaon calls (off / on settings) in check_usage()
> then it works:
> 
> check_usage()
> {
>         # quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
>         repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
>                 >$tmp.orig
>         quotacheck -u -g $SCRATCH_MNT 2>/dev/null
>         repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
>                 >$tmp.checked
>         # quotaon -u -g $SCRATCH_MNT 2>/dev/null
>         diff $tmp.orig $tmp.checked
> }
> 
> 
> Seems like 2 issues: noisy disable messages, and repquota failing when disabled.
  I've fixed noisy disable messages in quotaon (without -v flag only errors
should be printed) in CVS. With repquota & disabled quotas it's a bit more
complicated. The problem is that for ext?, reiserfs,... you have to disable
quotas before running quotacheck. Also quotacheck is NOP for XFS - we'd
rather need to call something to really recompute quota usage for XFS. How
that can be done?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
