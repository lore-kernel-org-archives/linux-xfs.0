Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 478277F3F
	for <xfs@oss.sgi.com>; Wed,  5 Nov 2014 07:17:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 15FEF304048
	for <xfs@oss.sgi.com>; Wed,  5 Nov 2014 05:17:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NmVfRXdp6ORfitTJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Nov 2014 05:17:15 -0800 (PST)
Date: Wed, 5 Nov 2014 08:17:06 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/6 v2] xfs: fix the bulkstat mess
Message-ID: <20141105131706.GB26724@bfoster.bfoster>
References: <1415145921-31507-1-git-send-email-david@fromorbit.com>
	<20141105060728.GE28565@dastard> <20141105063226.GF28565@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141105063226.GF28565@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 05, 2014 at 05:32:26PM +1100, Dave Chinner wrote:
> On Wed, Nov 05, 2014 at 05:07:28PM +1100, Dave Chinner wrote:
> > On Wed, Nov 05, 2014 at 11:05:15AM +1100, Dave Chinner wrote:
> > > Hi folks, this is version 2 of the bulkstat fixup series first
> > > posted here:
> > > 
> > > http://oss.sgi.com/archives/xfs/2014-11/msg00057.html
> > > 
> > > Version 2 fixes the issues Brian found during review:
> > > - chunk formatter error leakage (patch 3)
> > > - moved main loop chunk formatter error handling from patch 4 to
> > >   patch 5
> > > - reworks last_agino updating in patch 6 to do post-formatting
> > >   updates and added comments.
> > > 
> > > Comeents and testing welcome.
> > 
> > I'm not 100% convinced that this fixes all the problems. I just
> > created, dumped and restored a 10 million inode filesystem (about
> > 50GB of dump file) and I found 102 missing files in the dump with no
> > errors from xfsdump or xfsrestore.
> > 
> > The files are missing from just 4 directories out of about 1000
> > directories containing equal numbers of files, so its not a common
> > trigger whatever the issue is. I'll keep digging...
> 
> OK, this looks like a problem with handling the last record in the
> AGI btree:
> 
> $ for i in `cat s.diff | grep "^+/" | sed -e 's/^+//'` ; do ls -i $i; done |sort -n
> 163209114099 /mnt/scratch/2/dbc/5459605f~~~~~~~~RDJX8QBHPPMCGMD7YJQGYPD2
> ....
> 163209114129 /mnt/scratch/2/dbc/5459605f~~~~~~~~U820IYQFKS8A6QYCC8HU3ZBX
> 292057960758 /mnt/scratch/0/dcc/54596070~~~~~~~~9BUH5D5PZTGAC8BT1YL77OZ0
> ...
> 292057960769 /mnt/scratch/0/dcc/54596070~~~~~~~~DAO78GAAFNUZU8PH7Q0UZNRH
> 1395864555809 /mnt/scratch/1/e60/54596103~~~~~~~~GEMXGHYNREW409N7W9INBMVA
> .....
> 1395864555841 /mnt/scratch/1/e60/54596103~~~~~~~~9XPK9FWHCE21AJ3EN023DU47
> 1653562593576 /mnt/scratch/5/e79/5459611c~~~~~~~~BSBZ6EUCT9HOIRQPMFZDVPQ5
> .....
> 1653562593601 /mnt/scratch/5/e79/5459611c~~~~~~~~6QY1SO8ZGGNQESAGXSB3G3DH
> $
> 
> xfs_db> convert inode 163209114099 agno
> 0x26 (38)
> xfs_db> convert inode 163209114099 agino
> 0x571f3 (356851)
> xfs_db> convert inode 163209114129 agino
> 0x57211 (356881)
> xfs_db> agi 38
> xfs_db> a root
> xfs_db> a ptrs[2]
> xfs_db> p
> ....
> recs[1-234] = [startino,freecount,free]
> ......
> 228:[356352,0,0] 229:[356416,0,0] 230:[356512,0,0] 231:[356576,0,0]
> 232:[356672,0,0] 233:[356736,0,0] 234:[356832,14,0xfffc000000000000]
> 
> So the first contiguous inode range they all fall into the partial final record
> in the AG.
> 
> xfs_db> convert inode 292057960758 agino
> 0x2d136 (184630)
> .....
> 155:[184544,0,0] 156:[184608,30,0xfffffffc00000000]
> 
> Same.
> 
> xfs_db> convert inode 1395864555809 agino
> 0x2d121 (184609)
> .....
> 155:[184544,0,0] 156:[184608,30,0xfffffffc00000000]
> 
> Same.
> 
> xfs_db> convert inode 1653562593576 agino
> 0x2d128 (184616)
> ....
> 155:[184544,0,0] 156:[184608,30,0xfffffffc00000000]
> 
> Same.
> 
> So they are all falling into the last btree record in the AG, and so
> appear to have been skipped as a result of the same issue. At least
> that gives me something to look at.
> 

Interesting, though just to note... is it possible this is related to
records with free inodes? If this is a prepopulated fs for the purpose
of this test, it's conceivable that there's only a small set of such
records in the fs. The other records in your snippets here are fully
allocated, but of course this is only a small snippet of a larger set of
data.

It also might be interesting to know whether this repeats without the
last patch in the series. IIRC that one seemed to have the most
potential impact on the overall algorithm (by changing loop iteration
logic, etc.). Just a thought.

Brian

> Still, please review the patches I've already posted - I'll push
> them to linus if they are fine ASAP, and then add whatever I find
> from this test later.
> 
> Cheers,
> 
> Dave.
> 
> PS: every AG I looked at had an identical inode allocation pattern.
> Given that the directory entries and the file contents created are
> all deterministic, it's reassuring to see that the allocator has
> created identical metadata structure layouts on disk for a
> repeating workload that creates identical user-visible
> hierarchies...
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
