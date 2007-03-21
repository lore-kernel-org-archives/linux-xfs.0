Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Mar 2007 04:08:42 -0700 (PDT)
Received: from mail.interline.it (mail.interline.it [195.182.241.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2LB8a6p008462
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 04:08:38 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.interline.it (Postfix) with ESMTP id D45BBE8D
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 11:59:39 +0100 (CET)
Received: from mail.interline.it ([127.0.0.1])
	by localhost (pin [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 21722-14 for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2007 11:59:33 +0100 (CET)
From: "Daniele P." <daniele@interline.it>
Subject: Re: xfsrepair memory consumption
Date: Wed, 21 Mar 2007 12:08:27 +0100
References: <200703210843.TAA08491@larry.melbourne.sgi.com>
In-Reply-To: <200703210843.TAA08491@larry.melbourne.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703211208.27665.daniele@interline.it>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wednesday 21 March 2007 09:48, Barry Naujok wrote:
> This could be libxfs caching in action.
>
> Another option you can try is:
>
> -o bhash=256
>
> Also, -M and -P options may reduce memory consumption.
> I recommend -M (I'm in the middle of making that default).

Hi Barry,
In the previous test I already used the -M option (no thread).
Using also -P and -o bhash=256 make the memory usage of the new version
of xfs_repair close to the old version with no option for phases
1-5.
This is really useful.
Phase 6 still uses little more memory (killed!).
I will add more memory and will test later.

Thanks,
Daniele P.
