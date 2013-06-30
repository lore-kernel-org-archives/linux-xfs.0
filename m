Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8218629DF8
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 17:36:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 71DBF8F8033
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 15:36:12 -0700 (PDT)
Received: from mail-yh0-f47.google.com (mail-yh0-f47.google.com
	[209.85.213.47]) by cuda.sgi.com with ESMTP id Rl1rUVdx0HC3AAeB
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 30 Jun 2013 15:36:10 -0700 (PDT)
Received: by mail-yh0-f47.google.com with SMTP id f64so2223830yha.20
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 15:36:10 -0700 (PDT)
Subject: Re: swidth in RAID
Mime-Version: 1.0 (Apple Message framework v1085)
From: aurfalien <aurfalien@gmail.com>
In-Reply-To: <51D0A62E.2020309@hardwarefreak.com>
Date: Sun, 30 Jun 2013 15:36:06 -0700
Message-Id: <B16785AB-A803-40A0-B537-5F24BCE5213A@gmail.com>
References: <557F888F-34EA-4669-B861-C0B684DAD13D@gmail.com>
	<51D0A62E.2020309@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com


On Jun 30, 2013, at 2:42 PM, Stan Hoeppner wrote:

> On 6/30/2013 1:43 PM, aurfalien wrote:
> 
>> I understand swidth should = #data disks.
> 
> No.  "swidth" is a byte value specifying the number of 512 byte blocks
> in the data stripe.
> 
> "sw" is #data disks.
> 
>> And the docs say for RAID 6 of 8 disks, that means 6.
>> 
>> But parity is distributed and you actually have 8 disks/spindles working for you and a bit of parity on each.
>> 
>> So shouldn't swidth equal disks in raid when its concerning distributed parity raid?
> 
> No.  Lets try visual aids.
> 
> Set 8 coffee cups (disk drives) on a table.  Grab a bag of m&m's.
> Separate 24 blues (data) and 8 reds (parity).

But are the cups 8oz, 16oz or smaller/larger?

Ceramic, plastic, glass, etc...?

Actually I really enjoyed the visual aid, many many thanks.

- aurf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
