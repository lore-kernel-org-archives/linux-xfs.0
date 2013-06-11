Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 32F2029DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:30:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 078418F8050
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 12:30:37 -0700 (PDT)
Received: from mail-qc0-f182.google.com (mail-qc0-f182.google.com
	[209.85.216.182]) by cuda.sgi.com with ESMTP id
	sI7ancrKmDeFXFdm (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 12:30:37 -0700 (PDT)
Received: by mail-qc0-f182.google.com with SMTP id e10so2241491qcy.41
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 12:30:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B75EF7.40801@redhat.com>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<51B75C39.3030306@redhat.com>
	<CAAxjCEyne63XH1Uk6_7jzjaxDbsSopO9E+=6oo3xE=PvjBFcjA@mail.gmail.com>
	<51B75EF7.40801@redhat.com>
Date: Tue, 11 Jun 2013 14:30:36 -0500
Message-ID: <CAO9HMNEk1qNVGzM+a052O1y0nm3-cxqM17BGWBZDc1byfWTa7w@mail.gmail.com>
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
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Stefan Ring <stefanrin@gmail.com>, Linux fs XFS <xfs@oss.sgi.com>

Thanks. But I'm specifically *not* talking about database apps, I'm
talking about non-database applications written in languages that
don't even have a concept of fsync. I understand that PostgreSQL would
be perfectly fine on pretty much any unix filesystem short of tmpfs.
But PostgreSQL is just a small part of my mixed workloads. I wish
everything I had were PostgreSQL. But I have to deal with reality. My
only reasonable migration path for getting everything backed by a
database is to upgrade to the latest version of our software, replace
all the Linux workstations with Windows, replace the Linux servers
with Windows Server 2008 or later, and install Microsoft SQL Server at
all locations. I'm sticking with the current Cobol app which is quite
stable and reliable when running on ext3. Especially as I keep hearing
that the newer Windows-only version doesn't work particularly well.


-Steve

On Tue, Jun 11, 2013 at 12:31 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
> On 06/11/2013 01:27 PM, Stefan Ring wrote:
>>>
>>> Let's take a simple example - a database app that does say 30
>>> transactions/sec.
>>>
>>> In your example, you are extremely likely to lose up to just shy of 5
>>> seconds of "committed" data - way over 100 transactions!  That can be
>>> *really* serious amounts of data and translate into large financial loss.
>>
>> Every database software will do the flushing correctly.
>
>
> Stefan, you are making my point because every database will do the right
> thing, it won't rely on ext3's magic every 5 second fsync :)
>
> Ric
>
>>
>>> In a second example, let's say you are copying data to disk (say a movie)
>>> at
>>> a rate of 50 MB/second.  When the power cut hits at just the wrong time,
>>> you
>>> will have lost a large chunk of that data that has been "written" to disk
>>> (over 200MB).
>>
>> But why would anyone care about that? I know that the system went down
>> while copying this large movie, so I'll just copy it again.
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
