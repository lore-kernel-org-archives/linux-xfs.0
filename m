Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o74KYc12047601 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 15:34:38 -0500
Received: from lennier.cc.vt.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E702949591B
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 13:34:58 -0700 (PDT)
Received: from lennier.cc.vt.edu (lennier.cc.vt.edu [198.82.162.213]) by
	cuda.sgi.com with ESMTP id AadOuz0IKuKgApze for
	<xfs@oss.sgi.com>; Wed, 04 Aug 2010 13:34:58 -0700 (PDT)
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
In-Reply-To: Your message of "Wed, 04 Aug 2010 12:25:26 +0200."
	<20100804102526.GB13766@isilmar-3.linta.de>
From: Valdis.Kletnieks@vt.edu
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
Mime-Version: 1.0
Date: Wed, 04 Aug 2010 16:33:06 -0400
Message-ID: <15446.1280953986@localhost>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5364902876820659234=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com

--===============5364902876820659234==
Content-Type: multipart/signed; boundary="==_Exmh_1280953986_3909P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit

--==_Exmh_1280953986_3909P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <15440.1280953986.1@localhost>

On Wed, 04 Aug 2010 12:25:26 +0200, Dominik Brodowski said:

> The "good" news: it also happens on my notebook, even though it has a
> different setup (no raid, disk -> lv/vg -> crypt). On my notebook, I'm
> more than happy to test out different kernel versions, patches etc.
> 
> /dev/sd*                17.7 MB/s       (100 %)
> /dev/mapper/vg1-*       16.2 MB/s       ( 92 %)
> /dev/mapper/*_crypt      3.1 MB/s       ( 18 %)

Unfortunately, on my laptop with a similar config, I'm seeing this:

# dd if=/dev/sda bs=8k count=1000000 of=/dev/null
1000000+0 records in
1000000+0 records out
8192000000 bytes (8.2 GB) copied, 108.352 s, 75.6 MB/s
# dd if=/dev/sda2 bs=8k count=1000000 of=/dev/null
1000000+0 records in
1000000+0 records out
8192000000 bytes (8.2 GB) copied, 105.105 s, 77.9 MB/s
# dd if=/dev/mapper/vg_blackice-root bs=8k count=100000 of=/dev/null
100000+0 records in
100000+0 records out
819200000 bytes (819 MB) copied, 11.6469 s, 70.3 MB/s

The raw disk, the LUKS-encrypted partition that's got a LVM on it, and a
crypted LVM partition. The last run spikes both CPUs up to about 50%CPU each.
So whatever it is, it's somehow more subtle than that.  Maybe the fact that
in my case, it's disk, crypto, and LVM on the crypted partition, rather than
crypted filesystems on an LVM volume?


--==_Exmh_1280953986_3909P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMWc6CcC3lWbTT17ARAiAuAKCfL5NTEQUgaL9kVy6x0SN/ryDfbgCg9vhS
WfKyIOBnRrmDh2eZQDebem0=
=iHTW
-----END PGP SIGNATURE-----

--==_Exmh_1280953986_3909P--


--===============5364902876820659234==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5364902876820659234==--
