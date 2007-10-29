Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 00:57:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9T7utKA004659
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 00:56:57 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA21597 for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 18:56:58 +1100
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id l9T7uvdD84049573
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 18:56:58 +1100 (AEDT)
Received: (from xaiki@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id l9T7uvCs85357075
	for xfs@oss.sgi.com; Mon, 29 Oct 2007 18:56:57 +1100 (AEDT)
Date: Mon, 29 Oct 2007 18:56:57 +1100
From: Niv Sardi <xaiki@sgi.com>
Subject: Default mount options (that suck less).
Message-ID: <20071029075657.GA84369978@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

XFS's default mount options are in most cases sub-optimal, we should try
to have more sensible defaults, so far I'm following some quick dave-powered
recomendations:

- version 2 logs
- attr2
- lazy superblock counters
- less allocation groups for single disk configs

- imaxpct default can be reduced

it is currently 25, what would be reasonable ?

- dropping the ability to turn unwritten extents off completely

please submit your pet-idea for better defaults here.

Cheers, 
-- 
Niv
