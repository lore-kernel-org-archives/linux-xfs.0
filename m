Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Mar 2008 22:30:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2J5UbC9019315
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 22:30:39 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5CD86BB67B
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 22:31:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 5YUGcQdBNBSKsF2w for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 22:31:10 -0700 (PDT)
Message-ID: <47E0A51D.9020803@sandeen.net>
Date: Wed, 19 Mar 2008 00:31:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <b1b17e290803181631x60a3e921l836b115c3b026773@mail.gmail.com> <47E085F3.8030908@sandeen.net> <47E0A07D.5090803@sandeen.net>
In-Reply-To: <47E0A07D.5090803@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andre Draszik <xfs@andred.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Eric Sandeen wrote:
> 
>> I've helpfully provided structure layouts for the structures you mention
>> in the attached files, for your diffing pleasure.  I think you'll find
>> that it's not exactly as you described.
> 
> Ah hell the arm structs I attached were for oldabi.  It's what I get for
> saving this fun work for late at night ;)
> 
> Attached are eabi structs; still only xfs_dir2_data_entry, xfs_dinode
> and xfs_log_item seem to be affected by end-of-struct padding, of the
> structures you mention.  And xfs_log_item isn't a disk structure...
> 
> which brings me back to, what specific failures do you see as a result
> of end-of-struct padding on these structs?

... especially since the layout is identical to ia64, padding and all!

Ok must.. stop.. replying.. to.. self.

-Eric
