Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FEDE7F6F
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 16:34:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7014D304059
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 14:34:03 -0700 (PDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
	[209.85.212.179]) by cuda.sgi.com with ESMTP id
	qsCMlh1ruvkBK37C (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Oct 2015 14:34:01 -0700 (PDT)
Received: by wicfx6 with SMTP id fx6so47533006wic.1
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 14:34:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151023134805.3c7998e4@harpe.intellique.com>
References: <20151022202324.5f00807f@linux>
	<20151023134805.3c7998e4@harpe.intellique.com>
Date: Fri, 23 Oct 2015 23:34:00 +0200
Message-ID: <CAAxjCEzE68m66mhdr7KoXG7p515cmrogyT5Yr6S18nUXK9xNnw@mail.gmail.com>
Subject: Re: hdd + ssd
From: Stefan Ring <stefanrin@gmail.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>, "krautus@kr916.org" <krautus@kr916.org>

On Fri, Oct 23, 2015 at 1:48 PM, Emmanuel Florac <eflorac@intellique.com> wrote:
> YMMV, but here's my take:
>
>  * flashcache being a facebook internal dev, probably is the most
>    largely deployed one. It's clearly production-ready.
>
>  * EnhanceIO works fine but I haven't tested it thoroughly. It adds no
>    signature to the drives so it can be added to existing filesystems
>    (flashcache and bcache need reformatting). However that means that
>    bad thing may happen if you're careless -- it's clearly targeted at
>    always-on servers.
>
>  * bcache works fine but the latest fixes haven't been backported, so
>    you should probably use it only with latest (4.2, 4.3) kernels. It's
>    not very mature yet but it's *friggin' fast*.
>
>  * dm-cache is the easiest to set-up with the lvmcache command (if your
>    distro is recent enough of course). Like very very easy. It's
>    unfortunately the slowest of the pack, apparently. Doesn't need
>    reformatting IF your existing FS already lives in a LV.

Very good summary, thanks! Do you also happen to know if all of these
retain cache contents across reboots?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
