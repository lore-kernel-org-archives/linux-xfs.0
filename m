Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 242AC29DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 16:43:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D49A68F8049
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:43:13 -0700 (PDT)
Received: from mail-qe0-f41.google.com (mail-qe0-f41.google.com
	[209.85.128.41]) by cuda.sgi.com with ESMTP id 7XdQOzTRLJCFCEU5
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:43:12 -0700 (PDT)
Received: by mail-qe0-f41.google.com with SMTP id b4so1970030qen.14
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:43:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130611210312.GN29338@dastard>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<51B75C39.3030306@redhat.com>
	<CAAxjCEyne63XH1Uk6_7jzjaxDbsSopO9E+=6oo3xE=PvjBFcjA@mail.gmail.com>
	<51B75EF7.40801@redhat.com>
	<CAO9HMNEk1qNVGzM+a052O1y0nm3-cxqM17BGWBZDc1byfWTa7w@mail.gmail.com>
	<20130611210312.GN29338@dastard>
Date: Tue, 11 Jun 2013 16:43:11 -0500
Message-ID: <CAO9HMNFUnWUzSE3NhOwXmtzuqxjB1Ri3JxpOU-FTugQt3CdkPQ@mail.gmail.com>
Subject: Re: Questions about XFS
From: Steve Bergman <sbergman27@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Stefan Ring <stefanrin@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

> I get it. You want a pony, and you don't want to pay anything for
it.

Hi Dave,

Not at all. I don't mind incurring a performance penalty in that LV.
Ext3 performance is quite acceptable, with the exception of a single
maintenance operation which I perform periodically (which can be quite
slow, indeed, on the larger files. Very intensive random writes.)
Fortunately, the filesystem intensive part of that operation occurs in
its own work directory. The files in that directory are just temporary
work files. And at the end of the processing, the resulting files get
copied back to the main data directory tree.  XFS performs extremely
well for this operation. For about a dozen years, I've been using Ext3
for the whole thing, and the resiliency has been much more than just
adequate. (If I needed more, I'd mount ext3 data=journal; I can't
imagine mounting synchronously.) But for this new server, and probably
future ones, I'll be using Ext3 for the permanent data, and XFS for
the work directory. It makes a huge difference for that one operation,
and leverages the strengths of both filesystems to yield something
more appropriate for the workload than either one alone. As Ted is
fond of noting, one of Linux's greatest strengths is the variety of
filesystems it offers. And sometimes filesystem performance just
doesn't matter.

-Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
