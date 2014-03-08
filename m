Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C99597F5E
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 18:39:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BC4718F804C
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 16:38:57 -0800 (PST)
Received: from mail-qa0-f53.google.com (mail-qa0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id c6q2VxurMiiNARv7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 07 Mar 2014 16:38:56 -0800 (PST)
Received: by mail-qa0-f53.google.com with SMTP id w8so4867100qac.12
	for <xfs@oss.sgi.com>; Fri, 07 Mar 2014 16:38:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140307230915.GS6851@dastard>
References: <195DE8C60CE24A62A71911FDE0B0DC97@gmail.com>
	<5318DB01.2040102@hardwarefreak.com>
	<279D0A265E5D4AF5B099BFAD4E8B1700@gmail.com>
	<531A4600.7050906@hardwarefreak.com>
	<20140307230915.GS6851@dastard>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Fri, 7 Mar 2014 19:38:15 -0500
Message-ID: <CAGpXXZLtYiS3gLubA_9vbvT34RUosi91w=+7DYX_J1M3CA3czQ@mail.gmail.com>
Subject: Re: Hello, I have a question about XFS File System
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
Cc: Yongmin <dev.yongmin@gmail.com>, Stan Hoeppner <stan@hardwarefreak.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Mar 7, 2014 at 6:09 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Mar 07, 2014 at 04:19:44PM -0600, Stan Hoeppner wrote:
>> Please reply to the mailing list as well as the individual.
>>
>> Note that you stated:
>>
>> '...the concentrated part of mine is "Deleted File Recovery"'
>>
>> On 3/6/2014 10:02 PM, Yongmin wrote:
>> >
>> > Yes! there are no actual file data in journaling part.
>> >
>> > BUT, by analyzing journaling part, we can get a Inode Core Information which was deleted.
>> > In Inode Core, there are many information about the actual data, i.e. start address, file length etc.
>>
>> Analyzing the journal code may inform you about structures, but it won't
>> inform you about on disk locations of the structures and how to find
>> them.  If a file has been deleted, no information about that is going to
>> exist in the journal for more than a few seconds before the transaction
>> is committed and the entry removed from the journal.
>
> Well, we don't actually "remove" information from the log. We update
> pointers that indicate what the active region is, but we never
> physically "remove" anything from it. IOWs, the information is in
> the journal until it wraps around and is over written by new
> checkpoints....
>
>> > By using those information, Recovering delete file can be done.
>> >
>> > So the analysis of Journaling part is absolutely needed.
>>
>> I disagree.  Again, the journal log is unrelated to "deleted file
>> recovery" in a forensics scenario.
>>
>> I think Dave and Jeff both missed the fact that you're interested only
>> in deleted file recovery, not in learning how the journal works for the
>> sake of learning how the journal works.
>
> Oh, no, I saw it and didn't think it was worth commenting on. I
> think it's a brain-dead concept trying to do undelete in the
> filesystem. "recoverable delete" was a problem solved 30 years ago -
> it's commonly known as a trash bin and you do it in userspace with a
> wrapper around unlink that calls rename(2) instead. And then "empty
> trashbin" is what does the unlink and permanently deletes the files.

As a practicing forensicator, I can say "potentially recoverable
files" is a heavily used concept.

I don't know XFS on disk structure in detail, so I'll comment about
HFS+ and NTFS.

NTFS uses a simple linear on disk directory structure and inode (mft)
structure.  Forensic tools look at existing directory structures that
have directory entries marked invalid and they also scan the
unallocated space for directory remnants that were left behind from a
delete operation.  When either are found, they assume the data pointed
at is "potentially recoverable".

I think some tools also parse the NTFS journal, but it is a much less
useful mechanism.

Note that it is understood that the data pointed at by filesystem
remnants may have been overwritten by new data, so it is unreliable.

As a last resort, data carving tools equivalent to photorec are used.
Photorec depends on the files not being fragmented and also fails to
recover any filesystem metadata such as filenames, timestamps, etc.

Macs use HFS+ which uses a btree structure for the directory
structure.  I'm not aware of any forensic tool that attempts to look
for invalid directory remnants with HFS+.  Instead they go straight to
data carving.  It turns out with HFS+ the files are often not
fragmented, so data carving is very successful, but you still don't
get any filesystem metadata.

I believe XFS is similar to HFS+ in this sense.  Data carving would
likely have good results, but looking for filesystem metadata remnants
is a waste of time.  If I'm right, there is not really any research
needed on the deleted file recovery side.

At the same time, I'm not familiar with forensic tool, free or
commercial, that parses the XFS filesystem for live files and
filesystem metadata such as timestamps.  (I could be wrong, it is not
something I've had to research in the last few years.)

> Besides, from a conceptual point of view after-the-fact filesystem
> based undelete is fundamentally flawed. i.e.  the journal is a
> write-ahead logging journal and so can only be used to roll the
> filesystem state forwardi in time. Undelete requires having state
> and data in the journal that allows the filesystem to be rolled
> *backwards in time*. XFS simply does not record such information in
> the log and so parsing the log to "undelete files by transaction
> rollback" just doesn't work.

I suspect you are assuming the goal is "reliable undelete".  The
typical goal is the identification of potentially recoverable files.
I don't know if parsing the XFS journal can help with that.

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
