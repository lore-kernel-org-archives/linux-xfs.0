Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RKb4hm220197 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 15:37:04 -0500
Received: from mx2.netapp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7125182E89F
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 13:37:03 -0700 (PDT)
Received: from mx2.netapp.com (mx2.netapp.com [216.240.18.37]) by cuda.sgi.com
	with ESMTP id 82PUhNbWlIPoUJKY for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 13:37:03 -0700 (PDT)
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 27 Jul 2011 16:37:01 -0400
In-Reply-To: <20110727194722.GA9345@infradead.org>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<20110727160752.GC974@fieldses.org>
	<alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
	<20110727181111.GA23009@infradead.org>
	<alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
	<20110727193937.GA5354@infradead.org>
	<alpine.DEB.2.02.1107271540100.1451@p34.internal.lan>
	<20110727194722.GA9345@infradead.org>
Message-ID: <1311799021.25645.41.camel@lade.trondhjem.org>
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
To: Christoph Hellwig <hch@infradead.org>, Bryan Schumaker <bjschuma@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 15:47 -0400, Christoph Hellwig wrote: 
> On Wed, Jul 27, 2011 at 03:44:20PM -0400, Justin Piszcz wrote:
> > 
> > 
> > On Wed, 27 Jul 2011, Christoph Hellwig wrote:
> > 
> > >On Wed, Jul 27, 2011 at 03:35:01PM -0400, Justin Piszcz wrote:
> > >>Currently I do not see any dupes, however I have a script that moves
> > >>images out of the directory once an hour:
> > >>0 * * * * /usr/local/bin/move_to_old2.sh > /dev/null 2>&1
> > >
> > >Do you keep adding files to the directory while you move files out?
> > Yes, otherwise there are too many files in the directory and viewers, e.g.,
> > each geeqie (picture viewer) will use > 4-6GB of memory, so I try to keep
> > it around 5,000 pictures or less.
> > 
> > >What's the rate of additions/removals to the directory?
> > Additions it depends, around 5,000 over a 12hr period, 416/hr, current:
> > 
> > atom:/d1/motion# find cam1|wc
> >    5215    5215  166853
> > atom:/d1/motion# find cam2|wc
> >    5069    5069  162181
> > atom:/d1/motion# find cam3|wc
> >    5594    5594  178981
> > atom:/d1/motion#
> 
> This sounds a lot like xfs simply filling up the directory index slots
> of files that you just moved out with new files, and nfs falsely
> claiming that this is a problem.

Yep. There is an existing bugzilla report for this bug at

   https://bugzilla.kernel.org/show_bug.cgi?id=38572

I have a preliminary patch there that attempts to turn off the loop
detection when the directory is seen to change, however that patch still
appears to have a bug in it, and I haven't had time to figure out what
is wrong yet.

Can you perhaps take a look, Bryan?

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
