Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Mar 2008 09:25:36 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m23HPG3U017651
	for <xfs@oss.sgi.com>; Mon, 3 Mar 2008 09:25:17 -0800
Received: from nf-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDE2F644095
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2008 09:25:44 -0800 (PST)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188]) by cuda.sgi.com with ESMTP id 8BF3lonYvNhMti05 for <xfs@oss.sgi.com>; Mon, 03 Mar 2008 09:25:44 -0800 (PST)
Received: by nf-out-0910.google.com with SMTP id e27so95784nfd.42
        for <xfs@oss.sgi.com>; Mon, 03 Mar 2008 09:25:43 -0800 (PST)
Message-ID: <e03b90ae0803030901i289552c6od7f4de4a422e90ee@mail.gmail.com>
Date: Mon, 3 Mar 2008 09:01:08 -0800
From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: disappearing xfs partition
In-Reply-To: <47CC2536.7080205@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e03b90ae0803030514v585249ecjf93af325287b59f@mail.gmail.com>
	 <alpine.DEB.1.00.0803030857590.29466@p34.internal.lan>
	 <47CC2536.7080205@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

On Mon, Mar 3, 2008 at 8:20 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Justin Piszcz wrote:
>  > Looks like a udev problem or something is not making /dev/sde1? Have you
>  > tried a manual mknod of the device?

# mknod /dev/sde1 b 8 65

# mount /dev/sde1 /data2
mount: /dev/sde1 is not a valid block device

>  but... it is not an xfs problem.  :)

Sorry for posting.

>  (also check /proc/partitions for sde1...)

Not present.

# grep sde /proc/partitions
   8    64  976762584 sde
