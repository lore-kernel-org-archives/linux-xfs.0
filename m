Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B97C11D00
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 00:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0233207FD
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 00:41:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CuNROqWh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgBUAl3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 19:41:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53580 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729365AbgBUAl3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 19:41:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01L0YElK169433;
        Fri, 21 Feb 2020 00:41:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aa1zkPjM74iK2ByfhK4MusknhhehHE7ZZ2VJfd99/Rg=;
 b=CuNROqWhL9LYrbCtwAd+FGg0lthtx9+HSEnQA3/MGOF0MrDiM0kZTkVz7HkR+4fwvIqk
 ZbKiU6eSy/fC+0aZoqsVWxgvnrcayQM2O4Vb++VtrT1ucSto0aY6eqdYBjP3G8u8Og7T
 B20tsyCX9cD70NXcOdRidopY/2f18q7rQxcKr87jeXdardTIeRsiu9KiswRL1ejuwlJ0
 lUO7fJ3a7OGg3C5G2AKnPNY15JVjFqh8KnKwAWgk5mpwgutkF77t2oe86IkonC2HIR40
 OIVta6PR37Ifu5j8m453VU+9nbZE09sUnPlhjdx4nQ50Q8e3FTcaafuvaik7tPLcIaMF 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2y8ud1dbwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 00:41:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01L0Vgbu129113;
        Fri, 21 Feb 2020 00:39:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2y8ud545yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 00:39:22 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01L0dLdT028308;
        Fri, 21 Feb 2020 00:39:21 GMT
Received: from localhost (/10.145.178.17)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Feb 2020 16:39:20 -0800
Date:   Thu, 20 Feb 2020 16:39:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_db: check that metadata updates have been
 committed
Message-ID: <20200221003921.GE9506@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
 <158216293385.601264.3202158027072387776.stgit@magnolia>
 <20200220140623.GC48977@bfoster>
 <20200220165840.GX9506@magnolia>
 <20200220175857.GI48977@bfoster>
 <20200220183450.GA9506@magnolia>
 <20200221000119.GR10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221000119.GR10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=2 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=2 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 11:01:19AM +1100, Dave Chinner wrote:
> On Thu, Feb 20, 2020 at 10:34:50AM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 20, 2020 at 12:58:57PM -0500, Brian Foster wrote:
> > > On Thu, Feb 20, 2020 at 08:58:40AM -0800, Darrick J. Wong wrote:
> > > > On Thu, Feb 20, 2020 at 09:06:23AM -0500, Brian Foster wrote:
> > > > > On Wed, Feb 19, 2020 at 05:42:13PM -0800, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > 
> > > > > > Add a new function that will ensure that everything we scribbled on has
> > > > > > landed on stable media, and report the results.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > ---
> > > > > >  db/init.c |   14 ++++++++++++++
> > > > > >  1 file changed, 14 insertions(+)
> > > > > > 
> > > > > > 
> > > > > > diff --git a/db/init.c b/db/init.c
> > > > > > index 0ac37368..e92de232 100644
> > > > > > --- a/db/init.c
> > > > > > +++ b/db/init.c
> > > > > > @@ -184,6 +184,7 @@ main(
> > > > > >  	char	*input;
> > > > > >  	char	**v;
> > > > > >  	int	start_iocur_sp;
> > > > > > +	int	d, l, r;
> > > > > >  
> > > > > >  	init(argc, argv);
> > > > > >  	start_iocur_sp = iocur_sp;
> > > > > > @@ -216,6 +217,19 @@ main(
> > > > > >  	 */
> > > > > >  	while (iocur_sp > start_iocur_sp)
> > > > > >  		pop_cur();
> > > > > > +
> > > > > > +	libxfs_flush_devices(mp, &d, &l, &r);
> > > > > > +	if (d)
> > > > > > +		fprintf(stderr, _("%s: cannot flush data device (%d).\n"),
> > > > > > +				progname, d);
> > > > > > +	if (l)
> > > > > > +		fprintf(stderr, _("%s: cannot flush log device (%d).\n"),
> > > > > > +				progname, l);
> > > > > > +	if (r)
> > > > > > +		fprintf(stderr, _("%s: cannot flush realtime device (%d).\n"),
> > > > > > +				progname, r);
> > > > > > +
> > > > > > +
> > > > > 
> > > > > Seems like we could reduce some boilerplate by passing progname into
> > > > > libxfs_flush_devices() and letting it dump out of the error messages,
> > > > > unless there's some future code that cares about individual device error
> > > > > state.
> > > > 
> > > > Such a program could call libxfs_flush_devices directly, as we do here.
> > > > 
> > > 
> > > Right.. but does anything actually care about that level of granularity
> > > right now beyond having a nicer error message?
> > 
> > No, afaict.
> > 
> > > > Also, progname is defined in libxfs so we don't even need to pass it as
> > > > an argument.
> > > > 
> > > 
> > > Ok.
> > > 
> > > > I had originally thought that we should try not to add fprintf calls to
> > > > libxfs because libraries aren't really supposed to be doing things like
> > > > that, but perhaps you're right that all of this should be melded into
> > > > something else.
> > > > 
> > > 
> > > Yeah, fair point, though I guess it depends on the particular library. 
> > 
> > I mean... is libxfs even a real library? :)
> 
> It's an internal abstraction to allow code to be shared easily with
> the kernel and between xfsprogs binaries. It is not a library in the
> sense it has a fixed API and ABI that compatibility has to be
> maintained across releases (i.e. like, say, libhandle). It is a
> library in the sense is contains shared code that things within the
> build don't have to re-implement them over and over again, and
> because it is internal that means the rules for external/distro
> level libraries don't need to be strictly applied.
> 
> e.g. if -everything- uses a global variable and has to declares it
> themselves so the shared internal code can access it, then why not
> just declare it in the shared code? :)

