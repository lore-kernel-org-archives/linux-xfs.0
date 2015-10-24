Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A2E2C7F47
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 00:39:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27A18AC001
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 22:39:04 -0700 (PDT)
Received: from posta3.euchiamail.it (posta3.euchiamail.it [46.30.241.112]) by
	cuda.sgi.com with ESMTP id kL68QVGnCQCrLzCp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Oct 2015 22:39:01 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by posta3.euchiamail.it (Postfix) with ESMTP id 12FDA7E5FA6
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 07:38:57 +0200 (CEST)
Received: from posta3.euchiamail.it ([127.0.0.1])
	by localhost (sufferone.euchiamail.it [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id dGx3xLSuMjc8 for <xfs@oss.sgi.com>;
	Sat, 24 Oct 2015 07:38:54 +0200 (CEST)
Received: from linux (2-227-160-98.ip186.fastwebnet.it [2.227.160.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by posta3.euchiamail.it (Postfix) with ESMTPSA id 011A87E5FA5
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 07:38:52 +0200 (CEST)
Date: Sat, 24 Oct 2015 07:38:57 +0200
From: "krautus@kr916.org" <krautus@kr916.org>
Subject: Re: hdd + ssd
Message-ID: <20151024073857.6a77ee5f@linux>
In-Reply-To: <CAAxjCEzE68m66mhdr7KoXG7p515cmrogyT5Yr6S18nUXK9xNnw@mail.gmail.com>
References: <20151022202324.5f00807f@linux>
	<20151023134805.3c7998e4@harpe.intellique.com>
	<CAAxjCEzE68m66mhdr7KoXG7p515cmrogyT5Yr6S18nUXK9xNnw@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
Cc: Linux fs XFS <xfs@oss.sgi.com>

Thank you all for the suggestions!
I'll report back my progress, will take a while .. :)

Bye and have a nice week-end,
Mike

On Fri, 23 Oct 2015 23:34:00 +0200
Stefan Ring <stefanrin@gmail.com> wrote:

> On Fri, Oct 23, 2015 at 1:48 PM, Emmanuel Florac <eflorac@intellique.com> wrote:
> > YMMV, but here's my take:
> >
> >  * flashcache being a facebook internal dev, probably is the most
> >    largely deployed one. It's clearly production-ready.
> >
> >  * EnhanceIO works fine but I haven't tested it thoroughly. It adds no
> >    signature to the drives so it can be added to existing filesystems
> >    (flashcache and bcache need reformatting). However that means that
> >    bad thing may happen if you're careless -- it's clearly targeted at
> >    always-on servers.
> >
> >  * bcache works fine but the latest fixes haven't been backported, so
> >    you should probably use it only with latest (4.2, 4.3) kernels. It's
> >    not very mature yet but it's *friggin' fast*.
> >
> >  * dm-cache is the easiest to set-up with the lvmcache command (if your
> >    distro is recent enough of course). Like very very easy. It's
> >    unfortunately the slowest of the pack, apparently. Doesn't need
> >    reformatting IF your existing FS already lives in a LV.
> 
> Very good summary, thanks! Do you also happen to know if all of these
> retain cache contents across reboots?
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
