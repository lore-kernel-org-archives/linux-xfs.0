Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 06:53:33 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m15ErQlw000954
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 06:53:30 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F5F45A0434
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 06:53:46 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id kyCndqo2GARFkWUS for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 06:53:46 -0800 (PST)
Message-ID: <47A87877.1050106@sandeen.net>
Date: Tue, 05 Feb 2008 08:53:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
References: <20080129093201.GA16203@citd.de>
In-Reply-To: <20080129093201.GA16203@citd.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

Matthias Schniedermeyer wrote:

> There is roughly 1/3 missing.

SGI, have you settled on a fix for this?  Latest released xfsprogs,
2.9.5 has this problem, and I've put it in rawhide; it's also in the F9
alpha spin.  Should I revert to 2.9.4 if you don't have plans to fix it
soon?

Nothing indicates to the user that their fs was misformatted, and there
will be a growing number fileystems missing a substantial portion of
their space out there....

-Eric
