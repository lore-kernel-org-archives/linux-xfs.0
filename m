Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 12:09:03 -0700 (PDT)
Received: from smtp107.sbc.mail.mud.yahoo.com (smtp107.sbc.mail.mud.yahoo.com [68.142.198.206])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6HJ8oDW023164
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 12:08:50 -0700
Date: Mon, 17 Jul 2006 12:08:27 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: file system defragmentation
Message-ID: <20060717190827.GA7845@tuatara.stupidest.org>
References: <4f52331f050826001612f8e323@mail.gmail.com> <20050826101131.GA24544@ii.uib.no> <4f52331f0508260848782f240a@mail.gmail.com> <43128F82.4010004@tlinx.org> <4312913F.6040205@coremetrics.com> <43311567.3060208@tlinx.org> <5356806.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5356806.post@talk.nabble.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Cosmo Nova <cs_mcc98@hotmail.com>
Cc: linux-xfs@oss.sgi.com

On Mon, Jul 17, 2006 at 12:36:09AM -0700, Cosmo Nova wrote:

> If I have a DVR system of 16 channels. They keep writing data to the
> disk in pieces of video files.

I did some work for someone who does a similar thing (they write 96
channels in parallel and have to be able to do read back up to 32 of
them at the same time of something).

By default concurrent writes into the same directory will cause the
files to get badly interleaved, and trying to get one file per-ag
doesn't work so well if the agcount < n-files.

I ended up getting them to change their code to preallocate and AFAIK
it works very well now (you can throw away any space you over allocate
when you're closing the file too).
