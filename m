Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n18N1gfc200325 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 17:01:43 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 143D918F00AC
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2009 15:01:03 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id RJadhAz8DWqmNRww for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2009 15:01:03 -0800 (PST)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch 0/4] attr: test/ improvements and integrate with make
Date: Sun, 8 Feb 2009 23:59:59 +0100
References: <20090108021947.404730068@ifup.org> <20090108165820.GA3832@jenkins>
	<20090207091033.GO29636@jenkins.ifup.org>
In-Reply-To: <20090207091033.GO29636@jenkins.ifup.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902090000.00162.agruen@suse.de>
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
To: Brandon Philips <brandon@ifup.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Saturday 07 February 2009 10:10:33 Brandon Philips wrote:
> On 08:58 Thu 08 Jan 2009, Brandon Philips wrote:
> > On 10:44 Thu 08 Jan 2009, Christoph Hellwig wrote:
> > > On Wed, Jan 07, 2009 at 06:19:47PM -0800, brandon@ifup.org wrote:
> > > > NOTE: Timothy Shimmin's email (tes@sgi.com) seems to be gone. Who
> > > > should I send patches like this to in the future?
> > >
> > > That's not quite sorted out.  For now send them to Andreas Gruenbacher
> > > and the xfs list.
> >
> > Ok, thanks.
> >
> > Andreas, please review these patches if you can:
> >   http://oss.sgi.com/archives/xfs/2009-01/msg00136.html
> >   http://oss.sgi.com/archives/xfs/2009-01/msg00146.html
>
> I noticed that Christoph put acl-dev.git and attr-dev.git on
> git.kernel.org.  Great news!

Yes, and the trees have nice histories as well, which is great.

> But, can I suggest that we merge the attr-dev and acl-dev tree into one
> git repo and share libmisc? I have done it over here:
>
>   http://ifup.org/git/?p=acl-attr-dev.git;a=summary
>   git clone git://ifup.org/philips/acl-attr-dev.git
>
> What do you think?

I believe it's a good start; we probably want to merge the trees eventually. 
The way how you have moved libmisc breaks the tarballs though; I have fixed 
it. Also, I was surprised that your repository has all the history rewritten 
instead of merging Christoph's trees, so I redid the merge.

  http://www.kernel.org/pub/scm/linux/kernel/git/agruen/xattr-tools.git
  git://git.kernel.org/pub/scm/linux/kernel/git/agruen/xattr-tools.git

Are you fine with this tree?

> Also, my test/ patchset hasn't gotten any feedback. I will merge them
> into either {acl,attr}-dev.git or my acl-attr-dev.git if they seem
> acceptable and send you a pull request.
>
>  http://oss.sgi.com/pipermail/xfs/2009-January/039600.html
>  http://oss.sgi.com/pipermail/xfs/2009-January/039610.html

Sorry for being slow. I will first add the other acked distro patches, then 
look at your changes.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
