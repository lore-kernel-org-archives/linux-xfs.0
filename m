Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 04:52:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7PBqioS009673
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 04:52:44 -0700
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDB6C125526F
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 04:54:05 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.188]) by cuda.sgi.com with ESMTP id PtnmMQhxBOIaMfyC for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 04:54:05 -0700 (PDT)
Date: Mon, 25 Aug 2008 13:53:54 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: agi unlinked bucket
In-Reply-To: <20080825020239.GQ5706@disturbed>
Message-ID: <alpine.DEB.1.10.0808251241000.26780@sheep.housecafe.de>
References: <alpine.DEB.1.10.0808230017150.20126@sheep.housecafe.de> <alpine.DEB.1.10.0808231412230.20126@sheep.housecafe.de> <20080825003929.GN5706@disturbed> <alpine.DEB.1.10.0808250254380.26780@sheep.housecafe.de> <20080825020239.GQ5706@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 25 Aug 2008, Dave Chinner wrote:
> Ok, so if you do a 'ls -i /' do you see an inode numbered 20208090?
> i.e. is it the unlinked bucket that is incorrect, or the root
> directory.

I see inode 128 (the mountpoint), but I don't see inode 20208090 (I've 
used find).

> You are not using barriers.

I think, I can't, as I am using XFS on top of dm-crypt. And barriers are 
not supported for dm, right?

> Are you using write caching?

Just check with hdparm on the underlying hdb...yes, write caching is 
active.

> The problems with filesystem corruption on powerloss when using 
> volatile write caching have traditionally shown up in directory
> corruptions...

Hm, I see. Still strange, that it does not complain during mount(8). But I 
guess things like these are just not checked during mount.


Thanks,
Christian.
-- 
BOFH excuse #57:

Groundskeepers stole the root password
