Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o67NbWDC002550 for <xfs@oss.sgi.com>; Wed, 7 Jul 2010 18:37:32 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3046D15B9209
	for <xfs@oss.sgi.com>; Wed,  7 Jul 2010 16:45:57 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id MyK3wzI2AV7SXRtG
	for <xfs@oss.sgi.com>; Wed, 07 Jul 2010 16:45:57 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 2EA276C029
	for <xfs@oss.sgi.com>; Wed,  7 Jul 2010 18:40:22 -0500 (CDT)
Message-ID: <4C351065.7060803@hardwarefreak.com>
Date: Wed, 07 Jul 2010 18:40:21 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: utf-8' chars from Winxp machine may be problem related (was Re:
	xfs	file system in process of becoming corrupt; though xfs_repair...)
References: <4C26A51F.8020909@tlinx.org>	<20100628022744.GX6590@dastard>	<4C2A749E.4060006@tlinx.org>	<20100629232532.GA24712@dastard>	<4C2A8948.3030008@tlinx.org>	<20100630010622.GC24712@dastard>	<4C2AA36F.2070905@tlinx.org>
	<4C2BB0C4.4060800@hardwarefreak.com> <4C34F464.6060506@tlinx.org>
In-Reply-To: <4C34F464.6060506@tlinx.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Linda A. Walsh put forth on 7/7/2010 4:40 PM:

> So yup...foreign char delight.
> 
> I can easily image most or all of these having been imported from my
> winXP machine at
> one point -- as I only recently started using Win7.  -- and many of the
> troublsome japanese
> filenames were 'downloaded japanese anime-related stuff' that I did on
> my old
> XP machine -- which I used as a download client while I did work on my
> Win7 machine...
> That gave a huge influx of foreign names from a WinXP machine.  That
> could be what
> made the problem jump out so noticeable -- before it was only maybe
> 20-30 files out of about a million or more.  But in the new batch it was
> hundreds out of several thousand, so
> they stand out alot more.

I run into a similar problem frequently when saving downloads to my XFS samba
shares via a Windows client.  I don't recall ever seeing XFS corruption, but I
do have problems manipulating these file names through bash.  Quite often I
end up having to rename the files through Windows Explorer to something bash
can handle.  That usually fixes the problem--not always, but usually.

Just for comparison, I'm running:

Debian stable (Lenny 5.0.4)
rolled 2.6.32.9 from kernel.org, XFS in kernel not as module
xfsprogs:  2.9.8-1lenny1
bash:      3.2-4
samba:     3.2.5-4lenny9
W2K and XP Pro clients

As I've never seriously dealt with character encoding issues (i.e. changed
anything related in Debian), I don't even know where/how to find my servers
default character encoding.  Google isn't being very friendly here.  I'm using
whatever character encoding is the default for US English Debian Lenny.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
