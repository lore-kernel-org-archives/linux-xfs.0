Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3OLLYtJ184851 for <xfs@oss.sgi.com>; Sat, 24 Apr 2010 16:21:35 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1AB6E2ED7DE
	for <xfs@oss.sgi.com>; Sat, 24 Apr 2010 14:23:35 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 4um23oujZcrG7Cgz for
	<xfs@oss.sgi.com>; Sat, 24 Apr 2010 14:23:35 -0700 (PDT)
Date: Sat, 24 Apr 2010 23:23:20 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100424232320.71f764eb@galadriel.home>
In-Reply-To: <201004241844.23482.hpj@urpla.net>
References: <201004050049.17952.hpj@urpla.net> <20100413091823.GD7544@dastard>
	<201004131142.33518.hpj@urpla.net>
	<201004241844.23482.hpj@urpla.net>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Nick Piggin <npiggin@suse.de>, opensuse-kernel@opensuse.org, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Le Sat, 24 Apr 2010 18:44:22 +0200 vous =E9criviez:

> Greg, you might search for a server using xfs filesystems and and a
> i586 kernel >=3D 2.6.33, (2.6.32.11 of SLE11-SP1 will serve as well),
> log in as an ordinary user, do a "du" on /usr, and wait for the other
> users screaming...

I did precisely that, and didn't notice anything special (du on kernel
source tree) kernel 2.6.32.11, deadline scheduler, 7 drives RAID-6
array, 8GB RAM.

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
