Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:44841 "EHLO
        smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbeIAPLq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Sep 2018 11:11:46 -0400
Subject: Re: xfs_scrub_all warning
References: <974f65da-60f9-55aa-2e27-3fe9abb64f97@bodenbinder.de>
 <20180831164535.GA4355@magnolia>
From: Matthias Bodenbinder <matthias@bodenbinder.de>
Message-ID: <14ac54ca-4f2d-c3a2-9157-93ae7e274f47@bodenbinder.de>
Date: Sat, 1 Sep 2018 12:45:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180831164535.GA4355@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Am 31.08.18 um 18:45 schrieb Darrick J. Wong:
> I think so.  If you remove the lines:
> 
> 	if '-' not in path:
> 		return path
> 
> from systemd_escape() in /sbin/xfs_scrub_all, do the warnings go away?
> Does scrub still work afterwards?

That does work:
 
8# ./my-xfs_scrub_all
Scrubbing /home...
Failed to add filter for units: No data available
Scrubbing /home done, (err=0)


But what is this "Failed to add filter..." message about?

Thanks for your help
Matthias
