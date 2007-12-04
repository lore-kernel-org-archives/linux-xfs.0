Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Dec 2007 01:57:14 -0800 (PST)
Received: from ninsei.hu (ninsei.hu [212.92.23.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB49v6Op007074
	for <xfs@oss.sgi.com>; Tue, 4 Dec 2007 01:57:09 -0800
Received: from luba (pb-d-128-141-57-222.cern.ch [128.141.57.222])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chatsubo.ninsei.hu (Postfix) with ESMTP id 6656F7A92
	for <xfs@oss.sgi.com>; Tue,  4 Dec 2007 10:56:37 +0100 (CET)
Date: Tue, 4 Dec 2007 10:42:29 +0100
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: 2.6.24-rc3 oopses while mounting fs
Message-ID: <20071204094229.GC2074@luba>
References: <20071128134523.GF7793@luba> <474E003A.7020000@sgi.com> <20071130223154.GB13589@luba> <47537709.9040406@sgi.com> <20071203220200.GC13667@luba> <47549B1A.4070508@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47549B1A.4070508@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Timothy Shimmin (tes@sgi.com) [20071204 11:11]:

Timothy,

Thanks for the recommendations.

> Often it is simplest to save the log using the -C option to a
> file.  -C filename [...] The log can then be analysed in various
> ways later.

I did that (I played with it and did the same thing with dd(1),
too).

> If you want to save the filesystem away for possible metadata
> debugging later, then xfs_metadump is your friend.

I'll check this out.  I watched Barry implement the thing but we
were stuck in the past for a while with xfsprogs-2.6.x.

Peter

-- 
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+''
 Kelemen Péter     /       \       /       \     Peter.Kelemen@cern.ch
.+'         `+...+'         `+...+'         `+...+'         `+...+'
