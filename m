Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D09B27FFE
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 05:48:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC8CE304043
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 03:48:23 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id kic1BoWSx0YU16OK for
	<xfs@oss.sgi.com>; Tue, 28 Jul 2015 03:48:22 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: XFS File system in trouble
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <55B73365.1050908@mygrande.net>
Date: Tue, 28 Jul 2015 11:48:18 +0100
Message-Id: <DB96438B-AE3A-400C-9DA1-F4A5CA2532D9@filmlight.ltd.uk>
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
	<55AA5FCE.4080702@sandeen.net>
	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
	<55AAF73A.4040903@mygrande.net>
	<20150720111747.GA53450@bfoster.bfoster>
	<55B73365.1050908@mygrande.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: Brian Foster <bfoster@redhat.com>, Kris Rusocki <kszysiu@braxis.org>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Roger Willcocks <roger@filmlight.ltd.uk>, "Rhorer,
	Leslie" <Leslie.Rhorer@level3.com>


On 28 Jul 2015, at 08:46, Leslie Rhorer <lrhorer@mygrande.net> wrote:

> =

> =

> 	So now, what?
> =



Either the filesystem has an error which xfs-repair doesn=92t see (which wo=
uld appear unlikely since you say that you could untar into an image of the=
 filesystem on an nfs mount); or you have a data-dependent hardware fault.

It=92s notable that the directory you=92re unpacking is a driver for a High=
point 2722 raid controller =97 is that the controller you=92re having probl=
ems with ?

=97
Roger


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
