Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B678B7F56
	for <xfs@oss.sgi.com>; Sun,  8 Sep 2013 15:08:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97D29304032
	for <xfs@oss.sgi.com>; Sun,  8 Sep 2013 13:08:04 -0700 (PDT)
Received: from mail-qc0-f172.google.com (mail-qc0-f172.google.com
	[209.85.216.172]) by cuda.sgi.com with ESMTP id
	0RECCh0j4d4Jr6fX (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Sep 2013 13:08:03 -0700 (PDT)
Received: by mail-qc0-f172.google.com with SMTP id l13so741552qcy.31
	for <xfs@oss.sgi.com>; Sun, 08 Sep 2013 13:08:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <522B1C4F.7000404@redhat.com>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-11-git-send-email-bfoster@redhat.com>
	<20130905025421.GX23571@dastard> <5228AF00.7080700@redhat.com>
	<20130906002847.GR12779@dastard> <5229BEE6.3060407@redhat.com>
	<20130906212441.GB12541@dastard> <522B1C4F.7000404@redhat.com>
Date: Sun, 8 Sep 2013 16:08:03 -0400
Message-ID: <CAJzLF9mM30C=vU9R4_ZJ7wXr3URyAnVGaydYT074eED3uDbADA@mail.gmail.com>
Subject: Re: [RFC PATCH 10/11] xfs: update the finobt on inode free
From: "Michael L. Semon" <mlsemon35@gmail.com>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Sep 7, 2013 at 8:30 AM, Brian Foster <bfoster@redhat.com> wrote:
> On 09/06/2013 05:24 PM, Dave Chinner wrote:
>> On Fri, Sep 06, 2013 at 07:39:18AM -0400, Brian Foster wrote:
>>> On 09/05/2013 08:28 PM, Dave Chinner wrote:
>>>> On Thu, Sep 05, 2013 at 12:19:12PM -0400, Brian Foster wrote:
>>>>> On 09/04/2013 10:54 PM, Dave Chinner wrote:
>>>>>> On Tue, Sep 03, 2013 at 02:25:07PM -0400, Brian Foster wrote:
>>> ...
>>>>>
> ...
>>>> No worries. BTW, can you post your rudimentary userspace support so
>>>> we can run tests that use this code, too?
>>>>
>>>
>>> Sure. My xfsprogs branch currently is the application of a slightly
>>> older version of this set (pre-cleanups I made to make this post-worthy)
>>> with some hacks to make it apply/compile and a few other patches on top
>>> of that for mkfs, xfs_db and xfs_repair to work through some basic
>>> things I ran into when running xfstests.
>>>
>>> Would you prefer I drop the whole thing on the list?
>>
>> Drop it on the list, maybe just a as tarball rather than a patchset
>> if it's not ready for review yet.
>>
>
> Ok, attached. This applies on top of the following commit in the
> xfsprogs tree:
>
> 982e5c7e xfs_db: add header to freesp -d output
>
> Use the following command to format a finobt enabled fs:
>
> mkfs.xfs -m crc=1,finobt=1 <dev>
>
> ... and otherwise there are a couple random fixes for xfs_db and xfs_repair.
>
> Brian

OK, I gave it a try and messed it up.  I have updated numbers that look a
little better, and they'll be posted once I get to a Linux PC.

My merge went badly because it went on top of Dave's latest work and Mark's
v4 dirent work.  It's like some of the features2 stuff takes one extra argument
in places.

Also, when patching some code, it looks like some constants have been
updated to use cpu_to_be32(), and I don't know why they've been updated.

So it's not a surprise that I can make a v4-finobt filesystem with -finobt=1,
mount it, get all the v5 warnings from the kernel, but there's not enough
v5 code in use to choke on 256-byte v4 inodes.  Afterwards, `xfs_repair -n`
suggests that it will correct some areas from each AG.

It's also not a surprise that I don't know what issues are your fault,
which ones
are my fault, and which ones require Mark to update his v4-dirent patches.
Therefore, there's no conclusion to be placed on your userspace code yet.  It's
an RFC, anyway...

My "user commands" benchmark succeeded for the 4 XFS filesystem
variants considered previously.

More later...

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
