Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 11F4929DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 12:31:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8136AC004
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 10:31:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dAW5DzgQcocjuviL for
	<xfs@oss.sgi.com>; Tue, 11 Jun 2013 10:31:38 -0700 (PDT)
Message-ID: <51B75EF7.40801@redhat.com>
Date: Tue, 11 Jun 2013 13:31:35 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<51B75C39.3030306@redhat.com>
	<CAAxjCEyne63XH1Uk6_7jzjaxDbsSopO9E+=6oo3xE=PvjBFcjA@mail.gmail.com>
In-Reply-To: <CAAxjCEyne63XH1Uk6_7jzjaxDbsSopO9E+=6oo3xE=PvjBFcjA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Steve Bergman <sbergman27@gmail.com>, Linux fs XFS <xfs@oss.sgi.com>

On 06/11/2013 01:27 PM, Stefan Ring wrote:
>> Let's take a simple example - a database app that does say 30
>> transactions/sec.
>>
>> In your example, you are extremely likely to lose up to just shy of 5
>> seconds of "committed" data - way over 100 transactions!  That can be
>> *really* serious amounts of data and translate into large financial loss.
> Every database software will do the flushing correctly.

Stefan, you are making my point because every database will do the right thing, 
it won't rely on ext3's magic every 5 second fsync :)

Ric

>
>> In a second example, let's say you are copying data to disk (say a movie) at
>> a rate of 50 MB/second.  When the power cut hits at just the wrong time, you
>> will have lost a large chunk of that data that has been "written" to disk
>> (over 200MB).
> But why would anyone care about that? I know that the system went down
> while copying this large movie, so I'll just copy it again.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
