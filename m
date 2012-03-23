Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2NK5lpN006231 for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 15:05:47 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ErXTTDFuk4VDq5cI for <xfs@oss.sgi.com>;
	Fri, 23 Mar 2012 13:05:46 -0700 (PDT)
Message-ID: <4F6CD799.9090903@sandeen.net>
Date: Fri, 23 Mar 2012 15:05:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr XFS_IOC_SWAPEXT failed
References: <alpine.LRH.2.02.1203231552490.21859@mail.vlasiu.net>
	<4F6CD1DC.7010706@sandeen.net>
	<alpine.LRH.2.02.1203232159210.3056@mail.vlasiu.net>
In-Reply-To: <alpine.LRH.2.02.1203232159210.3056@mail.vlasiu.net>
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

On 3/23/12 3:01 PM, Gabriel VLASIU wrote:
> On Fri, 23 Mar 2012, Eric Sandeen wrote:
> 
>> Check kernel logs / dmesg?
> xfs_swap_extents: inode 0x400dd2e4 format is incompatible for exchanging.
> 
> Also xfs_repair does not report anything wrong.

It wouldn't be expected to.

Please see also

https://bugzilla.redhat.com/show_bug.cgi?id=671015

and suggestions for tracing the error, so we know exactly which case this is.

Thanks,
- -Eric


> 
> Sincerely,
> Gabriel
> 
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPbNeYAAoJECCuFpLhPd7g7oMQAJj7eeTurTYhjUxHpt09/y6G
EwGsjn8CnicpzYgmZ8KckZxeW8rdrxn6fspgYKTkVd8zuolgSw0CSmtO78Cn3wr/
SvJo5XPR61gFrDTGyhQGdLt13h/U096gNMS3lZnTWM7Cydkgw8Uv0VD6vX42iO9L
qzn7nAAypRm3Bd5KdNCDBbA3Y2sovjqixE/W5qYSDt0OzkEXwSpj/0VN/Dk1xPEz
n2eEvFDx3KoaEyBQWlaN02c+WHsDsfNjp+qIlgyCp3fa78Ho+I1WJGQ9tQzsAmLb
u98WkGkMx66BswAiFIIMq9LeljUQA69oIpCUS1ZWzW71/BZEwAKwfBeBa5n4aVJz
3cQjpGVR9uVfOvBcQB5oS+gjLcTF2A6HXI4DEe0xU90VeRotEj/Y0HgNhHhIxDef
Qq7u9w8cChdR7dIIVBNoTbGGV3OtDUo+LPFCcTfNH4UGLM5UftGp3nbPmx+O9IcB
fBGhTn+6qb4JFo4sVcIjVeQ7SFwvs36/OOFWnvtoe46kW/G/JdnMc9TQ8B0FoMn7
vRtqj9eJ8pDdxefdTVMtKxuze135FGTByxB6KrwOWw87KWP7NgU/29UBAVp1WdP5
GRUxnTLK/zvI4+sLbifwHi8H6liu87eqsKTQi/nGkjKbwLp4iOrbtV1dIxx8q++f
md88m2JD6Np7pd+mmYxI
=d4wS
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
