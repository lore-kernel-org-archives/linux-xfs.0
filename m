Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JFT4cL112523 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 10:29:05 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Z20W6RlT5fmscnlh for
	<xfs@oss.sgi.com>; Tue, 19 Jun 2012 08:29:03 -0700 (PDT)
Date: Tue, 19 Jun 2012 11:28:56 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and	discard
Message-ID: <20120619152856.GB7225@redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
	<alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
	<20120619141933.GC10637@thunk.org>
	<20120619144316.GD14208@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120619144316.GD14208@agk-dp.fab.redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>, =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Spelic <spelic@shiftmail.org>

On Tue, Jun 19 2012 at 10:43am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Tue, Jun 19, 2012 at 10:19:33AM -0400, Ted Ts'o wrote:
> > One of the things which would be nice to be able to easily set up is a
> > configuration where we get the benefits of thin provisioning with
> > respect to snapshost, but where the underlying block device used by
> > the file system is contiguous.  
> 
> We're tracking this requirement (for lvm2) here:
>   https://bugzilla.redhat.com/show_bug.cgi?id=814737

That is an lvm2 BZ but there is further kernel work needed.

It should be noted that the "external origin" feature was added to the
thinp target with this commit: 
http://git.kernel.org/linus/2dd9c257fbc243aa76ee6d

It is start, but external origin is kept read-only and any writes
trigger allocation of new blocks within the thin-pool.

We've talked some about the desire to have a fully provisioned volume
that only starts to get fragmented once snapshots are taken.  The idea
is to move the origin into the data volume, via mapping, rather than
copying:

Dec 14 10:37:08 <ejt> we then build a data dev that consists of a linear mapping to that origin
Dec 14 10:37:12 <ejt> plus some extra stuff
Dec 14 10:37:23 <ejt> (the additonal free space for snapshots)
Dec 14 10:37:49 <ejt> we then prepare thinp metadata with a mapping to that origin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
