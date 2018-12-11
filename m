Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f180.google.com ([209.85.160.180]:34941 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbeLKWzF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Dec 2018 17:55:05 -0500
Received: by mail-qt1-f180.google.com with SMTP id v11so18472102qtc.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Dec 2018 14:55:04 -0800 (PST)
Received: from lud1.home ([177.98.82.44])
        by smtp.gmail.com with ESMTPSA id y14sm7590799qkb.2.2018.12.11.14.55.02
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Dec 2018 14:55:03 -0800 (PST)
Date: Tue, 11 Dec 2018 20:54:59 -0200
From: Luciano ES <lucmove@gmail.com>
Subject: Re: I got file system corruption with XFS
Message-ID: <20181211205459.106b35c9@lud1.home>
In-Reply-To: <3daac366-6e0f-34c8-1a2f-e5d07ae4fee1@sandeen.net>
References: <20181211183203.7fdbca0f@lud1.home>
        <3daac366-6e0f-34c8-1a2f-e5d07ae4fee1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Tue, 11 Dec 2018 14:57:45 -0600, Eric Sandeen wrote:

> On 12/11/18 2:32 PM, Luciano ES wrote:
> > I needed to restore something from my backups, an external hard
> > disk that is kept separately, always disconnected until I really
> > need it. 
> > 
> > But the file system refused to be mounted: "structure needs
> > cleaning," it said.
> > 
> > I googled and didn't find much hope about it. I followed what
> > little advice I found: I ran xfs_repair and it didn't work. So I
> > ran it again with -L and it worked, but the software itself warned
> > me that some files could not be recovered. I'll never know which
> > ones.
> > 
> > I always liked XFS and thought those dreaded days of file system 
> > corruption and lost files were far behind. So my only question is: 
> > Why does that happen? The disk is not even used 99% of the time.
> > How does an XFS file system go belly up just like that?  
> 
> There is no way for us to know.  You didn't provide nearly enough
> information to even hazard a guess.
> 
> But ok fine, I'll hazard a wild guess anyway: your external drive had
> a corrupt log because the enclosure didn't honor a cache flush issued
> by the filesystem after some previous mount.
> 
> -Eric


**************************

I understand you don't have much to work with, but I can't tell you
more than I have. It happened several days ago and I didn't write 
anything down. As far as I can remember, there wasn't really much 
to note. "Structure needs cleaning" was pretty much all I was ever 
told. There must have been more when I ran xfs_repair, but it looked 
incomprehensible to me and I thought I shouldn't bother anyone else 
about it.

Your theory about the enclosure sounds good. Do you think it is so 
flawed that issuing a 'sync' command manually before umounting 
wouldn't have made any difference?

-- 
Luciano ES
>>
