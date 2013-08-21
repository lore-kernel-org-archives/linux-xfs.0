Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 63C118011
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 13:12:51 -0500 (CDT)
Date: Wed, 21 Aug 2013 13:12:47 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
Message-ID: <20130821181247.GL5262@sgi.com>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
	<20130821064357.GA8822@infradead.org>
	<20130821130152.GA9709@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130821130152.GA9709@quack.suse.cz>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, Abhijith Das <adas@redhat.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>

Hey Jan, Christoph,

On Wed, Aug 21, 2013 at 03:01:52PM +0200, Jan Kara wrote:
> On Tue 20-08-13 23:43:57, Christoph Hellwig wrote:
> > Sorry for being late to the game, but I don not like the in-kernel
> > interface here at all.  Given that Q_XGETQSTATV is a strict superset
> > of Q_XGETQSTAT there is no need for the second method - just always
> > fill out the larger in-kernel structure and only copy the smaller
> > information to userspace for the Q_XGETSTAT case.  That keeps the amount
> > of code required in the implementations of the methods low and follows
> > the model used elsewhere in the kernel (e.g. stat and statfs)

So you don't like the addition of .get_xstatev in quotactl_ops, and
fs_quota_stat would need to match with fs_quota_statv, adding the project quota
to the end of the structure?

>   Well, the trouble is with gquota vs pquota - previously we report in
> qs_gquota field either group quotas or project quotas depending on what is
> turned on. Generic quota code doesn't know this so xfs get_xstatev() would
> have to recognize whether it is being called from the old Q_XGETSTAT
> quotactl or from the new Q_XGETSTATV quotactl to know where to fill in
> project quotas. And at that point you somewhat loose the elegancy of using
> one interface - we could set qs_version to some special value so that
> .get_xstatev() recognizes this and does the magic but that doesn't seem very
> different from the extra call...

IIUC to make this happen without the addition of .get_xstate in quotactl_ops,
.get_xstate could also grow an argument to determine whether it was called as
Q_XGETSTAT vs Q_XGETSTATV.  If called as Q_XGETSTATV it can look at qs_version
to determine how much to copy.  That might be a bit cleaner than the qs_version
magic number, as long as you don't mind changing the .get_xstate interface.

> Some duplication could be certainly avoided within XFS itself.

Chandra may have taken this route to limit the possibility of breaking the old
interface...

Anyway, please give a shout if I need to revert this.  I believe the commit
raced with the commentary.  ;)

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
