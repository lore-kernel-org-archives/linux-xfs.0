Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8CDC11D0C
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 17:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A95452467A
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 17:59:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z9HCnnjN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgBTR7G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 12:59:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49961 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727285AbgBTR7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 12:59:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582221544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1Cc2QpCgdic5D8u47gdWPeOsbbSTTW3hNkoTZdN9hA0=;
        b=Z9HCnnjN3CtK3MPn90iV5suSffhVZTVuq3uCMTddKDcJVOKv/SAx9LI6wtdvC/G8Cih/fJ
        sHCg/8esiVtSuYzMGxKzbtsabgAsettzkGbrf0QxjQ/JlRIlg3KgUstWY/x0XY5A6/KPt/
        Pdzk0TEhWWBehQKeWywtsWl7BEAlQh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-1UqoTRmAPvmxT5NWTvvEwQ-1; Thu, 20 Feb 2020 12:59:00 -0500
X-MC-Unique: 1UqoTRmAPvmxT5NWTvvEwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE172100726F;
        Thu, 20 Feb 2020 17:58:59 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54E7E909E1;
        Thu, 20 Feb 2020 17:58:59 +0000 (UTC)
Date:   Thu, 20 Feb 2020 12:58:57 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_db: check that metadata updates have been
 committed
Message-ID: <20200220175857.GI48977@bfoster>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
 <158216293385.601264.3202158027072387776.stgit@magnolia>
 <20200220140623.GC48977@bfoster>
 <20200220165840.GX9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220165840.GX9506@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 08:58:40AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 20, 2020 at 09:06:23AM -0500, Brian Foster wrote:
> > On Wed, Feb 19, 2020 at 05:42:13PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Add a new function that will ensure that everything we scribbled on has
> > > landed on stable media, and report the results.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  db/init.c |   14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > > 
> > > 
> > > diff --git a/db/init.c b/db/init.c
> > > index 0ac37368..e92de232 100644
> > > --- a/db/init.c
> > > +++ b/db/init.c
> > > @@ -184,6 +184,7 @@ main(
> > >  	char	*input;
> > >  	char	**v;
> > >  	int	start_iocur_sp;
> > > +	int	d, l, r;
> > >  
> > >  	init(argc, argv);
> > >  	start_iocur_sp = iocur_sp;
> > > @@ -216,6 +217,19 @@ main(
> > >  	 */
> > >  	while (iocur_sp > start_iocur_sp)
> > >  		pop_cur();
> > > +
> > > +	libxfs_flush_devices(mp, &d, &l, &r);
> > > +	if (d)
> > > +		fprintf(stderr, _("%s: cannot flush data device (%d).\n"),
> > > +				progname, d);
> > > +	if (l)
> > > +		fprintf(stderr, _("%s: cannot flush log device (%d).\n"),
> > > +				progname, l);
> > > +	if (r)
> > > +		fprintf(stderr, _("%s: cannot flush realtime device (%d).\n"),
> > > +				progname, r);
> > > +
> > > +
> > 
> > Seems like we could reduce some boilerplate by passing progname into
> > libxfs_flush_devices() and letting it dump out of the error messages,
> > unless there's some future code that cares about individual device error
> > state.
> 
> Such a program could call libxfs_flush_devices directly, as we do here.
> 

Right.. but does anything actually care about that level of granularity
right now beyond having a nicer error message?

> Also, progname is defined in libxfs so we don't even need to pass it as
> an argument.
> 

Ok.

> I had originally thought that we should try not to add fprintf calls to
> libxfs because libraries aren't really supposed to be doing things like
> that, but perhaps you're right that all of this should be melded into
> something else.
> 

Yeah, fair point, though I guess it depends on the particular library. 

> > That said, it also seems the semantics of libxfs_flush_devices() are a
> > bit different from convention. Just below we invoke
> > libxfs_device_close() for each device (rather than for all three), and
> > device_close() also happens to call fsync() and platform_flush_device()
> > itself...
> 
> Yeah, the division of responsibilities is a little hazy here -- I would
> think that unmounting a filesystem should flush all the memory caches
> and then the disk cache, but OTOH it's the utility that opens the
> devices and should therefore flush and close them.
> 
> I dunno.  My current thinking is that libxfs_umount should call
> libxfs_flush_devices() and print error messages as necessary, and return
> error codes as appropriate.  xfs_repair can then check the umount return
> value and translate that into exit(1) as required.  The device_close
> functions will fsync a second time, but that shouldn't be a big deal
> because we haven't dirtied anything in the meantime.
> 
> Thoughts?
> 

I was thinking of having a per-device libxfs_device_flush() along the
lines of libxfs_device_close() and separating out that functionality,
but one could argue we're also a bit inconsistent between libxfs_init()
opening the devices and having to close them individually. I think
having libxfs_umount() do a proper purge -> flush and returning any
errors instead is a fair tradeoff for simplicity. Removing the
flush_devices() API also eliminates risk of somebody incorrectly
attempting the flush after the umount frees the buftarg structures
(without reinitializing pointers :P).

Brian

> --D
> 
> > Brian
> > 
> > >  	libxfs_umount(mp);
> > >  	if (x.ddev)
> > >  		libxfs_device_close(x.ddev);
> > > 
> > 
> 

