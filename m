Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 15:18:42 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m53MId3r027572
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 15:18:40 -0700
Received: from hrndva-omtalb.mail.rr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA4C01776CE2
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 15:19:24 -0700 (PDT)
Received: from hrndva-omtalb.mail.rr.com (hrndva-omtalb.mail.rr.com [71.74.56.124]) by cuda.sgi.com with ESMTP id PADvXBcUObZYw7eC for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 15:19:24 -0700 (PDT)
From: Thomas King <kingttx@tomslinux.homelinux.org>
Message-ID: <59654.143.166.255.56.1212531553.squirrel@tomslinux.homelinux.org>
In-Reply-To: <4845C254.6050104@sandeen.net>
References: 
    <13033.143.166.226.57.1212526129.squirrel@tomslinux.homelinux.org>
    <4845C254.6050104@sandeen.net>
Date: Tue, 3 Jun 2008 17:19:13 -0500 (CDT)
Subject: Re: Questions for article
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> Thomas King wrote:
>
>> -Concerning the block-size limit, will this eventually be a thing of the past?
>> Mr. Newman's contention is massive filesystems should have much larger block
>> sizes, but he also contends that OSD is the eventual answer instead of using
>> block allocation.
>
> Just to reiterate what I already put on the ext4 list... :)
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/christoph/largeblocksize/4/patches/
> http://kerneltrap.org/Linux/Large_Blocksize_Performance
>
> Not sure where those patches are headed.
>
> It's also not clear to me that this is really a critical feature for
> large filesystems; space allocation is not done block by block per se in
> xfs, as Mr. Newman seems (?) to imply (?)  The block granularity is
> there throughout the fs but I'm not sure how much it matters in
> practice.  Dave...?
>
> OSDs may have their place, we'll see.  It's pretty new stuff (unless you
> count Lustre, I guess, but I thought he didn't want to talk lustre...)
> I don't think this relates to a linux shortcoming in any way (or to
> xfs...), it's  awfully new stuff that just about nobody really has in
> production.
>
>> -Is there anything else y'all would like folks to understand about XFS and
>> massive implementations?
>
> I already pointed him at the xfs_repair paper, since he seems concerned
> about fsck (and pointed out that yes, xfs_repair really *DOES* check all
> filesystem data and does not simply replay the log...)
>
> http://mirror.linux.org.au/pub/linux.conf.au/2008/slides/135-fixing_xfs_faster.pdf
>
> Maybe some of the folks on the list with said massive implementations
> can speak up too.  :)
>
> -Eric
>
Both you and Andreas gave me some excellent information on both lists, and thank
you all for your patience. I appreciate everyone piping in. Like you say, if
there is anyone with massive implementations that wishes to add, please do so.

Thanks!
Tom King
