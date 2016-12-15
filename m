Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35756 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754909AbcLOTJn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 14:09:43 -0500
Subject: Re: [PATCH 6/6] libxcmd: add non-iterating user commands
References: <20161207034724.1613-1-david@fromorbit.com>
 <20161207034724.1613-7-david@fromorbit.com>
 <CAOQ4uxj2AROKtg=ZE64Q-RJbMaiRdP7SvoosmvCD4C1h-X-4bA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3464a695-a76a-b7e2-5426-c013c92f2fe8@sandeen.net>
Date: Thu, 15 Dec 2016 13:09:42 -0600
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj2AROKtg=ZE64Q-RJbMaiRdP7SvoosmvCD4C1h-X-4bA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On 12/6/16 10:49 PM, Amir Goldstein wrote:
>> @@ -25,14 +28,35 @@ These code paths include not only the obvious read/write/mmap interfaces
>>  for manipulating files, but also cover all of the XFS extensions (such
>>  as space preallocation, additional inode flags, etc).
>>  .SH OPTIONS
>> +.B xfs_io
>> +commands may be run interactively (the default) or as arguments on the
>> +command line.
>> +Interactive mode always runs commands on the current open file, whilst commands
>> +run from the command line may operate on all open files rather than the current
>> +open file.
> "operate on all open files" is ambiguous. does the loop go files -> cmds or
> cmds -> files? this is part of the confusion IMO.

How about adding something like:

Files specified at the end of the command line are added to the file
table first, then files specified in -c and -C commands are added.
The last file in the file table is the current open file.

-Eric 
