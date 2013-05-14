Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 87E1B7CBF
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 00:33:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23A26AC001
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 22:33:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2LBL7CQ1p5M5FEtB for
	<xfs@oss.sgi.com>; Mon, 13 May 2013 22:33:40 -0700 (PDT)
Message-ID: <1368509609.2507.8.camel@cr0>
Subject: Re: [Patch] quota: do not leak info to user-space
From: Cong Wang <amwang@redhat.com>
Date: Tue, 14 May 2013 13:33:29 +0800
In-Reply-To: <20130513101839.GE400@quack.suse.cz>
References: <1368177873-4819-1-git-send-email-amwang@redhat.com>
	<20130513100423.GD400@quack.suse.cz>
	<20130513101839.GE400@quack.suse.cz>
Mime-Version: 1.0
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
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, 2013-05-13 at 12:18 +0200, Jan Kara wrote:
> On Mon 13-05-13 12:04:23, Jan Kara wrote:
> > On Fri 10-05-13 17:24:33, Cong Wang wrote:
> > > From: Cong Wang <amwang@redhat.com>
> > > 
> > > There is a hole in struct fs_quota_stat, so we have to
> > > zero the struct on stack before copying it to user-space.
> > > 
> > > Cc: Jan Kara <jack@suse.cz>
> > > Signed-off-by: Cong Wang <amwang@redhat.com>
> >   Good point. I've merged the patch.
>   Ah, now I've noticed that XFS (the only user of the callback you are
> fixing) is zeroing the structure on its own (xfs_qm_scall_getqstat). So
> there's no real problem. I'm somewhat wondering whether clearing the field
> in the place where you did it isn't more future-proof but usually we don't
> pass in prezeroed buffers so I've decided to leave things as they are.
> 

You are right. Thanks for looking into this!


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
