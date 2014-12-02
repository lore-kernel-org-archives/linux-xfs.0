Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A2E387F56
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 16:00:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FE6DAC00C
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 14:00:17 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	csCC92gSDwxHJkXf for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 14:00:15 -0800 (PST)
Date: Wed, 3 Dec 2014 08:59:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Correctly lock inode when removing suid and
	security marks
Message-ID: <20141202215947.GD18131@dastard>
References: <1417532489-26580-1-git-send-email-jack@suse.cz>
	<20141202163548.GB2113@laptop.bfoster>
	<20141202204756.GA944@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141202204756.GA944@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Dec 02, 2014 at 09:47:56PM +0100, Jan Kara wrote:
> On Tue 02-12-14 11:35:48, Brian Foster wrote:
> > On Tue, Dec 02, 2014 at 04:01:29PM +0100, Jan Kara wrote:
> > > Currently XFS calls file_remove_suid() without holding i_mutex. This is
> > > wrong because that function can end up messing with file permissions and
> > > security xattrs for which we need i_mutex held.
> > > 
> > > Fix the problem by grabbing iolock exclusively when we will need to
> > > change anything in permissions / xattrs.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > 
> > Hi Jan,
> > 
> > This doesn't compile... it looks like we need to include the security.h
> > header. FWIW, even then I get an undefined symbol error when compiling
> > as a module (security_inode_need_killpriv() does not appear to be
> > exported).
>   Sorry, forgot to amend the include in the commit. Regarding export of
> security_inode_need_killpriv() - right, I had security XFS compiled in so I
> didn't notice. Before I go and fix this up in the obvious way, does anyone
> have better idea how to fix this than to second guess what
> file_remove_suid() does? Maybe a VFS helper like file_needs_remove_suid()
> will be cleaner than what I did?

Helper seems like a sane idea - that way the filesystems can use
them as a matched pair if need be...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
