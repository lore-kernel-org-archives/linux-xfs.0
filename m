Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 266DB7FAF
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 01:54:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7D5C304043
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 23:54:45 -0800 (PST)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	5aGPuSZLNpDfYxYB for <xfs@oss.sgi.com>;
	Mon, 09 Dec 2013 23:54:44 -0800 (PST)
Date: Mon, 9 Dec 2013 23:56:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: XFS security fix never sent to -stable?
Message-ID: <20131210075621.GA30135@kroah.com>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
	<20131209121534.GE4278@hercules>
	<CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
	<20131209235523.GW31386@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209235523.GW31386@dastard>
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
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Luis Henriques <luis.henriques@canonical.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Dwight Engen <dwight.engen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Gao feng <gaofeng@cn.fujitsu.com>, Kees Cook <keescook@google.com>

On Tue, Dec 10, 2013 at 10:55:23AM +1100, Dave Chinner wrote:
> [cc xfs list, cc stable@vger.kernel.org]
> 
> On Mon, Dec 09, 2013 at 08:17:09AM -0500, Josh Boyer wrote:
> > On Mon, Dec 9, 2013 at 7:15 AM, Luis Henriques
> > <luis.henriques@canonical.com> wrote:
> > > On Thu, Dec 05, 2013 at 04:35:50PM -0800, Kees Cook wrote:
> > >> Hi,
> > >>
> > >> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
> > >> capability check to free eofblocks ioctl") is a security fix that was
> > >> never sent to -stable? From what I can see, it was introduced in 3.8
> > >> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
> > >> XFS_IOC_FREE_EOFBLOCKS ioctl").
> > >>
> > >> I don't see this in the 3.8.y tree. Should it be added there and newer?
> > >
> > > Thanks Kees, I'm queuing it for the 3.11 kernel.
> > 
> > There's also this one:
> > 
> > http://thread.gmane.org/gmane.comp.file-systems.xfs.general/57654
> > 
> > It fixes CVE-2013-6382
> 
> First I've heard about it there being a CVE for that bug. Since when
> has it been considered best practice to publish CVEs without first
> (or ever) directly contacting the relevant upstream developers?
> 
> But, regardless of how broken I think the CVE process is, commit
> 071c529 ("xfs: underflow bug in xfs_attrlist_by_handle()") should be
> picked up by the stable kernels.

I don't see that commit in Linus's tree, is it not there yet?

thanks,

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
