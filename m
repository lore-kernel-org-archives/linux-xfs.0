Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8S6x9xR093289 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 01:59:09 -0500
Received: from mta11.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D9281C4D5A3
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 23:59:08 -0700 (PDT)
Received: from mta11.charter.net (mta11.charter.net [216.33.127.80]) by
	cuda.sgi.com with ESMTP id cNKtIcUXriTHzvFd for
	<xfs@oss.sgi.com>; Tue, 27 Sep 2011 23:59:08 -0700 (PDT)
Received: from imp10 ([10.20.200.15]) by mta11.charter.net
	(InterMail vM.7.09.02.04 201-2219-117-106-20090629) with ESMTP
	id <20110928065907.ICUE4091.mta11.charter.net@imp10>
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 02:59:07 -0400
Received: from [IPv6:2002:6027:d601:1:21f:c6ff:fed7:f9d5] (unknown
	[IPv6:2002:6027:d601:1:21f:c6ff:fed7:f9d5])
	by cchtml.com (Postfix) with ESMTPSA id 7A815C0287BED
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 01:59:06 -0500 (CDT)
Message-ID: <4E82C5AF.8040203@cchtml.com>
Date: Wed, 28 Sep 2011 01:58:55 -0500
From: Michael Cronenworth <mike@cchtml.com>
MIME-Version: 1.0
Subject: Re: 64-bit inodes and back again
References: <4E825C25.6050804@cchtml.com> <20110928011020.GE3159@dastard>
	<4E8278D8.9060309@cchtml.com> <4E828BE1.8030003@cchtml.com>
	<20110928053539.GF3159@dastard>
In-Reply-To: <20110928053539.GF3159@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 09/28/2011 12:35 AM, Dave Chinner wrote:
> It has to be able to access the files with inode numbers>  32 bit,
> so you need to run it on the 2.6.38 kernel. Once you've done that,
> you should be able to read all the files back on the .35 kernel,
> too.

I tried that. It fails on the newer kernel, too. (32-bit inode mode)

# xfs_reno -vv /var/lib/mock.save
Scanning directory tree...
Processing 31 directories...
xfs_reno: directory: 4298768443 1 /var/lib/mock.save/dist-5E-build-377-1401
xfs_reno: unable to duplicate directory attributes: 
/var/lib/mock.save/dist-5E-build-377-1401
0 seconds elapsed
Done.
# ls -i
12884946465 dist-5E-build-373-1401   17200292312 dist-f15-build-383-1416
  8612299211 dist-5E-build-375-1401    8626045248 dist-f15-build-384-1416
  4298768443 dist-5E-build-377-1401   12884946478 dist-f15-build-385-1417
17196739302 dist-5E-build-378-1401   12885555358 dist-f15-build-386-1417
     3226235 dist-5E-build-379-1401    4298161997 dist-f15-build-387-1417
17197934889 dist-5E-build-380-1401   30082488692 dist-f15-build-388-1417
12917432680 dist-5E-build-381-1415   17196807090 dist-f15-build-389-1417
  4295007704 dist-6E-build-374-1403          1460 xfs_reno.recover
21502499833 dist-f15-build-382-1416

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
