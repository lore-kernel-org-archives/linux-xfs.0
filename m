Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 20:00:58 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M30uTX003929
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 20:00:56 -0700
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05EB81916524
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 20:02:05 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.250]) by cuda.sgi.com with ESMTP id JZYpJ90OZGcJJx6e for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 20:02:05 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id d30so436851and.75
        for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 20:02:05 -0700 (PDT)
Message-ID: <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>
Date: Tue, 22 Jul 2008 05:02:05 +0200
From: "Richard Hartmann" <richih.mailinglist@gmail.com>
Subject: Re: xfsrestore over ssh?
In-Reply-To: <4884F2A5.5050507@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>
	 <4884F2A5.5050507@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 22:33, Bill Kendall <wkendall@sgi.com> wrote:


> % cat dumpfile | ssh root@host xfsrestore - /restore/here

I did try

  cat root.xfs | ssh root@192.168.1.213 xfsrestore - /mnt/sda3

which resulted in

The authenticity of host '192.168.1.213 (192.168.1.213)' can't be established.
RSA key fingerprint is 3c:a9:a3:84:0f:8e:e2:84:c9:c6:85:af:5f:8d:52:5f.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.1.213' (RSA) to the list of known hosts.
Password:
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 2.2.45 (dump format 3.0) - Running single-threaded
xfsrestore: unable to construct a file system handle for /mnt/sda3:
Das Argument ist ung�ltig
xfsrestore: Restore Status: ERROR

'The argument is invalid' -- needless to say, this is a valid xfs partition of
appropriate size..


Richard
