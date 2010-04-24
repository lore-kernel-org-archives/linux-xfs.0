Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3OMSpk2189922 for <xfs@oss.sgi.com>; Sat, 24 Apr 2010 17:28:51 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B9258C3161
	for <xfs@oss.sgi.com>; Sat, 24 Apr 2010 15:30:51 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186]) by cuda.sgi.com with ESMTP id
	pG3boNtgKuTugY9J for <xfs@oss.sgi.com>;
	Sat, 24 Apr 2010 15:30:51 -0700 (PDT)
From: "Hans-Peter Jansen" <hpj@urpla.net>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Date: Sun, 25 Apr 2010 00:30:40 +0200
References: <201004050049.17952.hpj@urpla.net>
	<201004241844.23482.hpj@urpla.net>
	<20100424232320.71f764eb@galadriel.home>
In-Reply-To: <20100424232320.71f764eb@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201004250030.40867.hpj@urpla.net>
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
Cc: Nick Piggin <npiggin@suse.de>, opensuse-kernel@opensuse.org, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Saturday 24 April 2010, 23:23:20 Emmanuel Florac wrote:
> Le Sat, 24 Apr 2010 18:44:22 +0200 vous =E9criviez:
> > Greg, you might search for a server using xfs filesystems and and a
> > i586 kernel >=3D 2.6.33, (2.6.32.11 of SLE11-SP1 will serve as well),
> > log in as an ordinary user, do a "du" on /usr, and wait for the other
> > users screaming...
>
> I did precisely that, and didn't notice anything special (du on kernel
> source tree) kernel 2.6.32.11, deadline scheduler, 7 drives RAID-6
> array, 8GB RAM.

I guess, you're not on this specific openSUSE git version of 2.6.32.11 (e.g=
. =

the preparation for SP1 of SLE11), which, as usual, carries a lot of stuff =

from later kernels. The offending patch was included in linux-2.6.33 =

between -rc4 and -rc5:

Committer
Alex Elder<aelder@sgi.com>
Author
Dave Chinner<david@fromorbit.com>
Author date
11.01.10 00:51
Parent
xfs: Avoid inodes in reclaim when flushing from inode cache
Child
xfs: Remove inode iolock held check during allocation
Branch
master origin (Merge branch 'for-linus' of git://git.kernel.org/pub/scm/...=
) =

Branch
2.6.33.1 (Linux 2.6.33) =

Follows
v2.6.33-rc4 (Linux 2.6.33-rc4)
Precedes
v2.6.33-rc5 (Linux 2.6.33-rc5)

Cheers,
Pete

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
