Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Dec 2007 01:57:14 -0800 (PST)
Received: from ninsei.hu (ninsei.hu [212.92.23.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB49v6ps007078
	for <xfs@oss.sgi.com>; Tue, 4 Dec 2007 01:57:09 -0800
Received: from luba (pb-d-128-141-57-222.cern.ch [128.141.57.222])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chatsubo.ninsei.hu (Postfix) with ESMTP id C0E9C7A97
	for <xfs@oss.sgi.com>; Tue,  4 Dec 2007 10:56:38 +0100 (CET)
Date: Tue, 4 Dec 2007 10:57:10 +0100
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: 2.6.24-rc3 oopses while mounting fs
Message-ID: <20071204095710.GD2074@luba>
References: <20071128134523.GF7793@luba> <474E003A.7020000@sgi.com> <20071130223154.GB13589@luba> <47537709.9040406@sgi.com> <20071203220200.GC13667@luba> <47549B1A.4070508@sgi.com> <4754FCEC.30906@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4754FCEC.30906@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Lachlan Mcilroy (lachlan@sgi.com) [20071204 18:08]:

Lachlan,

> The transactional view appears to be truncated. [...]
> Peter, can you try xfs_logprint -c ...?

xfs_logprint -c -t -i produces an identical transactional dump
than what you have seen.
http://cern.ch/fuji/lxfsre1103/xfs_logprint_c_t_i.txt

You can grab the whole saved log from here (128M uncompressed):
http://cern.ch/fuji/lxfsre1103/sdc.xlg.bz2
88a6906567ab44994a0b5c4255c5c619428405dc  sdc.xlg

HTH,
Peter

-- 
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+''
 Kelemen Péter     /       \       /       \     Peter.Kelemen@cern.ch
.+'         `+...+'         `+...+'         `+...+'         `+...+'
