Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTJmWfA020598 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 13:48:33 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B0051794134
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 11:48:31 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id ozhjMxaZPrEhFO0Y for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 11:48:31 -0800 (PST)
Received: from shambhala.lichtvoll.local
	(DSL01.83.171.154.140.ip-pool.NEFkom.net [83.171.154.140])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id AA5795AE4F
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 20:48:30 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: safe writing in applications (was: Re: massively truncated files with
	XFS with sudden power loss on 2.6.27 and 2.6.28)
Date: Mon, 29 Dec 2008 20:48:40 +0100
References: <200812291920.34123.Martin@Lichtvoll.de>
	(sfid-20081229_192707_589385_FA1D7E0C)
In-Reply-To: <200812291920.34123.Martin@Lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812292048.41193.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Am Montag 29 Dezember 2008 schrieb Martin Steigerwald:
> Hi!
> Remember
>
> http://oss.sgi.com/pipermail/xfs/2008-November/037399.html
>
> ?

[... about truncated KDE configuration files ...]

> I cannot remember having seen this kind of behavior anywhere between
> 2.6.17.7 and 2.6.26! And I had sudden interruptions of write activity
> from time to time.
>
> I can't prove anything right now. I possibly could if I dare to test
> this again with 2.6.26! But from my experiences this never was so
> massive. Prior to the null file fixes a file or two might have been
> corrupted and that not all the times. Thats to be expected if thats the
> file that where written out at the time. But now it seems that almost
> every file that is opened for writing or not even just for writing is
> truncated seriously at sudden interruption of write activity. Whereas
> before it appeared that usually either the change was not made or it
> was made - at least for small files. Now the file is truncated, no
> holes, just lots less bytes than before.

Ok, I had to test this. So I made a backup of my current KDE configuration 
to an external drive and tested with 2.6.25.10 and 2.6.26.5! It happens 
there too. So its nothing new what I have observed here. Even the case of 
massively truncated files when trying directly after KDE login. Why all 
those applications appear to write out their configurations files when 
just having been started is a bit beyond me, but well that seems to be 
the case.

So it seems with pre 2.6.27 and 2.6.28 sudden power interruptions I had 
*lots of luck*. Or there is a very subtile difference in the likelyhood 
of truncated files happening. I had the impression during my todays test 
that at least with 2.6.25.10 and 2.6.26.5 truncated files were a little 
less likely, but I have no means of statistics.

And I do not yet have a comparison with ext3/ext4 either.

So I jumped out of the window with my conclusions too early, or I need to 
test even earlier kernels. I hold back an earlier mail about this 
already, but this time I thought I'd write an email. Sorry for the noise.

It might be wise however to file enhancement requests for the KDE 
applications where I observed this behavior if safer writing within the 
applications is possible. Any hints on what application developers should 
keep in mind when writing out config files?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
