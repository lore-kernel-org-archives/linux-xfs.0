Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 51E717F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 08:37:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 301788F8039
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 06:37:47 -0800 (PST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id AuGfzoBBpeNzmPgz
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 06:37:44 -0800 (PST)
Received: by wmww144 with SMTP id w144so16037465wmw.0
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 06:37:43 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
	<565C5D39.8080300@scylladb.com>
	<20151130161438.GD24765@bfoster.bfoster>
	<565D639F.8070403@scylladb.com>
	<20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<CAD-J=zY=A8MQLzykox276cHiH7ddXHFVp0w0B4XRBskv6YK_WQ@mail.gmail.com>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <565DB0B5.40202@scylladb.com>
Date: Tue, 1 Dec 2015 16:37:41 +0200
MIME-Version: 1.0
In-Reply-To: <CAD-J=zY=A8MQLzykox276cHiH7ddXHFVp0w0B4XRBskv6YK_WQ@mail.gmail.com>
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
To: Glauber Costa <glauber@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com



On 12/01/2015 04:01 PM, Glauber Costa wrote:
> On Tue, Dec 1, 2015 at 8:58 AM, Avi Kivity <avi@scylladb.com> wrote:
>>
>> On 12/01/2015 03:11 PM, Brian Foster wrote:
>>> On Tue, Dec 01, 2015 at 11:08:47AM +0200, Avi Kivity wrote:
>>>> On 11/30/2015 06:14 PM, Brian Foster wrote:
>>>>> On Mon, Nov 30, 2015 at 04:29:13PM +0200, Avi Kivity wrote:
>>>>>> On 11/30/2015 04:10 PM, Brian Foster wrote:
>>> ...
>>>>> The agsize/agcount mkfs-time heuristics change depending on the type of
>>>>> storage. A single AG can be up to 1TB and if the fs is not considered
>>>>> "multidisk" (e.g., no stripe unit/width is defined), 4 AGs is the
>>>>> default up to 4TB. If a stripe unit is set, the agsize/agcount is
>>>>> adjusted depending on the size of the overall volume (see
>>>>> xfsprogs-dev/mkfs/xfs_mkfs.c:calc_default_ag_geometry() for details).
>>>> We'll experiment with this.  Surely it depends on more than the amount of
>>>> storage?  If you have a high op rate you'll be more likely to excite
>>>> contention, no?
>>>>
>>> Sure. The absolute optimal configuration for your workload probably
>>> depends on more than storage size, but mkfs doesn't have that
>>> information. In general, it tries to use the most reasonable
>>> configuration based on the storage and expected workload. If you want to
>>> tweak it beyond that, indeed, the best bet is to experiment with what
>>> works.
>>
>> We will do that.
>>
>>>>>> Are those locks held around I/O, or just CPU operations, or a mix?
>>>>> I believe it's a mix of modifications and I/O, though it looks like some
>>>>> of the I/O cases don't necessarily wait on the lock. E.g., the AIL
>>>>> pushing case will trylock and defer to the next list iteration if the
>>>>> buffer is busy.
>>>>>
>>>> Ok.  For us sleeping in io_submit() is death because we have no other
>>>> thread
>>>> on that core to take its place.
>>>>
>>> The above is with regard to metadata I/O, whereas io_submit() is
>>> obviously for user I/O.
>>
>> Won't io_submit() also trigger metadata I/O?  Or is that all deferred to
>> async tasks?  I don't mind them blocking each other as long as they let my
>> io_submit alone.
>>
>>>    io_submit() can probably block in a variety of
>>> places afaict... it might have to read in the inode extent map, allocate
>>> blocks, take inode/ag locks, reserve log space for transactions, etc.
>>
>> Any chance of changing all that to be asynchronous?  Doesn't sound too hard,
>> if somebody else has to do it.
>>
>>> It sounds to me that first and foremost you want to make sure you don't
>>> have however many parallel operations you typically have running
>>> contending on the same inodes or AGs. Hint: creating files under
>>> separate subdirectories is a quick and easy way to allocate inodes under
>>> separate AGs (the agno is encoded into the upper bits of the inode
>>> number).
>>
>> Unfortunately our directory layout cannot be changed.  And doesn't this
>> require having agcount == O(number of active files)?  That is easily in the
>> thousands.
> Actually, wouldn't agcount == O(nr_cpus) be good enough?

Depends on whether the locks are around I/O or cpu access only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
