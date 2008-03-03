Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 17:03:35 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2313M5U002093
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 17:03:27 -0800
Message-ID: <47CB4E20.5070808@sgi.com>
Date: Mon, 03 Mar 2008 12:02:24 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: Kernel oops / XFS filesystem corruption
References: <47C93C32.40006@mathtm.de> <47C9C44D.8080400@sandeen.net> <47C9F5E9.70703@mathtm.de> <47CA043F.5070202@sandeen.net>
In-Reply-To: <47CA043F.5070202@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: =?ISO-8859-15?Q?Thomas_M=FCller?= <thomas@mathtm.de>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org



Eric Sandeen wrote:
> Thomas Müller wrote:
>> Eric Sandeen wrote:
>>> Did you also happen to save the xfs_repair output?
>> No, but I made a complete copy of the file system before
>> repairing it, so I can easily recreate it... :)
> 
> oh, like a dd image?  great.  You can use xfs_metadump to make a more
> transportable image... xfs folks might even be able to use that to
> recreate the oops.

YES PLEASE. See the xfs_metadump man page for instructions. It will
obfuscate filenames by default (but please only do so if you need to).

Please make it available for Barry, thanks.

Cheers
-- Mark
