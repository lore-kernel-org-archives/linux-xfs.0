Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 00:46:23 -0700 (PDT)
Received: from zebday.corky.net (corky.net [212.150.53.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T7kItL021680
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 00:46:20 -0700
Message-ID: <4684B716.6030601@corky.net>
Date: Fri, 29 Jun 2007 08:39:02 +0100
From: Just Marc <marc@corky.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr, performance related tweaks
References: <4683ADEB.3010106@corky.net> <46841C60.5030207@sandeen.net> <4684A506.4030705@corky.net> <op.tun7i8wd3jf8g2@pc-bnaujok.melbourne.sgi.com> <4684A98B.1030000@corky.net> <20070629070814.GR31489@sgi.com> <4684B1CC.60004@corky.net> <20070629074114.GS31489@sgi.com>
In-Reply-To: <20070629074114.GS31489@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

I agree with you.  But what about files it works on, heavily, then 
decides they can't be defragged further? then it tries to defrag them 
again and again and again.  And that's the end of my story.


David Chinner wrote:
> No, I don't - if you want files not to be defragmented, then you
> have to set the flags yourself in some way. You have a specific need
> that can be solved by some scripting to describe your defrag/no
> defrag policy. xfs_fsr has no place is setting defrag policy; it's
> function is simply to find and defrag files.
>
> Cheers,
>
> Dave.
>   
