Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 134FA7F81
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 08:41:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B77898F8035
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 06:41:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qtJR4YAcRxT3bkKd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jun 2014 06:41:27 -0700 (PDT)
Date: Thu, 26 Jun 2014 09:41:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/6] xfs: add xlog sysfs kobject and attribute handlers
Message-ID: <20140626134120.GE37470@bfoster.bfoster>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
	<1402060414-22075-5-git-send-email-bfoster@redhat.com>
	<20140626044719.GX4453@dastard>
	<20140626122854.GA37470@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140626122854.GA37470@bfoster.bfoster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 26, 2014 at 08:28:55AM -0400, Brian Foster wrote:
> On Thu, Jun 26, 2014 at 02:47:19PM +1000, Dave Chinner wrote:
> > On Fri, Jun 06, 2014 at 09:13:32AM -0400, Brian Foster wrote:
> > > Embed a kobject into the xfs log data structure (xlog). This creates a
> > > 'log' subdirectory for every XFS mount instance in sysfs. The lifecycle
> > > of the log kobject is tied to the lifecycle of the log.
> > > 
> > > Also define a set of generic attribute handlers associated with the log
> > > kobject in preparation for the addition of attributes.
> > 
> > The code works fine, but....
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c      |  9 +++++++++
> > >  fs/xfs/xfs_log_priv.h |  3 +++
> > >  fs/xfs/xfs_sysfs.c    | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_sysfs.h    |  1 +
> > >  4 files changed, 66 insertions(+)
> > > 
...
> > > diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> > > index 41365fe..f837527 100644
> > > --- a/fs/xfs/xfs_sysfs.c
> > > +++ b/fs/xfs/xfs_sysfs.c
...
> > > +
> > > +STATIC void
> > > +xfs_log_release(struct kobject *kobj)
> > > +{
> > > +	struct xlog *log = container_of(kobj, struct xlog, l_kobject);
> > > +
> > > +	complete(&log->l_kobject_complete);
> > > +}
> > 
> > If the release funtion is common with other types, then the xfs_kobj
> > structure is perfect for this use - it will prevent a heap of
> > duplicated release functions...
> > 
> 
> It's going to look virtually the same for every kobject. Unfortunately,
> it needs to go from kobj->xfs_object->xfs_kobj, so each type requires a
> unique definition. We might be able to just turn it into a macro or
> something that takes the appropriate info and reduces the clutter. I'll
> play around with it. Thanks.
> 

Oops, never mind. I didn't grok what we'd get handed back here,
apparently. We get the kobject, contained by the new xfs_kobj and
already carrying the completion. There's no need to reference the
outermost structure so this can be made generic.

Brian

> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
