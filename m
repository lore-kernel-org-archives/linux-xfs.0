Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12GSOek062223 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 10:28:24 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	jDEKWukJdCXTFBqw (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 08:28:24 -0800 (PST)
Date: Thu, 2 Feb 2012 11:28:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Inode lockdep problem observed on 2.6.37.6 xfs with RT subvolume
Message-ID: <20120202162823.GA3425@infradead.org>
References: <CAC=U0a1huHVULfMObyH_XNcQi5aTZtrbpcciNhw=92PE96f4cg@mail.gmail.com>
	<20120202091330.GA31203@infradead.org>
	<CAC=U0a11udmsGAKg5Sp+X2uxRTKS8gq37CK9OAZKhLOPKbWHKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC=U0a11udmsGAKg5Sp+X2uxRTKS8gq37CK9OAZKhLOPKbWHKQ@mail.gmail.com>
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
To: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, cernekee@gmail.com, xfs@oss.sgi.com

On Thu, Feb 02, 2012 at 11:26:28AM -0500, Kamal Dasu wrote:
> > ?xfs: only lock the rt bitmap inode once per allocation
> > ?xfs: fix xfs_get_extsz_hint for a zero extent size hint
> > ?xfs: add lockdep annotations for the rt inodes
> >
> > But in general the RT subvolume code is not regularly tested and only
> > fixed when issues arise.
> 
> 
> Thanks for quick reply and clarifying this, if upgrading the kernel is
> not an option, should I be
> considering backporting  changes to 2.6.37,  should I  use the entire
> 2.6.39 or 3.0
> xfs implementation as is of cherry pick the above three changes ?.

I don't remember if we have other changes in that area.  If backporting
the changes is easy enough, go for it, if not stick to your original
workaround.  Either way make sure you don't introduce other regressions
by running xfstests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
