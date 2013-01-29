Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7EF0A7F59
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 15:13:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6DF62304059
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 13:13:55 -0800 (PST)
Received: from thunder.skymagik.net (thunder.skymagik.net [76.75.207.68]) by
	cuda.sgi.com with ESMTP id vjv5jFgiayYKtcaf for
	<xfs@oss.sgi.com>; Tue, 29 Jan 2013 13:13:54 -0800 (PST)
Message-ID: <25999.192.104.24.222.1359494034.squirrel@secure.skymagik.net>
Date: Tue, 29 Jan 2013 16:13:54 -0500 (EST)
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
From: "Tom" <storm9c1@skymagik.com>
In-Reply-To: <20130129151833.GF27055@sgi.com>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: bpm@sgi.com
Cc: storm9c1@skymagik.com, xfs@oss.sgi.com

In a previous message, Ben Myers wrote:
>
> I took a brief look at your report.  I think a traceback would be
> helpful.
>
> echo t > /proc/sysrq-trigger should do the trick.  You're in the middle
> of unmount so you might need to go serial console to capture the output.
>  Your report metions freeze/thaw.  This is an area where we've had
> deadlocks in the past, so I wouldn't be surprised if that is what you're
> hitting.  We'll have to see.
>

Hi Ben,

Sure.  If I do a reboot, and let it go through the motions, then I let it
hang for more than 120 seconds, sometimes it displays a traceback on it's
own.  If not, I can trigger it from the serial console (though probably
with break-t instead since this happens at the very end of the shutdown
sequence, so no access to the shell).

I'll have access to the test systems tonight and will get a traceback.
I'll also post what is displayed during the shutdown process right before
the hang.

Thanks again for your help.

-- Tom




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
