Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBA3Hdib007526 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 21:17:39 -0600
Message-ID: <493F34CA.3040101@sgi.com>
Date: Wed, 10 Dec 2008 14:17:30 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: add testcase for ->setattr permission checking
References: <20081202142039.GA25155@infradead.org> <493CB518.7000001@sgi.com>
	<20081209095546.GB8599@infradead.org>
In-Reply-To: <20081209095546.GB8599@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Mon, Dec 08, 2008 at 04:48:08PM +1100, Timothy Shimmin wrote:
>> 1.
>>> +echo "user: chown root owned file to qa_user (should fail)"
>>> +su ${qa_user} -c "chown root test.${qa_user}"
>>> +
>> I think the description and command above don't match.
>> I think we have a swap with subtest 4 below.
>> Need to either swap descriptions or commands.
> 
> Yes, I swapped the descriptions.
> 
>>> +#
>>> +# Setup a file owned by the qa_user and with the suid bit set.
>>> +# A chown by root should not clean the suid bit.
>>> +#
>> Typos:
>> s/clean/clear/
>>
>> s/suceed/succeed/ in a couple of places.
> 
> Yeah.
> 
>> * It looks like you test the clearing of suid/sgid bits
>> for setting the mode permission bits and not
>> for setting ownership as the description suggests;
>> i.e. you test with chmod instead of chown for clearing of suid/sgid bits
> 
> Yes, that's also what I intended too,
Oh okay.


> as XFS had some code to clear
> the suid bits for changing permissions, but those shouldn't happen
> for the restricted_chown case (and don't even happen in the XFS code,
> it's just not obvious when reading the old setattr implementation).

Yeah, I didn't see anything about this in posix under chmod.
But reasonable to test this too - I agree.

> While for sgid we want to clear it on mode changes if the gid
> is not in the group list.  So what needs fixing here is once again
> the comment.
> 
Ok have found it in posix (thanks to gnb mentioning www.opengroup.org).

For chmod:
	"If the calling process does not have appropriate privileges, and
	if the group ID of the file does not match the effective group ID
	or one of the supplementary group IDs and if the file is a regular
	file, bit S_ISGID (set-group-ID on execution) in the file's mode
	shall be cleared upon successful return from chmod()."

reg file + file's gid not in process' group set + no approp. privileges
  -> clear sgid

Which is what your test did. Cool.

For chown:
	"If the specified file is a regular file, one or more of the S_IXUSR,
	S_IXGRP, or S_IXOTH bits of the file mode are set, and the process
	does not have appropriate privileges, the set-user-ID (S_ISUID) and
	set-group-ID (S_ISGID) bits of the file mode shall be cleared upon
	successful return from chown(). If the specified file is a regular
	file, one or more of the S_IXUSR, S_IXGRP, or S_IXOTH bits of the
	file mode are set, and the process has appropriate privileges, it
	is implementation-defined whether the set-user-ID and set-group-ID
	bits are altered. If the chown() function is successfully invoked
	on a file that is not a regular file and one or more of the S_IXUSR,
	S_IXGRP, or S_IXOTH bits of the file mode are set, the set-user-ID
	and set-group-ID bits may be cleared."

reg file + mode-bits set + no appropriate privileges -> clear suid,sgid
reg file + mode-bits set + appropriate privileges -> maybe clear suid,sgid
non reg file + mode-bits set + chown success on file (??) -> maybe clear suid/sgid

By appropriate privileges, I presume they are referring to extra
capabilities.

I will add a couple of tests for this suid/sgid clear after chown.

> Btw, I just noticed you checked in another testcase as 192.  Do you want
> a respin or do you want to fix it up yourself?
Don't worry about any respin.
I'll fix up based on your reply etc. and check in myself.

Thanks,
Tim.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
