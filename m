Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7NIkvCk211020 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 13:46:57 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E48D2191A8F5
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 11:46:55 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	tlSIe1lcDn1AxCqE for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 11:46:55 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) (authenticated bits=0)
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with
	ESMTP id p7NIkqnR016816
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=FAIL)
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 11:46:54 -0700
Received: by wyg36 with SMTP id 36so338932wyg.26
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 11:46:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108231739.p7NHdXQ8008360@stout.americas.sgi.com>
References: <201108231739.p7NHdXQ8008360@stout.americas.sgi.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 23 Aug 2011 11:46:30 -0700
Message-ID: <CA+55aFxEyj8qJnr9QR3Scy7SFocEr2BNA9z4PXs7q9rpkXM1vQ@mail.gmail.com>
Subject: Re: [GIT PULL] XFS update for 3.1-rc4
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
To: Alex Elder <aelder@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 23, 2011 at 10:39 AM, Alex Elder <aelder@sgi.com> wrote:
>
> Linus, please pull the following XFS changes. =A0Their effect is to
> remove the subdirectory structure from the XFS source hierarchy.
> There are no functional changes to the XFS code itself. =A0Thanks.

Pulled.

Any plans to further sanitize the namespace?

It's kind of crazy to have filenames like

   fs/xfs/xfs_trace.c

which just duplicate the "xfs" part for no good reason. Why not just
do something like

  for i in xfs_*; do j=3D$(echo $i | sed 's/^xfs_//'); git mv $i $j; done

to get rid of the silly "xfs_" prefix that adds nothing?

You could use the bytes you save to rename "qm.c" to "quota_manager.c"
instead. Wouldn't it be nice to have *good* names, instead of a jumble
of crazy and mostly redundant letters?

                        Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
