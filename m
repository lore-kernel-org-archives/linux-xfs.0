Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBD9029DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 12:28:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD654304053
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 10:28:01 -0700 (PDT)
Received: from mail-wg0-f52.google.com (mail-wg0-f52.google.com
	[74.125.82.52]) by cuda.sgi.com with ESMTP id mI2qAXy2ek0piEHz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Jun 2013 10:28:00 -0700 (PDT)
Received: by mail-wg0-f52.google.com with SMTP id z12so5518299wgg.19
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 10:28:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B75C39.3030306@redhat.com>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<51B75C39.3030306@redhat.com>
Date: Tue, 11 Jun 2013 19:27:59 +0200
Message-ID: <CAAxjCEyne63XH1Uk6_7jzjaxDbsSopO9E+=6oo3xE=PvjBFcjA@mail.gmail.com>
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

> Let's take a simple example - a database app that does say 30
> transactions/sec.
>
> In your example, you are extremely likely to lose up to just shy of 5
> seconds of "committed" data - way over 100 transactions!  That can be
> *really* serious amounts of data and translate into large financial loss.

Every database software will do the flushing correctly.

> In a second example, let's say you are copying data to disk (say a movie) at
> a rate of 50 MB/second.  When the power cut hits at just the wrong time, you
> will have lost a large chunk of that data that has been "written" to disk
> (over 200MB).

But why would anyone care about that? I know that the system went down
while copying this large movie, so I'll just copy it again.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
