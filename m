Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n179BXvs087669 for <xfs@oss.sgi.com>; Sat, 7 Feb 2009 03:11:34 -0600
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BE91F7E6C
	for <xfs@oss.sgi.com>; Sat,  7 Feb 2009 01:10:54 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com
	[209.85.146.179]) by cuda.sgi.com with ESMTP id
	REOi3hlxjJlmGZrI for <xfs@oss.sgi.com>;
	Sat, 07 Feb 2009 01:10:54 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so612863waf.4
	for <xfs@oss.sgi.com>; Sat, 07 Feb 2009 01:10:54 -0800 (PST)
Date: Sat, 7 Feb 2009 01:10:33 -0800
From: Brandon Philips <brandon@ifup.org>
Subject: Re: [patch 0/4] attr: test/ improvements and integrate with make
Message-ID: <20090207091033.GO29636@jenkins.ifup.org>
References: <20090108021947.404730068@ifup.org>
	<20090108154453.GA5017@infradead.org>
	<20090108165820.GA3832@jenkins>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090108165820.GA3832@jenkins>
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
To: Christoph Hellwig <hch@infradead.org>, Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <agruen@suse.de>
Cc: xfs@oss.sgi.com

On 08:58 Thu 08 Jan 2009, Brandon Philips wrote:
> On 10:44 Thu 08 Jan 2009, Christoph Hellwig wrote:
> > On Wed, Jan 07, 2009 at 06:19:47PM -0800, brandon@ifup.org wrote:
> > > NOTE: Timothy Shimmin's email (tes@sgi.com) seems to be gone. Who should
> > > I send patches like this to in the future?
> > 
> > That's not quite sorted out.  For now send them to Andreas Gruenbacher
> > and the xfs list.
> 
> Ok, thanks.
> 
> Andreas, please review these patches if you can:
>   http://oss.sgi.com/archives/xfs/2009-01/msg00136.html
>   http://oss.sgi.com/archives/xfs/2009-01/msg00146.html

I noticed that Christoph put acl-dev.git and attr-dev.git on
git.kernel.org.  Great news! The process with CVS and TAKEs was a bit
confusing.

But, can I suggest that we merge the attr-dev and acl-dev tree into one
git repo and share libmisc? I have done it over here:

  http://ifup.org/git/?p=acl-attr-dev.git;a=summary
  git clone git://ifup.org/philips/acl-attr-dev.git

What do you think?

Also, my test/ patchset hasn't gotten any feedback. I will merge them
into either {acl,attr}-dev.git or my acl-attr-dev.git if they seem
acceptable and send you a pull request.

 http://oss.sgi.com/pipermail/xfs/2009-January/039600.html
 http://oss.sgi.com/pipermail/xfs/2009-January/039610.html


Cheers, Brandon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
