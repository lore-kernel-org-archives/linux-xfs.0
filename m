Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n99JRMGg094750 for <xfs@oss.sgi.com>; Fri, 9 Oct 2009 14:27:23 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56BBABF6AE9
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2009 12:28:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DzCfIIpCP69hJEAG for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2009 12:28:49 -0700 (PDT)
Message-ID: <4ACF8EEF.1040809@sandeen.net>
Date: Fri, 09 Oct 2009 14:28:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can't mount XFS from a read-only device
References: <20091009170937.3938ff7b@harpe.intellique.com>	<4ACF8801.7070009@sandeen.net>
	<20091009212150.2b54cb77@galadriel.home>
In-Reply-To: <20091009212150.2b54cb77@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Emmanuel Florac wrote:
> Le Fri, 09 Oct 2009 13:59:13 -0500 vous =E9criviez:
> =

>> try mount -o norecovery (and maybe -o nobarrier)
> =

> Thank you, that worked.
> =

> I can't help but think that when given the "ro" option, XFS shouldn't
> try to write a single bit to the underlying device, or else what's the
> point?

For a dirty log, we do still recover -unless- the underlying device is
RO.  Otherwise you get a corrupt fs mounted ro.... other filesystems do
the same thing, FWIW.

For a clean log I agree; what kernel was this?  I vaguely remember a fix
in this area.

Which option solved it?  (norecovery I'm guessing)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
