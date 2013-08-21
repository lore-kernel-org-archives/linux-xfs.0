Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB7638011
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 13:19:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 78173AC001
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 11:19:22 -0700 (PDT)
Date: Wed, 21 Aug 2013 11:19:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
Message-ID: <20130821181919.GA21378@infradead.org>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
	<20130821064357.GA8822@infradead.org>
	<20130821130152.GA9709@quack.suse.cz>
	<20130821181247.GL5262@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130821181247.GL5262@sgi.com>
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
Cc: Jan Kara <jack@suse.cz>, Chandra Seetharaman <sekharan@us.ibm.com>, Abhijith Das <adas@redhat.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>

On Wed, Aug 21, 2013 at 01:12:47PM -0500, Ben Myers wrote:
> So you don't like the addition of .get_xstatev in quotactl_ops, and
> fs_quota_stat would need to match with fs_quota_statv, adding the project quota
> to the end of the structure?

That was what I had in mind initially, before the additional
complication were pointed out, except that we don't need it to look
exactly the same - if we use put_user calls instead of copy_to_user that
layout doesn't have to be the same.

However it seems like going down the stat route and having a kquota_info
structure might be the better way to fully separate the in-kernel API
from the userspace ABI.

> >   Well, the trouble is with gquota vs pquota - previously we report in
> > qs_gquota field either group quotas or project quotas depending on what is
> > turned on. Generic quota code doesn't know this so xfs get_xstatev() would
> > have to recognize whether it is being called from the old Q_XGETSTAT
> > quotactl or from the new Q_XGETSTATV quotactl to know where to fill in
> > project quotas. And at that point you somewhat loose the elegancy of using
> > one interface - we could set qs_version to some special value so that
> > .get_xstatev() recognizes this and does the magic but that doesn't seem very
> > different from the extra call...
> 
> IIUC to make this happen without the addition of .get_xstate in quotactl_ops,
> .get_xstate could also grow an argument to determine whether it was called as
> Q_XGETSTAT vs Q_XGETSTATV.  If called as Q_XGETSTATV it can look at qs_version
> to determine how much to copy.  That might be a bit cleaner than the qs_version
> magic number, as long as you don't mind changing the .get_xstate interface.

I don't think we'd need that argument - the fs would always fill out
both fields, then the implementation of Q_XGETSTAT would:

 (1) fail if both group and project quota information is present
 (2) export the pquota fields as gqouta if only project quota is present

> Anyway, please give a shout if I need to revert this.  I believe the commit
> raced with the commentary.  ;)

As this is in-kernel only I don't think we need to revert anything, but
it would be nice to fix it before 3.12 is released.  I didn't exactly
race either, your reply to Jan made me look a it a bit more.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
