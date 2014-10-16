Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D4C267F3F
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 08:28:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C2FC98F8033
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 06:28:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LmFMGZdRp8EKL860 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Oct 2014 06:28:16 -0700 (PDT)
Date: Thu, 16 Oct 2014 09:28:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs: use after free on error in xfs_qm_log_quotaoff()
Message-ID: <20141016132813.GA50649@bfoster.bfoster>
References: <20140219095305.GA22351@elgon.mountain>
	<20141015130535.GN26918@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141015130535.GN26918@mwanda>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 15, 2014 at 04:05:35PM +0300, Dan Carpenter wrote:
> This bug is still around.
> 
> regards,
> dan carpenter
> 
> On Wed, Feb 19, 2014 at 12:53:05PM +0300, Dan Carpenter wrote:
> > Smatch complains here.  I don't think I have reported this one before.
> > It feels very familiar but I have grepped my outbox.
> > 
> > 	fs/xfs/xfs_qm_syscalls.c:814 xfs_qm_log_quotaoff()
> > 	warn: 'tp' was already freed.
> > 

Heh, looks like this function also has a problem restoring flags. If the
reserve fails we restore flags to 0 rather than the old flags. I'll send
a patch shortly.

Brian

> > fs/xfs/xfs_qm_syscalls.c
> >    804          /*
> >    805           * We have to make sure that the transaction is secure on disk before we
> >    806           * return and actually stop quota accounting. So, make it synchronous.
> >    807           * We don't care about quotoff's performance.
> >    808           */
> >    809          xfs_trans_set_sync(tp);
> >    810          error = xfs_trans_commit(tp, 0);
> >                         ^^^^^^^^^^^^^^^^
> > This function frees tp.
> > 
> >    811  
> >    812  error0:
> >    813          if (error) {
> >    814                  xfs_trans_cancel(tp, 0);
> >                         ^^^^^^^^^^^^^^^^^
> > Use after free.
> > 
> >    815                  /*
> >    816                   * No one else is modifying sb_qflags, so this is OK.
> >    817                   * We still hold the quotaofflock.
> >    818                   */
> > 
> > regards,
> > dan carpenter
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
