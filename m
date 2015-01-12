Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D48547F51
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 09:52:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F866AC007
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 07:52:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 04IEVEIBzVTgM6BH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Jan 2015 07:52:13 -0800 (PST)
Date: Mon, 12 Jan 2015 10:52:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: extremely slow file creation/deletion after xfs ran full
Message-ID: <20150112155206.GD25944@bfoster.bfoster>
References: <54B387A1.6000807@aei.mpg.de>
 <54B3CC6A.4080405@aei.mpg.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54B3CC6A.4080405@aei.mpg.de>
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
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: xfs@oss.sgi.com

On Mon, Jan 12, 2015 at 02:30:18PM +0100, Carsten Aulbert wrote:
> Hi again
> 
> (sorry that I reply to my own email, rather than Brian's, but I've only
> just subscribed to the list), I'll try to address Brian's email in here
> with fake quotation. Sorry for breaking the threading :(
> 
> Brian Foster wrote:
> > Based on the size and consumption of the fs, first thing that comes
> > to mind is perhaps fragmented use of inode records. E.g., inode
> > records are spread all over the storage with handfulls of inodes
> > free here and there, which means individual inode allocation can
> > take a hit searching for the record with free inodes. I don't think
> > that explains rm performance though.
> 
> > It might be interesting to grab a couple perf traces of the touch
> > and rm commands and see what cpu usage looks like. E.g., 'perf
> > record -g touch <file>,' 'perf report -g,' etc.
> 
> I've attached both perf outputs and after reviewing them briefly I think
> slowness is caused by different means, i.e. only the touch one is in
> xfs' territory.
> 

Ok, well if something else causes the rm slowness, the scattered free
inode scenario might be more likely.

I can't see any symbols associated with the perf output. I suspect
because I'm not running on your kernel. It might be better to run 'perf
report -g' and copy/paste the stack trace for some of the larger
consumers.

> > 	30265117 xfs: Fix rounding in xfs_alloc_fix_len()
> >
> > That originally went into 3.16 and I don't see it in the 3.14 stable
> > branch. Did xfs_repair actually report anything wrong?
> 
> Nope, only displayed all the stages, but nothing was fixed.
> 

Ok, also seems like further indication of the problem fixed by the above
commit.

> > It seems like you have sufficiently large and available free
> > space. That said, it's fairly common for filesytems to naturally
> > drop in performance as free space becomes more limited. E.g., I
> > think it's common practice to avoid regular usage while over 80%
> > used if performance is a major concern. Also, I doubt xfs_fsr will
> > do much to affect inode allocation performance, but I could be
> > wrong.
> 
> Yes, we should have monitored that mount point rather than /tmp which we
> did when bad things happened(TM). Given that we have a high
> fragmentation of directories, would xfs_fsr help here at all?
> 

I don't _think_ that fsr will mess with directories, but I don't know
for sure...

> Regarding v5, currently we are copying data off that disk and will
> create it anew with -m crc=1,finobt=1 on a recent 3.18 kernel. Apart
> from that I don't know much we can further do to safe-guard us against
> this happening again (well kepp it below 80% all the time as well).
> 

Sounds good. FWIW, something like the following should tell us how many
free inodes are available in each ag, and thus whether we have to search
for free inodes in existing records rather than allocate new ones:

for i in $(seq 0 15); do
	xfs_db -c "agi $i" -c "p freecount" <dev>
done

Brian

> Thanks a lot for the remarks!
> 
> cheers
> 
> Carsten
> 
> -- 
> Dr. Carsten Aulbert - Max Planck Institute for Gravitational Physics
> Callinstrasse 38, 30167 Hannover, Germany
> phone/fax: +49 511 762-17185 / -17193
> https://wiki.atlas.aei.uni-hannover.de/foswiki/bin/view/ATLAS/WebHome



> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
