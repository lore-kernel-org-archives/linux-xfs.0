Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 21:48:58 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0J5mcJb004476
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 21:48:39 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17490539486
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 21:48:56 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ZHFICOSzY2opGxMI for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 21:48:56 -0800 (PST)
Message-ID: <47918F46.8070600@sandeen.net>
Date: Fri, 18 Jan 2008 23:48:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW 0/2] Case insensitive support for XFS
References: <op.t43ze9ot3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t43ze9ot3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Barry Naujok wrote:
> In the following two emails is contains patches for
> case-insensitive and Unicode support for XFS in Linux.
> It implements case-insensitivity utilising a Unicode
> case folding table stored on disk generated from
> http://www.unicode.org/Public/UNIDATA/CaseFolding.txt

FWIW, I wanted to play with this a bit, and rolled the patches into
Fedora Rawhide rpm builds for kernel & userspace:

http://people.fedoraproject.org/~sandeen/xfs-ci/

it's not *in* rawhide; those are scratch builds based on rawhide, with
the xfs CI stuff applied.

-Eric
