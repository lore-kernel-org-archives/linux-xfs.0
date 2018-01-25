Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:32958 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751559AbeAYWQx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jan 2018 17:16:53 -0500
Subject: Re: [PATCH 27/29] xfs_scrub: integrate services with systemd
References: <151622651142.31925.4179778330985746435.stgit@magnolia>
 <151622668376.31925.11115543396206091025.stgit@magnolia>
 <e517aefd-5ad0-4de6-6b8f-1911da22f464@sandeen.net>
 <20180125214411.GP9068@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0a9006ce-05ea-1bc8-751e-6a49aa0db32a@sandeen.net>
Date: Thu, 25 Jan 2018 16:16:52 -0600
MIME-Version: 1.0
In-Reply-To: <20180125214411.GP9068@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org



On 1/25/18 3:44 PM, Darrick J. Wong wrote:
>> Ok this seems batshit crazy, no offense.  I don't blame /you/ ;)  You pointed me
>> at  http://refspecs.linuxbase.org/LSB_2.0.1/LSB-PDA/LSB-PDA/iniscrptact.html
>> but it says that the /initscript/ should exit with specific codes, not that
>> the application it /calls/ should do so.
> Yes.  At the moment, the systemd service calls xfs_scrub directly, hence
> it interprets the return code as an initscript error code.  So in theory
> we could create a wrapper script that does all the is_service junk, but
> now that's another weird little script to break.  On the plus side we'd
> contain the systemd workaround crap to some random wrapper in /usr/lib.
> 
> Ok, I'll think about it.
> 

does LSB even have anything to do w/ systemd behavior or have they reinvented
all that by now?  :(

FWIW,

https://www.freedesktop.org/software/systemd/man/systemd.service.html

says that you can define:

SuccessExitStatus=

    Takes a list of exit status definitions that, when returned by the main service process, will be considered successful termination

does that help?

-Eric
