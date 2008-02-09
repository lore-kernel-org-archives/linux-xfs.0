Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Feb 2008 20:58:37 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m194wWv3032440
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2008 20:58:34 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5CB75B9BB1
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2008 20:58:55 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id HU75IyuXg2VTT2Z2 for <xfs@oss.sgi.com>; Fri, 08 Feb 2008 20:58:55 -0800 (PST)
Message-ID: <47AD330D.3010603@sandeen.net>
Date: Fri, 08 Feb 2008 22:58:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.25
References: <20080208022705.0DB1058C4C11@chook.melbourne.sgi.com> <47AD284F.7080603@sandeen.net> <20080209045645.GB1428@infradead.org>
In-Reply-To: <20080209045645.GB1428@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Feb 08, 2008 at 10:13:03PM -0600, Eric Sandeen wrote:
>> Lachlan McIlroy wrote:
>>> Please pull from the for-linus branch:
>>>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
>>>
>>> This will update the following files:
>>>
>>>  fs/xfs/Makefile-linux-2.6      |    1 -
>> Is there a reason the other various makefile updates still haven't been
>> pushed?  They're a lot tidier now, and they facilitate out-of-tree
>> building...
> 
> Well, the makefiles are pretty different for CVS vs mainline to modular
> quota and dmapi.  I'm thinking about doing a proof of concept modular
> quota patch for mainline and if it doesn't get too ugly that would
> mean the makefiles are a lot more in sync.

Even if they differ, they can still get the same basic treatment.  I'll
make a patch if desired.  The current kernel.org makefiles are a mess,
IMHO :)

-Eric
