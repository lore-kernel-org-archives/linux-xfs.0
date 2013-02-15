Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4AD98038
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 02:47:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA8948F8049
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 00:47:42 -0800 (PST)
Received: from frost.carfax.org.uk (frost.carfax.org.uk [85.119.82.111]) by
	cuda.sgi.com with ESMTP id ThRIsEzQ3JAladIQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Feb 2013 00:47:37 -0800 (PST)
Date: Fri, 15 Feb 2013 08:47:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [test] comments removed
Message-ID: <20130215084733.GH28997@carfax.org.uk>
References: <1360909755-2966-1-git-send-email-hemanthkumar51@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1360909755-2966-1-git-send-email-hemanthkumar51@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7610997088147110730=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Hemanth Kumar <hemanthkumar51@gmail.com>
Cc: sandeen@redhat.com, sensille@gmx.net, ganeshkumar14@gmail.com, praneethu.u@gmail.com, xfs@oss.sgi.com, bo.li.liu@oracle.com, skjmca51@gmail.com, chetahan.casey@gmail.com, kirantpatil@gmail.com, linux-btrfs@vger.kernel.org


--===============7610997088147110730==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzX0AQGjRQPusK/O"
Content-Disposition: inline


--NzX0AQGjRQPusK/O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 15, 2013 at 11:59:15AM +0530, Hemanth Kumar wrote:

   No description of what the patch does. You should probably also put
[btrfs-progs] in the subject line, if you're patching against
btrfs-progs (and in that case, you probably don't need to cc the xfs
people).

   More comments below.

   Hugo.

> Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
> ---
>  0001-heirarchical-quotas-test-case.patch | 44 ++++++++++++++++++++++++++++++++
        hierarchical

>  hquotas.sh                               |  2 --
>  2 files changed, 44 insertions(+), 2 deletions(-)
>  create mode 100644 0001-heirarchical-quotas-test-case.patch
> 
> diff --git a/0001-heirarchical-quotas-test-case.patch b/0001-heirarchical-quotas-test-case.patch

    And here

> new file mode 100644
> index 0000000..c6577e0
> --- /dev/null
> +++ b/0001-heirarchical-quotas-test-case.patch

    And here

> @@ -0,0 +1,44 @@
> +From 9f49a870eab70ae37028f937331f9ec1b67dadb1 Mon Sep 17 00:00:00 2001
> +From: Hemanth Kumar <hemanthkumar51@gmail.com>
> +Date: Fri, 15 Feb 2013 11:21:03 +0530
> +Subject: [test] heirarchical quotas test case
> +
> +
> +Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>

   You're sending a patch file that creates a patch file? This is wrong.

> +---
> + hquotas.sh | 8 ++++----
> + 1 file changed, 4 insertions(+), 4 deletions(-)
> +
> +diff --git a/hquotas.sh b/hquotas.sh
> +index 2eaae01..a870d4a 100644
> +--- a/hquotas.sh
> ++++ b/hquotas.sh
> +@@ -1,7 +1,5 @@
> + #! /bin/bash
> +-# btrfs quotas test case
> +-#owner=hemanthkumar51@gamil.com ganeshkumr14@gmail.com
> +-
> ++# btrfs hierarchical quotas test case
> + #here=`pwd`
> + #tmp=/sample
> + status=1
> +@@ -11,6 +9,8 @@ cleanup()
> + 	btrfs subvolume delete $TEST_DIR/vol1/vol2/vol3
> + 	btrfs subvolume delete $TEST_DIR/vol1/vol2
> + 	btrfs subvolume delete $TEST_DIR/vol1
> ++	btrfs quota disable $TEST_DIR
> ++	echo"quota disabled"
> + }
> + 
> + #trap "_cleanup ; exit \$status" 0 1 2 3 15
> +@@ -25,6 +25,6 @@ btrfs qgroup limit 3m $TEST_DIR/vol1/vol2
> + btrfs qgroup limit 1m $TEST_DIR/vol1/vol2/vol3
> + dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/vol3/file3 bs=2M count=1
> + dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/file2 bs=1M count=1
> +-dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=5M count=1
> ++dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=4M count=1
> + cleanup
> + exit
> +-- 
> +1.8.1.2
> +
> diff --git a/hquotas.sh b/hquotas.sh
> index a870d4a..672b6d1 100644
> --- a/hquotas.sh
> +++ b/hquotas.sh
> @@ -1,7 +1,5 @@
>  #! /bin/bash
>  # btrfs hierarchical quotas test case
> -#here=`pwd`
> -#tmp=/sample
>  status=1
>  
>  cleanup()

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                    --- Beware geeks bearing GIFs ---                    

--NzX0AQGjRQPusK/O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUR32JL9z9OVl50rAAQKz7BAAnz0UgNyihu2fHsO7Zk7CxbdfRXFAxRha
jJgNTrir08xDOvkvpbSRCVh1ubopywP+I5PoPAPvgPcOS2RCq8vsVofrr/aR/CtY
T2KkXxcrZ4HOce3dIm6+mRFUdXt8S8RlANJs1erbvr/UYiNBSJP/IRCfUBzno3HH
J/R9Wy5PHHklL+Ber8AmLyDHsxsuD1aXuoN/AUSRdP9h0AyJE9rO/U3cGa/ASFGQ
jOw9uGiWSdozpwrV3njnU5GNxAQ+2JDsVkyurzJB0ve5s24MJ3C1H4p6tXOJGIeS
6fixyW1ws2qhHIVOBc/mS7sFozP49YPjEKFsr0EhOQfA8Uw6eYyTkVfE6iiVl+GB
viLv4yzcLvRYvbY0sIoH/NU03NPDQKVyAdKMlnP3jPbiMUFLOKahX3OpZetHLVqk
964lJJ7+mXk79xlbkrRpE7uQr8eQA4imEnIIFZ7n3gqMNB2oJn2PTGI5vDTUM6HR
w6hcsqiDcR/ae7u9dcvFiLhoAvTAGsaNUEvXsK0/YcUVOpiMzJI075/GQ4hMwyxC
v1kN0w9HshjDaNMDl2dqGYfPzUFn0CyLcbjucgqEGP0iQPd1XrxOzC4xnPj/6Jgu
T1WxMCYNbt7niLQvrJWwrpH9QBPPdscx8oY4ULdH806cK/dJpQmionBe6JdfYLiZ
qcPySLkbfjE=
=9DB4
-----END PGP SIGNATURE-----

--NzX0AQGjRQPusK/O--


--===============7610997088147110730==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7610997088147110730==--
