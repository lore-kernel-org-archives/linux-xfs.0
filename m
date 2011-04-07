Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p37DgKsq099473 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 08:42:20 -0500
Received: from twin.jikos.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17C2614672F5
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2011 06:45:35 -0700 (PDT)
Received: from twin.jikos.cz (twin.jikos.cz [89.185.236.188]) by cuda.sgi.com
	with ESMTP id dfEnNDYd1o4KhrFW for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2011 06:45:35 -0700 (PDT)
Received: from twin.jikos.cz (dave@localhost [127.0.0.1])
	by twin.jikos.cz (8.13.6/8.13.6) with ESMTP id p37DjXb7017375
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 15:45:33 +0200
Received: (from dave@localhost)
	by twin.jikos.cz (8.13.6/8.13.6/Submit) id p37DjX3O017374
	for xfs@oss.sgi.com; Thu, 7 Apr 2011 15:45:33 +0200
Date: Thu, 7 Apr 2011 15:45:33 +0200
From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] xfs: fix variable set but not used warnings
Message-ID: <20110407134532.GH31675@twin.jikos.cz>
References: <20110404125544.GA726@infradead.org>
	<1301941280.2630.61.camel@doink>
	<20110404235226.GC31675@twin.jikos.cz>
	<20110405060558.GA31057@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110405060558.GA31057@dastard>
Reply-To: dave@jikos.cz
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
To: xfs@oss.sgi.com

Hi,

On Tue, Apr 05, 2011 at 04:05:58PM +1000, Dave Chinner wrote:
> Background: the quotaon syscall on XFS can only change whether
> quotas are enforced or not in XFS. It can't switch quotas on at
> all because that has to be done at mount time. Switching quotas on
> at mount time sets the appropriate flags in the superblock, so we
> can always rely on a superblock flag check for whether accounting
> is enabled or not.

Thanks for the explanation.

> > 
> >             (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
> >             (flags & XFS_UQUOTA_ENFD))
> >              ^^^^^^^^^^^^^^^^^^^^^^^
> 
> And those are the checks that are meaningful.

Should have been the flags & _ACCT check line above, my mistake.

> > Besides, there are more cleanups and fixups in this function:
> > 
> > line 331:
> >         /* No fs can turn on quotas with a delayed effect */
> > 	ASSERT((flags & XFS_ALL_QUOTA_ACCT) == 0);
> > 
> > seems to be broken too:
> > * the acct flags are masked out -> always asserts true
> > * doing s/flags/accflags/ does not make sense
> 
> No, that makes perfect sense given the commit above. We use ASSERT()
> statements to document constraints and assumptions in the code, and
> that is exactly what this does....

Yes, in context of the linked commit. From a technical POV, this assert
would only fail when the constants for XFS_ALL_QUOTA_ACCT and
XFS_ALL_QUOTA_ENFD overlap.

> Well, yes. that's why we have a relatively strict review process -
> the reviewer needs to check stuff like this, not just blindly trust
> the person who wrote the code did it. That's the essence of the
> meaning of the Reviewed-by tag we throw around all the time - it's
> not just a rubber stamp.
> 
> Indeed, it's not uncommon for me to spend hours doing this sort of
> analysis when reviewing complex changes, and all you might see on
> the mailing list is (maybe) a short comment accompanying a
> Reviewed-by tag....

Understood and no doubts here. I was missing something like
"removing just the variable and will clean the rest later", which
Christoph wrote in a later email.


dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
