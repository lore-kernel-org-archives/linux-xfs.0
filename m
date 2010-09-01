Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o81AW7q2128532 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 05:32:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92C4ED777F1
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 03:24:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BpdBzj9LU2BN1UmD for
	<xfs@oss.sgi.com>; Wed, 01 Sep 2010 03:24:12 -0700 (PDT)
Date: Wed, 1 Sep 2010 06:13:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 4K drives, sectsz=512, bsize=4096
Message-ID: <20100901101336.GA31648@infradead.org>
References: <881036.47658.qm@web76207.mail.sg1.yahoo.com>
	<201009010938.51894@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009010938.51894@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Sep 01, 2010 at 09:38:46AM +0200, Michael Monnerie wrote:
> On Mittwoch, 1. September 2010 Gim Leong Chin wrote:
> > Should we leave it at the default 256 bytes, or set it to the maximum
> >  of 2 kB?
>  
> An interesting question. Why are inodes sizes configurable at all? To 
> store ACLs? How would one know when bigger Inodes should be used? And 
> what is the implication when they would be needed but aren't used?

The XFS inode consists of three parts:

 - the fixed format dinode
 - the data fork
 - the attribute fork

the fixed format inode is fixed size, so any change in the inode size
only applies to the data and attribute forks.  For regular files we
generally don't use much space in the data fork as it just contains
the extent list, and most files have rather few of them.  But we can
also store short smbolic links directly inside it, as well as the
content of directories.  The attribute fork is used to store extent
attributes and if it's large enough we can store them inline instead
of using external blocks.

You want large inodes mostly if you store lots of extentded attributes,
either for ACLs, Selinux or posisbly DMAPI.  It will also help if you
have enough directories that are just too big for the inline directory
format with smaller inode sizes.


> 
> -- 
> mit freundlichen Gr?ssen,
> Michael Monnerie, Ing. BSc
> 
> it-management Internet Services
> http://proteger.at [gesprochen: Prot-e-schee]
> Tel: 0660 / 415 65 31
> 
> ****** Aktuelles Radiointerview! ******
> http://www.it-podcast.at/aktuelle-sendung.html
> 
> // Wir haben im Moment zwei H?user zu verkaufen:
> // http://zmi.at/langegg/
> // http://zmi.at/haus2009/



> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
