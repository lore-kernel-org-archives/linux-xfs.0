Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CCFD27F8B
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 05:48:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6B9E3AC003
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 03:48:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EdAidQDd1ttWDPS1 for
	<xfs@oss.sgi.com>; Mon, 17 Mar 2014 03:48:39 -0700 (PDT)
Date: Mon, 17 Mar 2014 11:48:30 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/6 v2] ext4: Update inode i_size after the preallocation
In-Reply-To: <20140317030201.GE14162@thunk.org>
Message-ID: <alpine.LFD.2.00.1403171148130.30625@localhost.localdomain>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
	<1393355679-11160-2-git-send-email-lczerner@redhat.com>
	<20140317030201.GE14162@thunk.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Sun, 16 Mar 2014, tytso@mit.edu wrote:

> Date: Sun, 16 Mar 2014 23:02:01 -0400
> From: tytso@mit.edu
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 1/6 v2] ext4: Update inode i_size after the preallocation
> 
> On Tue, Feb 25, 2014 at 08:14:34PM +0100, Lukas Czerner wrote:
> > Currently in ext4_fallocate we would update inode size, c_time and sync
> > the file with every partial allocation which is entirely unnecessary. It
> > is true that if the crash happens in the middle of truncate we might end
> > up with unchanged i size, or c_time which I do not think is really a
> > problem - it does not mean file system corruption in any way. Note that
> > xfs is doing things the same way e.g. update all of the mentioned after
> > the allocation is done.
> > 
> > This commit moves all the updates after the allocation is done. In
> > addition we also need to change m_time as not only inode has been change
> > bot also data regions might have changed (unwritten extents). However
> > m_time will be only updated when i_size changed.
> > 
> > Also we do not need to be paranoid about changing the c_time only if the
> > actual allocation have happened, we can change it even if we try to
> > allocate only to find out that there are already block allocated. It's
> > not really a big deal and it will save us some additional complexity.
> > 
> > Also use ext4_debug, instead of ext4_warning in #ifdef EXT4FS_DEBUG
> > section.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Further testing has shown that this patch (applied on top of the ext4
> dev branch) is causing a regression failure of xfstests shared/243.
> 
> Could you take a look?
> 
> 						- Ted

Hi Ted,

I am looking into this. Thanks!

-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
