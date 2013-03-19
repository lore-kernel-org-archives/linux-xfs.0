Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C6B2D7F52
	for <linux-xfs@oss.sgi.com>; Tue, 19 Mar 2013 09:15:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B3F78304059
	for <linux-xfs@oss.sgi.com>; Tue, 19 Mar 2013 07:15:04 -0700 (PDT)
Received: from smtp0.epfl.ch (smtp0.epfl.ch [128.178.224.218]) by cuda.sgi.com
	with SMTP id HvLzJRdCnQeqGKxJ for <linux-xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 07:15:03 -0700 (PDT)
Message-ID: <5148731F.8030108@epfl.ch>
Date: Tue, 19 Mar 2013 15:15:59 +0100
From: Guillaume Anciaux <guillaume.anciaux@epfl.ch>
MIME-Version: 1.0
Subject: Re: mount XFS partition fail after repair when uquota and gquota
	are used
References: <1363600796196-34996.post@n7.nabble.com>
	<20130318164743.GC22182@sgi.com> <51477035.7070200@epfl.ch>
	<20130318213604.GF22182@sgi.com> <51478CAB.3020409@epfl.ch>
In-Reply-To: <51478CAB.3020409@epfl.ch>
Content-Type: multipart/mixed; boundary="------------070603070004080802060008"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------070603070004080802060008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear Ben and Dave,

I fixed my problem:

I was using the version 3.1.7 of xfs_repair and eventhough the inode 
problem was detected:

....
         - agno = 3
data fork in regular inode 3224608213 claims used block 335579196
         - agno = 4
....

The problem was never corrected. So under the advice of Ben Meyers, I 
compiled the latest version from git of the xfsprogs (3.1.10) and used 
the xfs_repair tool from that version.
The problem was then addressed:

....
         - agno = 3
data fork in regular inode 3224608213 claims used block 335579196
correcting nextents for inode 3224608213
correcting nextents for inode 3224608213, was 1 - counted 0
         - agno = 4
.....

And it did fix the problem.

I want to thank you again for your concern on my problem.

best,

Guillaume Anciaux



--------------070603070004080802060008
Content-Type: text/x-vcard; charset=utf-8;
 name="guillaume_anciaux.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="guillaume_anciaux.vcf"

begin:vcard
fn:Guillaume Anciaux
n:Anciaux;Guillaume
org:EPFL/ENAC/IS/LSMS
adr:;;Station 18, GC A2 494;Lausanne;Vaud;1015;Switzerland
email;internet:guillaume.anciaux@epfl.ch
title:Ph.D
url:http://lsms.epfl.ch
version:2.1
end:vcard


--------------070603070004080802060008
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------070603070004080802060008--
