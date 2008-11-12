Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 08:37:37 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mACGbQg5031702
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 08:37:28 -0800
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A63E4154C3E2
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 08:37:25 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id QeursHlFZRaf33Kt for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 08:37:25 -0800 (PST)
Message-ID: <491AFC85.2000708@redhat.com>
Date: Wed, 12 Nov 2008 09:55:49 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix dbtest build
References: <490F8380.6020706@redhat.com> <20081112100420.GA32567@infradead.org>
In-Reply-To: <20081112100420.GA32567@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Nov 03, 2008 at 05:04:32PM -0600, Eric Sandeen wrote:
>> At least on my x86_64 RHEL5 box, if gdbm-devel is installed, then the
>> xfstests build fails with:
> 
> Still doesn't build even with libgdbm-dev installed on debian, despite
> having a /usr/include/gdbm.h.  Even when manually including that one it
> doesn't define DBM.  Which of the three headers does actually get used
> on RHEL?
> 

hm, looks like:


checking gdbm/ndbm.h usability... yes
checking gdbm/ndbm.h presence... yes
checking for gdbm/ndbm.h... yes

and include/config.h winds up as:

/* Define to 1 if you have the <gdbm/ndbm.h> header file. */
#define HAVE_GDBM_NDBM_H 1

...

/* Define to 1 if you have the <ndbm.h> header file. */
/* #undef HAVE_NDBM_H */

and:

[root@host xfstests]# locate gdbm/ndbm.h
/usr/include/gdbm/ndbm.h
[root@host xfstests]# rpm -qf /usr/include/gdbm/ndbm.h
gdbm-devel-1.8.0-26.2.1
[root@bear-05 xfstests]#


-Eric
