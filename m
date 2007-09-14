Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 07:14:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EEEO4p031669
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 07:14:25 -0700
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 1AE2D18003EF4
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 09:14:26 -0500 (CDT)
Message-ID: <46EA9741.6060303@sandeen.net>
Date: Fri, 14 Sep 2007 09:14:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can't remove dir
References: <20070914080926.GA30150@apartia.fr>
In-Reply-To: <20070914080926.GA30150@apartia.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Louis-David Mitterrand wrote:
> Hello,
> 
> While cleaning up /lost+found a directory resisted removal:
> 
> 	sylla:/lost+found# rm 1879629858 -rf
> 	rm: cannot remove directory `1879629858': Directory not empty
> 
> The directory _is_ empty and "-rf" should remove it anyway, so this 
> looks like a fs error.
> 
> This is on debian unstable with 2.6.23-rc6.
> 
> 

Any errors in the system logs?  I'd try most recent xfs_repair next.  If
that doesn't fix it, make an xfs_metadump for Barry to look at.  :)
Make a backup first if you're paranoid.

-Eric
