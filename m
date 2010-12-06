Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB6DWLMU247343 for <xfs@oss.sgi.com>; Mon, 6 Dec 2010 07:32:22 -0600
Received: from mail-out1.uio.no (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1425E1C9A27
	for <xfs@oss.sgi.com>; Mon,  6 Dec 2010 05:34:07 -0800 (PST)
Received: from mail-out1.uio.no (mail-out1.uio.no [129.240.10.57]) by
	cuda.sgi.com with ESMTP id HdtDnezJSwJ8nhO1 for
	<xfs@oss.sgi.com>; Mon, 06 Dec 2010 05:34:07 -0800 (PST)
Subject: Re: NFS corruption on ENOSPC (was: Re: Bugs in mkfs.xfs, device
	mapper, xfs, and /dev/ram)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <4CFCD4F2.10300@shiftmail.org>
References: <4CF7A539.1050206@shiftmail.org>
	<4CF7A9CF.2020904@shiftmail.org> <20101202230743.GZ16922@dastard>
	<4CF8F9BE.6000604@shiftmail.org> <20101206040940.GA16103@dastard>
	<4CFCD4F2.10300@shiftmail.org>
Date: Mon, 06 Dec 2010 08:33:55 -0500
Message-ID: <1291642435.3990.8.camel@heimdal.trondhjem.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Spelic <spelic@shiftmail.org>
Cc: linux-nfs@vger.kernel.org, linux-lvm@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, 2010-12-06 at 13:20 +0100, Spelic wrote:
> On 12/06/2010 05:09 AM, Dave Chinner wrote:
> >> [Files become sparse at nfs-server-side upon hitting ENOSPC if NFS client uses local writeback caching]
> >>
> >>
> >> It's nice that the NFS server does local writeback caching but it
> >> should also cache the filesystem's free space (and check it
> >> periodically, since nfs-server is presumably not the only process
> >> writing in that filesystem) so that it doesn't accept more data than
> >> it can really write. Alternatively, when free space drops below 1GB
> >> (or a reasonable size based on network speed), nfs-server should
> >> turn off filesystem writeback caching.
> >>      
> > This isn't a NFS server problem, or one that canbe worked around at
> > the server. it's a NFS _client_ problem in that it does not get
> > synchronous ENOSPC errors when using writeback caching. There is no
> > way for the NFS client to know the server is near ENOSPC conditions
> > prior to writing the data to the server as clients operate
> > independently.
> >
> > If you really want your NFS clients to behave correctly when the
> > server goes ENOSPC, turn off writeback caching at the client side,
> > not the server (i.e. use sync mounts on the client side).
> > Write performance will suck, but if you want sane ENOSPC behaviour...
> >
> >    
> 
> [adding NFS ML in cc]
> 
> Thank you for your very clear explanation.
> 
> Going without writeback cache is a problem (write performance sucks as 
> you say), but guaranteeing to never reach ENOSPC also is hardly 
> feasible, especially if humans are logged at client side and they are 
> doing "whatever they want".
> 
> I would suggest that either be the NFS client to do polling to see if 
> it's near an ENOSPC and if yes disable writeback caching, or be the 
> server to do the polling and if it finds out it's near-ENOSPC condition 
> it sends a specific message to clients to warn them so that they can 
> disable caching.



> Performed at client side wouldn't change the NFS protocol and can be 
> good enough if one can specify how often freespace should be polled and 
> what is the freespace threshold. Or with just one value: specify what is 
> the max speed at which server disk can fill (next polling period can be 
> inferred from current free space), and maybe also specify a minimum 
> polling period (just in case).

You can just as easily do this at the application level. The kernel
can't do it any more reliably than the application can, so there really
is no point in doing it there.

We already ensure that when the server does send us an error, we switch
to synchronous operation until the error clears.

Trond

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
