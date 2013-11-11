Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D06067F6B
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 11:55:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDEC13040BA
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 09:55:56 -0800 (PST)
Date: Mon, 11 Nov 2013 15:55:51 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: ag selection
Message-ID: <20131111175550.GB16643@orion.maiolino.org>
References: <l5r3tf$m0j$1@ger.gmane.org>
	<20131111175313.GA16643@orion.maiolino.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131111175313.GA16643@orion.maiolino.org>
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
To: xfs@oss.sgi.com, linux-xfs@oss.sgi.com

On Mon, Nov 11, 2013 at 03:53:14PM -0200, Carlos Maiolino wrote:
> On Mon, Nov 11, 2013 at 06:25:13PM +0100, Bernd Schubert wrote:
> > Hi all,
> > 
> > for streaming writes onto a raid6 the current round-robin ag
> > selection seems does not seem to be optimal. Writing 4 files from 4
> > threads into a single directory we get 900 MB/s, writing 4 files in
> > 4 different directories we only get 700 MB/s (12 disks with with hw
> > megaraid-sas). The current round-robin scheme seems to be optimized
> > for linear raid0? With small AGs one could also argue, that choosing
> > AGs which are not far away from each other (in respect to the number
> > of blocks) also adds more parallel disk access for small and medium
> > sized files.
> > 
> > Any objections against a patch to improve the AG selection?
> > 
> 
> I wouldn't say this it is optimized specifically for raid 0 environments but I
> lack some knowledge on this choice. The mainly reason for the round-robing IIRC,
> was to avoid lock contention in a single AG. spreading different files along the
> whole disk, and also making it able to allocate them contiguously along the disk.
> 
Lock contention in inodes and blocks B-Trees for example, improving parallelism
in the filesystem, but of course this might not be the optimal behavior for all
environments. That's why XFS has a long list of tuning mkfs/mount options :-)

> But, I'm not sure what kind of optimization you have in mind and I believe
> another engineers will also need some extra information about what optimization
> you have in mind, what kind of tests you're doing (Direct I/O, buffered,
> pre-allocation), etc.. You'll also need to post filesystem configurations like
> FS aligment (su, sw options), etc.
> 
> For different write patterns, you might also want to take a look at the
> rotor_step procfs option, and some other options dedicated to streaming writes,
> that might help you in this case.
> 
> Just my $0.02
> 
> > 

Just complementing my past comment

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
