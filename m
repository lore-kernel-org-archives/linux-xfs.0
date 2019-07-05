Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56660 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfGER6O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 13:58:14 -0400
Subject: Re: [PATCH 9/9] man: create a separate xfs shutdown ioctl manpage
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
 <156104950912.1174403.4990641877651635072.stgit@magnolia>
 <d00e8961-c6f0-4adb-9b83-4750a15e97b1@sandeen.net>
 <20190705171303.GJ1404256@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cfdfb9f9-be9d-a73e-6373-12c4db82588a@sandeen.net>
Date: Fri, 5 Jul 2019 12:58:12 -0500
MIME-Version: 1.0
In-Reply-To: <20190705171303.GJ1404256@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 7/5/19 12:13 PM, Darrick J. Wong wrote:
> On Fri, Jul 05, 2019 at 11:08:54AM -0500, Eric Sandeen wrote:
>> On 6/20/19 11:51 AM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>

...

 
>>> +
>>> +.PP
>>> +.I flags
>>> +can be one of the following:
>>> +.RS 0.4i
>>> +.TP
>>> +.B XFS_FSOP_GOING_FLAGS_DEFAULT
>>> +Flush all dirty data and in-core state to disk, flush pending transactions to
>>> +the log, and shut down.
>>
>> What exactly do we mean by "in-core state" here?  I'm not sure the average
>> reader will know (I'm not sure I know)
> 
> Hm... really it's any dirty cached state, like ... unflushed inodes and
> dquots, dirty file data, etc.  I didn't want to commit to that level of
> specificity though.

"Flush all dirty data and metadata to disk, flush pending transactions
to the log, and shut down." ?

>>> +.TP
>>> +.B XFS_FSOP_GOING_FLAGS_LOGFLUSH
>>> +Flush all pending transactions to the log and shut down, leaving all dirty
>>> +data unwritten.
>>> +.TP
>>> +.B XFS_FSOP_GOING_FLAGS_NOLOGFLUSH
>>> +Shut down immediately, without writing pending transactions or dirty data
>>> +to disk.
>>> +
>>> +.SH RETURN VALUE
>>> +On error, \-1 is returned, and
>>> +.I errno
>>> +is set to indicate the error.
>>> +.PP
>>> +.SH ERRORS
>>> +Error codes can be one of, but are not limited to, the following:
>>
>> Hm crud, now I wonder about auditing all your stated error codes.
>> EPERM, EFAULT, and EINVAL seem to be the only options for this
>> particular call.  Maybe that can be a 2nd cleanup, documenting
>> an error code that won't happen is harmless...
> 
> <urk> Ok, I'll go do that. :)
> 
>>> +.TP
>>> +.B EFSBADCRC
>>> +Metadata checksum validation failed while performing the query.
>>> +.TP
>>> +.B EFSCORRUPTED
>>> +Metadata corruption was encountered while performing the query.
>>> +.TP
>>> +.B EINVAL
>>> +The specified allocation group number is not valid for this filesystem.
> 
> This one definitely was copypasta error. :(

Oh oopsies.  Ok that's worth fixing ....

-Eric
