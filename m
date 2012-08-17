Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7HHYr1f068481 for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 12:34:53 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	nHJbCNaWhwX0wX7V (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Aug 2012 10:34:51 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1T2QRd-0004vC-N3
	for xfs@oss.sgi.com; Fri, 17 Aug 2012 17:34:49 +0000
Date: Fri, 17 Aug 2012 13:34:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3] Make inode64 a remountable option
Message-ID: <20120817173449.GB18347@infradead.org>
References: <1345171178-10447-1-git-send-email-cmaiolino@redhat.com>
	<20120817122437.GC2502@infradead.org>
	<20120817144950.GA17092@orion.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120817144950.GA17092@orion.usersys.redhat.com>
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

On Fri, Aug 17, 2012 at 11:49:50AM -0300, Carlos Maiolino wrote:
> I don't think there is any lock protection around m_flags, I did a search on the
> code and couldn't find anything protecting it. At a first glance though, I don't
> think there is a need to protect it once this flag is managed only during super
> operations - mount/umount/remount -
> Also, I *think* the sb->s_umount rw_semaphore is enough for protection, once it
> protects the whole mount/umount operation, but I'm 100% sure of it.

Seems like rw_semaphore takes care of it, and we already have a trace
when setting XFS_MOUNT_FS_SHUTDOWN.  I guess it's fine as is for now,
but I'd love to have comment explaining why it's safe.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
