Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Jul 2006 09:26:13 -0700 (PDT)
Received: from MAIL01HQ.adic.com (mail01hq.adic.com [63.81.117.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6VGQ2DW010380
	for <xfs@oss.sgi.com>; Mon, 31 Jul 2006 09:26:03 -0700
MIME-Version: 1.0
Subject: Where are superblocks stored?
Date: Mon, 31 Jul 2006 09:23:27 -0600
Message-ID: <51A9A4FCBC06324F8BFE956A551B58E0056A4CA3@mail01dn.adic.com>
From: "Rishi Malik" <rishi.malik@adic.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi All,

 

I'm investigating some compact flash failures we've had. We run XFS on
the CF. I've been getting a lot of I/O errors around logical block
543080. These are 512MB compact flash cards, and I think that block puts
it at about halfway through the CF. I know the I/O errors indicate an
error at a lower level then XFS. What I'm wondering, is if there's a
superblock stored there? Maybe we're hammering that area a lot, and
because of other problems with the card, we're getting these errors. 

 

I know that XFS stores its primary superblock at 0, but I haven't found
out where the secondary superblocks are stored. Any help is appreciated.

 

Rishi Malik

 

 

 

Rishi Malik::Firmware Engineer::Rishi.Malik@adic.com
<mailto:Rishi.Malik@adic.com> ::o720-249-5932::c303-396-3568 

 



[[HTML alternate version deleted]]
