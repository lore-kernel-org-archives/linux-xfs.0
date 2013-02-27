Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D16D77F37
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 09:07:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1036304066
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 07:07:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0jkdU0SmpZxye50l for
	<xfs@oss.sgi.com>; Wed, 27 Feb 2013 07:07:34 -0800 (PST)
Date: Wed, 27 Feb 2013 10:07:15 -0500
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: pvmove corrupting XFS filesystems (was Re: [BUG] Internal error
	xfs_dir2_data_reada_verify)
Message-ID: <20130227150715.GA4492@redhat.com>
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
	<20130227010414.GD1514@agk.fab.redhat.com>
	<20130227014900.GY5551@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130227014900.GY5551@dastard>
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
Cc: dm-devel@redhat.com, xfs@oss.sgi.com, Matteo Frigo <athena@fftw.org>

On Tue, Feb 26 2013 at  8:49pm -0500,
Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Feb 27, 2013 at 01:04:14AM +0000, Alasdair G Kergon wrote:
> > (Quick pointers that might be relevant)
> > 
> > EAGAIN, I'm not aware of dm itself returning that on the i/o path.
> 
> Neither am I, but it's coming from somewhere in the IO path...
> 
> > For 3.8 issues, read dm-devel around https://www.redhat.com/archives/dm-devel/2013-February/msg00086.html
> > (I queued the dm-side fixes for linux-next earlier today)
> 
> It's reproducable on lots of different kernels, apparently - 3.8,
> 3.4.33, CentOS 6.3, debian sid/wheezy and Fedora 18 were mentioned
> specifically by the OP - so it doesn't look like a recent
> regression or constrained to a specific kernel.
> 
> > For pvmove, check exactly which version and whether discards are enabled: there
> > was a userspace bug for a short period some time ago when discards were enabled.
> 
> The version I used to reproduce on a 3.8.0 kernel was:
> 
> $ pvmove --version
>   LVM version:     2.02.95(2) (2012-03-06)
>   Library version: 1.02.74 (2012-03-06)
>   Driver version:  4.23.1

Was issue_discards enabled in lvm.conf?

If so, as Alasdair said, this lvm2 2.02.97 fix is needed:
http://git.fedorahosted.org/cgit/lvm2.git/commit/?id=07a25c249b3e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
