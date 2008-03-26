Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 19:06:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2Q26l10026317
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 19:06:49 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6D016EB37B
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 19:07:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id QnKI6huACAh0R5H2 for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 19:07:19 -0700 (PDT)
Message-ID: <47E9AFD6.3050304@sandeen.net>
Date: Tue, 25 Mar 2008 21:07:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: REVIEW: Write primary superblock info to ALL secondaries during
 mkfs
References: <op.t8j4nch93jf8g2@pc-bnaujok.melbourne.sgi.com> <47E8F5BD.7000601@sandeen.net> <47E9AC67.8070809@sgi.com>
In-Reply-To: <47E9AC67.8070809@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Mark Goodwin wrote:
> 
> Eric Sandeen wrote:

>> One related thing I'd always wondered about was stamping a secondary at
>> the very end of the device (and therefore shrinking the fs by just a
>> bit) - repair could then do a quick check at the end of the device
>> before resorting to scanning for the 2nd backup... would this make any
>> sense?
> 
> I guess it might, Barry what do you think? Probably makes grow a bit
> more complicated. What would repair do if it doesn't find the backup
> SB at the end of the device? We'd need a new SB flag to indicate it's
> supposed to be there, which seems a bit chicken-and-egg'ish ...

If not found at the end, just go back to the original search scheme, I'd
say...

-Eric
