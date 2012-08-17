Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7HEntsY047840 for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 09:49:56 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PJPSMzDqDxPjfELy for
	<xfs@oss.sgi.com>; Fri, 17 Aug 2012 07:49:54 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7HEnsmE025127
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 10:49:54 -0400
Received: from orion.usersys.redhat.com (vpn1-6-11.gru2.redhat.com
	[10.97.6.11])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q7HEnpYf016631
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 10:49:53 -0400
Date: Fri, 17 Aug 2012 11:49:50 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V3] Make inode64 a remountable option
Message-ID: <20120817144950.GA17092@orion.usersys.redhat.com>
References: <1345171178-10447-1-git-send-email-cmaiolino@redhat.com>
	<20120817122437.GC2502@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120817122437.GC2502@infradead.org>
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

On Fri, Aug 17, 2012 at 08:24:37AM -0400, Christoph Hellwig wrote:
> On Thu, Aug 16, 2012 at 11:39:38PM -0300, Carlos Maiolino wrote:
> > Actually, there is no reason about why a user must umount and mount a XFS
> > filesystem to enable 'inode64' option. So, this patch makes this a remountable
> > option.
> 
> What does protect concurrent updates of m_flags?
> 
I don't think there is any lock protection around m_flags, I did a search on the
code and couldn't find anything protecting it. At a first glance though, I don't
think there is a need to protect it once this flag is managed only during super
operations - mount/umount/remount -
Also, I *think* the sb->s_umount rw_semaphore is enough for protection, once it
protects the whole mount/umount operation, but I'm 100% sure of it.

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
