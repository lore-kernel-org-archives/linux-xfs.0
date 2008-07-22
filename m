Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 03:39:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6MAdX7J023380
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:39:34 -0700
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4CE6312C2E
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:40:43 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.249]) by cuda.sgi.com with ESMTP id OGxBQAr623MySCak for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:40:43 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id d30so456084and.75
        for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:40:42 -0700 (PDT)
Message-ID: <2d460de70807220340g59507d8ejce30fba28e65a20e@mail.gmail.com>
Date: Tue, 22 Jul 2008 12:40:42 +0200
From: "Richard Hartmann" <richih.mailinglist@gmail.com>
Subject: Re: xfsrestore over ssh?
In-Reply-To: <48857C4A.6060004@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>
	 <4884F2A5.5050507@sgi.com>
	 <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>
	 <48855B16.4050208@sgi.com>
	 <2d460de70807212143j1f80e016y6a48cab966091215@mail.gmail.com>
	 <48857C4A.6060004@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Bill Kendall <wkendall@sgi.com>, xfs@oss.sgi.com

On Tue, Jul 22, 2008 at 08:20, Donald Douwsma <donaldd@sgi.com> wrote:

> Should be working then. If you hexdump the start of the dump does it look
> reasonable? It should be something like:

00000000  78 46 53 64 75 6d 70 30  00 00 00 02 7c 88 36 7e  |xFSdump0....|.6~|
00000010  48 80 68 62 00 00 00 00  00 00 00 00 00 7f 01 01  |H.hb............|
00000020  4d 5b 06 14 c5 68 40 99  9d 23 9d ef 10 23 5d 4a  |M[...h@..#...#]J|
00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000100  69 6c 6f 6e 61 2d 6c 61  70 74 6f 70 00 00 00 00  |ilona-laptop....|
00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000400  00 00 00 01 00 00 00 00  00 00 00 01 00 00 00 00  |................|
00000410  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

An interactive xfsrestore on the local computer does work like a charm, as
well.


Richard
