Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IIcxcP206248 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 13:38:59 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HJNRnsIlMe3O3JgC for
	<xfs@oss.sgi.com>; Thu, 18 Oct 2012 11:40:37 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9IIebl8005199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 14:40:37 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-113.phx2.redhat.com
	[10.3.113.113])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q9IIeXwo003223
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 14:40:36 -0400
Date: Thu, 18 Oct 2012 15:40:33 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Update mount options documentation
Message-ID: <20121018184033.GA15782@andromeda.usersys.redhat.com>
References: <1350574138-30305-1-git-send-email-cmaiolino@redhat.com>
	<5080253A.9060906@sgi.com> <5080279C.8030702@mrc-lmb.cam.ac.uk>
	<508028CC.5080800@sgi.com>
	<20121018170442.GA6634@andromeda.usersys.redhat.com>
	<50803926.1010904@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50803926.1010904@sgi.com>
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

On Thu, Oct 18, 2012 at 12:15:18PM -0500, Mark Tinguely wrote:
> On 10/18/12 12:04, Carlos Maiolino wrote:
> >On Thu, Oct 18, 2012 at 11:05:32AM -0500, Mark Tinguely wrote:
> >>On 10/18/12 11:00, Dave Howorth wrote:
> >>>Mark Tinguely wrote:
> >>>>Would "Indicates that XFS is allowed to create inodes at locations up to
> >>>>32 bits of significance .."
> >>>
> >>>I prefer the original wording. Your suggestion says something about what
> >>>XFS can do, but nothing about what it is not allowed to do, which is
> >>>rather more important.
> >>>
> >>>_______________________________________________
> >>>xfs mailing list
> >>>xfs@oss.sgi.com
> >>>http://oss.sgi.com/mailman/listinfo/xfs
> >>
> >>I see your point. Sounds good to me.
> >>
> >>--Mark.
> >>
> >This means no change is needed?
> >
> 
> I am okay with what is written about creating inodes.
> 
> On a separate question, should something be mentioned that inode32
> mode can still read/write/unlink any inode, even those number
> greater than 32 bit, or will that confuse the inode creation point?
> 
I thought about this when modifying the documentation, but, to be honest I was
wondering if this might not cause more confusion than expected. 

For example,
afaik, one of the principal reasons we still keep an inode32 allocator is due
applications which cannot handle 64bit inodes. So, I suppose that users which
will use inode32 are those who really needs 32bit inodes for this kind of
'problem'.

Saying that inode32 mode can still read 64bit inodes might (IMHO) lead users,
*think* they won't have problems with larger inodes just by using inode32 mode,
when, AFAICT, they'll have the same problems with their applications and larger
inode numbers if they have any inode allocated beyong 32bit limit. even using
inode32 mode.

So, I believe that, not saying it will "force" users who need 32bit inodes to
use inode32 since its first inode allocation, instead of think they'll fix their
problems only switching to inode32 mode after they already had lots of 64bit
inodes allocated.



Hopefully I didn't create more confusion around it :-)

> --Mark.
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
