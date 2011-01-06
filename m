Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p068cnAG040929 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 02:38:49 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B152DFAD612
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 00:40:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CGbjyoPIywSFOzNY for
	<xfs@oss.sgi.com>; Thu, 06 Jan 2011 00:40:58 -0800 (PST)
Date: Thu, 6 Jan 2011 09:40:48 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: xfs: add FITRIM support
In-Reply-To: <alpine.LFD.2.00.1101060923210.2731@dhcp-lab-213.englab.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.1101060939400.2731@dhcp-lab-213.englab.brq.redhat.com>
References: <20101125112304.GA4195@infradead.org> <201101052307.38379@zmi.at>
	<20110105225039.GD8322@dastard> <201101060910.34534@zmi.at>
	<alpine.LFD.2.00.1101060923210.2731@dhcp-lab-213.englab.brq.redhat.com>
MIME-Version: 1.0
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, 6 Jan 2011, Lukas Czerner wrote:

> On Thu, 6 Jan 2011, Michael Monnerie wrote:
> 
> > On Mittwoch, 5. Januar 2011 Dave Chinner wrote:
> > > No state or additional on-disk
> > > structures are needed for xfs_fsr to do it's work....
> > 
> > That's not exactly the same - once you defraged a file, you know it's 
> > done, and can skip it next time. But you dont know if the (free) space 
> > between block 0 and 20 on disk has been rewritten since the last trim 
> > run or not used at all, so you'd have to do it all again.
> >  
> > > The background trim is intended to enable even the slowest of
> > > devices to be trimmed over time, while introducing as little runtime
> > > overhead and complexity as possible. Hence adding complexity and
> > > runtime overhead to optimise background trimming tends to defeat the
> > > primary design goal....
> > 
> > It would be interesting to have real world numbers to see what's "best". 
> > I'd imagine a normal file or web server to store tons of files that are 
> > mostly read-only, while 5% of it a used a lot, as well as lots of temp 
> > files. For this, knowing what's been used would be great.
> > 
> > Also, I'm thinking of a NetApp storage, that has been setup to run 
> > deduplication on Sunday. It's best to run trim on Saturday and it should 
> > be finished before Sunday. For big storages that might be not easy to 
> > finish, if all disk space has to be freed explicitly.
> > 
> > And wouldn't it still be cheaper to keep a "written bmap" than to run 
> > over the full space of a (big) disk? I'd say depends on the workload.
> > 
> 
> I have already investigated approach with storing the information about
> blocks freed since last trim. However I found it not that useful for
> several reasons.
> 
> 1. Bitmaps are big, especially on huge filesystems you are talking about
> it will significantly increase the memory utilization.
> 
> 2. Rbtree might be better, however there is some threshold we need to
> watch, because when it gets really fragmented it can be bigger than
> bitmap. Moreover it adds significant complexity and of course CPU
> utilization.

Not talking about the fact that neither bitmaps not rbtrees can survive
umount.

> 
> 3. As I said several times, we do not need to trim when there was not
> enough writes from the last trim, because when we have enough space for
> example for wear leveling in SSD, we do not need to reclaim more, OR we
> can do is really slowly as a precaution measure.
> 
> All that said, we have much more flexibility in user space and we can
> think of a lots of different heuristic to determine whether or not to do
> the trim and how.
> 
> Thanks!
> -Lukas
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
