Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 78A797F50
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2015 11:42:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 55BD030404E
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2015 09:42:11 -0700 (PDT)
Received: from mail.vlasiu.net (mail.vlasiu.net [91.223.50.125]) by
	cuda.sgi.com with ESMTP id aVQCNXyy2SYyJK96 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Jun 2015 09:42:10 -0700 (PDT)
Date: Mon, 22 Jun 2015 19:41:59 +0300 (EEST)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: xfs_repair and xfs filesystem strange behaviour
In-Reply-To: <20150622125913.GA3377@laptop.bfoster>
Message-ID: <alpine.LRH.2.11.1506221938130.17353@mail.vlasiu.net>
References: <alpine.LRH.2.11.1506201447380.21027@mail.vlasiu.net>
	<20150622125913.GA3377@laptop.bfoster>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi Brian.

On Mon, 22 Jun 2015, Brian Foster wrote:

> FWIW, the above stack trace and error messages look related to the issue
> fixed by the following patch:
> 
> http://oss.sgi.com/archives/xfs/2015-06/msg00276.html
> 
> This went into 4.1, but also looks like it was included in 4.0 stable
> and merged to 4.0.5, which you are running. If possible, you might want
> to try reverting back a kernel version back to 4.0.4 and see if this
> clears up.
Yep, I can remove all files with 4.0.4 kernel without any errors. Thank 
you very much.

Maybe someone should look over 4.0.5 because the merge is not quite right.


Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 44952F15
// OpenGPG-Fingerprint: 4AC5 7C26 2FE9 02DA 4906  24B2 D32B 7ED7 4495 2F15
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJViDrXAAoJENMrftdElS8Vd3QP/A8PtiE0i4CPXhyDvsSF10h1
GWv+QEmMFiiMRWMoSyhXwuAGrBZEA30DnbAVlTIvmWcqimIv1CSsUeW4p/HpuU2Q
NQ8+C1TXQvuAAVR/EUrKq4KQz6CpUIAMJEtK0k73S9N6TpBBz8DrDM5zU8gowRP5
3awL/mwAp4dcdZkHX6g68VEuwkwdrnIxsDvk4eQ6dDpRlBBP6HhiXm8x+N7AdGww
SfepyZzrIds0KdAmyXc0BLI75HL8jG/SDe1wA9qLUL4h2CZVmJgXzSwXV7pEDb6Q
dlPcAGvmVm2Qsb7IToYWD16cgzUzVqVXkp/nLLk1FQZ9Hsbrx4tluFsZJ61CIUIu
QEQucreneAYuY+gKx5hvLYeGP/Gy50XXQU6/u+ocW6stm1f8TSdI1BeZ93pUJHF2
xUhM7//zHFn2Ck+7EkGGwmAQoqh2nkLE5RL2K7repJECnaxB6DcWjjK03AzI6FU7
72TjjO33g56iiF5v5ota5Ss1VIFxLvgl6Wkw7a2+hTZPXKS4Hn1OIWfQA8lTbfN0
kP9yiWnxOfFSiKYwSLPOyDRYWJJ9dTJw0oMQxL6gjLI2jxq3cLAbp+RvKeaMPKjE
yc3r0R+rRFL2uw5SizU7HOtGwymnvrMZoj16oaXfCHRyXFloFDLDW9TF/VKk9Nz4
PM6JXwkBS0Eh+YU/SOMn
=S+oY
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
