Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Sep 2008 20:49:40 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M3nPqG007797
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 20:49:25 -0700
Message-ID: <48D71831.4090104@sgi.com>
Date: Mon, 22 Sep 2008 13:59:45 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Unlock inode before calling xfs_idestroy()
References: <48D3193C.6060201@sgi.com> <20080920070126.GQ5811@disturbed>
In-Reply-To: <20080920070126.GQ5811@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Dave Chinner wrote:
> On Fri, Sep 19, 2008 at 01:15:08PM +1000, Lachlan McIlroy wrote:
>> Lock debugging reported the ilock was being destroyed
>> without being unlocked.
> 
> Is this going to go in before or after my changes to refactor
> this function? If it is before< can you please push it out to
> the master git tree ASAP (and all the other outstanding changes)
> so I can rediff all the outstanding patches I have before I
> send them again?
Yeah sure.  I need to get Christoph's btree patch set in real soon
so I'll do that then update oss/master.