Fair enough.  It's a sharedcode library.

> > > > I dunno.  My current thinking is that libxfs_umount should call
> > > > libxfs_flush_devices() and print error messages as necessary, and return
> > > > error codes as appropriate.  xfs_repair can then check the umount return
> > > > value and translate that into exit(1) as required.  The device_close
> > > > functions will fsync a second time, but that shouldn't be a big deal
> > > > because we haven't dirtied anything in the meantime.
> > > > 
> > > > Thoughts?
> > > > 
> > > 
> > > I was thinking of having a per-device libxfs_device_flush() along the
> > > lines of libxfs_device_close() and separating out that functionality,
> > > but one could argue we're also a bit inconsistent between libxfs_init()
> > > opening the devices and having to close them individually.
> > 
> > Yeah, I don't understand why libxfs_destroy doesn't empty out the same
> > struct libxfs_init that libxfs_init populates.  Or why we have a global
> > variable named "x", or why the buffer cache is a global variable.
> > However, those sound like refactoring for another series.
> 
> You mean structure the unmount code like we do in teh kernel? e.g:
> 
> > > I think
> > > having libxfs_umount() do a proper purge -> flush and returning any
> > > errors instead is a fair tradeoff for simplicity. Removing the
> > > flush_devices() API also eliminates risk of somebody incorrectly
> > > attempting the flush after the umount frees the buftarg structures
> > > (without reinitializing pointers :P).
> 
> You mean like this code that I'm slowly working on to bring the
> xfs_buf.c code across to userspace and get rid of the heap of crap
> we have in libxfs/{rdwr,cache}.c now and be able to use AIO properly
> and do non-synchronous delayed writes like we do in the kernel?
> 
> libxfs/init.c:
> ....
> static void
> buftarg_cleanup(
>         struct xfs_buftarg      *btp)
> {
>         if (!btp)
>                 return;
> 
>         while (btp->bt_lru.l_count > 0)
>                 xfs_buftarg_shrink(btp, 1000);
>         xfs_buftarg_wait(btp);
>         xfs_buftarg_free(btp);

Not quite what the v3 series does, but only because it's still stuck
with "whack the bcache and then go see what happened to each buftarg".

> }
> 
> /*
>  * Release any resource obtained during a mount.
>  */
> void
> libxfs_umount(
>         struct xfs_mount        *mp)
> {
>         struct xfs_perag        *pag;
>         int                     agno;
> 
>         libxfs_rtmount_destroy(mp);
> 
>         buftarg_cleanup(mp->m_ddev_targp);
>         buftarg_cleanup(mp->m_rtdev_targp);
>         if (mp->m_logdev_targp != mp->m_ddev_targp)
>                 buftarg_cleanup(mp->m_logdev_targp);

Yep, that's exactly where I moved the cleanup call in v3.

> .....
> 
> libxfs/xfs_buftarg.c:
> .....
> void
> xfs_buftarg_free(
>         struct xfs_buftarg      *btp)
> {
>         ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
>         percpu_counter_destroy(&btp->bt_io_count);
>         platform_flush_device(btp->bt_fd, btp->bt_bdev);
> 	libxfs_device_close(btp->bt_bdev);
>         free(btp);

I'm assuming this means you've killed off the buffer handling parts of
struct libxfs_xinit too?

> }
> 
> I haven't added the error returns for this code yet - I'm still
> doing the conversion and making it work.
> 
> I'll probably have to throw the vast majority of that patchset away
> and start again if all this API change that darrick has done is
> merged. And that will probably involve me throwing away all of the
> changes in this patch series because they just don't make any sense
> once the code is restructured properly....

...or just throw them at me in whatever state they're in now and let me
help figure out how to get there?

Everyone: don't be afraid of the 'RFCRAP' for interim patchsets.
Granted, posting git branches with a timestamp might be more
practicable...

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
