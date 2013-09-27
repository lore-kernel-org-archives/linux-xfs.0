Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 645657F3F
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 21:18:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4FBB88F8065
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 19:18:07 -0700 (PDT)
Received: from mail-ie0-f176.google.com (mail-ie0-f176.google.com
	[209.85.223.176]) by cuda.sgi.com with ESMTP id
	bz7Vam3aEb7mJ0N5 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 19:18:02 -0700 (PDT)
Received: by mail-ie0-f176.google.com with SMTP id as1so2635198iec.35
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 19:18:02 -0700 (PDT)
Message-ID: <5244EAD5.1010202@gmail.com>
Date: Thu, 26 Sep 2013 22:17:57 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: Issues and new to the group
References: <0e4201cebaae$24873680$6d95a380$@host2max.com>
	<5244234D.1010603@hardwarefreak.com>
	<100f01cebaba$0ae84280$20b8c780$@host2max.com>
	<52444BDD.9060100@gmail.com> <20130926221643.GR26872@dastard>
In-Reply-To: <20130926221643.GR26872@dastard>
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
To: xfs@oss.sgi.com

On 09/26/2013 06:16 PM, Dave Chinner wrote:

> Virtualisation will have nothing to do with the problem. *All* my

YMMV.  Very heavy IO in KVM/Xen often results in some very interesting 
performance anomolies from the testing we've done on customer use cases.

[...]

> And, well, I can boot a virtualised machine in under 7s, while a
> physical machine reboot takes about 5 minutes, so there's a massive
> win in terms of compile/boot/test cycle times doing things this way.

Certainly I agree with that aspect.  Our KVM instances reboot and reload 
very quickly.  This is one of their nicest features.  One we use for 
similar reasons.

>
>> First and foremost:
>>
>> Can you change from one single large folder to a heirarchical set of
>> folders?  The single large folder means any metadata operation (ls,
>> stat, open, close) has a huge set of lists to traverse.  It will
>> work, albiet slowly.  As a rule of thumb, we try to make sure our
>> users don't go much beyond 10k files/folder.  If they need to,
>> building a heirarchy of folders slightly increases management
>> complexity, but keeps the lists that are needed to be traversed much
>> smaller.
>
> I'll just quote what I told someone yesterday on IRC:
>

[...]


>> A strategy for doing this:  If your files are named "aaaa0001"
>> "aaaa0002" ... "zzzz9999" or similar, then you can chop off the
>> first letter, and make a directory of it, and then put all files
>> starting with that letter in that directory.  Then within each of
>> those directories, do the same thing with the second letter.  This
>> gets you 676 directories and about 15k files per directory.  Much
>> faster directory operations. Much smaller lists to traverse.
>
> But that's still not optimal, as directory operations will then
> serialise on per AG locks and so modifications will still be a
> bottleneck if you only have 4 AGs in your filesystem. i.e. if you
> are going to do this, you need to tailor the directory hash to the
> concurrency the filesystem structure provide because more, smaller
> directories are not necessarily better than fewer larger ones.
>
> Indeed, if you're workload is dominated by random lookups, the
> hashing technique is less efficient than just having one large
> directory as the internal btree indexes in the XFS directory
> structure are far, far more IO efficient than a multi-level
> directory hash of smaller directories. The trade-off in this case is
> lookup concurrency - enough directories to provide good llokup
> concurrency, yet few enough that you still get the IO benefit from
> the scalability of the internal directory structure.

This said, its pretty clear the OP is hitting performance bottlenecks. 
While the schema I proposed was non-optimal for the use case, I'd be 
hard pressed to imagine it being worse for his use case based upon what 
he's reported.

Obviously, more detail on the issue is needed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
