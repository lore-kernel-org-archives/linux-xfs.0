Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7J8GrAq197199 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 03:17:08 -0500
Received: from intranet.easterngraphics.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9BC23DF712
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 01:17:18 -0700 (PDT)
Received: from intranet.easterngraphics.com (intranet.easterngraphics.com
	[62.80.28.49]) by cuda.sgi.com with ESMTP id rcACeVGoSEbnBk9w
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 01:17:18 -0700 (PDT)
From: Christian Fischer <Christian.Fischer@easterngraphics.com>
Subject: Re: [Patch] Re: xfs crash, kernel 2.6.29
Date: Wed, 19 Aug 2009 10:16:53 +0200
References: <200908110921.50752.Christian.Fischer@easterngraphics.com>
	<20090814141807.GA2891@infradead.org>
	<f4527be0908190050h5f3a4ca8h7d1712ab677616db@mail.gmail.com>
In-Reply-To: <f4527be0908190050h5f3a4ca8h7d1712ab677616db@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908191016.54339.Christian.Fischer@easterngraphics.com>
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
To: Andrew Lyon <andrew.lyon@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wednesday 19 August 2009, Andrew Lyon wrote:
> On Fri, Aug 14, 2009 at 3:18 PM, Christoph Hellwig<hch@infradead.org> wrote:
> > On Fri, Aug 14, 2009 at 02:56:58PM +0200, Christian Fischer wrote:
> >> backported to 2.6.29-xen-r4 from
> >> http://code.google.com/p/gentoo-xen-kernel/downloads/list
> >>
> >> Can you please review it?
> >
> > I'll reviewed it and do some QA over the weekend, and we'll send it to
> > -stable then.
>
> Did the patch fix the problem?
>
> Andy

Hi Andrew,

nice to hear you.

All i can say is that the kernel compiles and runs.

On my testbox I can't reproduce the fs crash, seems 2.6.29.4 is more stable 
than 2.6.30/31.

I've tried Erics steps to reproduce for 2.6.30/31, tried stressing the nfs 
mount with iozone, tried recursive unpacking and removing eclipse (a lot of 
small files) and this in a lot of parallel tasks.

Nothing triggers the bug.
You know, if I can't reproduce it I can't say whether it is fixed or not.

I'll update one server this week with the patched kernel and switch nfs on 
again, and wait then for the next crash. Hope that comes never.

Christian
-- 
------------------------------------------------------------
EasternGraphics - visualize your business

Christian Fischer
Administration
http://www.EasternGraphics.com
phone: +49 3677 678265

EasternGraphics GmbH - Albert-Einstein-Strasse 1 - DE-98693 Ilmenau
Geschaeftsfuehrer - Ekkehard Beier, Volker Blankenberg, Frank Wicht
Amtsgericht Jena - HRB 304052

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
