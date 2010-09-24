Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ODI7st183464 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 08:18:07 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 993CB9A650
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 06:19:00 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id YqnlPVdnVc7blFsX for
	<xfs@oss.sgi.com>; Fri, 24 Sep 2010 06:19:00 -0700 (PDT)
Date: Fri, 24 Sep 2010 15:18:58 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Problem with file system on iSCSI FileIO
Message-ID: <20100924151858.10528c86@harpe.intellique.com>
In-Reply-To: <4C9C875D.9050308@open-e.com>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
	<4C9C875D.9050308@open-e.com>
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
To: slawomir.nowakowski@open-e.com
Cc: xfs@oss.sgi.com

Le Fri, 24 Sep 2010 13:11:25 +0200
Slawomir Nowakowski <slawomir.nowakowski@open-e.com> =E9crivait:

> But we believe the problem is with the XFS. With unknown reason we
> are not able to mount the LV and after running xfs_repair the file is =

> missing from the LV. Do you have any ideas how we can try to fix the =

> broken XFS?

This doesn't really make much sense to me. What target are you using?
scst, tgt, lio or iet? What looks weird to me is that the dd command
example you gave writes over the xfs filesystem :

dd if=3D/dev/zero of=3D/dev/vg+vg00/lv+i+lv0000 bs=3D1M conv=3Dnotrunc

This is definitely incorrect. Given that /dev/vg+vg00/lv+i+lv0000 is
your xfs formatted lv, you must mount it somewhere :

mount /dev/vg+vg00/lv+i+lv0000 /mnt/whatever

Then you dd the file on /mnt/whatever :

dd if=3D/dev/zero of=3D/mnt/whatever/lunfile bs=3D1M

Lastly, you declare /mnt/whatever/lunfile as the lun in your target
(method varies depending upon the target used), something like (ietd
example):

Target iqn.2010-09:com.whatever.host.target1
	Alias host.target1
	Lun 0 Type=3Dfileio,Path=3Dmnt/whatever/lunfile,IOMode=3Dwback

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
