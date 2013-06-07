Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 82D4C7CBF
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 12:08:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 70B7E8F8037
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 10:08:36 -0700 (PDT)
Date: Fri, 7 Jun 2013 13:08:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: Cleancache support in XFS
Message-ID: <20130607170826.GA6925@phenom.dumpdata.com>
References: <51810CED.4080003@zynstra.com> <20130501162044.GN29359@sgi.com>
	<20130501223022.GQ10481@dastard> <518222D3.3080109@zynstra.com>
	<20130522192834.GD10617@phenom.dumpdata.com>
	<519F1708.10603@zynstra.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519F1708.10603@zynstra.com>
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
To: James Dingwall <james.dingwall@zynstra.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Fri, May 24, 2013 at 08:30:16AM +0100, James Dingwall wrote:
> Konrad Rzeszutek Wilk wrote:
> >On Thu, May 02, 2013 at 09:24:51AM +0100, James Dingwall wrote:
> >>Dave Chinner wrote:
> >>>On Wed, May 01, 2013 at 11:20:44AM -0500, Ben Myers wrote:
> >>>>Hi James,
> >Hey folks,
> >I am walking through my vacation-emails-mbox.
> >
> >>>>On Wed, May 01, 2013 at 01:39:09PM +0100, James Dingwall wrote:
> >>>>>In reference to: http://oss.sgi.com/archives/xfs/2012-05/msg00046.html
> >>>>>
> >>>>>$ grep -r cleancache fs/xfs
> >>>>>on the 3.9 kernel source suggests that no patch was submitted to
> >>>>>enable cleancache for the XFS filesystem.  Since it was suggested
> >>>>>that this could be a one liner I've had a go and my first effort is
> >>>>>inline below.  While this seems to compile OK I have no experience
> >>>>>in filesystems so I would appreciate it if anyone can point out that
> >>>>>it is obviously wrong and likely to eat my data before I try booting
> >>>>>the kernel.
> >>>>>
> >>>>>If it seems a reasonable attempt what would be the best way to check
> >>>>>that it isn't doing nasty things?
> >>>>Hrm.. Looks like there is a doc in Documentation/vm/cleancache.txt which
> >>>>includes a list of attributes the filesystem needs to have to work properly
> >>>>with cleancache.
> >>>So, those points are:
> >>I had started to look at these too but I feel very out of my depth!
> >>I had similar conclusions to what Dave wrote but I don't think my
> >>thoughts should carry very much (any) weight.  Anyway I gambled and
> >>booted my xen domU with this patch and so far so good...  xen top
> >>shows that tmem is now being used where previously it wasn't.  I'll
> >>try running the xfstests at the weekend after a couple more days up
> >>time to see what happens.
> >And how did it go?
> I am running the patch I created on 3.9.3 on half of my xen guests
> now and have not noticed any stability or filesystem problems.  xl
> top with 'T' shows that the guests running with it are using
> ephemeral pages were those without do not.  I did do some runs with
> xfstests which had some failures but they were present with and
> without the patch.  The best I can really offer is that it works for
> me, ymmv.  The patch is available as commit
> c725011c4fc5d47e12d131f61bd91a58a40036b5 in
> https://github.com/JKDingwall/linux.git xfs-enable-cleancache or in
> the first message of this thread.

Hey James,

I've run this patch on my local tree and it looks to work right. I am
saying "looks" as I am hitting some other issue that I believe are
unralted to the patch - but I need to figure them out before I can
comfortably say: "Yes, this looks right and works for me as well."

Stay tuned.
> 
> Regards,
> James
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
