Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 21:42:04 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M4g2am016265
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:42:02 -0700
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 501CF1916BF7
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:43:12 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.247]) by cuda.sgi.com with ESMTP id cGyGHsjCPBzE166Q for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:43:12 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id d30so441105and.75
        for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:43:11 -0700 (PDT)
Message-ID: <2d460de70807212143j1f80e016y6a48cab966091215@mail.gmail.com>
Date: Tue, 22 Jul 2008 06:43:11 +0200
From: "Richard Hartmann" <richih.mailinglist@gmail.com>
Subject: Re: xfsrestore over ssh?
In-Reply-To: <48855B16.4050208@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>
	 <4884F2A5.5050507@sgi.com>
	 <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>
	 <48855B16.4050208@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Bill Kendall <wkendall@sgi.com>, xfs@oss.sgi.com

On Tue, Jul 22, 2008 at 05:59, Timothy Shimmin <tes@sgi.com> wrote:


> xfsrestore just uses standard posix calls for the most part to
> restore the files (seeks, writes, etc...) to a mounted filesystem -
> and in many circumstances can restore on a non-xfs mounted filesystem.
> It is _NOT_ a low level file system restorer to an unmounted filesystem
> like some other restorers.

True, this is why I told it to use /mnt/sda3, not a raw device :)


Richard
