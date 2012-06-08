Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58AplCF196792 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 05:51:47 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 72Konw50RyOpo2qK for
	<xfs@oss.sgi.com>; Fri, 08 Jun 2012 03:51:43 -0700 (PDT)
Date: Fri, 8 Jun 2012 12:51:38 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Repeated XFS corruption on RAID-10 on Adaptec 51245
Message-ID: <20120608125138.20c79cee@harpe.intellique.com>
In-Reply-To: <4FD1C9B8.70907@internet-sicherheit.de>
References: <4FD1C9B8.70907@internet-sicherheit.de>
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
To: "Christian J. Dietrich" <dietrich@internet-sicherheit.de>
Cc: xfs@oss.sgi.com

Le Fri, 08 Jun 2012 11:45:28 +0200
"Christian J. Dietrich" <dietrich@internet-sicherheit.de> =E9crivait:

> I am running CentOS 6.2 (=3DRHEL 6.2) with kernel
> 2.6.32-220.17.1.el6.x86_64 (most recent) and all OS updates installed.
> Controller Firmware is the most recent (18948), driver version is
> 1.1-5. HDDs are 2x WD2001FASS, 10x WD2002FAEX.
> =


I currently manage many servers (about 50) with Adaptec 5xx5 raid
cards. The only case of data corruption I've met was with WD drives.

Therefore it's most probably related to the WD drives. WD desktop
drives are well known for being (voluntarily) crippled for RAID
operation. They will almost always create all sort of weird problems
when running under high IO load.

It is of utmost importance that you at least take care of setting TLER
in the correct mode on the drives. Beware that apparently newer WD
drives don't even allow setting TLER properly anymore (I said
"crippled").

http://en.wikipedia.org/wiki/Time-Limited_Error_Recovery


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
