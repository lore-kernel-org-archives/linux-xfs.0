Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 69B137F4E
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 17:14:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D2D48F804B
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 15:14:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pA0Za0HULzdWOgnn for <xfs@oss.sgi.com>;
	Wed, 13 May 2015 15:14:45 -0700 (PDT)
Message-ID: <5553CCD2.1010906@sandeen.net>
Date: Wed, 13 May 2015 17:14:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE, DISCUSS] xfsprogs: libxfs-4.1-update branch created
References: <20150511000508.GD16689@dastard>
In-Reply-To: <20150511000508.GD16689@dastard>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

One interesting problem that arises from this is in xfs_format.h:

/* On-disk XFS extended attribute names */
#define SGI_ACL_FILE            (char *)"SGI_ACL_FILE"
#define SGI_ACL_DEFAULT         (char *)"SGI_ACL_DEFAULT"
#define SGI_ACL_FILE_SIZE       (sizeof(SGI_ACL_FILE)-1)
#define SGI_ACL_DEFAULT_SIZE    (sizeof(SGI_ACL_DEFAULT)-1)

(aside: why is it unsigned in the kernel but not here?)

Anyway: that "sizeof" gives us 7, because it's getting the 
size of the pointer, not the string literal.  Cool eh!
Never mattered in the kernel, because the _SIZE macros aren't
used.

I'm not actually sure what the cleanest way to fix this is;
casting string literals gets way past my comfort level with 
C pedantry; technically if we want an array of unsigned chars,
we probably need:

unsigned char *SGI_ACL_FILE[] = "SGI_ACL_FILE";
unsigned char *SGI_ACL_DEFAULT[] = "SGI_ACL_DEFAULT";

but then it can't live in the format header; in kernelspace we need that
symbol in xfs_acl.c, in userspace we need it in repair/attr_repair.c 

- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJVU8zRAAoJECCuFpLhPd7gzmIQAJPuO9ZRCMEjswGNVssux0Jm
+++pRvgPVl3qhdplzgukWcPTnZeq9NzfrU2rzwNNiA5nolgyKdo+Iu5rsPm3ZYHR
d80WU3mmkFPjoKbtwHP70bp71mxfSw7gb/k+MBOks/8PdkKHhbzI81n9q5WKGWxv
RQ+tUSVDxy/n25j4nLNp5nUwLPCycglxk8BD+rA3m4yJ1oDXZVWq7hXV+rYPxrQR
RV+GrwN+2thETlFSRexnzyTPO7n3cysUVaDVWC1RvqcMY2Ku3yb4EiJJdiCgLLq9
sBX4OWiy/A6020fhbaSnNV3tX4OQ7DmZe8JQ82GmtfwlzHWiQtFogJFgH4kLaXNm
oRwIsgX8BCzwDIYdbu+kbY5krtMaO8I4Fi1hM7nxVZKodo+hbPzTQjWEt9dmx4up
ForoWXsX3eibKhVEei7kuM0GIXK8C0G40VH2eFFGhJBTOOHj5NglLiZxMx0pl/HE
tl/l/SXhYK025ADFxpiwOBGkIoEo/bZI8REJblPIpb1PZNVEc05jTT3aTXpGmx+p
1AAeDnI3/urseJjhtQdvD8O7q47NrQNC4MLStA9wxQkn3d+XAoeQAzSCbxGS2fHO
CClPrV8tmAjI6Q3XvtdauRMXcO9npNroIndXjK4fuiSn0jtcHDJJts0wjPJkAI/x
6dnAQ7VcMg4V/Cxrt5XK
=T5wD
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
