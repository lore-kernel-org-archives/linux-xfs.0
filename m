Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 326D229DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 12:41:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08734304053
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 10:41:38 -0700 (PDT)
Received: from mail-we0-f178.google.com (mail-we0-f178.google.com
	[74.125.82.178]) by cuda.sgi.com with ESMTP id XCFK4IRc3GN2SmHI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Jun 2013 10:41:37 -0700 (PDT)
Received: by mail-we0-f178.google.com with SMTP id u53so6210837wes.9
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 10:41:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B75EF7.40801@redhat.com>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<51B75C39.3030306@redhat.com>
	<CAAxjCEyne63XH1Uk6_7jzjaxDbsSopO9E+=6oo3xE=PvjBFcjA@mail.gmail.com>
	<51B75EF7.40801@redhat.com>
Date: Tue, 11 Jun 2013 19:41:36 +0200
Message-ID: <CAAxjCEwvudBHV1LAEKOabTBk7no4uXV8RbfZDbm5E=TjA_Vm5A@mail.gmail.com>
Subject: Re: Questions about XFS
From: Stefan Ring <stefanrin@gmail.com>
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
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Steve Bergman <sbergman27@gmail.com>, Linux fs XFS <xfs@oss.sgi.com>

>> Every database software will do the flushing correctly.
>
>
> Stefan, you are making my point because every database will do the right
> thing, it won't rely on ext3's magic every 5 second fsync :)

Ok, let us agree on this one then ;)

There is still kind of a dichotomy regarding the entire issue. While
in many cases, noone will complain about a few  seconds of lost data,
it is an entirely different beast if you lose an entire file that may
have been added to and maintained over month/years, just because the
system went down at an unfortunate moment. In my opinion, having a
consistent, yet possibly somewhat outdated file, is much more
important than having the most recent view in an inconsistent/broken
state.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
