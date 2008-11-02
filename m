Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 14:22:00 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA2MLl5M028078
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 14:21:48 -0800
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58FC61318923
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 14:21:48 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.243]) by cuda.sgi.com with ESMTP id WcQvnNZqKAXexNB0 for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 14:21:48 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id f25so2096792rvb.32
        for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 14:21:48 -0800 (PST)
Message-ID: <e9c3a7c20811021421g24086479v9fddacd5a6ee2c5e@mail.gmail.com>
Date: Sun, 2 Nov 2008 15:21:48 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: Linux RAID & XFS Question - Multiple levels of concurrency = faster I/O on md/RAID 5?
In-Reply-To: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Sat, Nov 1, 2008 at 1:29 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> I am using XFS and md/RAID-5, the CFQ scheduler and kernel 2.6.27.4.
> Is this more of an md/raid issue ( I am guessing ) than XFS? I remember
> reading of some RAID acceleration patches awhile back that were supposed to
> boost performance quite a bit, what happened to them?
>

You have it applied, Neil accepted the patch[1] for 2.6.26.

--
Dan

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8b3e6cdc53b7f29f7026955d6cb6902a49322a15
