Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Jul 2006 15:58:06 -0700 (PDT)
Received: from postfix1-c.free.fr (postfix1-c.free.fr [213.228.0.79])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6VMvrDW005627
	for <xfs@oss.sgi.com>; Mon, 31 Jul 2006 15:57:54 -0700
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by postfix1-c.free.fr (Postfix) with ESMTP id 771351E20EB3
	for <xfs@oss.sgi.com>; Tue,  1 Aug 2006 00:16:38 +0200 (CEST)
Received: from inara.maison.net (lns-bzn-36-82-251-57-152.adsl.proxad.net [82.251.57.152])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 24C5B75B4C
	for <xfs@oss.sgi.com>; Tue,  1 Aug 2006 00:16:30 +0200 (CEST)
Date: Tue, 1 Aug 2006 00:16:17 +0200
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: Where are superblocks stored?
Message-ID: <20060731221617.GC26891@inara.maison.net>
References: <51A9A4FCBC06324F8BFE956A551B58E0056A4CA3@mail01dn.adic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51A9A4FCBC06324F8BFE956A551B58E0056A4CA3@mail01dn.adic.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Rishi Malik (rishi.malik@adic.com) [20060731 09:23]:

> I'm investigating some compact flash failures we've had. We run
> XFS on the CF. I've been getting a lot of I/O errors around
> logical block 543080. These are 512MB compact flash cards, and
> I think that block puts it at about halfway through the CF. I
> know the I/O errors indicate an error at a lower level then XFS.
> [...]

It's most likely the internal log, sitting in the middle of the
fs.  BTW your mail address is bouncing.

Peter

-- 
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+''
 Kelemen Péter     /       \       /       \     Peter.Kelemen@cern.ch
.+'         `+...+'         `+...+'         `+...+'         `+...+'
