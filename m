Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AKT5Sr201917 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 15:29:05 -0500
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCC5716BB87A
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 13:36:15 -0700 (PDT)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	a0yVpf5J4QvxaVa4 for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 13:36:15 -0700 (PDT)
Received: by gyd10 with SMTP id 10so7825225gyd.26
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 13:29:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110100829.45823@zmi.at>
References: <201110071352.20135@zmi.at> <20111007233450.GK3159@dastard>
	<201110100829.45823@zmi.at>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Mon, 10 Oct 2011 16:28:33 -0400
Message-ID: <CAGpXXZJs8kjZaSp248rA+-d=gpwWe=oK0xtUUirv+zgE3Vq3kA@mail.gmail.com>
Subject: Re: TRIM on XFS
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Mon, Oct 10, 2011 at 2:29 AM, Michael Monnerie
<michael.monnerie@is.it-management.at> wrote:
>
> On Samstag, 8. Oktober 2011 Dave Chinner wrote:
> > e84661a xfs: add online discard support
> >
> > and
> >
> > a46db60 xfs: add FITRIM support
>
> I guess that means those patches are not released by now? Sorry, I know
> that these numbers are the patch ID, but don't know what to do with it.

I think online was added in the spring of this year, so around 2.6.38.

I don't know when batch kernel support went in, but I assume some time ago.

>
> > So both online and background trim methods are available.
>
> I found the threads in the mailing list. FITRIM v3 Patch was posted
> 7.Jan.2011, but even if it's in default kernel already - how would you
> call it?

fitrim is the batch mode.

To enable realtime discard, add --discard to your mount options.

Documented at http://lxr.linux.no/#linux+v3.0.4/Documentation/filesystems/x=
fs.txt

To invoke batch mode, simply use fstrim from user space.

>
> > Test well before using them in production, though, as buggy hardware
> > or thinp implementations are quite common....
>
> I have a NetApp Storage here that is quite capable :-)
> Just having no idea how to activate filesystem discard support :-(

Definitely test.  Particularly for performance.  Many are surprised to
see their performance drop not go up when they start using discard
heavily.

Many people assume realtime support is better than a batched version.

In most cases I believe users find the opposite to be true.

They can simply have cron call fstrim on a routine basis and all is
good.  ie. Maybe every night right after the backups complete.

Especially when talking about thin provisioning, fstrim has more
flexibility.=A0 You can tell it to only discard free areas that meet
minimum size criteria.=A0 So if your thin provisioning is 1MB at a time,
it would be logical to pass 1 MB to fstrim as a minimum discard size.
You can't do that with mount --discard

>
> --
> mit freundlichen Gr=FCssen,
> Michael Monnerie, Ing. BSc

HTH
Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
