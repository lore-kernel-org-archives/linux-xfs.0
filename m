Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36964 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933722AbcLPBuf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 20:50:35 -0500
Subject: Re: [PATCH 5/6] xfs_io: make various commands one-shot only
References: <20161207034724.1613-1-david@fromorbit.com>
 <20161207034724.1613-6-david@fromorbit.com>
 <fec1a6dd-cebd-1ff4-e916-f696139b876e@sandeen.net>
 <20161216005326.GK4326@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <533e20be-406a-c028-f51f-9c90775a8b66@sandeen.net>
Date: Thu, 15 Dec 2016 19:50:33 -0600
MIME-Version: 1.0
In-Reply-To: <20161216005326.GK4326@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, amir73il@gmail.com

On 12/15/16 6:53 PM, Dave Chinner wrote:
> On Thu, Dec 15, 2016 at 12:21:43PM -0600, Eric Sandeen wrote:
>> On 12/6/16 9:47 PM, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> It makes no sense to iterate the file table for some xfs_io
>>> commands. Some commands are already marked in this way, but lots of
>>> them are not and this leads to bad behaviour. For example, the open
>>> command will run until the process fd table is full and EMFILE is
>>> returned rather than just opening the specified file once.
>>
>> Ok, I'm not quite clear on when we should expect commands to be
>> "oneshot"
>>
>> With freeze, for example, this:
>>
>> xfs_io -x -c freeze mnt/file mnt2/file
>>
>> will freeze both filesystems today.  With this change,
> 
> xfs_freeze will ignore multiple filesystem options, so it only ever
> passes a single file to xfs_io.  IOWs, it's behaviour will be
> completely unchanged by making the xfs_io freeze command a one-shot
> command.

Sure, but xfs_freeze is not xfs_io, it's a wrapper which by design
presents /simple/ single-fs arguments to xfs_io.
 
> And right now, I think that's the only case we have to care about.
> unless someone is actually using xfs_io directly to freeze multiple
> filesystems like this, then I think it's better to make it a
> one-shot command.
> 
>> xfs_io -x -c freeze mnt/file mnt2/file
>>
>> freezes the mnt2 filesystem but not mnt.  Is that desired?
> 
> It's exactly what the man page says the freeze command does.
> 
>> I guess the command /is/ documented as "freeze fs of /current/ file"
>> but i wonder if that's just an accident of documentation.
> 
> If the man page documents it as operating on the current file,
> but instead it freezes all the open files, then that's a bug that
> needs fixing.

yes, in either the man page /or/ the code...
 
>> ditto for i.e. the inode command, or resblks - why not
>> iterate those?
> 
> Because they are aimed at single, specific filesystem operations
> only. It just doesn't make sense to iterate them across all open
> files inside xfs_io. If you have multiple filesystems youneed to
> query/modify, then do an xfs_io call for each. 

Ok, I guess this finally clicked for me; a very easily described
test for whether the flag gets set:

  Only operations which specifically operate on /files/ will iterate*.

  System-wide and fs-wide operations (even if they happen to take a
  file as an argument, as i.e. freeze can) do /not/ iterate.

*and open doesn't iterate because recursion :)

I'm happy with that, though I think it should be documented clearly.

Sorry if I was slow getting to your point.

-Eric

> Cheers,
> 
> Dave.
> 
