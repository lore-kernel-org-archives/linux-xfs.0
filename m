Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5812D7F60
	for <xfs@OSS.SGI.com>; Thu, 23 Oct 2014 18:01:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CCD58AC005
	for <xfs@OSS.SGI.com>; Thu, 23 Oct 2014 16:01:30 -0700 (PDT)
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	fBt4Gx2RFxaLaVeU for <xfs@OSS.SGI.com>;
	Thu, 23 Oct 2014 16:01:25 -0700 (PDT)
Received: from ty.sabi.co.UK (94.192.123.208) by woodbine.london.02.net
	(8.5.140)
	id 53BD9B4503BD6A2D for xfs@OSS.SGI.com; Fri, 24 Oct 2014 00:32:22 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1XhRNX-0001FT-9Z
	for <xfs@OSS.SGI.com>; Fri, 24 Oct 2014 00:01:11 +0100
MIME-Version: 1.0
Message-ID: <21577.34998.793883.747715@tree.ty.sabi.co.uk>
Date: Fri, 24 Oct 2014 00:01:10 +0100
Subject: Re: Problem about very high Average Read/Write Request Time
In-Reply-To: <54492AD5.3040704@fastmail.fm>
References: <CALSoAzD4ccHXBuD6mT3ggqMf1j_kDEK-RNMOeRLq+N+NiWVQXg@mail.gmail.com>
	<20141018143848.3baf3266@galadriel.home>
	<21571.36364.518119.806191@tree.ty.sabi.co.uk>
	<5444C122.4080104@fastmail.fm>
	<21574.42382.795064.152229@tree.ty.sabi.co.uk>
	<54492AD5.3040704@fastmail.fm>
From: pg@xfs.list.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@OSS.SGI.com>

[ ... ]

>>>> [ ... ] if the device name "/data/fhgfs/fhgfs_storage" is
>>>> dedscriptive, this "brave" RAID5 set is supposed to hold
>>>> the object storage layer of a BeeFS highly parallel
>>>> filesystem, and therefore will likely have mostly-random
>>>> accesses.
[ ... ]
>>> Where do you get the assumption from that FhGFS/BeeGFS is
>>> going to do random reads/writes or the application of top of
>>> it is going to do that?

>> It is not a mere assumption in the general case either; it is
>> both commonly observed and a simple deduction, because of the
>> nature of distributed filesystems and in particular parallel
>> HPC ones like Lustre or BeeGFS, but also AFS and even NFS ones.
[ ... ]

>> * Clients have caches.

> Correct is: Client *might* have caches. Besides of application
> directio, for BeeGFS the cache type is a configuration option.

Perhaps you have missed the explicit qualification =ABin the
general case=BB of =ABdistributed filesystems and in particular
parallel HPC ones=BB or perhaps you lack familiarity with =ABLustre
or BeeGFS, but also AFS and even NFS ones=BB most of which have
client caches and usually enabled, and that might justify your
inability to consider =ABthe general case=BB.

>> Therefore most of the locality in the (read) access patterns
>> will hopefully be filtered out by the client cache. This
>> applies (ideally) to any distributed filesystem.

> You cannot filter out everything, e.g. random reads of a large
> file.

It is good but somewhat pointless that you can understand the
meaning of =ABmost of the locality in the (read) access patterns
will hopefully be filtered out by the client cache=BB and agree
with it, and supply an example, but unfortunately you seem to
have the naive expectation that:

>> Local or remote file system does not matter here.

It can matter as:

* In the local case there is a single cache for all concurrent
  applications, while in the distributed case there is hopefully
  a separate cache per node, which segments the references (as
  well as hopefully providing a lot more cache space).
* In the purely local case there is usually just one level of
  caching, in the distribured case usually there are two levels,
  often resulting in rather different access patterns to the
  object stores in the server.

So the degree of filtering can be and often is quite different;
which is usually quite important because network transfers add a
cost.

As to these three comments I am perplexed:

>> Therefore it is likely that many clients will access with
>> concurrent read and write many different files on the same
>> server resulting in many random "hotspots" in each server's
>> load.

> If that would be important here there would be no difference
> between single write and parallel read/write.
[ ... ]
>> each client could be doing entirely sequential IO to each
>> file they access, but the concurrent accesses do possibly
>> widely scattered files will turn that into random IO at the
>> server level.
[ ... ]
> How does this matter if the op is comparing 1-thread write
> vs. 2-thread read/write?

>> * Eventually if the object server reaches a steady state
>> where roughly as much data is deleted and created the free
>> storage areas will become widely scattered, leading to
>> essentially random allocation, the more random the more
>> capacity used.

> All of that is irrelevant if a single write is fast and a
> parallel read/write is slow.

Because you seem rather confusedm, as my explanation was the
answer to this question you asked:

  >>> Where do you get the assumption from that FhGFS/BeeGFS is
  >>> going to do random reads/writes or the application of top
  >>> of it is going to do that?

and in it you mention no special case like =AB1-thread write=BB, or
=AB2-thread read/write=BB.

Also such simple special cases don't happen much in =ABthe object
storage layer=BB of any realistic =ABhighly parallel filesystem=BB,
which are often large with vast and varied workloads, as I tried
to remind you:

  >> HPC/parallel servers tend to whave many clients (e.g. for
  >> an it could be 10,000 clients and 500 object storage
  >> servers) and hopefully each client works on a different
  >> subset of the data tree, and distribution of data objects
  >> onto servers hopefully random.

Therefore there are likely to be many dozens or even hundreds of
threads accessing objects per object store, with every pattern
of read and write and to rather unrelated objects, not just 1 or
2 threads and single write or read/write.

That's one reason why XFS is so often used for those object
stores: it is particularly well suited to highly multithreaded
access patterns to many files, as the XFS has benefited from
quite a bit of effort in finer grained locking, and XFS uses
some mostly effective heuristics to distribute files across the
storage it uses in hopefully "best" ways.

>> The above issues are pretty much "network and distributed
>> filesystems for beginners" notes,

> It is lots of text

In my original reply I was terse and did not explain every
reason why =ABthe object storage layer of a BeeFS highly parallel
filesystem=BB is =ABlikely have mostly-random accesses=BB because I
assumed it is common knowledge among somewhat skilled readers;
but to a point I am also patient with beginners, even those who
seem to become confused about which question they themselves
asked.

Also I am trying to quote context because you seem confused as
to what the content of even your questions is.

> and does not help the op at all.

That seems unfortunately right, as to me you still seem very
confused as to the workloads likely experienced by object stores
for highly parallel filesystems despite my efforts in trying to
answer in detail the question you asked:

  >>> Where do you get the assumption from that FhGFS/BeeGFS is
  >>> going to do random reads/writes or the application of top
  >>> of it is going to do that?

At least as I already pointed out my answer to your question is
at least somewhat topical for the XFS list, for example by
hinting about using less "brave" configurations than 32-disk
RAID5 sets.

> And the claim/speculation that the parallel file system would
> introduce random access is also wrong.

As far as I can see it was only who you mentioned that because I
discussed just the consequences of the likely access patterns of
=ABthe application of top of it=BB part of your question.

It seemed strange to me that you would ask why =ABFhGFS/BeeGFS is
going to do random reads/writes=BB because filesystems typically
don't do =ABread/writes=BB except as a consequence of application
requests, so I ignored that other part of your question.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
