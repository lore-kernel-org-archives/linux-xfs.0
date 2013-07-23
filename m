Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 93F6E7F5E
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 11:27:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 75ACA304059
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 09:27:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id twvFmwr8Q5ltLWzo for
	<xfs@oss.sgi.com>; Tue, 23 Jul 2013 09:26:58 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6NGQvw9011066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 12:26:58 -0400
Date: Tue, 23 Jul 2013 09:26:57 -0700
From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH] xfsprogs/io: add getdents command
Message-ID: <20130723162656.GD30899@lenny.home.zabbo.net>
References: <1373567034-7534-1-git-send-email-bfoster@redhat.com>
	<20130715183845.GS25414@lenny.home.zabbo.net>
	<51EE9AC9.2050306@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51EE9AC9.2050306@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 23, 2013 at 11:01:29AM -0400, Brian Foster wrote:
> On 07/15/2013 02:38 PM, Zach Brown wrote:
> >> +ifeq ($(PKG_PLATFORM),linux)
> >> +CFILES += getdents.c
> >> +endif
> > 
> > I'd make a real test for getdents() rather than tying it to Linux.  Just
> > copy what's done for sync_file_range :). 
> > 
> 
> Having a look back, I think a reason why I avoided this was I didn't
> have a libc interface for getdents.

Bleh, yeah.  I guess you could test for the syscall(__NR,) signature.

> Perhaps there's still a way to test that, but I'm also wondering if
> this would be more broadly useful if I just converted it over to
> generic readdir(). Thoughts?

That seems reasonable, given that's what apps actually use.  If tests
really wanted to inspect getdents specifically they can worry about it.

- z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
