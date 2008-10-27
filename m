Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 17:00:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RNxtPt024704
	for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:59:55 -0700
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCECA54F4F2
	for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:59:54 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com with ESMTP id s3eMfXAtTcBBXYfa for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 16:59:54 -0700 (PDT)
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Kuc01-0007n8-Mx
	for linux-xfs@oss.sgi.com; Mon, 27 Oct 2008 23:59:53 +0000
Received: from 75-134-105-39.dhcp.aldl.mi.charter.com ([75.134.105.39])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:59:53 +0000
Received: from mlueck by 75-134-105-39.dhcp.aldl.mi.charter.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:59:53 +0000
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: Re: Bad day with xfsrestore, what went wrong?
Date: Mon, 27 Oct 2008 19:59:50 -0400
Message-ID: <ge5kle$ueo$1@ger.gmane.org>
References: <gde1k2$gkp$1@ger.gmane.org> <ge38k5$qf$1@ger.gmane.org> <49063F75.7000604@sgi.com>
Reply-To: mlueck@lueckdatasystems.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <49063F75.7000604@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Bill Kendall wrote:

> I tried to reproduce this using the command line you supplied, but
> everything worked as expected for me.

Glad to hear that. Seems my tried and true syntax _can_ still work.

> Perhaps try it without the -i (so that only subtrees given with -s are restored), just to rule out
> the possibility that you inadvertently added all files to the restore list.

Enough putzing with a production server I think.

It was odd that it only put back files present in that old backup set and did not overwrite everything... thankfully!

Anyway, thanks for checking / verifying my usual restore syntax that it is the correct syntax.

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/
