Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7HH31qq083556
	for <linux-xfs@oss.sgi.com>; Wed, 17 Aug 2011 12:03:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BEF3C15FDA3E
	for <linux-xfs@oss.sgi.com>; Wed, 17 Aug 2011 10:05:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DNUc0Jm8S90SHlvk for <linux-xfs@oss.sgi.com>;
	Wed, 17 Aug 2011 10:05:02 -0700 (PDT)
Date: Wed, 17 Aug 2011 13:02:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Deleting files with extended attributes is dead slow
Message-ID: <20110817170251.GB28650@infradead.org>
References: <j23qs9$1c3$1@dough.gmane.org>
	<20110812204746.GB30615@infradead.org>
	<20110816161357.GA18201@infradead.org>
	<4E4BBC98.7020501@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E4BBC98.7020501@itwm.fraunhofer.de>
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
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

On Wed, Aug 17, 2011 at 03:05:28PM +0200, Bernd Schubert wrote:
> >(squeeze-x86_64)fslab2:~# xfs_bmap -a /mnt/xfs/Bonnie.29243/00000/00000027faJxifNb0n
> >/mnt/xfs/Bonnie.29243/00000/00000027faJxifNb0n:
> >        0: [0..7]: 92304..92311
> 
> (Sorry, I have no idea what "0: [0..7]: 92304..9231" is supposed to
> tell me).

It means that you are having an extent spanning 8 blocks for xattr
storage, that map to physical blocks 92304 to 9231 in the filesystem.

It sounds to me like your workload has a lot more than 256 bytes of
xattrs, or the underlying code is doing something rather stupid.

> Looking at 'top' and 'iostat -x' outout, I noticed we are actually
> not limited by io to disk, but CPU bound. If you should be
> interested, I have attached 'perf record -g' and 'perf report -g'
> outout, of the bonnie file create (create + fsetfattr() ) phase.

It's mostly spending a lot of time on copying things into the CIL
buffers, which is expected and intentional as that allows for additional
parallelity.  I you'd switch the workload to multiple intances doing
the create in parallel you should be able to scale to better numbers.

> >     100:256:256/10 37026  91 +++++ +++ 43691  93 35960  92 +++++ +++ 40708  92
> >Latency              4328us     765us    2960us     527us     440us    1075us
> >1.96,1.96,fslab2,1,1313594619,,,,,,,,,,,,,,100,256,256,,10,37026,91,+++++,+++,43691,93,35960,92,+++++,+++,40708,92,,,,,,,4328us,765us,2960us,527us,440us,1075us
> 
> 
> xfs:
> mkfs.xfs -f -i size=512 -i maxpct=90  -l lazy-count=1 -n size=64k /dev/sdd

Do 64k dir blocks actually help you with the workload?  They also tend
to do a lot of useless memcpys in their current form, although these
didn't show up on your profile.  Did you try using a larger inode size
as suggested in my previous mail?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
