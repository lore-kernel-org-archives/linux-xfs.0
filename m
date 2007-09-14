Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 07:18:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EEIL4p000514
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 07:18:22 -0700
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 2479918003EF4
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 09:18:24 -0500 (CDT)
Message-ID: <46EA982F.5090109@sandeen.net>
Date: Fri, 14 Sep 2007 09:18:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can't remove dir
References: <20070914080926.GA30150@apartia.fr> <46EA9741.6060303@sandeen.net>
In-Reply-To: <46EA9741.6060303@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Eric Sandeen wrote:
> Louis-David Mitterrand wrote:
>> Hello,
>>
>> While cleaning up /lost+found a directory resisted removal:
>>
>> 	sylla:/lost+found# rm 1879629858 -rf
>> 	rm: cannot remove directory `1879629858': Directory not empty
>>
>> The directory _is_ empty and "-rf" should remove it anyway, so this 
>> looks like a fs error.
>>
>> This is on debian unstable with 2.6.23-rc6.
>>
>>
> 
> Any errors in the system logs?  I'd try most recent xfs_repair next.  If
> that doesn't fix it, make an xfs_metadump for Barry to look at.  :)
> Make a backup first if you're paranoid.

Some day I'll learn to read all of a thread before replying... ignore
me.  Looks like dgc has things well under control.  :)

-Eric
