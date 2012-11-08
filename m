Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8Hjh6G011195 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 11:45:44 -0600
Received: from whiskey.americas.sgi.com (eagdhcp-232-197.americas.sgi.com
	[128.162.232.197])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AB7F6AC004
	for <xfs@oss.sgi.com>; Thu,  8 Nov 2012 09:47:39 -0800 (PST)
Date: Thu, 8 Nov 2012 11:47:39 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Update mount options documentation
Message-ID: <20121108174739.GP9783@sgi.com>
References: <1350574138-30305-1-git-send-email-cmaiolino@redhat.com>
	<5080253A.9060906@sgi.com> <5080279C.8030702@mrc-lmb.cam.ac.uk>
	<508028CC.5080800@sgi.com>
	<20121018170442.GA6634@andromeda.usersys.redhat.com>
	<50803926.1010904@sgi.com>
	<20121018184033.GA15782@andromeda.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121018184033.GA15782@andromeda.usersys.redhat.com>
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

Hey Carlos,

On Thu, Oct 18, 2012 at 03:40:33PM -0300, Carlos Maiolino wrote:
> On Thu, Oct 18, 2012 at 12:15:18PM -0500, Mark Tinguely wrote:
> > On 10/18/12 12:04, Carlos Maiolino wrote:
> > >On Thu, Oct 18, 2012 at 11:05:32AM -0500, Mark Tinguely wrote:
> > >>On 10/18/12 11:00, Dave Howorth wrote:
> > >>>Mark Tinguely wrote:
> > >>>>Would "Indicates that XFS is allowed to create inodes at locations up to
> > >>>>32 bits of significance .."
> > >>>
> > >>>I prefer the original wording. Your suggestion says something about what
> > >>>XFS can do, but nothing about what it is not allowed to do, which is
> > >>>rather more important.
> > >>>
> > >>>_______________________________________________
> > >>>xfs mailing list
> > >>>xfs@oss.sgi.com
> > >>>http://oss.sgi.com/mailman/listinfo/xfs
> > >>
> > >>I see your point. Sounds good to me.
> > >>
> > >>--Mark.
> > >>
> > >This means no change is needed?
> > >
> > 
> > I am okay with what is written about creating inodes.
> > 
> > On a separate question, should something be mentioned that inode32
> > mode can still read/write/unlink any inode, even those number
> > greater than 32 bit, or will that confuse the inode creation point?
> > 
> I thought about this when modifying the documentation, but, to be honest I was
> wondering if this might not cause more confusion than expected. 
> 
> For example,
> afaik, one of the principal reasons we still keep an inode32 allocator is due
> applications which cannot handle 64bit inodes. So, I suppose that users which
> will use inode32 are those who really needs 32bit inodes for this kind of
> 'problem'.
> 
> Saying that inode32 mode can still read 64bit inodes might (IMHO) lead users,
> *think* they won't have problems with larger inodes just by using inode32 mode,
> when, AFAICT, they'll have the same problems with their applications and larger
> inode numbers if they have any inode allocated beyong 32bit limit. even using
> inode32 mode.
> 
> So, I believe that, not saying it will "force" users who need 32bit inodes to
> use inode32 since its first inode allocation, instead of think they'll fix their
> problems only switching to inode32 mode after they already had lots of 64bit
> inodes allocated.
> 
> 
> 
> Hopefully I didn't create more confusion around it :-)

    I pulled in the original version of this on Nov 2.  That version looked fine to me. ;)

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
