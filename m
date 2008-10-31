Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 05:13:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VCD8Kk030697
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 05:13:08 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC3421B6FB4A
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 05:13:09 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id SGQ5e0XFX8k6RE2V for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 05:13:09 -0700 (PDT)
Date: Fri, 31 Oct 2008 08:13:09 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Which FileSystem do you use on your postfix server?
In-Reply-To: <20081031121002.D94A11F3E98@spike.porcupine.org>
Message-ID: <alpine.DEB.1.10.0810310810520.468@p34.internal.lan>
References: <20081031121002.D94A11F3E98@spike.porcupine.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Postfix users <postfix-users@postfix.org>
Cc: xfs@oss.sgi.com



On Fri, 31 Oct 2008, Wietse Venema wrote:

> Does XFS still overwrite existing files with zeros, when those
> files were open for write at the time of unclean shutdown? This
I believe this was fixed in an early 2.6.2x release, cc'ing xfs mailing 
list to confirm.

> would violate a basic requirement of Postfix (don't lose data after
> fsync).  Postfix updates existing files all the time: it updates
> queue files as it marks recipients as done, and it updates mailbox
> files as it appends mail.
