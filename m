Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 20:58:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6M3wIrY012146
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 20:58:19 -0700
Message-ID: <48855B16.4050208@sgi.com>
Date: Tue, 22 Jul 2008 13:59:18 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore over ssh?
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>	 <4884F2A5.5050507@sgi.com> <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>
In-Reply-To: <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: Bill Kendall <wkendall@sgi.com>, xfs@oss.sgi.com

Richard Hartmann wrote:
> On Mon, Jul 21, 2008 at 22:33, Bill Kendall <wkendall@sgi.com> wrote:
> 
> 
>> % cat dumpfile | ssh root@host xfsrestore - /restore/here
> 
> I did try
> 
>   cat root.xfs | ssh root@192.168.1.213 xfsrestore - /mnt/sda3
> 
> which resulted in
> 
> The authenticity of host '192.168.1.213 (192.168.1.213)' can't be established.
> RSA key fingerprint is 3c:a9:a3:84:0f:8e:e2:84:c9:c6:85:af:5f:8d:52:5f.
> Are you sure you want to continue connecting (yes/no)? yes
> Warning: Permanently added '192.168.1.213' (RSA) to the list of known hosts.
> Password:
> xfsrestore: using file dump (drive_simple) strategy
> xfsrestore: version 2.2.45 (dump format 3.0) - Running single-threaded
> xfsrestore: unable to construct a file system handle for /mnt/sda3:
> Das Argument ist ung�ltig
> xfsrestore: Restore Status: ERROR
> 
> 'The argument is invalid' -- needless to say, this is a valid xfs partition of
> appropriate size..
> 
> 
The final argument to restore should be a destination directory not a device
(as Donald sitting nearby mentioned to me :).

xfsrestore just uses standard posix calls for the most part to
restore the files (seeks, writes, etc...) to a mounted filesystem -
and in many circumstances can restore on a non-xfs mounted filesystem.
It is _NOT_ a low level file system restorer to an unmounted filesystem
like some other restorers.

--Tim
