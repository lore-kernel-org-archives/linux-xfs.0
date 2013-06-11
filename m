Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4BB7229DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 16:03:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 29C258F8049
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:03:18 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9roBQXQce0nEgmIQ for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 14:03:16 -0700 (PDT)
Date: Wed, 12 Jun 2013 07:03:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions about XFS
Message-ID: <20130611210312.GN29338@dastard>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<51B75C39.3030306@redhat.com>
	<CAAxjCEyne63XH1Uk6_7jzjaxDbsSopO9E+=6oo3xE=PvjBFcjA@mail.gmail.com>
	<51B75EF7.40801@redhat.com>
	<CAO9HMNEk1qNVGzM+a052O1y0nm3-cxqM17BGWBZDc1byfWTa7w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAO9HMNEk1qNVGzM+a052O1y0nm3-cxqM17BGWBZDc1byfWTa7w@mail.gmail.com>
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
To: Steve Bergman <sbergman27@gmail.com>
Cc: Stefan Ring <stefanrin@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

On Tue, Jun 11, 2013 at 02:30:36PM -0500, Steve Bergman wrote:
> Thanks. But I'm specifically *not* talking about database apps, I'm
> talking about non-database applications written in languages that
> don't even have a concept of fsync.

I get it. You want a pony, and you don't want to pay anything for
it.

Any language is fundamentally broken if it has no concept and/or
method for ensuring data integrity for data that is written through
it. If you have such a language and you need data integrity then
your only filesystem option for guaranteeing no data loss is
synchronous writes and metadata updates. 

XFS allows you to minimise the impact of such legacy languages and
applications to just the data sets those applications use through
the use of 'chattr -S' and the /proc/sys/fs/xfs/xfs_inherit_sync
sysctl....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
