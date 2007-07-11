Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Jul 2007 16:35:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6BNZgbm006065
	for <linux-xfs@oss.sgi.com>; Wed, 11 Jul 2007 16:35:44 -0700
Message-ID: <469569CC.1010904@sgi.com>
Date: Thu, 12 Jul 2007 09:37:48 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS capacity leak with dmapi
References: <b062d32b0707111442r5050ce96w6ce75df451741f0@mail.gmail.com>
In-Reply-To: <b062d32b0707111442r5050ce96w6ce75df451741f0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: John Groves <John@Groves.net>
Cc: linux-xfs@oss.sgi.com

John Groves wrote:
> Vlad, I've tried to send this via linux-xfs, but for some reason my 
> posts aren't going through (although I receive messages from it every 
> day).  Any ideas on this?
>
> We have an application that uses DMAPI, and we've been chasing an XFS 
> filesystem capacity leak for a week or two.  Here is the scenario:
>
> In some cases we initially create sparse files - normal open with 
> O_CREAT and than an ftruncate to the desired size. 
>
> If we subsequently fill the files via dm_write_invis(), and then 
> remove/unlink the files, XFS does not appear to free up the capacity 
> that was allocated when the file was made non-sparse via 
> dm_write_invis().  Repeating this sequence enough times results in a 
> full filesystem.
>
> If we use write() to fill the file (after creating it as sparse), 
> remove/unlink appears to work properly, and capacity does not appear 
> to be leaked.  We've seen this on several test systems; the current 
> one is 2.6.22-rc4, which I think is current as to the SGI cvs tree (or 
> very nearly so).
>
> Can anybody shed light on this?
>
> Thanks,
> John Groves
Hi John,

I will investigate this problem but at the moment I can't immediately jump
on it. I am copying the email to linux-xfs list in case if someone could
answer it straightaway.

Regards,
Vlad
