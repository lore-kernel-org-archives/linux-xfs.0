Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Mar 2007 01:35:22 -0700 (PDT)
Received: from mail.interline.it (mail.interline.it [195.182.241.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2L8ZI6p007297
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 01:35:19 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.interline.it (Postfix) with ESMTP id B4B2CE82
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 09:26:20 +0100 (CET)
Received: from mail.interline.it ([127.0.0.1])
	by localhost (pin [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 02089-20 for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2007 09:26:14 +0100 (CET)
From: "Daniele P." <daniele@interline.it>
Subject: Re: xfsrepair memory consumption
References: <200703201532.06076.daniele@interline.it> <20070320221305.GR32602149@melbourne.sgi.com>
In-Reply-To: <20070320221305.GR32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 21 Mar 2007 09:34:50 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703210934.50447.daniele@interline.it>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Tuesday 20 March 2007 23:13, you wrote:
> On Tue, Mar 20, 2007 at 03:32:05PM +0100, Daniele P. wrote:
> 6 million inodes in your filesystem, and a certain points in
> repair we have to hold indexes of them all (plus some state) in
> memory. Phase 6 is one of these points.

Hi David,
thanks for the explanation. 

> In terms of inode count, I generally use the rule that for every
> 10million inodes you need a gigabyte of RAM for repair - you needed
> about 500MB for 6million inodes.

This is true for 2.6.20-1, but 2.8.18-1 use a lot of memory in
phase 2.
I just want to point out the *increasing* memory requirements rather
than the total amount of memory needed to repair an xfs file system.

Regards,
Daniele P.
