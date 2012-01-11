Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BCEj3I165471 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 06:14:45 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dhdyVVtxigPGeINk for
	<xfs@oss.sgi.com>; Wed, 11 Jan 2012 04:14:43 -0800 (PST)
Date: Wed, 11 Jan 2012 13:14:29 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] xfstests: fix 251's cp -axT problem
In-Reply-To: <20120111114544.GE14423@infradead.org>
Message-ID: <alpine.LFD.2.00.1201111310060.5636@dhcp-27-109.brq.redhat.com>
References: <1326195560-4434-1-git-send-email-liubo2009@cn.fujitsu.com>
	<20120111114544.GE14423@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, Lukas Czerner <lczerner@redhat.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, 11 Jan 2012, Christoph Hellwig wrote:

> On Tue, Jan 10, 2012 at 07:39:20PM +0800, Liu Bo wrote:
> > When I ran xfstests, 251 got failed cause "cp -axT" did not work as wish:
> > cp: cannot overwrite directory `/mnt/scratch/1' with non-directory
> > 
> > With this patch, 251 has passed.
> 
> Why would cp give that message with a missing /?
> 
> I'm not against putting this in, but I'd like to understand what's going
> on.
> 
> Lukas, any idea?
> 

Hi Christoph,

the only reason I can think of is probably that Liu is accessing the
xfstests directory via symbolic link, hence the '$content' addresses the
symbolic link and cp is trying to overwrite the directory with
non-directory (symlink).

The fix is fine for both cases (xfstests as symlink and directory), confirmed
with a simple test.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
