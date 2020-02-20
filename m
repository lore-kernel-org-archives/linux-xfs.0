Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57070C11D0C
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 18:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 271E5208E4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 18:34:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L7SUn6i8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgBTSe6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 13:34:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36366 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgBTSe6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 13:34:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KIV0Qv081852;
        Thu, 20 Feb 2020 18:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=SXELtnbuh89BH0ELz5is11nHMJ8mZsgcAQ32Iwi8u1o=;
 b=L7SUn6i85dn5S1l+DuWB+/804SxSnzi9g+S1vdg2EWnSp5inRVeL7gtgwNE6a35SKWP3
 W/gViFFwNeXwDVwzEgHgNs+KvD40lpq8YytnRvJ5ZgAAbZcH6y0ZBSaFTIfoWDe4c3LV
 3XjHnHLcc5AHhYk9ZwMe3fKKgbbwfivQL+H+UtEmylod7r7UiedcHPlk8Q6XbnqeIM1Z
 2x4Q30cDMpz4Z9J2jOTvvaudUsZ09ISQNpBKItVtMuSngkiDnq8lnDy2buPwtOfej3Xi
 NSzh5+GmKlwEwzwsDehYdrQSmuWoTb++wyxA4KSrlZk675irEj/J3Z4fVl/ksnPjHpba uQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2y8uddbp6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 18:34:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KIRxON166698;
        Thu, 20 Feb 2020 18:34:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2y8ud6pw5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 18:34:53 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01KIYqhV007678;
        Thu, 20 Feb 2020 18:34:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Feb 2020 10:34:52 -0800
Date:   Thu, 20 Feb 2020 10:34:50 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_db: check that metadata updates have been
 committed
Message-ID: <20200220183450.GA9506@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
 <158216293385.601264.3202158027072387776.stgit@magnolia>
 <20200220140623.GC48977@bfoster>
 <20200220165840.GX9506@magnolia>
 <20200220175857.GI48977@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220175857.GI48977@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 12:58:57PM -0500, Brian Foster wrote:
> On Thu, Feb 20, 2020 at 08:58:40AM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 20, 2020 at 09:06:23AM -0500, Brian Foster wrote:
> > > On Wed, Feb 19, 2020 at 05:42:13PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Add a new function that will ensure that everything we scribbled on has
> > > > landed on stable media, and report the results.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  db/init.c |   14 ++++++++++++++
> > > >  1 file changed, 14 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/db/init.c b/db/init.c
> > > > index 0ac37368..e92de232 100644
> > > > --- a/db/init.c
> > > > +++ b/db/init.c
> > > > @@ -184,6 +184,7 @@ main(
> > > >  	char	*input;
> > > >  	char	**v;
> > > >  	int	start_iocur_sp;
> > > > +	int	d, l, r;
> > > >  
> > > >  	init(argc, argv);
> > > >  	start_iocur_sp = iocur_sp;
> > > > @@ -216,6 +217,19 @@ main(
> > > >  	 */
> > > >  	while (iocur_sp > start_iocur_sp)
> > > >  		pop_cur();
> > > > +
> > > > +	libxfs_flush_devices(mp, &d, &l, &r);
> > > > +	if (d)
> > > > +		fprintf(stderr, _("%s: cannot flush data device (%d).\n"),
> > > > +				progname, d);
> > > > +	if (l)
> > > > +		fprintf(stderr, _("%s: cannot flush log device (%d).\n"),
> > > > +				progname, l);
> > > > +	if (r)
> > > > +		fprintf(stderr, _("%s: cannot flush realtime device (%d).\n"),
> > > > +				progname, r);
> > > > +
> > > > +
> > > 
> > > Seems like we could reduce some boilerplate by passing progname into
> > > libxfs_flush_devices() and letting it dump out of the error messages,
> > > unless there's some future code that cares about individual device error
> > > state.
> > 
> > Such a program could call libxfs_flush_devices directly, as we do here.
> > 
> 
> Right.. but does anything actually care about that level of granularity
> right now beyond having a nicer error message?

No, afaict.

> > Also, progname is defined in libxfs so we don't even need to pass it as
> > an argument.
> > 
> 
> Ok.
> 
> > I had originally thought that we should try not to add fprintf calls to
> > libxfs because libraries aren't really supposed to be doing things like
> > that, but perhaps you're right that all of this should be melded into
> > something else.
> > 
> 
> Yeah, fair point, though I guess it depends on the particular library. 

I mean... is libxfs even a real library? :)

> > > That said, it also seems the semantics of libxfs_flush_devices() are a
> > > bit different from convention. Just below we invoke
> > > libxfs_device_close() for each device (rather than for all three), and
> > > device_close() also happens to call fsync() and platform_flush_device()
> > > itself...
> > 
> > Yeah, the division of responsibilities is a little hazy here -- I would
> > think that unmounting a filesystem should flush all the memory caches
> > and then the disk cache, but OTOH it's the utility that opens the
> > devices and should therefore flush and close them.
> > 
> > I dunno.  My current thinking is that libxfs_umount should call
> > libxfs_flush_devices() and print error messages as necessary, and return
> > error codes as appropriate.  xfs_repair can then check the umount return
> > value and translate that into exit(1) as required.  The device_close
> > functions will fsync a second time, but that shouldn't be a big deal
> > because we haven't dirtied anything in the meantime.
> > 
> > Thoughts?
> > 
> 
> I was thinking of having a per-device libxfs_device_flush() along the
> lines of libxfs_device_close() and separating out that functionality,
> but one could argue we're also a bit inconsistent between libxfs_init()
> opening the devices and having to close them individually.

Yeah, I don't understand why libxfs_destroy doesn't empty out the same
struct libxfs_init that libxfs_init populates.  Or why we have a global
variable named "x", or why the buffer cache is a global variable.
However, those sound like refactoring for another series.

> I think
> having libxfs_umount() do a proper purge -> flush and returning any
> errors instead is a fair tradeoff for simplicity. Removing the
> flush_devices() API also eliminates risk of somebody incorrectly
> attempting the flush after the umount frees the buftarg structures
> (without reinitializing pointers :P).

Ok, I'll add a separate patch to null out the xfs_mount so that any
further use (afaict there aren't any) will crash immediately on reuse.

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > >  	libxfs_umount(mp);
> > > >  	if (x.ddev)
> > > >  		libxfs_device_close(x.ddev);
> > > > 
> > > 
> > 
> 
