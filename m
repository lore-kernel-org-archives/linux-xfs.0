Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5EAk22o037435 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 05:46:02 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79B6F3C4700
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 03:48:37 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id yCvI3KdZ8R41YWvD for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 03:48:37 -0700 (PDT)
Date: Mon, 14 Jun 2010 12:48:17 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
Message-ID: <20100614104817.GE3903@quack.suse.cz>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
	<1274710459-11446-5-git-send-email-jack@suse.cz>
	<4C0FD43D.3040803@sandeen.net>
	<20100610105813.GB10827@quack.suse.cz>
	<4C1117F3.2010008@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C1117F3.2010008@sandeen.net>
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

On Thu 10-06-10 11:50:59, Eric Sandeen wrote:
> Jan Kara wrote:
> > On Wed 09-06-10 12:49:49, Eric Sandeen wrote:
> >> Jan Kara wrote:
> >>> Run fsx (and also several fsx threads in parallel) and verify that
> >>> quota accounting is correct after they finish.
> >> Jan, I'm having trouble with this one on XFS for some reason, with our 
> >> RHEL6 kernel and quota-3.17...
> >>
> >> +Disabling group quota enforcement and accounting on /dev/mapper/VolGroup00-testvol2
> >> +Disabling user quota enforcement and accounting on /dev/mapper/VolGroup00-testvol2
> >> +repquota: Mountpoint (or device) /mnt/testarea/scratch not found or has no quota enabled.
> >> +repquota: Not all specified mountpoints are using quota.
> >> +repquota: Mountpoint (or device) /mnt/testarea/scratch not found or has no quota enabled.
> >> +repquota: Not all specified mountpoints are using quota.
> >>
> >> ...
> >>
> >> however if I remove the quotaon calls (off / on settings) in check_usage()
> >> then it works:
> >>
> >> check_usage()
> >> {
> >>         # quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
> >>         repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
> >>                 >$tmp.orig
> >>         quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> >>         repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
> >>                 >$tmp.checked
> >>         # quotaon -u -g $SCRATCH_MNT 2>/dev/null
> >>         diff $tmp.orig $tmp.checked
> >> }
> >>
> >>
> >> Seems like 2 issues: noisy disable messages, and repquota failing when disabled.
> >   I've fixed noisy disable messages in quotaon (without -v flag only errors
> > should be printed) in CVS. 
> 
> Ok, we should probably just add a filter for these so that it'll work
> on older versions.
  OK, will add that.

> > With repquota & disabled quotas it's a bit more
> > complicated. 
> 
> Hm I'm still woefully unfamiliar with quota intricacies.
> 
> It seems that after quotaon -f, repquota fails on xfs but works for ext*?
  Yes, because we disabled also accounting. But with your change to quota
tools it shouldn't be a problem anymore. Still I've added a test so that
we turn quotas off only for ext? and reiserfs so that the tests work with
older quota tools as well.

> Not sure if that's intended...
> 
> Also is there a reason to disable quota before repquota?  Is disable/enable
> around quotacheck enough?
  Yes, that would be enough.

> Hm on ext* I'm also getting differences from the expected output; I suspect
> due to selinux xattrs.  I'll try to get that fixed up.
  I'm seeing some quota miscomputations for ext4, but ext2 and ext3 work
fine for me. I didn't have time to look into why ext4 after quotacheck
reports different number of blocks. Maybe it's just delayed allocation,
maybe it's a real bug.

> > The problem is that for ext?, reiserfs,... you have to disable
> > quotas before running quotacheck. Also quotacheck is NOP for XFS - we'd
> > rather need to call something to really recompute quota usage for XFS. How
> > that can be done?
> 
> It's regenerated at mount time if needed.  I don't know that we have a
> method to force this recalculation...  I guess mounting with quotas disabled,
> unmounting, then mounting again w/ quotas on will do it.
  OK, I'll add this to the test.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
