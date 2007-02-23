Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Feb 2007 11:35:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1NJZHm7032093
	for <linux-xfs@oss.sgi.com>; Fri, 23 Feb 2007 11:35:19 -0800
Message-ID: <45DF416F.5050907@sandeen.net>
Date: Fri, 23 Feb 2007 13:33:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: I/O error, SCSI error, reservation conflict.... xfs suggestions?
References: <9124908.post@talk.nabble.com>
In-Reply-To: <9124908.post@talk.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: pgf111000 <junkmail@petergfrazier.com>
Cc: linux-xfs@oss.sgi.com

pgf111000 wrote:
> In the middle of read/write operations on the xfs formatted areca array I
> experience the following repetative message (from /var/log/messages):
> 
> sd 3:0:1:0: reservation conflict
> sd 3:0:1:0: SCSI error: return code = 0x00070018
> end_request: I/O error, dev sdx, sector 681896097

...

> Any and all thoughts/suggestions will be warmly received....

Well, this isn't an xfs problem.  Something is happening at the scsi
layer, whatever xfs does after that is simply reacting (properly) to it.

I'd try another list... :)

-Eric
