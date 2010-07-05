Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o65FAovG126548 for <xfs@oss.sgi.com>; Mon, 5 Jul 2010 10:10:50 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F37DA15B4692
	for <xfs@oss.sgi.com>; Mon,  5 Jul 2010 08:18:59 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 5QM0JBFeLXh1uuGL for
	<xfs@oss.sgi.com>; Mon, 05 Jul 2010 08:18:59 -0700 (PDT)
Date: Mon, 5 Jul 2010 17:13:38 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Slow delete
Message-ID: <20100705171338.3bb38e1d@harpe.intellique.com>
In-Reply-To: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>
References: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>
Mime-Version: 1.0
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
To: Andrei Deftu <andreideftu@gmail.com>
Cc: xfs@oss.sgi.com

Le Mon, 5 Jul 2010 17:27:44 +0300
Andrei Deftu <andreideftu@gmail.com> =E9crivait:

> As many people have pointed out, xfs is very slow when deleting a
> large number of files. Does anyone has a technical answer to this
> problem? Also, I am interested to know if there is a way to
> temporarily speed up the delete process, regardless of all the other
> parameters.

Using the "nobarrier" mount option (when applicable/advisable)
considerably speeds up metadata operations.
Another possibility is to use a ramdisk (or /dev/null) as a log device
though it could be... dangerous :)

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
