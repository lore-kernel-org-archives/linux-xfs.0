Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2NJfIrs257048 for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 14:41:18 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id PcSweBVYwStxL4AR for <xfs@oss.sgi.com>;
	Fri, 23 Mar 2012 12:41:16 -0700 (PDT)
Message-ID: <4F6CD1DC.7010706@sandeen.net>
Date: Fri, 23 Mar 2012 14:41:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr XFS_IOC_SWAPEXT failed
References: <alpine.LRH.2.02.1203231552490.21859@mail.vlasiu.net>
In-Reply-To: <alpine.LRH.2.02.1203231552490.21859@mail.vlasiu.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Gabriel VLASIU <gabriel@vlasiu.net>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/23/12 8:57 AM, Gabriel VLASIU wrote:
> Hi!
> 
> Can somebody explain the reason for this error:
> 
> # xfs_fsr -vvv \{aed7ec6a-7659-494a-8837-cabce9e6f506\}.vdi
> {aed7ec6a-7659-494a-8837-cabce9e6f506}.vdi
> XFS_IOC_SWAPEXT failed: {aed7ec6a-7659-494a-8837-cabce9e6f506}.vdi: Invalid argument
> 
> I can copy this file and there are no errors reported by virtualbox.
> The kernel version is 3.3.0.

Check kernel logs / dmesg?

- -Eric

> Thank you.
> 
> 
> Sincerely,
> Gabriel
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPbNHbAAoJECCuFpLhPd7g3f4QAMYjEZyP1PnvhJcaHgYhygZI
eI2l2Bk5K7UfNY20lKwOe8A07CeLBXZ3QdjfBWM5QwUZB2gxYuM4d0G2H+XIqLsr
2Qe7+zarR6heV9qT3QmNE93bDKVgPG/rU3IYchL40THMFlkobC0sk9Kxu9S5Trrb
ssEOJFmcnVhtaCc6mle1Sac+SfArDixPbVlSny5esdQXh88v1Or7ixj+fL4/ck3c
680koIyoBnBr8po/dhDASzcW7H3wSuzldweOtbiq2JrHAIOUV9qY+A2f49ieUmt+
9TZUa86jsPNWE5DHn5BQ0C0OBphDXDfCEhNELf33sbOKUK0KkKLD3anloX/LtlKi
OrFlKstFgrdlDg0QY8yimYbxJvLAd48oA7qHqMKg8+moq9H//RP56DJJ7SfrL0G7
E7/0+Jxd9ii7d9cNHEAlxVYRY9JQT9G0hCL17NFxTBProHhhCmSZihil5QYMno9o
mO6Goh5DupCHnRSmj+M9GrhHHNiWpzLwwgAIMnadchyzSzrnCmSfU3Xsfw40JpaS
w654Full2tEWjszxSjox3smeGjR22//hh1koXMjdavbwwh9suRIjHegUl+U/bo0p
kGcNDwJiZD2O9vx2EuNfcDZbOB7UjSuE8eLzy5Nizmo8/e+x1q7YdmOJW12nkwzV
TG6nlVlk31LQhiMq1BDQ
=VaL/
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
