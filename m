Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KDZR0q015307 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 07:35:33 -0600
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F6551BA6DB7
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 05:35:25 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id WPHH4zP3loxWw247
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 05:35:25 -0800 (PST)
Date: Wed, 21 Jan 2009 00:35:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120133521.GD10158@disturbed>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net>
	<20090120004611.GA6445@disturbed>
	<20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com>
	<20090120114906.GA12526@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090120114906.GA12526@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jacek Luczak <difrost.kernel@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Tue, Jan 20, 2009 at 06:49:06AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 20, 2009 at 12:47:16PM +0100, Jacek Luczak wrote:
> > Christoph Hellwig pisze:
> > > I'm doing about half of my testing on 32 bit x86, and I couldn't
> > > reproduce the detailed receipe  in the kernel.org bugzilla yet.
> > > 
> > > Just curious:  do you have CONFIG_LBD set?
> > 
> > the answer is:
> > $ grep LBD .config
> > # CONFIG_LBD is not set
> 
> Ok, let me reproduce it without that set..

Good call, Christoph. I have a reproduce on ia32, CONFIG_LBD=n,
1k block size, 16 AGs in 4GB. Filesystem pre-prepared by
copying a build kernel onto it then 'make mrproper' to put
holes in it. Then, on boot:

dave@xfs-32:/mnt$ sudo mount /dev/sdb /mnt; cd /mnt
dave@xfs-32:/mnt$ cp /home/dave/linux-2.6.tar.gz . ; sync
dave@xfs-32:/mnt$ sudo xfs_bmap -v linux-2.6.tar.gz
linux-2.6.tar.gz:
 EXT: FILE-OFFSET       BLOCK-RANGE      AG AG-OFFSET         TOTAL
   0: [0..150271]:      92112..242383     0 (92112..242383)  150272
   1: [150272..346879]: 256188..452795    0 (256188..452795) 196608
   2: [346880..445183]: 906390..1004693   1 (382102..480405)  98304
   3: [445184..494335]: 770022..819173    1 (245734..294885)  49152
   4: [494336..543487]: 720870..770021    1 (196582..245733)  49152
   5: [543488..592639]: 671718..720869    1 (147430..196581)  49152
   6: [592640..641791]: 622566..671717    1 (98278..147429)   49152
   7: [641792..737023]: 1398498..1493729  2 (349922..445153)  95232
   8: [737024..781055]: 1353872..1397903  2 (305296..349327)  44032
   9: [781056..830207]: 1304720..1353871  2 (256144..305295)  49152
  10: [830208..879359]: 1255566..1304717  2 (206990..256141)  49152
  11: [879360..925367]: 1209558..1255565  2 (160982..206989)  46008
dave@xfs-32:/mnt$ > linux-2.6.tar.gz
Connection to xfs-32 closed.

I'll see if this is reproducable, and if it is I'll start
instrumenting in the morning during the LCA keynote. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
