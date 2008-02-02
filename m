Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Feb 2008 11:28:39 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m12JSYEC003943
	for <xfs@oss.sgi.com>; Sat, 2 Feb 2008 11:28:35 -0800
Received: from wx-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3541F100885F
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2008 11:28:55 -0800 (PST)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.228]) by cuda.sgi.com with ESMTP id UHSg5BUAnHqgQVAW for <xfs@oss.sgi.com>; Sat, 02 Feb 2008 11:28:55 -0800 (PST)
Received: by wx-out-0506.google.com with SMTP id s9so1547752wxc.32
        for <xfs@oss.sgi.com>; Sat, 02 Feb 2008 11:28:54 -0800 (PST)
Message-ID: <8f1895b90802021101k63d29842re986ef75ffcc113@mail.gmail.com>
Date: Sat, 2 Feb 2008 20:01:32 +0100
From: "Per Lundberg" <perlun@gmail.com>
Subject: Re: XFS: failed to read RT inodes
In-Reply-To: <47A49206.4020700@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8f1895b90802020212h278968efy7a644c55c480134e@mail.gmail.com>
	 <47A49206.4020700@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Feb 2, 2008 4:53 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > Jan 10 10:30:59 amos kernel: SGI XFS with ACLs, security attributes,
> > realtime, large block numbers, no debug enabled
> > Jan 10 10:30:59 amos kernel: SGI XFS Quota Management subsystem
> > Jan 10 10:31:00 amos kernel: XFS mounting filesystem sda10
> > Jan 10 10:31:00 amos kernel: XFS: failed to read RT inodes
> maybe try xfs_db on the device; "sb 0" and "p" commands to see what the
> rt inodes are.

Thanks for the hint! However, what I did was do a full restore of the
volume again and then xfs_repair + xfs_repair -L. Now, I can mount it
- but *everything* (and I really mean literally everything) has been
put into lost+found. Slightly annoying to say the least, but still a
whole lot better than having lost it all.

I think it *could* be because of a bad imaging program (Image for
Windows). The first sector of the partition doesn't seem to come
through properly (after restore, it contains 512 0x00 bytes. Quite
wrong in other words, so that could be the reason for the breakage. I
guess I could put back the broken drive again and just "dd" over the
data to the working disk but when I tried to do that yesterday on
another partition, I got 500 or so bad sectors... compared to 11 with
Image for Windows. So either Image for Windows was lying to me or the
disk has been starting to fall apart even more. :-)
-- 
Best regards,
Per Lundberg
