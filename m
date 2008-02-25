Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 10:14:02 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1PIDtAf007117
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 10:13:58 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1B4C615162
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 10:14:22 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id AFMF8WqrfFh9dnXr for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 10:14:22 -0800 (PST)
Message-ID: <47C3055C.3090103@sandeen.net>
Date: Mon, 25 Feb 2008 12:13:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS on Red Hat EL5
References: <00fa01c874b5$1908d150$8e0010ac@sg.lcl> <alpine.DEB.1.00.0802211401590.17484@p34.internal.lan> <47BDD390.1040102@sandeen.net> <000601c877c5$d33297b0$8e0010ac@sg.lcl> <47C2F4EF.4020008@sandeen.net> <002e01c877d7$9eb67210$8e0010ac@sg.lcl>
In-Reply-To: <002e01c877d7$9eb67210$8e0010ac@sg.lcl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miakell Figueredo <figueredom@scoregroup.com>
Cc: 'Justin Piszcz' <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

Miakell Figueredo wrote:
> rpmbuild --rebuild --define 'kernel 2.6.18-53.1.13.el5'
> kernel-module-xfs-2.6.17-1.2519.4.21.el5-0.2-1fc6.src.rpm
> 
>  
> 
> That is the command I used which matches my kernel "2.6.18-53.1.13.el5". I
> was able to build xfs-kmod-0.4-2.2.6.18_8.el5.src.rpm but not the kernel.
> Any suggestions?

Are both kernel-2.6.18-53.1.13.el5 and kernel-devel-2.6.18-53.1.13.el5
installed?

then build as:

rpmbuild --rebuild --define 'kvariants ""' --define 'kversion
2.6.18-53.1.13.el5' xfs-kmod-0.4-2.2.6.18_8.el5.src.rpm

(note, kversion not kernel)

-Eric
